/// Product model for e-commerce
class Product {
  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    this.salePrice,
    required this.images,
    required this.category,
    required this.brand,
    required this.stock,
    required this.sku,
    this.rating,
    this.reviewsCount = 0,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  final int id;
  final String name;
  final String description;
  final double price;
  final double? salePrice;
  final List<String> images;
  final ProductCategory category;
  final String brand;
  final int stock;
  final String sku;
  final double? rating;
  final int reviewsCount;
  final ProductStatus status;
  final DateTime createdAt;
  final DateTime updatedAt;

  bool get isOnSale => salePrice != null && salePrice! < price;
  double get finalPrice => salePrice ?? price;
  bool get inStock => stock > 0;
  String get mainImage => images.isNotEmpty ? images.first : '';

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as int,
      name: json['name'] as String,
      description: json['description'] as String,
      price: (json['price'] as num).toDouble(),
      salePrice: json['sale_price'] != null
          ? (json['sale_price'] as num).toDouble()
          : null,
      images: List<String>.from(json['images'] as List<dynamic>? ?? []),
      category: ProductCategory.fromJson(
        json['category'] as Map<String, dynamic>,
      ),
      brand: json['brand'] as String,
      stock: json['stock'] as int,
      sku: json['sku'] as String,
      rating: json['rating'] != null
          ? (json['rating'] as num).toDouble()
          : null,
      reviewsCount: json['reviews_count'] as int? ?? 0,
      status: ProductStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => ProductStatus.active,
      ),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'sale_price': salePrice,
      'images': images,
      'category': category.toJson(),
      'brand': brand,
      'stock': stock,
      'sku': sku,
      'rating': rating,
      'reviews_count': reviewsCount,
      'status': status.name,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}

class ProductCategory {
  ProductCategory({
    required this.id,
    required this.name,
    required this.slug,
    this.description,
    this.image,
    this.parentId,
  });

  final int id;
  final String name;
  final String slug;
  final String? description;
  final String? image;
  final int? parentId;

  factory ProductCategory.fromJson(Map<String, dynamic> json) {
    return ProductCategory(
      id: json['id'] as int,
      name: json['name'] as String,
      slug: json['slug'] as String,
      description: json['description'] as String?,
      image: json['image'] as String?,
      parentId: json['parent_id'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'slug': slug,
      'description': description,
      'image': image,
      'parent_id': parentId,
    };
  }
}

enum ProductStatus { active, inactive, draft, outOfStock }

/// Product list response with pagination
class ProductListResponse {
  ProductListResponse({required this.products, required this.meta});

  final List<Product> products;
  final ProductListMeta meta;

  factory ProductListResponse.fromJson(Map<String, dynamic> json) {
    return ProductListResponse(
      products: (json['data'] as List<dynamic>)
          .map((e) => Product.fromJson(e as Map<String, dynamic>))
          .toList(),
      meta: ProductListMeta.fromJson(json['meta'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': products.map((e) => e.toJson()).toList(),
      'meta': meta.toJson(),
    };
  }
}

class ProductListMeta {
  ProductListMeta({
    required this.currentPage,
    required this.totalPages,
    required this.totalProducts,
    required this.perPage,
    required this.hasNextPage,
    required this.hasPreviousPage,
  });

  final int currentPage;
  final int totalPages;
  final int totalProducts;
  final int perPage;
  final bool hasNextPage;
  final bool hasPreviousPage;

  factory ProductListMeta.fromJson(Map<String, dynamic> json) {
    return ProductListMeta(
      currentPage: json['current_page'] as int,
      totalPages: json['total_pages'] as int,
      totalProducts: json['total_products'] as int,
      perPage: json['per_page'] as int,
      hasNextPage: json['has_next_page'] as bool,
      hasPreviousPage: json['has_previous_page'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'current_page': currentPage,
      'total_pages': totalPages,
      'total_products': totalProducts,
      'per_page': perPage,
      'has_next_page': hasNextPage,
      'has_previous_page': hasPreviousPage,
    };
  }
}
