import 'package:flutter_structure/core/network/models/product_models.dart';

/// Cart models for e-commerce
class CartItem {
  CartItem({
    required this.id,
    required this.product,
    required this.quantity,
    required this.addedAt,
  });

  final int id;
  final Product product;
  final int quantity;
  final DateTime addedAt;

  double get totalPrice => product.finalPrice * quantity;

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      id: json['id'] as int,
      product: Product.fromJson(json['product'] as Map<String, dynamic>),
      quantity: json['quantity'] as int,
      addedAt: DateTime.parse(json['added_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'product': product.toJson(),
      'quantity': quantity,
      'added_at': addedAt.toIso8601String(),
    };
  }

  CartItem copyWith({
    int? id,
    Product? product,
    int? quantity,
    DateTime? addedAt,
  }) {
    return CartItem(
      id: id ?? this.id,
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
      addedAt: addedAt ?? this.addedAt,
    );
  }
}

class Cart {
  Cart({
    required this.id,
    required this.userId,
    required this.items,
    required this.createdAt,
    required this.updatedAt,
  });

  final int id;
  final int userId;
  final List<CartItem> items;
  final DateTime createdAt;
  final DateTime updatedAt;

  double get subtotal => items.fold(0, (sum, item) => sum + item.totalPrice);
  int get totalItems => items.fold(0, (sum, item) => sum + item.quantity);
  bool get isEmpty => items.isEmpty;
  bool get isNotEmpty => items.isNotEmpty;

  factory Cart.fromJson(Map<String, dynamic> json) {
    return Cart(
      id: json['id'] as int,
      userId: json['user_id'] as int,
      items: (json['items'] as List<dynamic>)
          .map((e) => CartItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'items': items.map((e) => e.toJson()).toList(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}

class AddToCartRequest {
  AddToCartRequest({required this.productId, required this.quantity});

  final int productId;
  final int quantity;

  Map<String, dynamic> toJson() {
    return {'product_id': productId, 'quantity': quantity};
  }
}

class UpdateCartItemRequest {
  UpdateCartItemRequest({required this.quantity});

  final int quantity;

  Map<String, dynamic> toJson() {
    return {'quantity': quantity};
  }
}
