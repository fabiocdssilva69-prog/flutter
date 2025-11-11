import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../controllers/payment_controller.dart';

class PaymentScreen extends ConsumerStatefulWidget {
  final double amount;
  final String? bookingId;
  final String description;

  const PaymentScreen({super.key, required this.amount, this.bookingId, required this.description});

  @override
  ConsumerState<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends ConsumerState<PaymentScreen> {
  PaymentMethod _selectedMethod = PaymentMethod.pix;
  PaymentTransaction? _pixTransaction;
  bool _isProcessing = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pagamento')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildAmountCard(),
          const SizedBox(height: 24),
          const Text('Escolha o método de pagamento', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          _buildPaymentMethodSelector(),
          const SizedBox(height: 24),
          if (_selectedMethod == PaymentMethod.pix) _buildPixPayment(),
          if (_selectedMethod == PaymentMethod.creditCard) _buildCardPayment(),
          if (_selectedMethod == PaymentMethod.wallet) _buildWalletPayment(),
        ],
      ),
    );
  }

  Widget _buildAmountCard() {
    return Card(
      color: Colors.blue,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Text('Valor a pagar', style: TextStyle(color: Colors.white70)),
            const SizedBox(height: 8),
            Text(
              'R\$ ${widget.amount.toStringAsFixed(2)}',
              style: const TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(widget.description, style: const TextStyle(color: Colors.white70)),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentMethodSelector() {
    return Column(
      children: [
        _PaymentMethodTile(
          icon: Icons.pix,
          title: 'PIX',
          subtitle: 'Aprovação instantânea',
          isSelected: _selectedMethod == PaymentMethod.pix,
          onTap: () => setState(() => _selectedMethod = PaymentMethod.pix),
        ),
        const SizedBox(height: 12),
        _PaymentMethodTile(
          icon: Icons.credit_card,
          title: 'Cartão de Crédito',
          subtitle: 'Parcelamento disponível',
          isSelected: _selectedMethod == PaymentMethod.creditCard,
          onTap: () => setState(() => _selectedMethod = PaymentMethod.creditCard),
        ),
        const SizedBox(height: 12),
        _PaymentMethodTile(
          icon: Icons.account_balance_wallet,
          title: 'Carteira Digital',
          subtitle: 'Use seu saldo',
          isSelected: _selectedMethod == PaymentMethod.wallet,
          onTap: () => setState(() => _selectedMethod = PaymentMethod.wallet),
        ),
      ],
    );
  }

  Widget _buildPixPayment() {
    if (_pixTransaction == null) {
      return ElevatedButton(onPressed: _generatePixPayment, child: const Text('Gerar QR Code PIX'));
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text('Escaneie o QR Code', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            if (_pixTransaction!.pixQrCode != null)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                child: QrImageView(data: _pixTransaction!.pixCopyPaste!, size: 200),
              ),
            const SizedBox(height: 16),
            const Text('ou copie o código', style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(8)),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      _pixTransaction!.pixCopyPaste!,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 12, fontFamily: 'monospace'),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.copy),
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: _pixTransaction!.pixCopyPaste!));
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Código copiado!')));
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            if (_isProcessing)
              const Column(
                children: [CircularProgressIndicator(), SizedBox(height: 8), Text('Aguardando pagamento...')],
              )
            else
              ElevatedButton(onPressed: _checkPixPayment, child: const Text('Verificar Pagamento')),
          ],
        ),
      ),
    );
  }

  Widget _buildCardPayment() {
    final cardNumberController = TextEditingController();
    final nameController = TextEditingController();
    final expiryController = TextEditingController();
    final cvvController = TextEditingController();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: cardNumberController,
              decoration: const InputDecoration(labelText: 'Número do Cartão', prefixIcon: Icon(Icons.credit_card)),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            ),
            const SizedBox(height: 16),
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Nome no Cartão', prefixIcon: Icon(Icons.person)),
              textCapitalization: TextCapitalization.characters,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: expiryController,
                    decoration: const InputDecoration(labelText: 'Validade (MM/AA)'),
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextField(
                    controller: cvvController,
                    decoration: const InputDecoration(labelText: 'CVV'),
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    maxLength: 3,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _isProcessing
                  ? null
                  : () => _processCardPayment(
                      cardNumberController.text,
                      nameController.text,
                      expiryController.text,
                      cvvController.text,
                    ),
              child: _isProcessing ? const CircularProgressIndicator() : const Text('Pagar com Cartão'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWalletPayment() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Icon(Icons.account_balance_wallet, size: 64, color: Colors.blue),
            const SizedBox(height: 16),
            const Text('Pagar com Carteira Digital', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text('O valor será debitado do seu saldo', style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _isProcessing ? null : _processWalletPayment,
              child: _isProcessing ? const CircularProgressIndicator() : const Text('Confirmar Pagamento'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _generatePixPayment() async {
    setState(() => _isProcessing = true);

    try {
      final transaction = await ref
          .read(paymentControllerProvider.notifier)
          .generatePixPayment(userId: 'current-user-id', amount: widget.amount, bookingId: widget.bookingId);

      setState(() {
        _pixTransaction = transaction;
        _isProcessing = false;
      });
    } catch (e) {
      setState(() => _isProcessing = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erro: $e')));
      }
    }
  }

  Future<void> _checkPixPayment() async {
    if (_pixTransaction == null) return;

    setState(() => _isProcessing = true);

    try {
      await ref.read(paymentControllerProvider.notifier).checkPixPaymentStatus(_pixTransaction!.id);

      setState(() => _isProcessing = false);

      if (mounted) {
        Navigator.pop(context, true);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Pagamento confirmado!')));
      }
    } catch (e) {
      setState(() => _isProcessing = false);
    }
  }

  Future<void> _processCardPayment(String number, String name, String expiry, String cvv) async {
    if (number.isEmpty || name.isEmpty || expiry.isEmpty || cvv.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Preencha todos os campos')));
      return;
    }

    setState(() => _isProcessing = true);

    try {
      final transaction = await ref
          .read(paymentControllerProvider.notifier)
          .processCardPayment(
            userId: 'current-user-id',
            amount: widget.amount,
            cardNumber: number,
            cardholderName: name,
            expiryDate: expiry,
            cvv: cvv,
            bookingId: widget.bookingId,
          );

      setState(() => _isProcessing = false);

      if (transaction.status == PaymentStatus.completed) {
        if (mounted) {
          Navigator.pop(context, true);
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Pagamento aprovado!')));
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Pagamento recusado: ${transaction.errorMessage}')));
        }
      }
    } catch (e) {
      setState(() => _isProcessing = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erro: $e')));
      }
    }
  }

  Future<void> _processWalletPayment() async {
    setState(() => _isProcessing = true);

    try {
      await ref
          .read(paymentControllerProvider.notifier)
          .processWalletPayment(userId: 'current-user-id', amount: widget.amount, bookingId: widget.bookingId);

      setState(() => _isProcessing = false);

      if (mounted) {
        Navigator.pop(context, true);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Pagamento realizado!')));
      }
    } catch (e) {
      setState(() => _isProcessing = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erro: $e')));
      }
    }
  }
}

class _PaymentMethodTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool isSelected;
  final VoidCallback onTap;

  const _PaymentMethodTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: isSelected ? Colors.blue.withOpacity(0.1) : null,
      child: ListTile(
        leading: Icon(icon, color: isSelected ? Colors.blue : Colors.grey),
        title: Text(title, style: TextStyle(fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
        subtitle: Text(subtitle),
        trailing: isSelected ? const Icon(Icons.check_circle, color: Colors.blue) : null,
        onTap: onTap,
      ),
    );
  }
}
