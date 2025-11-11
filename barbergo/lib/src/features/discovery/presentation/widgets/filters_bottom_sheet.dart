import 'package:flutter/material.dart';

import '../../../../domain/entities/enums.dart';
import '../../models/discovery_filters.dart';

class FiltersBottomSheet extends StatefulWidget {
  final DiscoveryFilters currentFilters;
  final Function(DiscoveryFilters) onApply;

  const FiltersBottomSheet({super.key, required this.currentFilters, required this.onApply});

  @override
  State<FiltersBottomSheet> createState() => _FiltersBottomSheetState();
}

class _FiltersBottomSheetState extends State<FiltersBottomSheet> {
  late DiscoveryFilters _filters;

  @override
  void initState() {
    super.initState();
    _filters = widget.currentFilters;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Filtros', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 24),

          // Raio
          const Text('Raio de busca:', style: TextStyle(fontSize: 16)),
          const SizedBox(height: 8),
          SegmentedButton<int>(
            segments: const [
              ButtonSegment(value: 5, label: Text('5 km')),
              ButtonSegment(value: 10, label: Text('10 km')),
              ButtonSegment(value: 25, label: Text('25 km')),
            ],
            selected: {_filters.radiusKm},
            onSelectionChanged: (Set<int> selection) {
              setState(() => _filters = _filters.copyWith(radiusKm: selection.first));
            },
          ),
          const SizedBox(height: 16),

          // Tipo de conta
          const Text('Tipo de usuário:', style: TextStyle(fontSize: 16)),
          const SizedBox(height: 8),
          SegmentedButton<AccountType?>(
            segments: const [
              ButtonSegment(value: null, label: Text('Todos')),
              ButtonSegment(value: AccountType.barber, label: Text('Barbeiros')),
              ButtonSegment(value: AccountType.barbershop, label: Text('Barbearias')),
            ],
            selected: {_filters.accountType},
            onSelectionChanged: (Set<AccountType?> selection) {
              setState(() => _filters = _filters.copyWith(accountType: selection.first));
            },
          ),
          const SizedBox(height: 16),

          // Online
          SwitchListTile(
            title: const Text('Apenas usuários online'),
            value: _filters.onlineOnly,
            onChanged: (value) {
              setState(() => _filters = _filters.copyWith(onlineOnly: value));
            },
          ),
          const SizedBox(height: 24),

          // Botão aplicar
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                widget.onApply(_filters);
                Navigator.pop(context);
              },
              child: const Text('Aplicar Filtros'),
            ),
          ),
        ],
      ),
    );
  }
}
