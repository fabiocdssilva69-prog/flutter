import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../controllers/wallet_controller.dart';

class WalletScreen extends ConsumerWidget {
  const WalletScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wallet = ref.watch(walletControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Carteira Digital'),
        actions: [IconButton(icon: const Icon(Icons.add), onPressed: () => _showAddFunds(context, ref))],
      ),
      body: wallet.when(
        data: (data) => ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _BalanceCard(balance: data.balance, cashback: data.cashback),
            const SizedBox(height: 24),
            const Text('Transações Recentes', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            ...data.transactions.map((t) => _TransactionItem(transaction: t)),
          ],
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, s) => Center(child: Text('Erro: $e')),
      ),
    );
  }

  void _showAddFunds(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Adicionar Saldo'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              onPressed: () {
                ref.read(walletControllerProvider.notifier).addFunds('current-user-id', 50);
                Navigator.pop(context);
              },
              child: const Text('R\$ 50,00'),
            ),
            ElevatedButton(
              onPressed: () {
                ref.read(walletControllerProvider.notifier).addFunds('current-user-id', 100);
                Navigator.pop(context);
              },
              child: const Text('R\$ 100,00'),
            ),
          ],
        ),
      ),
    );
  }
}

class _BalanceCard extends StatelessWidget {
  final double balance;
  final double cashback;

  const _BalanceCard({required this.balance, required this.cashback});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.blue,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const Text('Saldo Disponível', style: TextStyle(color: Colors.white70)),
            const SizedBox(height: 8),
            Text(
              'R\$ ${balance.toStringAsFixed(2)}',
              style: const TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.card_giftcard, color: Colors.amber),
                const SizedBox(width: 8),
                Text('Cashback: R\$ ${cashback.toStringAsFixed(2)}', style: const TextStyle(color: Colors.white)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _TransactionItem extends StatelessWidget {
  final Transaction transaction;

  const _TransactionItem({required this.transaction});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        transaction.type == 'payment' ? Icons.arrow_upward : Icons.arrow_downward,
        color: transaction.type == 'payment' ? Colors.red : Colors.green,
      ),
      title: Text(transaction.description),
      subtitle: Text(DateFormat('dd/MM/yyyy HH:mm').format(transaction.createdAt)),
      trailing: Text(
        'R\$ ${transaction.amount.abs().toStringAsFixed(2)}',
        style: TextStyle(fontWeight: FontWeight.bold, color: transaction.type == 'payment' ? Colors.red : Colors.green),
      ),
    );
  }
}
