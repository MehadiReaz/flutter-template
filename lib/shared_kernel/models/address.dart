import 'package:equatable/equatable.dart';

/// Address model that can be reused across features (shipping, billing, user profile)
class Address extends Equatable {
  /// First name
  final String firstName;

  /// Last name
  final String lastName;

  /// Phone number
  final String phone;

  /// Email address
  final String email;

  /// Street address
  final String street;

  /// Apartment/Unit number (optional)
  final String? apartment;

  /// City
  final String city;

  /// State/Province
  final String state;

  /// ZIP/Postal code
  final String zipCode;

  /// Country
  final String country;

  /// Whether this is the default address
  final bool isDefault;

  const Address({
    required this.firstName,
    required this.lastName,
    required this.phone,
    required this.email,
    required this.street,
    this.apartment,
    required this.city,
    required this.state,
    required this.zipCode,
    required this.country,
    this.isDefault = false,
  });

  /// Creates address from JSON
  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      phone: json['phone'] as String,
      email: json['email'] as String,
      street: json['street'] as String,
      apartment: json['apartment'] as String?,
      city: json['city'] as String,
      state: json['state'] as String,
      zipCode: json['zipCode'] as String,
      country: json['country'] as String,
      isDefault: json['isDefault'] as bool? ?? false,
    );
  }

  /// Converts address to JSON
  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'phone': phone,
      'email': email,
      'street': street,
      'apartment': apartment,
      'city': city,
      'state': state,
      'zipCode': zipCode,
      'country': country,
      'isDefault': isDefault,
    };
  }

  /// Gets full name
  String get fullName => '$firstName $lastName';

  /// Gets formatted address string
  String get formattedAddress {
    final parts = <String>[
      street,
      if (apartment != null && apartment!.isNotEmpty) apartment!,
      city,
      state,
      zipCode,
      country,
    ];
    return parts.join(', ');
  }

  /// Creates a copy with updated fields
  Address copyWith({
    String? firstName,
    String? lastName,
    String? phone,
    String? email,
    String? street,
    String? apartment,
    String? city,
    String? state,
    String? zipCode,
    String? country,
    bool? isDefault,
  }) {
    return Address(
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      street: street ?? this.street,
      apartment: apartment ?? this.apartment,
      city: city ?? this.city,
      state: state ?? this.state,
      zipCode: zipCode ?? this.zipCode,
      country: country ?? this.country,
      isDefault: isDefault ?? this.isDefault,
    );
  }

  @override
  List<Object?> get props => [
    firstName,
    lastName,
    phone,
    email,
    street,
    apartment,
    city,
    state,
    zipCode,
    country,
    isDefault,
  ];
}
