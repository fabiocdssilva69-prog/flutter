import 'package:flutter/material.dart';

/// Lista de tipos de serviço disponíveis
const List<String> _availableServices = [
  'Corte',
  'Barba',
  'Coloração',
  'Luzes',
  'Platinado',
  'Sobrancelha',
  'Depilação',
  'Hidratação',
  'Penteado',
  'Massagem',
];

/// Widget de chips para seleção de tipos de serviço
class ServiceTypeChips extends StatelessWidget {
  final List<String> selectedServices;
  final Function(String service, bool isSelected) onServiceToggled;

  const ServiceTypeChips({super.key, required this.selectedServices, required this.onServiceToggled});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _availableServices.map((service) {
            final isSelected = selectedServices.contains(service);

            return FilterChip(
              label: Text(service),
              selected: isSelected,
              onSelected: (selected) {
                onServiceToggled(service, selected);
              },
              selectedColor: Theme.of(context).primaryColor.withOpacity(0.2),
              checkmarkColor: Theme.of(context).primaryColor,
              avatar: isSelected ? Icon(Icons.check, size: 18, color: Theme.of(context).primaryColor) : null,
              labelStyle: TextStyle(
                color: isSelected ? Theme.of(context).primaryColor : Colors.black87,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
