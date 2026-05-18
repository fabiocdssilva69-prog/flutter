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

  /// Cria uma sessão de checkout para assinatura Silver Mensal
  String _withUid(String url) {
    final uid = _auth.currentUser?.uid;
    return uid != null ? '$url?client_reference_id=$uid' : url;
  }

  Future<String?> subscribeSilverMonthly() async => _withUid(StripeConfig.paymentLinkSilverMonthly);
  Future<String?> subscribeSilverYearly() async => _withUid(StripeConfig.paymentLinkSilverYearly);
  Future<String?> subscribeGoldMonthly() async => _withUid(StripeConfig.paymentLinkGoldMonthly);
  Future<String?> subscribeGoldYearly() async => _withUid(StripeConfig.paymentLinkGoldYearly);

  /// Cria uma sessão de checkout para compra de 5 Boosts
  Future<String?> buyBoosts5() async {
    print('🎯 [StripeService] Retornando Payment Link direto para 5 Boosts');
    return StripeConfig.paymentLinkBoosts5;
  }

  /// Cria uma sessão de checkout para compra de 10 Boosts
  Future<String?> buyBoosts10() async {
    print('🎯 [StripeService] Retornando Payment Link direto para 10 Boosts');
    return StripeConfig.paymentLinkBoosts10;
  }

  /// Cria uma sessão de checkout para compra de 20 Boosts
  Future<String?> buyBoosts20() async {
    print('🎯 [StripeService] Retornando Payment Link direto para 20 Boosts');
    return StripeConfig.paymentLinkBoosts20;
  }

  /// Cria uma sessão de checkout para compra de 10 Super Likes
  Future<String?> buySuperLikes10() async {
    print('🎯 [StripeService] Retornando Payment Link direto para 10 Super Likes');
    return StripeConfig.paymentLinkSuperLikes10;
  }

  /// Cria uma sessão de checkout para compra de 20 Super Likes
  Future<String?> buySuperLikes20() async {
    print('🎯 [StripeService] Retornando Payment Link direto para 20 Super Likes');
    return StripeConfig.paymentLinkSuperLikes20;
  }

  /// Cria uma sessão de checkout para compra de 50 Super Likes
  Future<String?> buySuperLikes50() async {
    print('🎯 [StripeService] Retornando Payment Link direto para 50 Super Likes');
    return StripeConfig.paymentLinkSuperLikes50;
  }

  // ============================================
  // MAGIC MATCH
  // ============================================

  /// Cria uma sessão de checkout para compra de 3 Magic Match
  Future<String?> buyMagicMatch3() async {
    print('🎯 [StripeService] Retornando Payment Link direto para 3 Magic Match');
    return StripeConfig.paymentLinkMagicMatch3;
  }

  /// Cria uma sessão de checkout para compra de 10 Magic Match
  Future<String?> buyMagicMatch10() async {
    print('🎯 [StripeService] Retornando Payment Link direto para 10 Magic Match');
    return StripeConfig.paymentLinkMagicMatch10;
  }

  /// Cria uma sessão de checkout para compra de 25 Magic Match
  Future<String?> buyMagicMatch25() async {
    print('🎯 [StripeService] Retornando Payment Link direto para 25 Magic Match');
    return StripeConfig.paymentLinkMagicMatch25;
  }

  // ============================================
  // REPLAY
  // ============================================

  /// Cria uma sessão de checkout para compra de 10 Replay
  Future<String?> buyReplay10() async {
    print('🎯 [StripeService] Retornando Payment Link direto para 10 Replay');
    return StripeConfig.paymentLinkReplay10;
  }

  /// Cria uma sessão de checkout para compra de 20 Replay
  Future<String?> buyReplay20() async {
    print('🎯 [StripeService] Retornando Payment Link direto para 20 Replay');
    return StripeConfig.paymentLinkReplay20;
  }

  /// Cria uma sessão de checkout para compra de 50 Replay
  Future<String?> buyReplay50() async {
    print('🎯 [StripeService] Retornando Payment Link direto para 50 Replay');
    return StripeConfig.paymentLinkReplay50;
  }

  /// Cria uma sessão de checkout genérica (uso público para testes)
  ///
  /// Retorna a URL de checkout ou null em caso de erro
  Future<String?> createCheckoutSession({required String priceId, required String mode}) async {
    return await _createCheckoutSession(priceId: priceId, mode: mode);
  }

  /// Cria uma sessão de checkout no Stripe (método alternativo direto)
  ///
  /// Este método usa Payment Links diretos do Stripe como fallback
  Future<String?> _createCheckoutSessionDirect({required String priceId, required String mode}) async {
    try {
      print('🟡 [StripeService] Usando método alternativo (Payment Link direto)...');

      final userId = _auth.currentUser?.uid;
      if (userId == null) {
        throw Exception('Usuário não autenticado');
      }

      // Mapear Price ID para Payment Link
      String? paymentLink;

      switch (priceId) {
        // Badges
        case StripeConfig.silverMonthly:
          paymentLink = StripeConfig.paymentLinkSilverMonthly;
          break;
        case StripeConfig.silverYearly:
          paymentLink = StripeConfig.paymentLinkSilverYearly;
          break;
        case StripeConfig.goldMonthly:
          paymentLink = StripeConfig.paymentLinkGoldMonthly;
          break;
        case StripeConfig.goldYearly:
          paymentLink = StripeConfig.paymentLinkGoldYearly;
          break;

        // Boosts
        case StripeConfig.boosts5:
          paymentLink = StripeConfig.paymentLinkBoosts5;
          break;
        case StripeConfig.boosts10:
          paymentLink = StripeConfig.paymentLinkBoosts10;
          break;
        case StripeConfig.boosts20:
          paymentLink = StripeConfig.paymentLinkBoosts20;
          break;

        // Super Likes
        case StripeConfig.superLikes10:
          paymentLink = StripeConfig.paymentLinkSuperLikes10;
          break;
        case StripeConfig.superLikes20:
          paymentLink = StripeConfig.paymentLinkSuperLikes20;
          break;
        case StripeConfig.superLikes50:
          paymentLink = StripeConfig.paymentLinkSuperLikes50;
          break;

        default:
          print('❌ [StripeService] Price ID não mapeado para Payment Link: $priceId');
          throw Exception('Produto não configurado para checkout direto');
      }

      if (paymentLink.contains('XXXXXXXX')) {
        print('⚠️ [StripeService] Payment Link não configurado no StripeConfig');
        throw Exception('Payment Link não configurado. Configure no Stripe Dashboard.');
      }

      print('✅ [StripeService] Payment Link encontrado');
      print('🔗 [StripeService] URL completa: $paymentLink');
      print('� [StripeService] Tamanho da URL: ${paymentLink.length} caracteres');
      print(
        '🔗 [StripeService] Primeiros 50 chars: ${paymentLink.substring(0, paymentLink.length >= 50 ? 50 : paymentLink.length)}',
      );
      print(
        '🔗 [StripeService] Últimos 20 chars: ${paymentLink.substring(paymentLink.length >= 20 ? paymentLink.length - 20 : 0)}',
      );
      print('�📋 [StripeService] PriceID usado: $priceId');
      print('⚠️ [StripeService] IMPORTANTE: Verifique se o link está ATIVO no Stripe Dashboard');

      return paymentLink;
    } catch (e) {
      print('❌ [StripeService] Erro no método alternativo: $e');
      rethrow;
    }
  }

  /// Cria uma sessão de checkout no Stripe
  ///
  /// Retorna a URL de checkout ou null em caso de erro
  Future<String?> _createCheckoutSession({required String priceId, required String mode}) async {
    try {
      print('🔵 [StripeService] Iniciando criação de checkout session...');

      final userId = _auth.currentUser?.uid;
      if (userId == null) {
        print('❌ [StripeService] Usuário não autenticado');
        throw Exception('Usuário não autenticado');
      }

      print('🔵 [StripeService] UserID: $userId');
      print('🔵 [StripeService] PriceID: $priceId');
      print('🔵 [StripeService] Mode: $mode');

      // PIX não suporta pagamentos recorrentes — disponível apenas em pagamentos únicos
      const subscriptionMethods = ['card', 'boleto'];
      const oneTimeMethods = ['card', 'boleto', 'pix'];
      final paymentMethodTypes = mode == 'subscription' ? subscriptionMethods : oneTimeMethods;

      // Cria a sessão de checkout na subcoleção do usuário
      print('🔵 [StripeService] Criando documento na coleção checkout_sessions...');
      final docRef = await _firestore.collection('customers').doc(userId).collection('checkout_sessions').add({
        'price': priceId,
        'success_url': StripeConfig.successUrl,
        'cancel_url': StripeConfig.cancelUrl,
        'mode': mode,
        'payment_method_types': paymentMethodTypes,
        'locale': 'pt-BR',
        'metadata': {'userId': userId, 'productName': StripeConfig.getProductName(priceId)},
      });

      print('✅ [StripeService] Documento criado com ID: ${docRef.id}');
      print('🔵 [StripeService] Aguardando extensão Firebase Stripe criar URL (timeout 10s)...');

      // Aguarda a extensão criar a URL de checkout (com timeout reduzido)
      try {
        final snapshot = await docRef
            .snapshots()
            .timeout(
              const Duration(seconds: 10),
              onTimeout: (sink) {
                print('⚠️ [StripeService] Timeout de 10s - tentando método alternativo');
                sink.close();
              },
            )
            .firstWhere(
              (snapshot) {
                final data = snapshot.data();
                print('🔵 [StripeService] Snapshot atualizado: ${data != null ? data.keys.toList() : "null"}');
                if (data?['error'] != null) {
                  print('❌ [StripeService] Erro da extensão: ${data?['error']}');
                }
                return data?['url'] != null;
              },
              orElse: () {
                print('⚠️ [StripeService] Extensão não respondeu - usando fallback');
                throw Exception('Extension timeout');
              },
            );

        final url = snapshot.data()?['url'] as String?;
        if (url != null) {
          print('✅ [StripeService] URL de checkout obtida: ${url.substring(0, 50)}...');
          return url;
        }
      } catch (e) {
        print('⚠️ [StripeService] Extensão falhou ($e) - usando método direto');
        // Fallback: usar método alternativo
        return await _createCheckoutSessionDirect(priceId: priceId, mode: mode);
      }

      return null;
    } catch (e) {
      print('❌ [StripeService] Erro ao criar sessão de checkout: $e');
      print('❌ [StripeService] Stack trace: ${StackTrace.current}');
      // Retornar erro específico para mostrar ao usuário
      rethrow;
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

  /// Cria uma sessão do Portal de Gerenciamento Stripe
  ///
  /// Permite que o usuário gerencie sua assinatura (cancelar, atualizar método de pagamento, etc)
  Future<String?> createPortalSession() async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) {
        throw Exception('Usuário não autenticado');
      }

      // Cria a sessão do portal na subcoleção do usuário
      final docRef = await _firestore.collection('customers').doc(userId).collection('portal_sessions').add({
        'return_url': StripeConfig.successUrl,
        'metadata': {'userId': userId},
      });

      // Aguarda a extensão criar a URL do portal
      final snapshot = await docRef.snapshots().firstWhere(
        (snapshot) => snapshot.data()?['url'] != null,
        orElse: () => throw Exception('Timeout ao criar sessão do portal'),
      );

      return snapshot.data()?['url'] as String?;
    } catch (e) {
      print('❌ Erro ao criar sessão do portal: $e');
      return null;
    }
  }
}
