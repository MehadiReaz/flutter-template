/// Authentication response models
class LoginResponse {
  LoginResponse({
    required this.user,
    required this.token,
    required this.tokenType,
    required this.expiresIn,
  });

  final User user;
  final String token;
  final String tokenType;
  final int expiresIn;

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      user: User.fromJson(json['user'] as Map<String, dynamic>),
      token: json['token'] as String,
      tokenType: json['token_type'] as String? ?? 'Bearer',
      expiresIn: json['expires_in'] as int? ?? 3600,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user': user.toJson(),
      'token': token,
      'token_type': tokenType,
      'expires_in': expiresIn,
    };
  }
}

class RegisterResponse {
  RegisterResponse({required this.user, required this.message});

  final User user;
  final String message;

  factory RegisterResponse.fromJson(Map<String, dynamic> json) {
    return RegisterResponse(
      user: User.fromJson(json['user'] as Map<String, dynamic>),
      message: json['message'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {'user': user.toJson(), 'message': message};
  }
}

class User {
  User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    this.phoneNumber,
    this.avatar,
    required this.emailVerifiedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  final int id;
  final String firstName;
  final String lastName;
  final String email;
  final String? phoneNumber;
  final String? avatar;
  final DateTime? emailVerifiedAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  String get fullName => '$firstName $lastName';

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int,
      firstName: json['first_name'] as String,
      lastName: json['last_name'] as String,
      email: json['email'] as String,
      phoneNumber: json['phone_number'] as String?,
      avatar: json['avatar'] as String?,
      emailVerifiedAt: json['email_verified_at'] != null
          ? DateTime.parse(json['email_verified_at'] as String)
          : null,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'phone_number': phoneNumber,
      'avatar': avatar,
      'email_verified_at': emailVerifiedAt?.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}

class ForgotPasswordResponse {
  ForgotPasswordResponse({required this.message});

  final String message;

  factory ForgotPasswordResponse.fromJson(Map<String, dynamic> json) {
    return ForgotPasswordResponse(message: json['message'] as String);
  }

  Map<String, dynamic> toJson() {
    return {'message': message};
  }
}
