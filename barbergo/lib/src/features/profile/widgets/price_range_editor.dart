import 'package:flutter/material.dart';

class PriceRangeEditor extends StatefulWidget {
  final Map<String, int>? initialRange;
  final Function(Map<String, int>) onSave;

  const PriceRangeEditor({super.key, required this.initialRange, required this.onSave});

  @override
  State<PriceRangeEditor> createState() => _PriceRangeEditorState();
}

class _PriceRangeEditorState extends State<PriceRangeEditor> {
  late RangeValues _priceRange;

  @override
  void initState() {
    super.initState();
    final min = widget.initialRange?['min']?.toDouble() ?? 20.0;
    final max = widget.initialRange?['max']?.toDouble() ?? 200.0;
    _priceRange = RangeValues(min, max);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Faixa de Preço'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'R\$ ${_priceRange.start.round()} - R\$ ${_priceRange.end.round()}',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          RangeSlider(
            values: _priceRange,
            min: 10,
            max: 500,
            divisions: 98, // (500-10)/5 = 98 divisions of R$5
            labels: RangeLabels('R\$ ${_priceRange.start.round()}', 'R\$ ${_priceRange.end.round()}'),
            onChanged: (RangeValues values) {
              setState(() {
                _priceRange = values;
              });
            },
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildPriceBox(label: 'Mínimo', value: _priceRange.start.round()),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildPriceBox(label: 'Máximo', value: _priceRange.end.round()),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'Esta é a faixa de preço dos seus serviços. Clientes poderão filtrar por preço.',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
            textAlign: TextAlign.center,
          ),
        ],
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
        ElevatedButton(
          onPressed: () {
            widget.onSave({'min': _priceRange.start.round(), 'max': _priceRange.end.round()});
            Navigator.pop(context);
          },
          child: const Text('Salvar'),
        ),
      ],
    );
  }

  Widget _buildPriceBox({required String label, required int value}) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.onPrimaryContainer),
          ),
          const SizedBox(height: 4),
          Text(
            'R\$ $value',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: Theme.of(context).colorScheme.onPrimaryContainer,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
