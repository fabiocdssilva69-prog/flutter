import 'package:flutter/material.dart';

class ServicesEditor extends StatefulWidget {
  final List<String> initialServices;
  final Function(List<String>) onSave;

  const ServicesEditor({super.key, required this.initialServices, required this.onSave});

  @override
  State<ServicesEditor> createState() => _ServicesEditorState();
}

class _ServicesEditorState extends State<ServicesEditor> {
  late List<String> _selectedServices;
  final _customServiceController = TextEditingController();

  static const List<String> commonServices = [
    'Corte Masculino',
    'Corte Feminino',
    'Corte Infantil',
    'Barba',
    'Barba + Corte',
    'Degradê',
    'Sobrancelha',
    'Platinado',
    'Luzes',
    'Coloração',
    'Hidratação',
    'Progressiva',
    'Escova',
    'Penteado',
    'Depilação',
    'Manicure',
    'Pedicure',
  ];

  @override
  void initState() {
    super.initState();
    _selectedServices = List.from(widget.initialServices);
  }

  @override
  void dispose() {
    _customServiceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        constraints: const BoxConstraints(maxHeight: 600),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppBar(
              title: const Text('Serviços Oferecidos'),
              automaticallyImplyLeading: false,
              actions: [
                TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
                TextButton(
                  onPressed: () {
                    widget.onSave(_selectedServices);
                    Navigator.pop(context);
                  },
                  child: const Text('Salvar'),
                ),
              ],
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  Text(
                    'Serviços Comuns',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: commonServices.map((service) {
                      final isSelected = _selectedServices.contains(service);
                      return FilterChip(
                        label: Text(service),
                        selected: isSelected,
                        onSelected: (selected) {
                          setState(() {
                            if (selected) {
                              _selectedServices.add(service);
                            } else {
                              _selectedServices.remove(service);
                            }
                          });
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Serviços Personalizados',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _customServiceController,
                          decoration: const InputDecoration(
                            hintText: 'Adicionar serviço personalizado',
                            border: OutlineInputBorder(),
                          ),
                          textCapitalization: TextCapitalization.words,
                          onSubmitted: (value) => _addCustomService(),
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(onPressed: _addCustomService, icon: const Icon(Icons.add), tooltip: 'Adicionar'),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Display custom services (those not in commonServices)
                  ..._selectedServices.where((service) => !commonServices.contains(service)).map((service) {
                    return ListTile(
                      title: Text(service),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          setState(() {
                            _selectedServices.remove(service);
                          });
                        },
                      ),
                    );
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _addCustomService() {
    final service = _customServiceController.text.trim();
    if (service.isNotEmpty && !_selectedServices.contains(service)) {
      setState(() {
        _selectedServices.add(service);
        _customServiceController.clear();
      });
    }
  }
}
