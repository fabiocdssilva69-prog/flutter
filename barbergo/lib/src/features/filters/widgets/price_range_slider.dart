import 'package:flutter/material.dart';

/// Widget de range slider para seleção de faixa de preço
class PriceRangeSlider extends StatelessWidget {
  final double minValue;
  final double maxValue;
  final Function(double min, double max) onChanged;

  const PriceRangeSlider({super.key, required this.minValue, required this.maxValue, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Row(
                  children: [
                    Icon(Icons.attach_money, size: 20),
                    SizedBox(width: 8),
                    Text('Faixa de preço', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'R\$ ${minValue.toInt()} - R\$ ${maxValue.toInt()}',
                    style: TextStyle(color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            RangeSlider(
              values: RangeValues(minValue, maxValue),
              min: 20,
              max: 200,
              divisions: 36, // Intervalos de R$5
              labels: RangeLabels('R\$ ${minValue.toInt()}', 'R\$ ${maxValue.toInt()}'),
              onChanged: (values) {
                onChanged(values.start, values.end);
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('R\$ 20', style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                Text('R\$ 200', style: TextStyle(fontSize: 12, color: Colors.grey[600])),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
