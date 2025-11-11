import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../services/firebase_service.dart';

/// Widget de demonstração dos serviços Firebase
///
/// Este widget mostra como usar:
/// - Firebase Analytics: logEvents, logScreenView, logBooking
/// - Firebase Crashlytics: recordError, log, setCustomKey
/// - Firebase Remote Config: feature flags e configurações remotas
class FirebaseServicesDemo extends ConsumerWidget {
  const FirebaseServicesDemo({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final analytics = ref.watch(firebaseAnalyticsServiceProvider);
    final crashlytics = ref.watch(firebaseCrashlyticsServiceProvider);
    final remoteConfig = ref.watch(firebaseRemoteConfigServiceProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Firebase Services Demo')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Analytics Section
          _buildSection(
            title: '📊 Firebase Analytics',
            color: Colors.blue,
            children: [
              ElevatedButton(
                onPressed: () async {
                  await analytics.logScreenView('demo_screen');
                  _showSnackBar(context, 'Screen view logged!');
                },
                child: const Text('Log Screen View'),
              ),
              ElevatedButton(
                onPressed: () async {
                  await analytics.logBookingCreated(serviceType: 'haircut', value: 50.0);
                  _showSnackBar(context, 'Booking created event logged!');
                },
                child: const Text('Log Booking Created'),
              ),
              ElevatedButton(
                onPressed: () async {
                  await analytics.logSearch('barber shop near me');
                  _showSnackBar(context, 'Search event logged!');
                },
                child: const Text('Log Search'),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Crashlytics Section
          _buildSection(
            title: '🐛 Firebase Crashlytics',
            color: Colors.red,
            children: [
              ElevatedButton(
                onPressed: () async {
                  crashlytics.log('User clicked test button');
                  await crashlytics.recordError(
                    Exception('This is a test error'),
                    StackTrace.current,
                    reason: 'Testing Crashlytics',
                  );
                  _showSnackBar(context, 'Non-fatal error logged!');
                },
                child: const Text('Log Non-Fatal Error'),
              ),
              ElevatedButton(
                onPressed: () async {
                  await crashlytics.setCustomKey('test_key', 'test_value');
                  _showSnackBar(context, 'Custom key set!');
                },
                child: const Text('Set Custom Key'),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                onPressed: () {
                  // ATENÇÃO: Isso vai crashar o app de propósito!
                  throw Exception('Forced crash for testing');
                },
                child: const Text('⚠️ FORCE CRASH (Test Only)'),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Remote Config Section
          _buildSection(
            title: '🎛️ Firebase Remote Config',
            color: Colors.green,
            children: [
              ElevatedButton(
                onPressed: () async {
                  final success = await remoteConfig.fetchAndActivate();
                  _showSnackBar(context, success ? 'Remote config fetched!' : 'No changes in config');
                },
                child: const Text('Fetch Remote Config'),
              ),
              ElevatedButton(
                onPressed: () {
                  final value = remoteConfig.getBool('enable_new_feature');
                  _showSnackBar(context, 'enable_new_feature: $value');
                },
                child: const Text('Get Feature Flag'),
              ),
              ElevatedButton(
                onPressed: () {
                  final value = remoteConfig.getString('welcome_message');
                  _showSnackBar(context, 'Message: $value');
                },
                child: const Text('Get Welcome Message'),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Info Card
          Card(
            color: Colors.amber.shade50,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.info_outline, color: Colors.amber.shade900),
                      const SizedBox(width: 8),
                      Text(
                        'Como usar',
                        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.amber.shade900),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    '1. Analytics: Eventos aparecem no Firebase Console após 24h\n'
                    '2. Crashlytics: Erros aparecem em tempo real\n'
                    '3. Remote Config: Configure valores no console',
                    style: TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection({required String title, required Color color, required List<Widget> children}) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color),
            ),
            const SizedBox(height: 16),
            ...children.map(
              (child) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: SizedBox(width: double.infinity, child: child),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message), duration: const Duration(seconds: 2)));
  }
}
