class RegisterRequest {
  final String? name;
  final String email;
  final String password;

  RegisterRequest({
    this.name,
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      if (name != null) 'name': name,
      'email': email,
      'password': password,
    };
  }
}

class LoginRequest {
  final String email;
  final String password;

  LoginRequest({
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
    };
  }
}
