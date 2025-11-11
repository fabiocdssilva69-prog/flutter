import 'package:flutter/material.dart';

class UploadProgressOverlay extends StatelessWidget {
  final int current;
  final int total;
  final String? currentFileName;

  const UploadProgressOverlay({super.key, required this.current, required this.total, this.currentFileName});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black54,
      child: Center(
        child: Card(
          margin: const EdgeInsets.all(24),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircularProgressIndicator(),
                const SizedBox(height: 24),
                Text('Enviando fotos...', style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 8),
                Text(
                  '$current / $total',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (currentFileName != null) ...[
                  const SizedBox(height: 16),
                  Text(
                    currentFileName!,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
                const SizedBox(height: 16),
                LinearProgressIndicator(value: current / total, backgroundColor: Colors.grey[300]),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
