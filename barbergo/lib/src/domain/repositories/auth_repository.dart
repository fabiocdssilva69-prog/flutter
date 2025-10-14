import 'package:barbergo_app/src/domain/entities/enums.dart';

/// Abstração responsável por expor o estado de autenticação e tipo de conta.
abstract class AuthRepository {
  /// Stream com o identificador único do usuário autenticado.
  Stream<String?> authStateChanges();

  /// Stream com o tipo de conta associado ao usuário autenticado.
  ///
  /// Quando não há usuário conectado o stream deve emitir `null`.
  Stream<AccountType?> accountTypeChanges();
}
