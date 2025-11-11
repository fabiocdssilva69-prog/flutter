import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

/// Tela de debug para testar carregamento de imagens das seeds
/// Verifica conectividade, tempo de resposta e status HTTP
class ImageTestScreen extends StatefulWidget {
  const ImageTestScreen({super.key});

  @override
  State<ImageTestScreen> createState() => _ImageTestScreenState();
}

class _ImageTestScreenState extends State<ImageTestScreen> {
  final List<Map<String, dynamic>> _results = [];
  bool _isTesting = false;

  // URLs das seeds para testar
  final List<String> _testUrls = [
    'https://i.pravatar.cc/400?img=12', // Carlos Silva
    'https://i.pravatar.cc/400?img=33', // Rafael Costa
    'https://i.pravatar.cc/400?img=51', // Thiago Alves
    'https://images.unsplash.com/photo-1503951914875-452162b0f3f1?w=400', // Barbearia Classic
    'https://i.pravatar.cc/400?img=60', // Lucas Mendes
    'https://images.unsplash.com/photo-1585747860715-2ba37e788b70?w=400', // Barbearia Premium
    'https://i.pravatar.cc/400?img=68', // André Santos
    'https://i.pravatar.cc/400?img=15', // Felipe Rodrigues
    'https://images.unsplash.com/photo-1622286346003-c6e7c316c28a?w=400', // The Barber House
    'https://i.pravatar.cc/400?img=70', // Marcelo Ferreira
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('🔧 Image URL Tester'), backgroundColor: Colors.deepOrange),
      body: Column(
        children: [
          // Botão de Teste
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton.icon(
              onPressed: _isTesting ? null : _runTests,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepOrange,
                minimumSize: const Size(double.infinity, 50),
              ),
              icon: _isTesting
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                    )
                  : const Icon(Icons.play_arrow),
              label: Text(
                _isTesting ? 'Testando URLs...' : '▶️ Testar Todas as URLs (${_testUrls.length})',
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ),

          // Estatísticas
          if (_results.isNotEmpty) ...[
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStat('✅ OK', _results.where((r) => r['status'] == 'success').length, Colors.green),
                  _buildStat('❌ Erro', _results.where((r) => r['status'] == 'error').length, Colors.red),
                  _buildStat(
                    '⏱️ Média',
                    _results.isNotEmpty
                        ? _results
                                  .where((r) => r['status'] == 'success')
                                  .map((r) => r['duration'] as int)
                                  .fold<int>(0, (a, b) => a + b) ~/
                              _results.where((r) => r['status'] == 'success').length
                        : 0,
                    Colors.blue,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
          ],

          // Lista de Resultados
          Expanded(
            child: _results.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.image_search, size: 80, color: Colors.grey[400]),
                        const SizedBox(height: 16),
                        Text(
                          'Clique no botão para testar URLs',
                          style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _results.length,
                    itemBuilder: (context, index) {
                      final result = _results[index];
                      final isSuccess = result['status'] == 'success';
                      final color = isSuccess ? Colors.green[50] : Colors.red[50];
                      final borderColor = isSuccess ? Colors.green : Colors.red;

                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: color,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: borderColor),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Status e URL
                            Row(
                              children: [
                                Text(isSuccess ? '✅' : '❌', style: const TextStyle(fontSize: 20)),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    result['url'],
                                    style: const TextStyle(fontSize: 12, fontFamily: 'monospace'),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),

                            // Detalhes
                            if (isSuccess) ...[
                              Row(
                                children: [
                                  Icon(Icons.check_circle, size: 16, color: Colors.green[700]),
                                  const SizedBox(width: 4),
                                  Text(
                                    'HTTP ${result['statusCode']}',
                                    style: TextStyle(fontSize: 12, color: Colors.green[700]),
                                  ),
                                  const SizedBox(width: 16),
                                  Icon(Icons.timer, size: 16, color: Colors.blue[700]),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${result['duration']}ms',
                                    style: TextStyle(fontSize: 12, color: Colors.blue[700]),
                                  ),
                                  const SizedBox(width: 16),
                                  Icon(Icons.image, size: 16, color: Colors.purple[700]),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${(result['size'] / 1024).toStringAsFixed(1)} KB',
                                    style: TextStyle(fontSize: 12, color: Colors.purple[700]),
                                  ),
                                ],
                              ),
                            ] else ...[
                              Row(
                                children: [
                                  Icon(Icons.error, size: 16, color: Colors.red[700]),
                                  const SizedBox(width: 4),
                                  Expanded(
                                    child: Text(
                                      result['error'],
                                      style: TextStyle(fontSize: 12, color: Colors.red[700]),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildStat(String label, int value, Color color) {
    return Column(
      children: [
        Text(
          value.toString(),
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color),
        ),
        Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
      ],
    );
  }

  Future<void> _runTests() async {
    setState(() {
      _isTesting = true;
      _results.clear();
    });

    for (final url in _testUrls) {
      await _testUrl(url);
      // Pequeno delay para não sobrecarregar
      await Future.delayed(const Duration(milliseconds: 100));
    }

    setState(() {
      _isTesting = false;
    });
  }

  Future<void> _testUrl(String url) async {
    final start = DateTime.now();

    try {
      final response = await http
          .get(Uri.parse(url))
          .timeout(const Duration(seconds: 10), onTimeout: () => throw Exception('Timeout após 10s'));

      final duration = DateTime.now().difference(start).inMilliseconds;

      setState(() {
        _results.add({
          'url': url,
          'status': 'success',
          'statusCode': response.statusCode,
          'duration': duration,
          'size': response.bodyBytes.length,
        });
      });

      debugPrint('✅ $url → ${response.statusCode} (${duration}ms, ${response.bodyBytes.length} bytes)');
    } catch (e) {
      final duration = DateTime.now().difference(start).inMilliseconds;

      setState(() {
        _results.add({'url': url, 'status': 'error', 'error': e.toString(), 'duration': duration});
      });

      debugPrint('❌ $url → ERROR: $e (${duration}ms)');
    }
  }
}
