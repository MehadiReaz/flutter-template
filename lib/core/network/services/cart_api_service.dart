import 'package:flutter_structure/core/network/api_client.dart';
import 'package:flutter_structure/core/network/api_endpoints.dart';
import 'package:flutter_structure/core/network/api_response.dart';
import 'package:flutter_structure/core/network/models/cart_models.dart';

/// Cart API service
class CartApiService {
  CartApiService(this._apiClient);

  final ApiClient _apiClient;

  /// Get user's cart
  Future<ApiResponse<Cart>> getCart() async {
    try {
      final response = await _apiClient.get(ApiEndpoints.cart);

      if (response.statusCode != null &&
          response.statusCode! >= 200 &&
          response.statusCode! < 300) {
        final data = response.data as Map<String, dynamic>;
        final cart = Cart.fromJson(data['data'] as Map<String, dynamic>);

        return ApiResponse<Cart>(
          success: true,
          message: 'Cart retrieved successfully',
          data: cart,
        );
      } else {
        return ApiResponse<Cart>(
          success: false,
          message: 'Failed to get cart',
          data: null,
        );
      }
    } catch (e) {
      return ApiResponse<Cart>(
        success: false,
        message: 'Failed to get cart: ${e.toString()}',
        data: null,
      );
    }
  }

  /// Add item to cart
  Future<ApiResponse<Cart>> addToCart(AddToCartRequest request) async {
    try {
      final response = await _apiClient.post(
        ApiEndpoints.addToCart,
        data: request.toJson(),
      );

      if (response.statusCode != null &&
          response.statusCode! >= 200 &&
          response.statusCode! < 300) {
        final data = response.data as Map<String, dynamic>;
        final cart = Cart.fromJson(data['data'] as Map<String, dynamic>);

        return ApiResponse<Cart>(
          success: true,
          message: data['message'] as String? ?? 'Item added to cart',
          data: cart,
        );
      } else {
        return ApiResponse<Cart>(
          success: false,
          message: 'Failed to add item to cart',
          data: null,
        );
      }
    } catch (e) {
      return ApiResponse<Cart>(
        success: false,
        message: 'Failed to add item to cart: ${e.toString()}',
        data: null,
      );
    }
  }

  /// Update cart item quantity
  Future<ApiResponse<Cart>> updateCartItem({
    required int itemId,
    required UpdateCartItemRequest request,
  }) async {
    try {
      final response = await _apiClient.put(
        ApiEndpoints.updateCartItem(itemId),
        data: request.toJson(),
      );

      if (response.statusCode != null &&
          response.statusCode! >= 200 &&
          response.statusCode! < 300) {
        final data = response.data as Map<String, dynamic>;
        final cart = Cart.fromJson(data['data'] as Map<String, dynamic>);

        return ApiResponse<Cart>(
          success: true,
          message: data['message'] as String? ?? 'Cart item updated',
          data: cart,
        );
      } else {
        return ApiResponse<Cart>(
          success: false,
          message: 'Failed to update cart item',
          data: null,
        );
      }
    } catch (e) {
      return ApiResponse<Cart>(
        success: false,
        message: 'Failed to update cart item: ${e.toString()}',
        data: null,
      );
    }
  }

  /// Remove item from cart
  Future<ApiResponse<Cart>> removeCartItem(int itemId) async {
    try {
      final response = await _apiClient.delete(
        ApiEndpoints.removeCartItem(itemId),
      );

      if (response.statusCode != null &&
          response.statusCode! >= 200 &&
          response.statusCode! < 300) {
        final data = response.data as Map<String, dynamic>;
        final cart = Cart.fromJson(data['data'] as Map<String, dynamic>);

        return ApiResponse<Cart>(
          success: true,
          message: data['message'] as String? ?? 'Item removed from cart',
          data: cart,
        );
      } else {
        return ApiResponse<Cart>(
          success: false,
          message: 'Failed to remove cart item',
          data: null,
        );
      }
    } catch (e) {
      return ApiResponse<Cart>(
        success: false,
        message: 'Failed to remove cart item: ${e.toString()}',
        data: null,
      );
    }
  }

  /// Clear cart
  Future<ApiResponse<void>> clearCart() async {
    try {
      final response = await _apiClient.delete(ApiEndpoints.clearCart);

      final isSuccess =
          response.statusCode != null &&
          response.statusCode! >= 200 &&
          response.statusCode! < 300;

      return ApiResponse<void>(
        success: isSuccess,
        message: isSuccess
            ? 'Cart cleared successfully'
            : 'Failed to clear cart',
        data: null,
      );
    } catch (e) {
      return ApiResponse<void>(
        success: false,
        message: 'Failed to clear cart: ${e.toString()}',
        data: null,
      );
    }
  }
}
