# Migration Guide: Restructuring Models for Better Organization

## Overview
This guide provides step-by-step instructions to migrate from the current model structure to a more scalable, feature-based organization.

## Current Structure (Problems)
```
lib/core/network/models/
├── auth_requests.dart       # Multiple auth models in one file
├── auth_responses.dart      # Auth response models
├── product_models.dart      # Multiple product models in one file
├── cart_models.dart         # Cart-related models
└── order_models.dart        # Order-related models
```

**Issues:**
- All models in core (tight coupling)
- Multiple models per file (poor organization)
- Mixed concerns (DTOs, entities, requests, responses)
- Difficult to maintain and scale

## Target Structure (Solution)
```
lib/
├── shared_kernel/
│   └── models/
│       ├── pagination.dart          # ✅ Created
│       ├── address.dart             # ✅ Created
│       └── money.dart               # 🔄 Next
├── features/
│   ├── auth/
│   │   ├── data/
│   │   │   ├── models/
│   │   │   │   ├── login_request.dart
│   │   │   │   ├── login_response.dart
│   │   │   │   ├── register_request.dart
│   │   │   │   ├── user_dto.dart
│   │   │   │   └── models.dart      # Barrel export
│   │   │   └── services/
│   │   │       └── auth_api_service.dart
│   │   ├── domain/
│   │   │   └── entities/
│   │   │       └── user.dart        # Business entity
│   │   └── presentation/
│   ├── products/
│   │   ├── data/
│   │   │   ├── models/
│   │   │   │   ├── product_dto.dart
│   │   │   │   ├── product_list_response.dart
│   │   │   │   ├── category_dto.dart
│   │   │   │   └── models.dart
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
│   │   │   │   ├── add_to_cart_request.dart
│   │   │   │   └── models.dart
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
│       │   │   ├── order_item_dto.dart
│       │   │   └── models.dart
│       │   └── services/
│       ├── domain/
│       │   └── entities/
│       │       ├── order.dart
│       │       └── order_item.dart
│       └── presentation/
```

## Migration Steps

### Phase 1: Create Shared Kernel (✅ DONE)
1. Create shared models directory structure
2. Move common models (Pagination, Address) ✅
3. Create Money value object (next step)

### Phase 2: Create Feature Directories
```bash
# Create feature structure
mkdir -p lib/features/auth/data/models
mkdir -p lib/features/auth/domain/entities
mkdir -p lib/features/products/data/models
mkdir -p lib/features/products/domain/entities
mkdir -p lib/features/cart/data/models
mkdir -p lib/features/cart/domain/entities
mkdir -p lib/features/orders/data/models
mkdir -p lib/features/orders/domain/entities
```

### Phase 3: Split and Move Auth Models
```dart
// FROM: lib/core/network/models/auth_requests.dart
// TO: lib/features/auth/data/models/

// Split into separate files:
// 1. login_request.dart
class LoginRequest {
  final String email;
  final String password;
  final bool rememberMe;
  // ... rest of implementation
}

// 2. register_request.dart
class RegisterRequest {
  final String email;
  final String password;
  final String firstName;
  final String lastName;
  final String phone;
  final String? dateOfBirth;
  // ... rest of implementation
}

// 3. refresh_token_request.dart
class RefreshTokenRequest {
  final String refreshToken;
  // ... rest of implementation
}

// 4. change_password_request.dart
class ChangePasswordRequest {
  final String currentPassword;
  final String newPassword;
  final String confirmPassword;
  // ... rest of implementation
}
```

### Phase 4: Split and Move Auth Responses
```dart
// FROM: lib/core/network/models/auth_responses.dart
// TO: lib/features/auth/data/models/

// Split into separate files:
// 1. login_response.dart
class LoginResponse {
  final bool success;
  final UserDto? user;
  final String? accessToken;
  final String? refreshToken;
  // ... rest of implementation
}

// 2. register_response.dart
class RegisterResponse {
  final bool success;
  final String message;
  // ... rest of implementation
}

// 3. user_dto.dart (Data Transfer Object)
class UserDto {
  final String id;
  final String email;
  final String firstName;
  final String lastName;
  // ... rest of implementation
  
  // Convert to domain entity
  User toDomainEntity() {
    return User(
      id: UserId(id),
      email: Email(email),
      name: FullName(firstName, lastName),
      // ... map other fields
    );
  }
}
```

### Phase 5: Create Domain Entities
```dart
// lib/features/auth/domain/entities/user.dart
class User {
  final UserId id;
  final Email email;
  final FullName name;
  final Phone? phone;
  final DateTime? dateOfBirth;
  final bool isActive;
  
  const User({
    required this.id,
    required this.email,
    required this.name,
    this.phone,
    this.dateOfBirth,
    required this.isActive,
  });
  
  // Business methods
  bool get isVerified => email.isVerified;
  String get displayName => name.full;
  int get age => dateOfBirth?.calculateAge() ?? 0;
}

// Value objects
class UserId {
  final String value;
  const UserId(this.value);
}

class Email {
  final String value;
  final bool isVerified;
  
  const Email(this.value, {this.isVerified = false});
  
  bool get isValid => _isValidEmail(value);
}

class FullName {
  final String firstName;
  final String lastName;
  
  const FullName(this.firstName, this.lastName);
  
  String get full => '$firstName $lastName';
  String get initials => '${firstName[0]}${lastName[0]}';
}
```

### Phase 6: Create Barrel Exports
```dart
// lib/features/auth/data/models/models.dart
export 'login_request.dart';
export 'login_response.dart';
export 'register_request.dart';
export 'register_response.dart';
export 'user_dto.dart';
export 'refresh_token_request.dart';
export 'change_password_request.dart';

// lib/features/auth/domain/entities/entities.dart
export 'user.dart';
export 'value_objects.dart';

// lib/features/auth/auth.dart
export 'data/models/models.dart';
export 'domain/entities/entities.dart';
export 'presentation/blocs/auth_bloc.dart';
```

### Phase 7: Update API Services
```dart
// lib/features/auth/data/services/auth_api_service.dart
import '../models/models.dart'; // Use barrel import
import '../../domain/entities/entities.dart';

class AuthApiService {
  Future<ApiResponse<LoginResponse>> login(LoginRequest request) async {
    // Implementation remains the same
  }
  
  Future<ApiResponse<RegisterResponse>> register(RegisterRequest request) async {
    // Implementation remains the same
  }
}
```

### Phase 8: Update Dependency Injection
```dart
// lib/core/di/dependency_injection.dart
void _registerAuthServices() {
  // Register with new import paths
  getIt.registerLazySingleton<AuthApiService>(
    () => AuthApiService(getIt<ApiClient>()),
  );
}
```

### Phase 9: Update Import Statements
```dart
// OLD imports
import 'package:flutter_structure/core/network/models/auth_requests.dart';
import 'package:flutter_structure/core/network/models/auth_responses.dart';

// NEW imports
import 'package:flutter_structure/features/auth/data/models/models.dart';
// OR specific imports
import 'package:flutter_structure/features/auth/data/models/login_request.dart';
import 'package:flutter_structure/features/auth/data/models/login_response.dart';
```

### Phase 10: Repeat for Other Features
Apply the same pattern to:
1. Products (product_models.dart → features/products/)
2. Cart (cart_models.dart → features/cart/)
3. Orders (order_models.dart → features/orders/)

## Benefits After Migration

### 1. Better Organization
- ✅ Each feature owns its models
- ✅ Clear separation of DTOs and domain entities
- ✅ Easier to find and maintain code

### 2. Improved Testability
- ✅ Mock specific feature models
- ✅ Test business logic in domain entities
- ✅ Isolated unit tests per feature

### 3. Team Scalability
- ✅ Multiple developers can work on different features
- ✅ Reduced merge conflicts
- ✅ Clear ownership boundaries

### 4. Better Architecture
- ✅ Domain-driven design principles
- ✅ Clean architecture layers
- ✅ Separation of concerns

## Migration Checklist

### Phase 1: Preparation ✅
- [x] Create shared_kernel structure
- [x] Create Pagination model
- [x] Create Address model
- [ ] Create Money value object
- [ ] Create base entity classes

### Phase 2: Auth Feature
- [ ] Create auth feature structure
- [ ] Split auth_requests.dart into separate files
- [ ] Split auth_responses.dart into separate files
- [ ] Create User domain entity
- [ ] Create value objects (Email, FullName, etc.)
- [ ] Update AuthApiService imports
- [ ] Update BLoC imports
- [ ] Test auth feature

### Phase 3: Products Feature
- [ ] Create products feature structure
- [ ] Split product_models.dart
- [ ] Create Product domain entity
- [ ] Create Category domain entity
- [ ] Update ProductApiService
- [ ] Test products feature

### Phase 4: Cart Feature
- [ ] Create cart feature structure
- [ ] Split cart_models.dart
- [ ] Create Cart domain entity
- [ ] Update CartApiService
- [ ] Test cart feature

### Phase 5: Orders Feature
- [ ] Create orders feature structure
- [ ] Split order_models.dart
- [ ] Create Order domain entity
- [ ] Update OrderApiService
- [ ] Test orders feature

### Phase 6: Cleanup
- [ ] Remove old model files
- [ ] Update all import statements
- [ ] Run tests to ensure nothing is broken
- [ ] Update documentation
- [ ] Code review

## Commands to Execute

```bash
# 1. Create all feature directories
mkdir -p lib/features/{auth,products,cart,orders}/{data/models,domain/entities,presentation}

# 2. Create shared kernel
mkdir -p lib/shared_kernel/{models,services,utilities}

# 3. After migration, remove old models
rm -rf lib/core/network/models/

# 4. Run code generation (if using json_serializable)
flutter packages pub run build_runner build

# 5. Run tests
flutter test

# 6. Analyze code
flutter analyze
```

This migration will significantly improve the maintainability and scalability of your Flutter application!
