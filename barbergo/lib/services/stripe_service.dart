import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../config/stripe_config.dart';

part 'stripe_service.g.dart';

@riverpod
StripeService stripeService(Ref ref) {
  return StripeService();
}

/// Serviço de integração com Stripe via Firebase Extensions
///
/// Este serviço utiliza a extensão firestore-stripe-payments para
/// processar pagamentos sem expor a Secret Key no client-side.
class StripeService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Cria uma sessão de checkout para assinatura Premium Mensal
  Future<String?> subscribeToPremiumMonthly() async {
    return await _createCheckoutSession(priceId: StripeConfig.premiumMonthly, mode: 'subscription');
  }

  /// Cria uma sessão de checkout para assinatura Premium Anual
  Future<String?> subscribeToPremiumYearly() async {
    return await _createCheckoutSession(priceId: StripeConfig.premiumYearly, mode: 'subscription');
  }

  /// Cria uma sessão de checkout para compra de 5 Boosts
  Future<String?> buyBoosts5() async {
    return await _createCheckoutSession(priceId: StripeConfig.boosts5, mode: 'payment');
  }

  /// Cria uma sessão de checkout para compra de 10 Super Likes
  Future<String?> buySuperLikes10() async {
    return await _createCheckoutSession(priceId: StripeConfig.superLikes10, mode: 'payment');
  }

  /// Cria uma sessão de checkout genérica (uso público para testes)
  ///
  /// Retorna a URL de checkout ou null em caso de erro
  Future<String?> createCheckoutSession({required String priceId, required String mode}) async {
    return await _createCheckoutSession(priceId: priceId, mode: mode);
  }

  /// Cria uma sessão de checkout no Stripe
  ///
  /// Retorna a URL de checkout ou null em caso de erro
  Future<String?> _createCheckoutSession({required String priceId, required String mode}) async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) {
        throw Exception('Usuário não autenticado');
      }

      // Cria a sessão de checkout na subcoleção do usuário
      final docRef = await _firestore.collection('customers').doc(userId).collection('checkout_sessions').add({
        'price': priceId,
        'success_url': StripeConfig.successUrl,
        'cancel_url': StripeConfig.cancelUrl,
        'mode': mode,
        'metadata': {'userId': userId, 'productName': StripeConfig.getProductName(priceId)},
      });

      // Aguarda a extensão criar a URL de checkout
      final snapshot = await docRef.snapshots().firstWhere(
        (snapshot) => snapshot.data()?['url'] != null,
        orElse: () => throw Exception('Timeout ao criar sessão de checkout'),
      );

      return snapshot.data()?['url'] as String?;
    } catch (e) {
      print('❌ Erro ao criar sessão de checkout: $e');
      return null;
    }
  }

  /// Verifica se o usuário tem uma assinatura ativa
  Future<bool> hasActiveSubscription() async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) return false;

      final subscriptions = await _firestore
          .collection('customers')
          .doc(userId)
          .collection('subscriptions')
          .where('status', whereIn: ['trialing', 'active'])
          .get();

      return subscriptions.docs.isNotEmpty;
    } catch (e) {
      print('❌ Erro ao verificar assinatura: $e');
      return false;
    }
  }

  /// Cancela a assinatura do usuário
  ///
  /// Nota: A assinatura continuará ativa até o final do período pago
  Future<bool> cancelSubscription() async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) {
        throw Exception('Usuário não autenticado');
      }

      // Busca assinaturas ativas
      final subscriptions = await _firestore
          .collection('customers')
          .doc(userId)
          .collection('subscriptions')
          .where('status', whereIn: ['trialing', 'active'])
          .get();

      if (subscriptions.docs.isEmpty) {
        throw Exception('Nenhuma assinatura ativa encontrada');
      }

      // Marca para cancelar no final do período
      for (final doc in subscriptions.docs) {
        await doc.reference.update({'cancel_at_period_end': true});
      }

      return true;
    } catch (e) {
      print('❌ Erro ao cancelar assinatura: $e');
      return false;
    }
  }

  /// Stream que monitora mudanças na assinatura do usuário
  Stream<bool> subscriptionStatusStream() {
    final userId = _auth.currentUser?.uid;
    if (userId == null) {
      return Stream.value(false);
    }

    return _firestore
        .collection('customers')
        .doc(userId)
        .collection('subscriptions')
        .where('status', whereIn: ['trialing', 'active'])
        .snapshots()
        .map((snapshot) => snapshot.docs.isNotEmpty);
  }

  /// Obtém detalhes da assinatura atual
  Future<Map<String, dynamic>?> getCurrentSubscription() async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) return null;

      final subscriptions = await _firestore
          .collection('customers')
          .doc(userId)
          .collection('subscriptions')
          .where('status', whereIn: ['trialing', 'active'])
          .get();

      if (subscriptions.docs.isEmpty) return null;

      return subscriptions.docs.first.data();
    } catch (e) {
      print('❌ Erro ao buscar assinatura: $e');
      return null;
    }
  }
}
