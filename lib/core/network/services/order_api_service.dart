import 'package:flutter_structure/core/network/api_client.dart';
import 'package:flutter_structure/core/network/api_endpoints.dart';
import 'package:flutter_structure/core/network/api_response.dart';
import 'package:flutter_structure/core/network/models/order_models.dart';

/// Order API service
class OrderApiService {
  OrderApiService(this._apiClient);

  final ApiClient _apiClient;

  /// Create new order (COD checkout)
  Future<ApiResponse<Order>> createOrder(CreateOrderRequest request) async {
    try {
      final response = await _apiClient.post(
        ApiEndpoints.createOrder,
        data: request.toJson(),
      );

      if (response.statusCode != null &&
          response.statusCode! >= 200 &&
          response.statusCode! < 300) {
        final data = response.data as Map<String, dynamic>;
        final order = Order.fromJson(data['data'] as Map<String, dynamic>);

        return ApiResponse<Order>(
          success: true,
          message: data['message'] as String? ?? 'Order created successfully',
          data: order,
        );
      } else {
        return ApiResponse<Order>(
          success: false,
          message: 'Failed to create order',
          data: null,
        );
      }
    } catch (e) {
      return ApiResponse<Order>(
        success: false,
        message: 'Failed to create order: ${e.toString()}',
        data: null,
      );
    }
  }

  /// Get user orders
  Future<ApiResponse<List<Order>>> getOrders({
    int page = 1,
    int perPage = 20,
    OrderStatus? status,
  }) async {
    try {
      final queryParameters = <String, dynamic>{
        'page': page,
        'per_page': perPage,
        if (status != null) 'status': status.name,
      };

      final response = await _apiClient.get(
        ApiEndpoints.orders,
        queryParameters: queryParameters,
      );

      if (response.statusCode != null &&
          response.statusCode! >= 200 &&
          response.statusCode! < 300) {
        final data = response.data as Map<String, dynamic>;
        final orders = (data['data'] as List<dynamic>)
            .map((e) => Order.fromJson(e as Map<String, dynamic>))
            .toList();

        return ApiResponse<List<Order>>(
          success: true,
          message: 'Orders retrieved successfully',
          data: orders,
        );
      } else {
        return ApiResponse<List<Order>>(
          success: false,
          message: 'Failed to get orders',
          data: null,
        );
      }
    } catch (e) {
      return ApiResponse<List<Order>>(
        success: false,
        message: 'Failed to get orders: ${e.toString()}',
        data: null,
      );
    }
  }

  /// Get order by ID
  Future<ApiResponse<Order>> getOrderById(int orderId) async {
    try {
      final response = await _apiClient.get(ApiEndpoints.orderById(orderId));

      if (response.statusCode != null &&
          response.statusCode! >= 200 &&
          response.statusCode! < 300) {
        final data = response.data as Map<String, dynamic>;
        final order = Order.fromJson(data['data'] as Map<String, dynamic>);

        return ApiResponse<Order>(
          success: true,
          message: 'Order retrieved successfully',
          data: order,
        );
      } else {
        return ApiResponse<Order>(
          success: false,
          message: 'Order not found',
          data: null,
        );
      }
    } catch (e) {
      return ApiResponse<Order>(
        success: false,
        message: 'Failed to get order: ${e.toString()}',
        data: null,
      );
    }
  }

  /// Cancel order
  Future<ApiResponse<Order>> cancelOrder(int orderId) async {
    try {
      final response = await _apiClient.post(ApiEndpoints.cancelOrder(orderId));

      if (response.statusCode != null &&
          response.statusCode! >= 200 &&
          response.statusCode! < 300) {
        final data = response.data as Map<String, dynamic>;
        final order = Order.fromJson(data['data'] as Map<String, dynamic>);

        return ApiResponse<Order>(
          success: true,
          message: data['message'] as String? ?? 'Order cancelled successfully',
          data: order,
        );
      } else {
        return ApiResponse<Order>(
          success: false,
          message: 'Failed to cancel order',
          data: null,
        );
      }
    } catch (e) {
      return ApiResponse<Order>(
        success: false,
        message: 'Failed to cancel order: ${e.toString()}',
        data: null,
      );
    }
  }

  /// Track order
  Future<ApiResponse<Order>> trackOrder(String orderNumber) async {
    try {
      final response = await _apiClient.get(
        ApiEndpoints.trackOrder(orderNumber),
      );

      if (response.statusCode != null &&
          response.statusCode! >= 200 &&
          response.statusCode! < 300) {
        final data = response.data as Map<String, dynamic>;
        final order = Order.fromJson(data['data'] as Map<String, dynamic>);

        return ApiResponse<Order>(
          success: true,
          message: 'Order tracking information retrieved',
          data: order,
        );
      } else {
        return ApiResponse<Order>(
          success: false,
          message: 'Order not found',
          data: null,
        );
      }
    } catch (e) {
      return ApiResponse<Order>(
        success: false,
        message: 'Failed to track order: ${e.toString()}',
        data: null,
      );
    }
  }
}
