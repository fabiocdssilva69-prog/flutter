/// Riverpod testing utilities
///
/// This file contains helper functions for testing Riverpod providers.
///
/// Note: Basic createContainer function is available in test_helpers.dart
/// Import test_helpers.dart to use createContainer().
library;

/// Cria um listener mock para observar mudanças em um provider
///
/// Útil para verificar se um provider notificou seus listeners corretamente.
///
/// Exemplo de uso:
/// ```dart
/// test('should notify listeners when state changes', () {
///   final container = createContainer();
///   final listener = MockListener<AsyncValue<User?>>();
///
///   container.listen(
///     authStateChangesProvider,
///     listener.call,
///     fireImmediately: true,
///   );
///
///   verify(() => listener(null, any())).called(1);
/// });
/// ```
class MockListener<T> {
  final List<T?> _previousValues = [];
  final List<T> _currentValues = [];

  void call(T? previous, T current) {
    _previousValues.add(previous);
    _currentValues.add(current);
  }

  /// Retorna o número de vezes que o listener foi chamado
  int get callCount => _currentValues.length;

  /// Retorna todos os valores anteriores recebidos
  List<T?> get previousValues => List.unmodifiable(_previousValues);

  /// Retorna todos os valores atuais recebidos
  List<T> get currentValues => List.unmodifiable(_currentValues);

  /// Retorna o último valor atual recebido
  T? get lastValue => _currentValues.isEmpty ? null : _currentValues.last;

  /// Limpa o histórico de chamadas
  void reset() {
    _previousValues.clear();
    _currentValues.clear();
  }
}
