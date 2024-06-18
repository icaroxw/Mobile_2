class CadastroService {
  static Map<String, String?> validateCadastro({
    required String name,
    required String matriculation,
    required String email,
    required String password,
    required String confirmPassword,
  }) {
    return {
      'Nome': validateNotEmpty(name, 'Nome'),
      'Código de Matrícula': validateMatriculation(matriculation),
      'E-mail Institucional': validateEmail(email),
      'Senha': validatePassword(password),
      'Confirmar Senha': validateConfirmPassword(password, confirmPassword),
    };
  }

  static String? validateNotEmpty(String value, String fieldName) {
    if (value.isEmpty) {
      return '$fieldName é obrigatório';
    }
    return null;
  }

  static String? validateEmail(String email) {
    if (!email.contains('@sou.unaerp.edu.br')) {
      return 'O e-mail deve conter @sou.unaerp.edu.br';
    }
    return null;
  }

  static String? validateMatriculation(String matriculation) {
    if (!RegExp(r'^\d{6}$').hasMatch(matriculation)) {
      return 'O código de matrícula deve conter apenas números e ter exatamente 6 caracteres';
    }
    return null;
  }

  static String? validatePassword(String password) {
    if (!RegExp(r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{6,}$').hasMatch(password)) {
      return 'A senha deve conter pelo menos uma letra, um número e ter pelo menos 6 caracteres';
    }
    return null;
  }

  static String? validateConfirmPassword(
      String password, String confirmPassword) {
    if (password != confirmPassword) {
      return 'As senhas não coincidem';
    }
    return null;
  }
}
