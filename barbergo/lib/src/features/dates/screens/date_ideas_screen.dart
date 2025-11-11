import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/widgets/common_widgets.dart';

/// Ideias de Encontros
class DateIdeasScreen extends ConsumerStatefulWidget {
  const DateIdeasScreen({super.key});

  @override
  ConsumerState<DateIdeasScreen> createState() => _DateIdeasScreenState();
}

class _DateIdeasScreenState extends ConsumerState<DateIdeasScreen> {
  String _selectedCategory = 'Todas';

  final _categories = ['Todas', 'Romance', 'Aventura', 'Cultura', 'Gastronomia', 'Esportes'];

  final _ideas = [
    {
      'title': 'Jantar à luz de velas',
      'category': 'Romance',
      'description': 'Um jantar romântico em um restaurante aconchegante',
      'duration': '2-3 horas',
      'cost': 'R\$ 100-200',
      'icon': Icons.restaurant,
    },
    {
      'title': 'Trilha na natureza',
      'category': 'Aventura',
      'description': 'Caminhe por trilhas e aprecie a natureza juntos',
      'duration': '3-4 horas',
      'cost': 'Gratuito',
      'icon': Icons.hiking,
    },
    {
      'title': 'Museu de arte',
      'category': 'Cultura',
      'description': 'Explore exposições e conheçam juntos o mundo da arte',
      'duration': '2-3 horas',
      'cost': 'R\$ 20-40',
      'icon': Icons.palette,
    },
    {
      'title': 'Food truck tour',
      'category': 'Gastronomia',
      'description': 'Experimente diferentes food trucks pela cidade',
      'duration': '2-3 horas',
      'cost': 'R\$ 50-100',
      'icon': Icons.food_bank,
    },
    {
      'title': 'Aula de dança',
      'category': 'Esportes',
      'description': 'Aprendam uma nova dança juntos',
      'duration': '1-2 horas',
      'cost': 'R\$ 30-60',
      'icon': Icons.music_note,
    },
    {
      'title': 'Cinema ao ar livre',
      'category': 'Romance',
      'description': 'Assistam a um filme sob as estrelas',
      'duration': '2-3 horas',
      'cost': 'R\$ 40-80',
      'icon': Icons.movie,
    },
  ];

  List<Map<String, dynamic>> get _filteredIdeas {
    if (_selectedCategory == 'Todas') return _ideas;
    return _ideas.where((idea) => idea['category'] == _selectedCategory).toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ideias de Encontros'),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite_outline),
            onPressed: () {
              // TODO: Ver favoritos
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Filtro de categorias
          Container(
            height: 60,
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                final category = _categories[index];
                final isSelected = _selectedCategory == category;

                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(category),
                    selected: isSelected,
                    onSelected: (selected) {
                      if (selected) {
                        setState(() => _selectedCategory = category);
                      }
                    },
                  ),
                );
              },
            ),
          ),

          // Lista de ideias
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _filteredIdeas.length,
              itemBuilder: (context, index) {
                final idea = _filteredIdeas[index];

                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Card(
                    child: InkWell(
                      onTap: () {
                        _showIdeaDetails(idea);
                      },
                      borderRadius: BorderRadius.circular(12),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: theme.colorScheme.primaryContainer,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(idea['icon'] as IconData, color: theme.colorScheme.primary, size: 32),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    idea['title'] as String,
                                    style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    idea['description'] as String,
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      color: theme.colorScheme.onSurface.withOpacity(0.6),
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.access_time,
                                        size: 16,
                                        color: theme.colorScheme.onSurface.withOpacity(0.6),
                                      ),
                                      const SizedBox(width: 4),
                                      Text(idea['duration'] as String, style: theme.textTheme.bodySmall),
                                      const SizedBox(width: 16),
                                      Icon(
                                        Icons.attach_money,
                                        size: 16,
                                        color: theme.colorScheme.onSurface.withOpacity(0.6),
                                      ),
                                      const SizedBox(width: 4),
                                      Text(idea['cost'] as String, style: theme.textTheme.bodySmall),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.favorite_border),
                              onPressed: () {
                                // TODO: Adicionar aos favoritos
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // TODO: Sugerir ideia aleatória
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Gerando sugestão aleatória...')));
        },
        icon: const Icon(Icons.shuffle),
        label: const Text('Surpresa!'),
      ),
    );
  }

  void _showIdeaDetails(Map<String, dynamic> idea) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        final theme = Theme.of(context);

        return DraggableScrollableSheet(
          initialChildSize: 0.7,
          minChildSize: 0.5,
          maxChildSize: 0.9,
          expand: false,
          builder: (context, scrollController) {
            return Padding(
              padding: const EdgeInsets.all(24),
              child: ListView(
                controller: scrollController,
                children: [
                  // Handle
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.onSurface.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Ícone
                  Center(
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(color: theme.colorScheme.primaryContainer, shape: BoxShape.circle),
                      child: Icon(idea['icon'] as IconData, color: theme.colorScheme.primary, size: 48),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Título
                  Text(
                    idea['title'] as String,
                    style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 8),

                  // Categoria
                  Center(
                    child: Chip(
                      label: Text(idea['category'] as String),
                      backgroundColor: theme.colorScheme.primaryContainer,
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Descrição
                  Text(idea['description'] as String, style: theme.textTheme.bodyLarge, textAlign: TextAlign.center),

                  const SizedBox(height: 32),

                  // Informações
                  _buildInfoRow(theme, Icons.access_time, 'Duração', idea['duration'] as String),
                  const SizedBox(height: 12),
                  _buildInfoRow(theme, Icons.attach_money, 'Custo estimado', idea['cost'] as String),

                  const SizedBox(height: 32),

                  // Botões
                  PrimaryButton(
                    text: 'Compartilhar Ideia',
                    icon: Icons.share,
                    onPressed: () {
                      // TODO: Compartilhar
                      Navigator.pop(context);
                    },
                  ),

                  const SizedBox(height: 12),

                  SecondaryButton(
                    text: 'Adicionar aos Favoritos',
                    icon: Icons.favorite_outline,
                    onPressed: () {
                      // TODO: Favoritar
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildInfoRow(ThemeData theme, IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: theme.colorScheme.primary),
        const SizedBox(width: 12),
        Text('$label: ', style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold)),
        Text(value, style: theme.textTheme.bodyMedium),
      ],
    );
  }
}
