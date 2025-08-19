/// Authentication request models
class LoginRequest {
  LoginRequest({
    required this.email,
    required this.password,
    this.rememberMe = false,
  });

  final String email;
  final String password;
  final bool rememberMe;

  Map<String, dynamic> toJson() {
    return {'email': email, 'password': password, 'remember_me': rememberMe};
  }
}

class RegisterRequest {
  RegisterRequest({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
    required this.passwordConfirmation,
    this.phoneNumber,
  });

  final String firstName;
  final String lastName;
  final String email;
  final String password;
  final String passwordConfirmation;
  final String? phoneNumber;

  Map<String, dynamic> toJson() {
    return {
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'password': password,
      'password_confirmation': passwordConfirmation,
      if (phoneNumber != null) 'phone_number': phoneNumber,
    };
  }
}

class ForgotPasswordRequest {
  ForgotPasswordRequest({required this.email});

  final String email;

  Map<String, dynamic> toJson() {
    return {'email': email};
  }
}

class ResetPasswordRequest {
  ResetPasswordRequest({
    required this.email,
    required this.token,
    required this.password,
    required this.passwordConfirmation,
  });

  final String email;
  final String token;
  final String password;
  final String passwordConfirmation;

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'token': token,
      'password': password,
      'password_confirmation': passwordConfirmation,
    };
  }
}
