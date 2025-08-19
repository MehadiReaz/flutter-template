/// Order models for e-commerce
class Order {
  Order({
    required this.id,
    required this.orderNumber,
    required this.userId,
    required this.items,
    required this.status,
    required this.paymentMethod,
    required this.shippingAddress,
    required this.billingAddress,
    required this.subtotal,
    required this.shippingCost,
    required this.tax,
    required this.total,
    required this.createdAt,
    required this.updatedAt,
    this.notes,
    this.trackingNumber,
  });

  final int id;
  final String orderNumber;
  final int userId;
  final List<OrderItem> items;
  final OrderStatus status;
  final PaymentMethod paymentMethod;
  final Address shippingAddress;
  final Address billingAddress;
  final double subtotal;
  final double shippingCost;
  final double tax;
  final double total;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? notes;
  final String? trackingNumber;

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'] as int,
      orderNumber: json['order_number'] as String,
      userId: json['user_id'] as int,
      items: (json['items'] as List<dynamic>)
          .map((e) => OrderItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      status: OrderStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => OrderStatus.pending,
      ),
      paymentMethod: PaymentMethod.values.firstWhere(
        (e) => e.name == json['payment_method'],
        orElse: () => PaymentMethod.cod,
      ),
      shippingAddress: Address.fromJson(
        json['shipping_address'] as Map<String, dynamic>,
      ),
      billingAddress: Address.fromJson(
        json['billing_address'] as Map<String, dynamic>,
      ),
      subtotal: (json['subtotal'] as num).toDouble(),
      shippingCost: (json['shipping_cost'] as num).toDouble(),
      tax: (json['tax'] as num).toDouble(),
      total: (json['total'] as num).toDouble(),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      notes: json['notes'] as String?,
      trackingNumber: json['tracking_number'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'order_number': orderNumber,
      'user_id': userId,
      'items': items.map((e) => e.toJson()).toList(),
      'status': status.name,
      'payment_method': paymentMethod.name,
      'shipping_address': shippingAddress.toJson(),
      'billing_address': billingAddress.toJson(),
      'subtotal': subtotal,
      'shipping_cost': shippingCost,
      'tax': tax,
      'total': total,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'notes': notes,
      'tracking_number': trackingNumber,
    };
  }
}

class OrderItem {
  OrderItem({
    required this.id,
    required this.productId,
    required this.productName,
    required this.productImage,
    required this.quantity,
    required this.price,
    required this.total,
  });

  final int id;
  final int productId;
  final String productName;
  final String productImage;
  final int quantity;
  final double price;
  final double total;

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      id: json['id'] as int,
      productId: json['product_id'] as int,
      productName: json['product_name'] as String,
      productImage: json['product_image'] as String,
      quantity: json['quantity'] as int,
      price: (json['price'] as num).toDouble(),
      total: (json['total'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'product_id': productId,
      'product_name': productName,
      'product_image': productImage,
      'quantity': quantity,
      'price': price,
      'total': total,
    };
  }
}

class Address {
  Address({
    required this.firstName,
    required this.lastName,
    required this.company,
    required this.addressLine1,
    this.addressLine2,
    required this.city,
    required this.state,
    required this.zipCode,
    required this.country,
    this.phoneNumber,
  });

  final String firstName;
  final String lastName;
  final String company;
  final String addressLine1;
  final String? addressLine2;
  final String city;
  final String state;
  final String zipCode;
  final String country;
  final String? phoneNumber;

  String get fullName => '$firstName $lastName';
  String get fullAddress {
    final parts = [
      addressLine1,
      if (addressLine2?.isNotEmpty == true) addressLine2,
      city,
      state,
      zipCode,
      country,
    ];
    return parts.join(', ');
  }

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      firstName: json['first_name'] as String,
      lastName: json['last_name'] as String,
      company: json['company'] as String? ?? '',
      addressLine1: json['address_line_1'] as String,
      addressLine2: json['address_line_2'] as String?,
      city: json['city'] as String,
      state: json['state'] as String,
      zipCode: json['zip_code'] as String,
      country: json['country'] as String,
      phoneNumber: json['phone_number'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'first_name': firstName,
      'last_name': lastName,
      'company': company,
      'address_line_1': addressLine1,
      'address_line_2': addressLine2,
      'city': city,
      'state': state,
      'zip_code': zipCode,
      'country': country,
      'phone_number': phoneNumber,
    };
  }
}

enum OrderStatus {
  pending,
  confirmed,
  processing,
  shipped,
  delivered,
  cancelled,
  refunded,
}

enum PaymentMethod {
  cod, // Cash on Delivery
  creditCard,
  debitCard,
  paypal,
  bankTransfer,
}

class CreateOrderRequest {
  CreateOrderRequest({
    required this.shippingAddress,
    required this.billingAddress,
    required this.paymentMethod,
    this.notes,
  });

  final Address shippingAddress;
  final Address billingAddress;
  final PaymentMethod paymentMethod;
  final String? notes;

  Map<String, dynamic> toJson() {
    return {
      'shipping_address': shippingAddress.toJson(),
      'billing_address': billingAddress.toJson(),
      'payment_method': paymentMethod.name,
      'notes': notes,
    };
  }
}
