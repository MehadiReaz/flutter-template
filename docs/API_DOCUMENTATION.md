# E-Commerce API Documentation

## Overview
This document describes the complete API structure for the e-commerce Flutter application, including request/response formats, error handling, and authentication requirements.

## Base Configuration
- **Base URL**: `https://api.yourapp.com/v1`
- **Content-Type**: `application/json`
- **Authentication**: Bearer Token (where required)
- **Timeout**: 30 seconds

## Error Response Format

All API errors follow a consistent structure:

```json
{
  "success": false,
  "error": {
    "code": "ERROR_CODE",
    "message": "Human readable error message",
    "details": "Additional technical details (optional)",
    "field": "specific_field_name (for validation errors)"
  },
  "timestamp": "2025-08-19T10:30:00Z",
  "path": "/api/v1/endpoint"
}
```

### Common Error Codes

| Code | HTTP Status | Description |
|------|-------------|-------------|
| `VALIDATION_ERROR` | 400 | Request validation failed |
| `UNAUTHORIZED` | 401 | Authentication required or failed |
| `FORBIDDEN` | 403 | Access denied |
| `NOT_FOUND` | 404 | Resource not found |
| `CONFLICT` | 409 | Resource already exists |
| `RATE_LIMITED` | 429 | Too many requests |
| `INTERNAL_ERROR` | 500 | Server error |
| `SERVICE_UNAVAILABLE` | 503 | Service temporarily unavailable |

### Validation Error Example
```json
{
  "success": false,
  "error": {
    "code": "VALIDATION_ERROR",
    "message": "Email is required",
    "field": "email"
  }
}
```

### Authentication Error Example
```json
{
  "success": false,
  "error": {
    "code": "UNAUTHORIZED",
    "message": "Invalid or expired token"
  }
}
```

---

## Authentication APIs

### 1. User Login
**Endpoint**: `POST /auth/login`

**Request Body**:
```json
{
  "email": "user@example.com",
  "password": "securePassword123",
  "rememberMe": true
}
```

**Success Response** (200):
```json
{
  "success": true,
  "data": {
    "user": {
      "id": "user_123",
      "email": "user@example.com",
      "firstName": "John",
      "lastName": "Doe",
      "phone": "+1234567890",
      "dateOfBirth": "1990-01-15",
      "emailVerifiedAt": "2025-01-01T10:00:00Z",
      "createdAt": "2024-12-01T09:00:00Z",
      "updatedAt": "2025-08-19T10:30:00Z",
      "isActive": true
    },
    "accessToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
    "refreshToken": "refresh_token_here",
    "expiresIn": 3600
  }
}
```

**Error Response** (400):
```json
{
  "success": false,
  "error": {
    "code": "INVALID_CREDENTIALS",
    "message": "Invalid email or password"
  }
}
```

### 2. User Registration
**Endpoint**: `POST /auth/register`

**Request Body**:
```json
{
  "email": "newuser@example.com",
  "password": "securePassword123",
  "firstName": "Jane",
  "lastName": "Smith",
  "phone": "+1234567890",
  "dateOfBirth": "1992-05-20"
}
```

**Success Response** (201):
```json
{
  "success": true,
  "data": {
    "message": "Registration successful. Please check your email for verification.",
    "userId": "user_124"
  }
}
```

### 3. Refresh Token
**Endpoint**: `POST /auth/refresh`

**Request Body**:
```json
{
  "refreshToken": "refresh_token_here"
}
```

**Success Response** (200):
```json
{
  "success": true,
  "data": {
    "accessToken": "new_access_token",
    "refreshToken": "new_refresh_token",
    "expiresIn": 3600
  }
}
```

### 4. Logout
**Endpoint**: `POST /auth/logout`
**Headers**: `Authorization: Bearer {token}`

**Success Response** (200):
```json
{
  "success": true,
  "data": {
    "message": "Logged out successfully"
  }
}
```

### 5. Get User Profile
**Endpoint**: `GET /auth/profile`
**Headers**: `Authorization: Bearer {token}`

**Success Response** (200):
```json
{
  "success": true,
  "data": {
    "user": {
      "id": "user_123",
      "email": "user@example.com",
      "firstName": "John",
      "lastName": "Doe",
      "phone": "+1234567890",
      "dateOfBirth": "1990-01-15",
      "emailVerifiedAt": "2025-01-01T10:00:00Z",
      "createdAt": "2024-12-01T09:00:00Z",
      "updatedAt": "2025-08-19T10:30:00Z",
      "isActive": true
    }
  }
}
```

---

## Product APIs

### 1. Get Products (with pagination)
**Endpoint**: `GET /products`

**Query Parameters**:
- `page` (int, default: 1): Page number
- `limit` (int, default: 20, max: 100): Items per page
- `category` (string, optional): Filter by category
- `search` (string, optional): Search in name/description
- `sort` (string, optional): Sort options
  - `name_asc`, `name_desc`
  - `price_asc`, `price_desc`
  - `rating_asc`, `rating_desc`
  - `created_asc`, `created_desc`
- `minPrice` (decimal, optional): Minimum price filter
- `maxPrice` (decimal, optional): Maximum price filter
- `brand` (string, optional): Filter by brand
- `inStock` (boolean, optional): Filter available items

**Example**: `GET /products?page=1&limit=20&category=electronics&sort=price_asc&search=phone&minPrice=100&maxPrice=1000`

**Success Response** (200):
```json
{
  "success": true,
  "data": {
    "products": [
      {
        "id": "prod_123",
        "name": "iPhone 15 Pro",
        "description": "Latest iPhone with advanced features",
        "category": "smartphones",
        "brand": "Apple",
        "price": 999.99,
        "originalPrice": 1099.99,
        "images": [
          "https://cdn.example.com/iphone15-1.jpg",
          "https://cdn.example.com/iphone15-2.jpg"
        ],
        "rating": 4.5,
        "reviewCount": 1250,
        "stock": 50,
        "tags": ["smartphone", "ios", "premium"],
        "isAvailable": true,
        "isFeatured": true,
        "createdAt": "2024-12-01T09:00:00Z",
        "updatedAt": "2025-08-19T10:30:00Z"
      }
    ],
    "pagination": {
      "currentPage": 1,
      "totalPages": 25,
      "totalItems": 500,
      "itemsPerPage": 20,
      "hasNext": true,
      "hasPrevious": false
    }
  }
}
```

### 2. Get Product Details
**Endpoint**: `GET /products/{productId}`

**Success Response** (200):
```json
{
  "success": true,
  "data": {
    "product": {
      "id": "prod_123",
      "name": "iPhone 15 Pro",
      "description": "Latest iPhone with advanced features and specifications...",
      "category": "smartphones",
      "brand": "Apple",
      "price": 999.99,
      "originalPrice": 1099.99,
      "images": ["..."],
      "rating": 4.5,
      "reviewCount": 1250,
      "stock": 50,
      "tags": ["smartphone", "ios", "premium"],
      "specifications": {
        "storage": "256GB",
        "ram": "8GB",
        "display": "6.1 inch",
        "camera": "48MP"
      },
      "isAvailable": true,
      "isFeatured": true,
      "createdAt": "2024-12-01T09:00:00Z",
      "updatedAt": "2025-08-19T10:30:00Z"
    }
  }
}
```

### 3. Get Product Categories
**Endpoint**: `GET /products/categories`

**Success Response** (200):
```json
{
  "success": true,
  "data": {
    "categories": [
      {
        "id": "cat_1",
        "name": "Electronics",
        "slug": "electronics",
        "description": "Electronic devices and gadgets",
        "imageUrl": "https://cdn.example.com/electronics.jpg",
        "productCount": 150,
        "isActive": true
      },
      {
        "id": "cat_2",
        "name": "Clothing",
        "slug": "clothing",
        "description": "Fashion and apparel",
        "imageUrl": "https://cdn.example.com/clothing.jpg",
        "productCount": 300,
        "isActive": true
      }
    ]
  }
}
```

### 4. Search Products
**Endpoint**: `GET /products/search`

**Query Parameters**:
- `q` (string, required): Search query
- `page` (int, default: 1): Page number
- `limit` (int, default: 20): Items per page
- `filters[]` (array, optional): Advanced filters
  - `brand:apple`
  - `category:electronics`
  - `price:100-500`
  - `rating:4+`

**Example**: `GET /products/search?q=smartphone&filters[]=brand:apple&filters[]=price:500-1500`

**Success Response** (200):
```json
{
  "success": true,
  "data": {
    "products": [...],
    "totalResults": 45,
    "searchQuery": "smartphone",
    "appliedFilters": {
      "brand": ["apple"],
      "priceRange": { "min": 500, "max": 1500 }
    },
    "pagination": {...}
  }
}
```

---

## Cart APIs (Authentication Required)

### 1. Get Cart
**Endpoint**: `GET /cart`
**Headers**: `Authorization: Bearer {token}`

**Success Response** (200):
```json
{
  "success": true,
  "data": {
    "cart": {
      "id": "cart_123",
      "userId": "user_123",
      "items": [
        {
          "id": "item_1",
          "productId": "prod_123",
          "productName": "iPhone 15 Pro",
          "productImage": "https://cdn.example.com/iphone15-1.jpg",
          "quantity": 2,
          "unitPrice": 999.99,
          "totalPrice": 1999.98,
          "addedAt": "2025-08-19T09:00:00Z"
        }
      ],
      "totalItems": 2,
      "totalAmount": 1999.98,
      "discountAmount": 100.00,
      "finalAmount": 1899.98,
      "updatedAt": "2025-08-19T10:30:00Z"
    }
  }
}
```

### 2. Add Item to Cart
**Endpoint**: `POST /cart/items`
**Headers**: `Authorization: Bearer {token}`

**Request Body**:
```json
{
  "productId": "prod_123",
  "quantity": 2
}
```

**Success Response** (200):
```json
{
  "success": true,
  "data": {
    "message": "Item added to cart successfully",
    "cart": {
      "id": "cart_123",
      "items": [...],
      "totalItems": 3,
      "finalAmount": 2899.97
    }
  }
}
```

**Error Response** (400):
```json
{
  "success": false,
  "error": {
    "code": "INSUFFICIENT_STOCK",
    "message": "Only 1 item available in stock",
    "details": "Requested quantity: 5, Available: 1"
  }
}
```

### 3. Update Cart Item
**Endpoint**: `PUT /cart/items/{itemId}`
**Headers**: `Authorization: Bearer {token}`

**Request Body**:
```json
{
  "quantity": 3
}
```

**Success Response** (200):
```json
{
  "success": true,
  "data": {
    "message": "Cart item updated successfully",
    "cart": {...}
  }
}
```

### 4. Remove Cart Item
**Endpoint**: `DELETE /cart/items/{itemId}`
**Headers**: `Authorization: Bearer {token}`

**Success Response** (200):
```json
{
  "success": true,
  "data": {
    "message": "Item removed from cart",
    "cart": {...}
  }
}
```

### 5. Clear Cart
**Endpoint**: `DELETE /cart`
**Headers**: `Authorization: Bearer {token}`

**Success Response** (200):
```json
{
  "success": true,
  "data": {
    "message": "Cart cleared successfully"
  }
}
```

---

## Order APIs (Authentication Required)

### 1. Create Order (COD)
**Endpoint**: `POST /orders`
**Headers**: `Authorization: Bearer {token}`

**Request Body**:
```json
{
  "paymentMethod": "COD",
  "shippingAddress": {
    "firstName": "John",
    "lastName": "Doe",
    "phone": "+1234567890",
    "email": "john@example.com",
    "street": "123 Main Street",
    "apartment": "Apt 4B",
    "city": "New York",
    "state": "NY",
    "zipCode": "10001",
    "country": "USA",
    "isDefault": false
  },
  "billingAddress": {
    "firstName": "John",
    "lastName": "Doe",
    "phone": "+1234567890",
    "email": "john@example.com",
    "street": "123 Main Street",
    "apartment": "Apt 4B",
    "city": "New York",
    "state": "NY",
    "zipCode": "10001",
    "country": "USA",
    "isDefault": true
  },
  "items": [
    {
      "productId": "prod_123",
      "quantity": 2,
      "unitPrice": 999.99
    }
  ],
  "notes": "Please deliver after 6 PM"
}
```

**Success Response** (201):
```json
{
  "success": true,
  "data": {
    "order": {
      "id": "order_456",
      "orderNumber": "ORD-2025-001234",
      "userId": "user_123",
      "status": "pending",
      "paymentMethod": "COD",
      "paymentStatus": "pending",
      "items": [
        {
          "id": "orderitem_1",
          "productId": "prod_123",
          "productName": "iPhone 15 Pro",
          "productImage": "https://cdn.example.com/iphone15-1.jpg",
          "quantity": 2,
          "unitPrice": 999.99,
          "totalPrice": 1999.98
        }
      ],
      "shippingAddress": {...},
      "billingAddress": {...},
      "totalAmount": 1999.98,
      "shippingCost": 50.00,
      "taxAmount": 159.99,
      "discountAmount": 100.00,
      "finalAmount": 2109.97,
      "notes": "Please deliver after 6 PM",
      "estimatedDelivery": "2025-08-25T18:00:00Z",
      "createdAt": "2025-08-19T10:30:00Z",
      "updatedAt": "2025-08-19T10:30:00Z"
    }
  }
}
```

### 2. Get Orders
**Endpoint**: `GET /orders`
**Headers**: `Authorization: Bearer {token}`

**Query Parameters**:
- `page` (int, default: 1): Page number
- `limit` (int, default: 10): Items per page
- `status` (string, optional): Filter by status
  - `pending`, `confirmed`, `processing`, `shipped`, `delivered`, `cancelled`
- `startDate` (string, optional): Filter from date (ISO format)
- `endDate` (string, optional): Filter to date (ISO format)

**Example**: `GET /orders?status=pending&page=1&limit=10`

**Success Response** (200):
```json
{
  "success": true,
  "data": {
    "orders": [
      {
        "id": "order_456",
        "orderNumber": "ORD-2025-001234",
        "status": "pending",
        "paymentMethod": "COD",
        "totalItems": 2,
        "finalAmount": 2109.97,
        "createdAt": "2025-08-19T10:30:00Z",
        "estimatedDelivery": "2025-08-25T18:00:00Z"
      }
    ],
    "pagination": {
      "currentPage": 1,
      "totalPages": 5,
      "totalItems": 45,
      "itemsPerPage": 10,
      "hasNext": true,
      "hasPrevious": false
    }
  }
}
```

### 3. Get Order Details
**Endpoint**: `GET /orders/{orderId}`
**Headers**: `Authorization: Bearer {token}`

**Success Response** (200):
```json
{
  "success": true,
  "data": {
    "order": {
      "id": "order_456",
      "orderNumber": "ORD-2025-001234",
      "userId": "user_123",
      "status": "confirmed",
      "paymentMethod": "COD",
      "paymentStatus": "pending",
      "items": [...],
      "shippingAddress": {...},
      "billingAddress": {...},
      "totalAmount": 1999.98,
      "shippingCost": 50.00,
      "taxAmount": 159.99,
      "discountAmount": 100.00,
      "finalAmount": 2109.97,
      "notes": "Please deliver after 6 PM",
      "trackingNumber": "TRACK123456789",
      "estimatedDelivery": "2025-08-25T18:00:00Z",
      "statusHistory": [
        {
          "status": "pending",
          "timestamp": "2025-08-19T10:30:00Z",
          "note": "Order placed successfully"
        },
        {
          "status": "confirmed",
          "timestamp": "2025-08-19T11:00:00Z",
          "note": "Order confirmed and processing"
        }
      ],
      "createdAt": "2025-08-19T10:30:00Z",
      "updatedAt": "2025-08-19T11:00:00Z"
    }
  }
}
```

### 4. Cancel Order
**Endpoint**: `PUT /orders/{orderId}/cancel`
**Headers**: `Authorization: Bearer {token}`

**Request Body**:
```json
{
  "reason": "Changed my mind"
}
```

**Success Response** (200):
```json
{
  "success": true,
  "data": {
    "message": "Order cancelled successfully",
    "order": {
      "id": "order_456",
      "status": "cancelled",
      "cancelledAt": "2025-08-19T12:00:00Z",
      "cancellationReason": "Changed my mind"
    }
  }
}
```

---

## Rate Limiting

All endpoints are rate limited:
- **Authentication endpoints**: 5 requests per minute per IP
- **Read operations**: 100 requests per minute per user
- **Write operations**: 30 requests per minute per user

**Rate Limit Headers**:
```
X-RateLimit-Limit: 100
X-RateLimit-Remaining: 87
X-RateLimit-Reset: 1692441600
```

**Rate Limit Error Response** (429):
```json
{
  "success": false,
  "error": {
    "code": "RATE_LIMITED",
    "message": "Too many requests. Please try again later.",
    "retryAfter": 60
  }
}
```

---

## HTTP Status Codes Summary

| Status Code | Description |
|-------------|-------------|
| 200 | OK - Request successful |
| 201 | Created - Resource created successfully |
| 400 | Bad Request - Invalid request data |
| 401 | Unauthorized - Authentication required |
| 403 | Forbidden - Access denied |
| 404 | Not Found - Resource not found |
| 409 | Conflict - Resource already exists |
| 422 | Unprocessable Entity - Validation failed |
| 429 | Too Many Requests - Rate limit exceeded |
| 500 | Internal Server Error - Server error |
| 503 | Service Unavailable - Service down |

---

## SDK Integration Examples

### Flutter/Dart Integration
```dart
// Using the API services
final authService = getIt<AuthApiService>();
final productService = getIt<ProductApiService>();

// Login
final loginResult = await authService.login(
  LoginRequest(
    email: 'user@example.com',
    password: 'password',
    rememberMe: true,
  ),
);

// Get products with pagination
final productsResult = await productService.getProducts(
  page: 1,
  limit: 20,
  category: 'electronics',
  sort: 'price_asc',
);

// Handle errors
if (productsResult.isFailure) {
  final error = productsResult.error;
  print('Error: ${error.message}');
  if (error.code == 'VALIDATION_ERROR') {
    // Handle validation error
  }
}
```

This API documentation provides a complete reference for implementing the e-commerce backend and integrating it with the Flutter application.
