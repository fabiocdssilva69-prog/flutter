import 'package:flutter/material.dart';

/// Widget para exibir estrelas de avaliação
/// Suporta valores decimais (ex: 4.5 estrelas)
class RatingStars extends StatelessWidget {
  final double rating; // 0.0 a 5.0
  final double size;
  final Color activeColor;
  final Color inactiveColor;
  final bool showRating; // Mostrar número ao lado
  final int? count; // Quantidade de avaliações
  final bool interactive; // Se permite interação (para seleção)
  final ValueChanged<int>? onRatingChanged; // Callback para seleção

  const RatingStars({
    required this.rating,
    this.size = 20,
    this.activeColor = Colors.amber,
    this.inactiveColor = Colors.grey,
    this.showRating = false,
    this.count,
    this.interactive = false,
    this.onRatingChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Estrelas
        for (int i = 1; i <= 5; i++) _buildStar(i),

        // Número da avaliação
        if (showRating) ...[
          const SizedBox(width: 4),
          Text(
            rating.toStringAsFixed(1),
            style: TextStyle(fontSize: size * 0.8, fontWeight: FontWeight.w600, color: Colors.grey[700]),
          ),
        ],

        // Contagem de avaliações
        if (count != null) ...[
          const SizedBox(width: 4),
          Text(
            '($count)',
            style: TextStyle(fontSize: size * 0.7, color: Colors.grey[600]),
          ),
        ],
      ],
    );
  }

  Widget _buildStar(int position) {
    final filled = rating >= position;
    final halfFilled = !filled && rating > position - 1;

    Widget star;

    if (filled) {
      // Estrela cheia
      star = Icon(Icons.star, size: size, color: activeColor);
    } else if (halfFilled) {
      // Estrela meia
      star = Icon(Icons.star_half, size: size, color: activeColor);
    } else {
      // Estrela vazia
      star = Icon(Icons.star_border, size: size, color: inactiveColor);
    }

    // Se é interativo, envolve em GestureDetector
    if (interactive && onRatingChanged != null) {
      return GestureDetector(
        onTap: () => onRatingChanged!(position),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: size * 0.05),
          child: star,
        ),
      );
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: size * 0.05),
      child: star,
    );
  }
}

/// Widget para selecionar estrelas de avaliação
class RatingSelector extends StatefulWidget {
  final int initialRating;
  final ValueChanged<int> onRatingChanged;
  final double size;
  final Color activeColor;
  final Color inactiveColor;

  const RatingSelector({
    required this.onRatingChanged,
    this.initialRating = 0,
    this.size = 40,
    this.activeColor = Colors.amber,
    this.inactiveColor = Colors.grey,
    super.key,
  });

  @override
  State<RatingSelector> createState() => _RatingSelectorState();
}

class _RatingSelectorState extends State<RatingSelector> {
  late int _selectedRating;

  @override
  void initState() {
    super.initState();
    _selectedRating = widget.initialRating;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (index) {
        final starNumber = index + 1;
        return GestureDetector(
          onTap: () {
            setState(() {
              _selectedRating = starNumber;
            });
            widget.onRatingChanged(starNumber);
          },
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: widget.size * 0.1),
            child: Icon(
              starNumber <= _selectedRating ? Icons.star : Icons.star_border,
              size: widget.size,
              color: starNumber <= _selectedRating ? widget.activeColor : widget.inactiveColor,
            ),
          ),
        );
      }),
    );
  }
}

/// Widget para exibir distribuição de estrelas (barras)
class RatingDistribution extends StatelessWidget {
  final Map<int, int> distribution; // {5: 10, 4: 5, 3: 2, 2: 1, 1: 0}
  final int totalRatings;
  final Color barColor;

  const RatingDistribution({
    required this.distribution,
    required this.totalRatings,
    this.barColor = Colors.amber,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (int stars = 5; stars >= 1; stars--)
          Padding(padding: const EdgeInsets.symmetric(vertical: 4), child: _buildBar(stars)),
      ],
    );
  }

  Widget _buildBar(int stars) {
    final count = distribution[stars] ?? 0;
    final percentage = totalRatings > 0 ? (count / totalRatings) * 100 : 0.0;

    return Row(
      children: [
        // Estrelas
        SizedBox(
          width: 20,
          child: Text('$stars', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
        ),
        const Icon(Icons.star, size: 16, color: Colors.amber),
        const SizedBox(width: 8),

        // Barra de progresso
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: percentage / 100,
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation<Color>(barColor),
              minHeight: 8,
            ),
          ),
        ),

        const SizedBox(width: 8),

        // Porcentagem
        SizedBox(
          width: 50,
          child: Text(
            '${percentage.toStringAsFixed(0)}%',
            style: const TextStyle(fontSize: 12, color: Colors.grey),
            textAlign: TextAlign.end,
          ),
        ),
      ],
    );
  }
}
