# Better Model Organization for Large-Scale Flutter Projects

## Current Problem
Having all models in `lib/core/network/models/` creates several issues in large projects:
- **Tight coupling**: All features depend on core models
- **Difficult maintenance**: Changes affect multiple features
- **Poor separation of concerns**: Business logic mixed with data transfer objects
- **Scalability issues**: Hundreds of models in one folder
- **Team conflicts**: Multiple developers editing same folders

## Recommended Solutions

### 1. Feature-Based Model Organization

Organize models by feature/domain, separating concerns:

```
lib/
├── core/
│   ├── network/
│   │   ├── api_client.dart
│   │   ├── api_response.dart
│   │   └── api_endpoints.dart
│   └── shared/
│       └── models/            # Only truly shared models
│           ├── pagination.dart
│           ├── address.dart
│           └── base_entity.dart
├── features/
│   ├── auth/
│   │   ├── data/
│   │   │   ├── models/        # Auth-specific models
│   │   │   │   ├── login_request.dart
│   │   │   │   ├── login_response.dart
│   │   │   │   ├── user_dto.dart
│   │   │   │   └── auth_token.dart
│   │   │   ├── repositories/
│   │   │   └── services/
│   │   ├── domain/
│   │   │   ├── entities/      # Business entities
│   │   │   │   └── user.dart
│   │   │   ├── repositories/
│   │   │   └── usecases/
│   │   └── presentation/
│   ├── products/
│   │   ├── data/
│   │   │   ├── models/        # Product-specific models
│   │   │   │   ├── product_dto.dart
│   │   │   │   ├── product_list_response.dart
│   │   │   │   └── category_dto.dart
│   │   │   └── services/
│   │   ├── domain/
│   │   │   └── entities/
│   │   │       ├── product.dart
│   │   │       └── category.dart
│   │   └── presentation/
│   ├── cart/
│   │   ├── data/
│   │   │   ├── models/
│   │   │   │   ├── cart_dto.dart
│   │   │   │   ├── cart_item_dto.dart
│   │   │   │   └── add_to_cart_request.dart
│   │   │   └── services/
│   │   ├── domain/
│   │   │   └── entities/
│   │   │       ├── cart.dart
│   │   │       └── cart_item.dart
│   │   └── presentation/
│   └── orders/
│       ├── data/
│       │   ├── models/
│       │   │   ├── order_dto.dart
│       │   │   ├── create_order_request.dart
│       │   │   └── order_status_dto.dart
│       │   └── services/
│       ├── domain/
│       │   └── entities/
│       │       ├── order.dart
│       │       └── order_item.dart
│       └── presentation/
```

### 2. Domain-Driven Design (DDD) Approach

Separate data models from domain entities:

```dart
// Domain Entity (Business Logic)
// lib/features/products/domain/entities/product.dart
class Product {
  final ProductId id;
  final String name;
  final Money price;
  final Stock stock;
  
  bool get isAvailable => stock.isAvailable;
  bool get isOnSale => price.hasDiscount;
  
  // Business methods
  void applyDiscount(Percentage discount) { ... }
  bool canPurchase(int quantity) { ... }
}

// Data Transfer Object (API Communication)
// lib/features/products/data/models/product_dto.dart
@JsonSerializable()
class ProductDto {
  final String id;
  final String name;
  final double price;
  final int stock;
  
  // Conversion methods
  Product toDomain() => Product(...);
  static ProductDto fromDomain(Product product) => ProductDto(...);
}
```

### 3. Shared Kernel Pattern

Create a shared kernel for common models:

```
lib/
├── shared_kernel/
│   ├── models/
│   │   ├── value_objects/     # Reusable value objects
│   │   │   ├── money.dart
│   │   │   ├── email.dart
│   │   │   ├── phone.dart
│   │   │   └── address.dart
│   │   ├── entities/          # Base entities
│   │   │   ├── base_entity.dart
│   │   │   └── auditable_entity.dart
│   │   └── enums/            # Shared enums
│   │       ├── order_status.dart
│   │       └── payment_method.dart
│   ├── services/             # Shared services
│   └── utilities/            # Shared utilities
```

### 4. Model Mapping Strategy

Use proper mapping between layers:

```dart
// lib/features/products/data/mappers/product_mapper.dart
class ProductMapper {
  static Product dtoToDomain(ProductDto dto) {
    return Product(
      id: ProductId(dto.id),
      name: dto.name,
      price: Money.fromDouble(dto.price),
      stock: Stock(dto.stock),
    );
  }
  
  static ProductDto domainToDto(Product product) {
    return ProductDto(
      id: product.id.value,
      name: product.name,
      price: product.price.amount,
      stock: product.stock.quantity,
    );
  }
}
```

### 5. Model Generation Strategy

Use code generation for repetitive models:

```dart
// lib/features/products/data/models/product_dto.dart
import 'package:json_annotation/json_annotation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'product_dto.freezed.dart';
part 'product_dto.g.dart';

@freezed
class ProductDto with _$ProductDto {
  const factory ProductDto({
    required String id,
    required String name,
    required double price,
    required int stock,
    @Default([]) List<String> images,
  }) = _ProductDto;

  factory ProductDto.fromJson(Map<String, dynamic> json) =>
      _$ProductDtoFromJson(json);
}
```

## Implementation Steps

### Step 1: Create Feature Structure
```bash
mkdir -p lib/features/auth/{data/models,domain/entities,presentation}
mkdir -p lib/features/products/{data/models,domain/entities,presentation}
mkdir -p lib/features/cart/{data/models,domain/entities,presentation}
mkdir -p lib/features/orders/{data/models,domain/entities,presentation}
mkdir -p lib/shared_kernel/{models,services,utilities}
```

### Step 2: Move Existing Models
Move current models from `core/network/models/` to appropriate feature folders:
- `auth_requests.dart` → `features/auth/data/models/`
- `product_models.dart` → `features/products/data/models/`
- `cart_models.dart` → `features/cart/data/models/`
- `order_models.dart` → `features/orders/data/models/`

### Step 3: Create Shared Models
Extract common models to `shared_kernel/models/`:
- Address
- Pagination
- Money/Currency
- Phone/Email value objects

### Step 4: Update Import Statements
Update all imports to use new paths:
```dart
// Old
import 'package:flutter_structure/core/network/models/auth_requests.dart';

// New
import 'package:flutter_structure/features/auth/data/models/login_request.dart';
```

### Step 5: Create Barrel Exports
Create index files for easy imports:

```dart
// lib/features/auth/data/models/models.dart
export 'login_request.dart';
export 'login_response.dart';
export 'user_dto.dart';
export 'auth_token.dart';

// Usage
import 'package:flutter_structure/features/auth/data/models/models.dart';
```

## Benefits of This Approach

1. **Better Separation of Concerns**: Each feature owns its models
2. **Improved Maintainability**: Changes are isolated to specific features
3. **Enhanced Testability**: Easier to mock and test individual features
4. **Team Scalability**: Multiple teams can work on different features
5. **Cleaner Dependencies**: Reduced coupling between features
6. **Domain-Driven Design**: Clear separation between business logic and data
7. **Flexible Architecture**: Easy to add/remove features

## Recommended Next Steps

1. **Gradual Migration**: Move models feature by feature
2. **Create Shared Kernel**: Start with common value objects
3. **Implement Mappers**: Add proper mapping between DTOs and entities
4. **Update Services**: Modify API services to use new model structure
5. **Add Documentation**: Document the new architecture for team members

This approach scales much better for large applications and provides better maintainability and team collaboration.
