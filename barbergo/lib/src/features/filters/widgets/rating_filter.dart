import 'package:flutter/material.dart';

/// Widget para seleção de avaliação mínima
class RatingFilter extends StatelessWidget {
  final double value;
  final ValueChanged<double> onChanged;

  const RatingFilter({super.key, required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.star, size: 20, color: Colors.amber),
                SizedBox(width: 8),
                Text('Avaliação mínima', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 16),
            // Opções de rating
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildRatingOption(context, 3.0, '3+'),
                _buildRatingOption(context, 3.5, '3.5+'),
                _buildRatingOption(context, 4.0, '4+'),
                _buildRatingOption(context, 4.5, '4.5+'),
                _buildRatingOption(context, 5.0, '5'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRatingOption(BuildContext context, double rating, String label) {
    final isSelected = value == rating;

    return GestureDetector(
      onTap: () => onChanged(rating),
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: isSelected ? Theme.of(context).primaryColor : Colors.grey[200],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isSelected ? Theme.of(context).primaryColor : Colors.grey[300]!, width: 2),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.star, color: isSelected ? Colors.white : Colors.amber, size: 24),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black87,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
