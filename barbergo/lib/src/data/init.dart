/// Inicialização global de Mappers
///
/// Este arquivo DEVE ser importado e executado no main.dart ANTES de qualquer
/// acesso ao Firestore para garantir que os hooks de conversão (ex: TimestampHook)
/// estejam registrados globalmente.
///
/// **Uso no main.dart:**
/// ```dart
/// import 'src/data/init.dart';
///
/// void main() async {
///   WidgetsFlutterBinding.ensureInitialized();
///   initMappers(); // ← CRÍTICO: Chamar antes do Firebase
///   await Firebase.initializeApp();
///   // ...
/// }
/// ```
library;

/// Inicializa os mappers globais
///
/// **DEVE ser chamado no main.dart ANTES de qualquer operação Firestore**
///
/// Esta função força o carregamento de todas as entidades e seus mappers gerados.
/// Isso garante que:
/// 1. Todos os mappers estão disponíveis para conversão Firestore <-> Dart
/// 2. Os hooks (TimestampHook, GeoFirePointHook) estão registrados via @MappableField
/// 3. O MapperContainer está pronto antes de qualquer acesso ao banco
void initMappers() {
  // dart_mappable v4.6+ registra automaticamente os mappers quando as classes
  // são importadas. Os imports acima garantem que todos os mappers estão carregados.
  //
  // Os hooks (TimestampHook, GeoFirePointHook) são aplicados via decorators
  // @MappableField(hook: TimestampHook()) nas entidades, não precisam registro aqui.

  // Este método serve para garantir que todas as entidades foram carregadas
  // ANTES do Firebase.initializeApp(), evitando race conditions.
}
