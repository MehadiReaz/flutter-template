import 'package:equatable/equatable.dart';

/// Money value object for handling currency and amounts safely
class Money extends Equatable {
  /// The monetary amount
  final double amount;

  /// The currency code (ISO 4217)
  final String currency;

  /// Number of decimal places for this currency
  final int decimalPlaces;

  const Money({
    required this.amount,
    this.currency = 'USD',
    this.decimalPlaces = 2,
  });

  /// Creates Money from a double amount
  factory Money.fromDouble(double amount, {String currency = 'USD'}) {
    return Money(amount: amount, currency: currency);
  }

  /// Creates Money from an integer (in smallest currency unit, e.g., cents)
  factory Money.fromCents(int cents, {String currency = 'USD'}) {
    return Money(amount: cents / 100.0, currency: currency);
  }

  /// Creates zero money
  factory Money.zero({String currency = 'USD'}) {
    return Money(amount: 0.0, currency: currency);
  }

  /// Creates Money from JSON
  factory Money.fromJson(Map<String, dynamic> json) {
    return Money(
      amount: (json['amount'] as num).toDouble(),
      currency: json['currency'] as String? ?? 'USD',
      decimalPlaces: json['decimalPlaces'] as int? ?? 2,
    );
  }

  /// Converts Money to JSON
  Map<String, dynamic> toJson() {
    return {
      'amount': amount,
      'currency': currency,
      'decimalPlaces': decimalPlaces,
    };
  }

  /// Gets the amount in the smallest currency unit (e.g., cents)
  int get amountInCents => (amount * 100).round();

  /// Checks if the amount is zero
  bool get isZero => amount == 0.0;

  /// Checks if the amount is positive
  bool get isPositive => amount > 0.0;

  /// Checks if the amount is negative
  bool get isNegative => amount < 0.0;

  /// Formats the money as a string
  String get formatted {
    return '${_getCurrencySymbol(currency)}${amount.toStringAsFixed(decimalPlaces)}';
  }

  /// Formats the money as a string with currency code
  String get formattedWithCode {
    return '${amount.toStringAsFixed(decimalPlaces)} $currency';
  }

  /// Adds two Money amounts (must be same currency)
  Money operator +(Money other) {
    _assertSameCurrency(other);
    return Money(
      amount: amount + other.amount,
      currency: currency,
      decimalPlaces: decimalPlaces,
    );
  }

  /// Subtracts two Money amounts (must be same currency)
  Money operator -(Money other) {
    _assertSameCurrency(other);
    return Money(
      amount: amount - other.amount,
      currency: currency,
      decimalPlaces: decimalPlaces,
    );
  }

  /// Multiplies Money by a factor
  Money operator *(double factor) {
    return Money(
      amount: amount * factor,
      currency: currency,
      decimalPlaces: decimalPlaces,
    );
  }

  /// Divides Money by a factor
  Money operator /(double factor) {
    if (factor == 0) throw ArgumentError('Cannot divide by zero');
    return Money(
      amount: amount / factor,
      currency: currency,
      decimalPlaces: decimalPlaces,
    );
  }

  /// Compares if this Money is greater than other
  bool operator >(Money other) {
    _assertSameCurrency(other);
    return amount > other.amount;
  }

  /// Compares if this Money is less than other
  bool operator <(Money other) {
    _assertSameCurrency(other);
    return amount < other.amount;
  }

  /// Compares if this Money is greater than or equal to other
  bool operator >=(Money other) {
    _assertSameCurrency(other);
    return amount >= other.amount;
  }

  /// Compares if this Money is less than or equal to other
  bool operator <=(Money other) {
    _assertSameCurrency(other);
    return amount <= other.amount;
  }

  /// Applies a percentage discount
  Money applyDiscount(double percentage) {
    if (percentage < 0 || percentage > 100) {
      throw ArgumentError('Percentage must be between 0 and 100');
    }
    final discountAmount = amount * (percentage / 100);
    return Money(
      amount: amount - discountAmount,
      currency: currency,
      decimalPlaces: decimalPlaces,
    );
  }

  /// Calculates percentage of this money
  Money percentage(double percentage) {
    return Money(
      amount: amount * (percentage / 100),
      currency: currency,
      decimalPlaces: decimalPlaces,
    );
  }

  /// Creates a copy with updated values
  Money copyWith({double? amount, String? currency, int? decimalPlaces}) {
    return Money(
      amount: amount ?? this.amount,
      currency: currency ?? this.currency,
      decimalPlaces: decimalPlaces ?? this.decimalPlaces,
    );
  }

  void _assertSameCurrency(Money other) {
    if (currency != other.currency) {
      throw ArgumentError(
        'Cannot operate on different currencies: $currency and ${other.currency}',
      );
    }
  }

  String _getCurrencySymbol(String currencyCode) {
    switch (currencyCode.toUpperCase()) {
      case 'USD':
        return '\$';
      case 'EUR':
        return '€';
      case 'GBP':
        return '£';
      case 'JPY':
        return '¥';
      case 'INR':
        return '₹';
      case 'CAD':
        return 'C\$';
      case 'AUD':
        return 'A\$';
      default:
        return '$currencyCode ';
    }
  }

  @override
  List<Object?> get props => [amount, currency, decimalPlaces];

  @override
  String toString() => formatted;
}
