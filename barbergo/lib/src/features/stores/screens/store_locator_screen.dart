import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Localizador de estabelecimentos para encontros
class StoreLocatorScreen extends ConsumerStatefulWidget {
  const StoreLocatorScreen({super.key});

  @override
  ConsumerState<StoreLocatorScreen> createState() => _StoreLocatorScreenState();
}

class _StoreLocatorScreenState extends ConsumerState<StoreLocatorScreen> {
  String _selectedCategory = 'Todos';

  final _categories = ['Todos', 'Restaurantes', 'Cafés', 'Bares', 'Cinemas', 'Parques', 'Museus'];

  final _places = [
    {
      'id': '1',
      'name': 'Restaurante Italiano',
      'category': 'Restaurantes',
      'rating': 4.5,
      'distance': '1.2 km',
      'priceRange': 'R\$ 80-150',
      'isOpen': true,
      'imageUrl': null,
    },
    {
      'id': '2',
      'name': 'Café Aconchego',
      'category': 'Cafés',
      'rating': 4.8,
      'distance': '800 m',
      'priceRange': 'R\$ 20-40',
      'isOpen': true,
      'imageUrl': null,
    },
    {
      'id': '3',
      'name': 'Bar do João',
      'category': 'Bares',
      'rating': 4.3,
      'distance': '2.5 km',
      'priceRange': 'R\$ 30-60',
      'isOpen': false,
      'imageUrl': null,
    },
  ];

  List<Map<String, dynamic>> get _filteredPlaces {
    if (_selectedCategory == 'Todos') return _places;
    return _places.where((place) => place['category'] == _selectedCategory).toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lugares para Encontros'),
        actions: [
          IconButton(
            icon: const Icon(Icons.map),
            onPressed: () {
              // TODO: Abrir visualização de mapa
              context.push('/map');
            },
          ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              // TODO: Abrir filtros
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Busca
          Padding(
            padding: const EdgeInsets.all(16),
            child: SearchBar(
              hintText: 'Buscar lugares...',
              leading: const Icon(Icons.search),
              onChanged: (value) {
                // TODO: Implementar busca
              },
            ),
          ),

          // Categorias
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

          // Lista de lugares
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _filteredPlaces.length,
              itemBuilder: (context, index) {
                final place = _filteredPlaces[index];

                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Card(
                    clipBehavior: Clip.antiAlias,
                    child: InkWell(
                      onTap: () => context.push('/place/${place['id']}'),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Imagem
                          Container(
                            height: 150,
                            color: theme.colorScheme.surfaceContainerHighest,
                            child: Center(
                              child: Icon(Icons.image, size: 48, color: theme.colorScheme.onSurface.withOpacity(0.3)),
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Nome e Status
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        place['name'] as String,
                                        style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: (place['isOpen'] as bool)
                                            ? Colors.green.withOpacity(0.1)
                                            : Colors.red.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        (place['isOpen'] as bool) ? 'Aberto' : 'Fechado',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: (place['isOpen'] as bool) ? Colors.green : Colors.red,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 8),

                                // Rating e Distância
                                Row(
                                  children: [
                                    const Icon(Icons.star, size: 16, color: Colors.amber),
                                    const SizedBox(width: 4),
                                    Text('${place['rating']}', style: theme.textTheme.bodyMedium),
                                    const SizedBox(width: 16),
                                    Icon(Icons.location_on, size: 16, color: theme.colorScheme.primary),
                                    const SizedBox(width: 4),
                                    Text(place['distance'] as String, style: theme.textTheme.bodyMedium),
                                  ],
                                ),

                                const SizedBox(height: 8),

                                // Preço
                                Text(
                                  place['priceRange'] as String,
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: theme.colorScheme.onSurface.withOpacity(0.6),
                                  ),
                                ),

                                const SizedBox(height: 12),

                                // Botões
                                Row(
                                  children: [
                                    Expanded(
                                      child: OutlinedButton.icon(
                                        onPressed: () {
                                          // TODO: Ver no mapa
                                        },
                                        icon: const Icon(Icons.map, size: 16),
                                        label: const Text('Mapa'),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: OutlinedButton.icon(
                                        onPressed: () {
                                          // TODO: Compartilhar
                                        },
                                        icon: const Icon(Icons.share, size: 16),
                                        label: const Text('Compartilhar'),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
