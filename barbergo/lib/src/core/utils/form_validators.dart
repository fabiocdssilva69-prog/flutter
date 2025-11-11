/// Validators compartilhados para validação de formulários
class FormValidators {
  FormValidators._(); // Previne instanciação

  /// Valida email com regex completo
  static String? email(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'E-mail é obrigatório';
    }

    // Regex mais completo para validação de email
    final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');

    if (!emailRegex.hasMatch(value.trim())) {
      return 'Digite um e-mail válido';
    }

    return null;
  }

  /// Valida senha com requisitos mínimos
  static String? password(String? value, {int minLength = 6}) {
    if (value == null || value.isEmpty) {
      return 'Senha é obrigatória';
    }

    if (value.length < minLength) {
      return 'Senha deve ter pelo menos $minLength caracteres';
    }

    return null;
  }

  /// Valida senha forte (para signup)
  static String? strongPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Senha é obrigatória';
    }

    if (value.length < 8) {
      return 'Senha deve ter pelo menos 8 caracteres';
    }

    // Verifica se tem pelo menos uma letra
    if (!RegExp(r'[a-zA-Z]').hasMatch(value)) {
      return 'Senha deve conter pelo menos uma letra';
    }

    // Verifica se tem pelo menos um número
    if (!RegExp(r'[0-9]').hasMatch(value)) {
      return 'Senha deve conter pelo menos um número';
    }

    return null;
  }

  /// Valida confirmação de senha
  static String? confirmPassword(String? value, String originalPassword) {
    if (value == null || value.isEmpty) {
      return 'Confirmação de senha é obrigatória';
    }

    if (value != originalPassword) {
      return 'As senhas não coincidem';
    }

    return null;
  }

  /// Valida nome (mínimo 2 caracteres)
  static String? name(String? value, {int minLength = 2}) {
    if (value == null || value.trim().isEmpty) {
      return 'Nome é obrigatório';
    }

    if (value.trim().length < minLength) {
      return 'Nome deve ter pelo menos $minLength caracteres';
    }

    if (value.trim().length > 100) {
      return 'Nome muito longo (máximo 100 caracteres)';
    }

    return null;
  }

  /// Valida telefone brasileiro (10 ou 11 dígitos)
  static String? phone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Telefone é obrigatório';
    }

    // Remove caracteres não numéricos
    final digitsOnly = value.replaceAll(RegExp(r'\D'), '');

    if (digitsOnly.length < 10 || digitsOnly.length > 11) {
      return 'Telefone deve ter 10 ou 11 dígitos';
    }

    return null;
  }

  /// Valida campo obrigatório genérico
  static String? required(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName é obrigatório';
    }

    return null;
  }

  /// Valida número positivo
  static String? positiveNumber(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return null; // Opcional
    }

    final number = double.tryParse(value);
    if (number == null || number <= 0) {
      return '$fieldName deve ser um número maior que zero';
    }

    return null;
  }

  /// Valida preço/valor monetário
  static String? price(String? value, {bool required = false}) {
    if (value == null || value.trim().isEmpty) {
      if (required) {
        return 'Preço é obrigatório';
      }
      return null;
    }

    final price = double.tryParse(value);
    if (price == null || price <= 0) {
      return 'Insira um valor válido maior que zero';
    }

    if (price > 9999999) {
      return 'Valor muito alto';
    }

    return null;
  }

  /// Valida percentual (0-100)
  static String? percentage(String? value, {bool required = false}) {
    if (value == null || value.trim().isEmpty) {
      if (required) {
        return 'Percentual é obrigatório';
      }
      return null;
    }

    final percentage = double.tryParse(value);
    if (percentage == null || percentage < 0 || percentage > 100) {
      return 'Insira um percentual válido (0-100)';
    }

    return null;
  }

  /// Valida URL
  static String? url(String? value, {bool required = false}) {
    if (value == null || value.trim().isEmpty) {
      if (required) {
        return 'URL é obrigatória';
      }
      return null;
    }

    final urlPattern = RegExp(
      r'^https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)$',
    );

    if (!urlPattern.hasMatch(value.trim())) {
      return 'Digite uma URL válida';
    }

    return null;
  }

  /// Valida comprimento de texto
  static String? maxLength(String? value, int max, String fieldName) {
    if (value != null && value.length > max) {
      return '$fieldName deve ter no máximo $max caracteres';
    }

    return null;
  }

  /// Valida comprimento mínimo de texto
  static String? minLength(String? value, int min, String fieldName) {
    if (value != null && value.trim().isNotEmpty && value.trim().length < min) {
      return '$fieldName deve ter pelo menos $min caracteres';
    }

    return null;
  }
}
