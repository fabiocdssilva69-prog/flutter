import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Extensão que facilita a exibição de erros centralizados na UI
extension AsyncValueUI on AsyncValue {
  // Mostra um AlertDialog se o estado atual for um erro.
  void showAlertDialogOnError(BuildContext context) {
    // Mostra o diálogo apenas se não estiver carregando E houver um erro
    if (!isLoading && hasError) {
      final String errorMessage = _getErrorMessage(error);

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Atenção'),
          content: Text(errorMessage),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  String _getErrorMessage(Object? error) {
    if (error is FirebaseAuthException) {
      return _mapFirebaseAuthError(error);
    }
    return error.toString();
  }

  // Mapeamento de códigos de erro do Firebase para mensagens amigáveis (Português)
  String _mapFirebaseAuthError(FirebaseAuthException e) {
    switch (e.code) {
      // Códigos comuns de Login
      case 'invalid-credential':
      case 'user-not-found':
      case 'wrong-password':
        return 'E-mail ou senha incorretos.';
      case 'invalid-email':
        return 'O endereço de e-mail está mal formatado.';
      case 'user-disabled':
        return 'Esta conta de usuário foi desabilitada.';
      // Códigos comuns de Cadastro
      case 'email-already-in-use':
        return 'O e-mail já está sendo usado por outra conta.';
      case 'weak-password':
        return 'A senha fornecida é muito fraca.';
      default:
        return 'Ocorreu um erro. Verifique sua conexão. Código: ${e.code}';
    }
  }
}
