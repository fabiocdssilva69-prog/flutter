import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'wallet_controller.g.dart';

class Transaction {
  final String id;
  final String type; // payment, cashback, withdrawal
  final double amount;
  final String description;
  final DateTime createdAt;
  final String status;

  Transaction({
    required this.id,
    required this.type,
    required this.amount,
    required this.description,
    required this.createdAt,
    required this.status,
  });
}

class WalletData {
  final double balance;
  final double cashback;
  final List<Transaction> transactions;

  WalletData({
    required this.balance,
    required this.cashback,
    required this.transactions,
  });
}

@riverpod
class WalletController extends _$WalletController {
  @override
  Future<WalletData> build() async {
    return _loadWallet('current-user-id');
  }

  Future<WalletData> _loadWallet(String userId) async {
    final doc = await FirebaseFirestore.instance
        .collection('wallets')
        .doc(userId)
        .get();

    final data = doc.data() ?? {};
    
    final transactionsSnapshot = await doc.reference
        .collection('transactions')
        .orderBy('createdAt', descending: true)
        .limit(20)
        .get();

    final transactions = transactionsSnapshot.docs.map((doc) {
      final data = doc.data();
      return Transaction(
        id: doc.id,
        type: data['type'],
        amount: data['amount'].toDouble(),
        description: data['description'],
        createdAt: (data['createdAt'] as Timestamp).toDate(),
        status: data['status'],
      );
    }).toList();

    return WalletData(
      balance: (data['balance'] ?? 0).toDouble(),
      cashback: (data['cashback'] ?? 0).toDouble(),
      transactions: transactions,
    );
  }

  Future<void> addFunds(String userId, double amount) async {
    await FirebaseFirestore.instance.collection('wallets').doc(userId).update({
      'balance': FieldValue.increment(amount),
    });

    await FirebaseFirestore.instance
        .collection('wallets')
        .doc(userId)
        .collection('transactions')
        .add({
      'type': 'deposit',
      'amount': amount,
      'description': 'Recarga de saldo',
      'createdAt': FieldValue.serverTimestamp(),
      'status': 'completed',
    });

    ref.invalidateSelf();
  }

  Future<void> processPayment(String userId, double amount, String description) async {
    await FirebaseFirestore.instance.collection('wallets').doc(userId).update({
      'balance': FieldValue.increment(-amount),
      'cashback': FieldValue.increment(amount * 0.05), // 5% cashback
    });

    await FirebaseFirestore.instance
        .collection('wallets')
        .doc(userId)
        .collection('transactions')
        .add({
      'type': 'payment',
      'amount': -amount,
      'description': description,
      'createdAt': FieldValue.serverTimestamp(),
      'status': 'completed',
    });

    ref.invalidateSelf();
  }
}
