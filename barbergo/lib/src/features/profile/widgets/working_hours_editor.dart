import 'package:flutter/material.dart';

class WorkingHoursEditor extends StatefulWidget {
  final Map<String, String?> initialHours;
  final Function(Map<String, String?>) onSave;

  const WorkingHoursEditor({super.key, required this.initialHours, required this.onSave});

  @override
  State<WorkingHoursEditor> createState() => _WorkingHoursEditorState();
}

class _WorkingHoursEditorState extends State<WorkingHoursEditor> {
  late Map<String, String?> _workingHours;

  static const weekdays = ['monday', 'tuesday', 'wednesday', 'thursday', 'friday', 'saturday', 'sunday'];

  static const weekdayNames = {
    'monday': 'Segunda-feira',
    'tuesday': 'Terça-feira',
    'wednesday': 'Quarta-feira',
    'thursday': 'Quinta-feira',
    'friday': 'Sexta-feira',
    'saturday': 'Sábado',
    'sunday': 'Domingo',
  };

  @override
  void initState() {
    super.initState();
    _workingHours = Map.from(widget.initialHours);

    // Initialize all weekdays if not present
    for (var day in weekdays) {
      _workingHours.putIfAbsent(day, () => null);
    }
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
              title: const Text('Horário de Funcionamento'),
              automaticallyImplyLeading: false,
              actions: [
                TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
                TextButton(
                  onPressed: () {
                    widget.onSave(_workingHours);
                    Navigator.pop(context);
                  },
                  child: const Text('Salvar'),
                ),
              ],
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: weekdays.map((day) {
                  return _buildDayEditor(day);
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDayEditor(String day) {
    final hours = _workingHours[day];
    final isClosed = hours == null;

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(weekdayNames[day]!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                Switch(
                  value: !isClosed,
                  onChanged: (value) {
                    setState(() {
                      if (value) {
                        _workingHours[day] = '09:00 - 18:00';
                      } else {
                        _workingHours[day] = null;
                      }
                    });
                  },
                ),
              ],
            ),
            if (!isClosed) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: _buildTimeField(
                      label: 'Abertura',
                      value: hours.split(' - ').first ?? '09:00',
                      onChanged: (value) {
                        final close = hours.split(' - ').last ?? '18:00';
                        setState(() {
                          _workingHours[day] = '$value - $close';
                        });
                      },
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: Text('-', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  Expanded(
                    child: _buildTimeField(
                      label: 'Fechamento',
                      value: hours.split(' - ').last ?? '18:00',
                      onChanged: (value) {
                        final open = hours.split(' - ').first ?? '09:00';
                        setState(() {
                          _workingHours[day] = '$open - $value';
                        });
                      },
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildTimeField({required String label, required String value, required Function(String) onChanged}) {
    return InkWell(
      onTap: () async {
        final TimeOfDay? picked = await showTimePicker(context: context, initialTime: _parseTimeOfDay(value));
        if (picked != null) {
          onChanged(_formatTimeOfDay(picked));
        }
      },
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        ),
        child: Text(value, style: const TextStyle(fontSize: 16)),
      ),
    );
  }

  TimeOfDay _parseTimeOfDay(String timeString) {
    final parts = timeString.split(':');
    return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
  }

  String _formatTimeOfDay(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }
}
