import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'payment_controller.g.dart';

enum PaymentMethod { pix, creditCard, debitCard, wallet, cash }

enum PaymentStatus { pending, processing, completed, failed, refunded }

class PaymentTransaction {
  final String id;
  final String userId;
  final String? bookingId;
  final double amount;
  final PaymentMethod method;
  final PaymentStatus status;
  final DateTime createdAt;
  final DateTime? completedAt;
  final String? pixQrCode;
  final String? pixCopyPaste;
  final String? errorMessage;
  final Map<String, dynamic>? metadata;

  PaymentTransaction({
    required this.id,
    required this.userId,
    this.bookingId,
    required this.amount,
    required this.method,
    required this.status,
    required this.createdAt,
    this.completedAt,
    this.pixQrCode,
    this.pixCopyPaste,
    this.errorMessage,
    this.metadata,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'bookingId': bookingId,
      'amount': amount,
      'method': method.name,
      'status': status.name,
      'createdAt': Timestamp.fromDate(createdAt),
      'completedAt': completedAt != null ? Timestamp.fromDate(completedAt!) : null,
      'pixQrCode': pixQrCode,
      'pixCopyPaste': pixCopyPaste,
      'errorMessage': errorMessage,
      'metadata': metadata,
    };
  }

  factory PaymentTransaction.fromMap(String id, Map<String, dynamic> map) {
    return PaymentTransaction(
      id: id,
      userId: map['userId'],
      bookingId: map['bookingId'],
      amount: map['amount'].toDouble(),
      method: PaymentMethod.values.firstWhere((e) => e.name == map['method']),
      status: PaymentStatus.values.firstWhere((e) => e.name == map['status']),
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      completedAt: map['completedAt'] != null ? (map['completedAt'] as Timestamp).toDate() : null,
      pixQrCode: map['pixQrCode'],
      pixCopyPaste: map['pixCopyPaste'],
      errorMessage: map['errorMessage'],
      metadata: map['metadata'],
    );
  }
}

class SavedCard {
  final String id;
  final String userId;
  final String cardNumber; // Últimos 4 dígitos
  final String cardholderName;
  final String brand; // visa, mastercard, etc
  final String expiryMonth;
  final String expiryYear;
  final bool isDefault;

  SavedCard({
    required this.id,
    required this.userId,
    required this.cardNumber,
    required this.cardholderName,
    required this.brand,
    required this.expiryMonth,
    required this.expiryYear,
    this.isDefault = false,
  });
}

@riverpod
class PaymentController extends _$PaymentController {
  @override
  Future<List<PaymentTransaction>> build() async {
    return _loadTransactions('current-user-id');
  }

  Future<List<PaymentTransaction>> _loadTransactions(String userId) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('payment_transactions')
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .limit(20)
        .get();

    return snapshot.docs.map((doc) => PaymentTransaction.fromMap(doc.id, doc.data())).toList();
  }

  // Gerar pagamento PIX
  Future<PaymentTransaction> generatePixPayment({
    required String userId,
    required double amount,
    String? bookingId,
    Map<String, dynamic>? metadata,
  }) async {
    // Simular geração de PIX (em produção, integrar com gateway real)
    final pixData = _generatePixMockData(amount);

    final transaction = PaymentTransaction(
      id: '',
      userId: userId,
      bookingId: bookingId,
      amount: amount,
      method: PaymentMethod.pix,
      status: PaymentStatus.pending,
      createdAt: DateTime.now(),
      pixQrCode: pixData['qrCode'],
      pixCopyPaste: pixData['copyPaste'],
      metadata: metadata,
    );

    final docRef = await FirebaseFirestore.instance.collection('payment_transactions').add(transaction.toMap());

    ref.invalidateSelf();

    return PaymentTransaction.fromMap(docRef.id, transaction.toMap());
  }

  // Processar pagamento com cartão
  Future<PaymentTransaction> processCardPayment({
    required String userId,
    required double amount,
    required String cardNumber,
    required String cardholderName,
    required String expiryDate,
    required String cvv,
    String? bookingId,
    bool saveCard = false,
    Map<String, dynamic>? metadata,
  }) async {
    state = const AsyncValue.loading();

    try {
      // Simular processamento (em produção, usar gateway de pagamento)
      await Future.delayed(const Duration(seconds: 2));

      final success = _simulateCardProcessing();

      final transaction = PaymentTransaction(
        id: '',
        userId: userId,
        bookingId: bookingId,
        amount: amount,
        method: PaymentMethod.creditCard,
        status: success ? PaymentStatus.completed : PaymentStatus.failed,
        createdAt: DateTime.now(),
        completedAt: success ? DateTime.now() : null,
        errorMessage: success ? null : 'Cartão recusado',
        metadata: metadata,
      );

      final docRef = await FirebaseFirestore.instance.collection('payment_transactions').add(transaction.toMap());

      if (saveCard && success) {
        await _saveCardInfo(userId, cardNumber, cardholderName, expiryDate);
      }

      ref.invalidateSelf();

      return PaymentTransaction.fromMap(docRef.id, transaction.toMap());
    } catch (e) {
      rethrow;
    }
  }

  // Processar com carteira digital
  Future<PaymentTransaction> processWalletPayment({
    required String userId,
    required double amount,
    String? bookingId,
    Map<String, dynamic>? metadata,
  }) async {
    // Verificar saldo
    final walletDoc = await FirebaseFirestore.instance.collection('wallets').doc(userId).get();
    final balance = (walletDoc.data()?['balance'] ?? 0).toDouble();

    if (balance < amount) {
      throw Exception('Saldo insuficiente');
    }

    final transaction = PaymentTransaction(
      id: '',
      userId: userId,
      bookingId: bookingId,
      amount: amount,
      method: PaymentMethod.wallet,
      status: PaymentStatus.completed,
      createdAt: DateTime.now(),
      completedAt: DateTime.now(),
      metadata: metadata,
    );

    final docRef = await FirebaseFirestore.instance.collection('payment_transactions').add(transaction.toMap());

    // Debitar da carteira
    await FirebaseFirestore.instance.collection('wallets').doc(userId).update({
      'balance': FieldValue.increment(-amount),
    });

    ref.invalidateSelf();

    return PaymentTransaction.fromMap(docRef.id, transaction.toMap());
  }

  // Verificar status do pagamento PIX
  Future<void> checkPixPaymentStatus(String transactionId) async {
    // Simular verificação (em produção, consultar gateway)
    await Future.delayed(const Duration(seconds: 1));

    final isPaid = _simulatePixPayment();

    if (isPaid) {
      await FirebaseFirestore.instance.collection('payment_transactions').doc(transactionId).update({
        'status': PaymentStatus.completed.name,
        'completedAt': FieldValue.serverTimestamp(),
      });

      ref.invalidateSelf();
    }
  }

  // Estornar pagamento
  Future<void> refundPayment(String transactionId) async {
    await FirebaseFirestore.instance.collection('payment_transactions').doc(transactionId).update({
      'status': PaymentStatus.refunded.name,
      'metadata.refundedAt': FieldValue.serverTimestamp(),
    });

    ref.invalidateSelf();
  }

  Map<String, String> _generatePixMockData(double amount) {
    // Em produção, integrar com API do banco/gateway
    final copyPaste =
        '00020126580014br.gov.bcb.pix0136${DateTime.now().millisecondsSinceEpoch}520400005303986540${amount.toStringAsFixed(2)}5802BR6009SAO PAULO62070503***6304ABCD';
    return {
      'qrCode': 'https://api.qrserver.com/v1/create-qr-code/?size=300x300&data=$copyPaste',
      'copyPaste': copyPaste,
    };
  }

  bool _simulateCardProcessing() {
    // 90% de sucesso
    return DateTime.now().millisecond % 10 != 0;
  }

  bool _simulatePixPayment() {
    // 50% de chance de ter sido pago
    return DateTime.now().millisecond % 2 == 0;
  }

  Future<void> _saveCardInfo(String userId, String cardNumber, String name, String expiry) async {
    final last4 = cardNumber.replaceAll(' ', '').substring(cardNumber.length - 4);
    final parts = expiry.split('/');

    await FirebaseFirestore.instance.collection('saved_cards').add({
      'userId': userId,
      'cardNumber': last4,
      'cardholderName': name,
      'brand': 'visa', // Detectar pela BIN em produção
      'expiryMonth': parts[0],
      'expiryYear': parts[1],
      'isDefault': false,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }
}

// Provider de cartões salvos
@riverpod
Future<List<SavedCard>> savedCards(Ref ref, String userId) async {
  final snapshot = await FirebaseFirestore.instance.collection('saved_cards').where('userId', isEqualTo: userId).get();

  return snapshot.docs.map((doc) {
    final data = doc.data();
    return SavedCard(
      id: doc.id,
      userId: data['userId'],
      cardNumber: data['cardNumber'],
      cardholderName: data['cardholderName'],
      brand: data['brand'],
      expiryMonth: data['expiryMonth'],
      expiryYear: data['expiryYear'],
      isDefault: data['isDefault'] ?? false,
    );
  }).toList();
}
