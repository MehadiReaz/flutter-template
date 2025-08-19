import 'package:flutter_structure/core/network/api_client.dart';
import 'package:flutter_structure/core/network/api_endpoints.dart';
import 'package:flutter_structure/core/network/api_response.dart';
import 'package:flutter_structure/core/network/models/product_models.dart';

/// Product API service
class ProductApiService {
  ProductApiService(this._apiClient);

  final ApiClient _apiClient;

  /// Get products with pagination
  Future<ApiResponse<ProductListResponse>> getProducts({
    int page = 1,
    int perPage = 20,
    String? search,
    int? categoryId,
    String? brand,
    double? minPrice,
    double? maxPrice,
    String? sortBy,
    String? sortOrder,
  }) async {
    try {
      final queryParameters = <String, dynamic>{
        'page': page,
        'per_page': perPage,
        if (search != null && search.isNotEmpty) 'search': search,
        if (categoryId != null) 'category_id': categoryId,
        if (brand != null && brand.isNotEmpty) 'brand': brand,
        if (minPrice != null) 'min_price': minPrice,
        if (maxPrice != null) 'max_price': maxPrice,
        if (sortBy != null && sortBy.isNotEmpty) 'sort_by': sortBy,
        if (sortOrder != null && sortOrder.isNotEmpty) 'sort_order': sortOrder,
      };

      final response = await _apiClient.get(
        ApiEndpoints.products,
        queryParameters: queryParameters,
      );

      if (response.statusCode != null &&
          response.statusCode! >= 200 &&
          response.statusCode! < 300) {
        final data = response.data as Map<String, dynamic>;
        final productListResponse = ProductListResponse.fromJson(data);

        return ApiResponse<ProductListResponse>(
          success: true,
          message: 'Products retrieved successfully',
          data: productListResponse,
        );
      } else {
        return ApiResponse<ProductListResponse>(
          success: false,
          message: 'Failed to get products',
          data: null,
        );
      }
    } catch (e) {
      return ApiResponse<ProductListResponse>(
        success: false,
        message: 'Failed to get products: ${e.toString()}',
        data: null,
      );
    }
  }

  /// Get product by ID
  Future<ApiResponse<Product>> getProductById(int productId) async {
    try {
      final response = await _apiClient.get(
        ApiEndpoints.productById(productId),
      );

      if (response.statusCode != null &&
          response.statusCode! >= 200 &&
          response.statusCode! < 300) {
        final data = response.data as Map<String, dynamic>;
        final product = Product.fromJson(data['data'] as Map<String, dynamic>);

        return ApiResponse<Product>(
          success: true,
          message: 'Product retrieved successfully',
          data: product,
        );
      } else {
        return ApiResponse<Product>(
          success: false,
          message: 'Product not found',
          data: null,
        );
      }
    } catch (e) {
      return ApiResponse<Product>(
        success: false,
        message: 'Failed to get product: ${e.toString()}',
        data: null,
      );
    }
  }

  /// Search products
  Future<ApiResponse<ProductListResponse>> searchProducts({
    required String query,
    int page = 1,
    int perPage = 20,
    int? categoryId,
    String? brand,
    double? minPrice,
    double? maxPrice,
  }) async {
    try {
      final queryParameters = <String, dynamic>{
        'q': query,
        'page': page,
        'per_page': perPage,
        if (categoryId != null) 'category_id': categoryId,
        if (brand != null && brand.isNotEmpty) 'brand': brand,
        if (minPrice != null) 'min_price': minPrice,
        if (maxPrice != null) 'max_price': maxPrice,
      };

      final response = await _apiClient.get(
        ApiEndpoints.searchProducts,
        queryParameters: queryParameters,
      );

      if (response.statusCode != null &&
          response.statusCode! >= 200 &&
          response.statusCode! < 300) {
        final data = response.data as Map<String, dynamic>;
        final productListResponse = ProductListResponse.fromJson(data);

        return ApiResponse<ProductListResponse>(
          success: true,
          message: 'Search results retrieved successfully',
          data: productListResponse,
        );
      } else {
        return ApiResponse<ProductListResponse>(
          success: false,
          message: 'Search failed',
          data: null,
        );
      }
    } catch (e) {
      return ApiResponse<ProductListResponse>(
        success: false,
        message: 'Search failed: ${e.toString()}',
        data: null,
      );
    }
  }

  /// Get featured products
  Future<ApiResponse<List<Product>>> getFeaturedProducts({
    int limit = 10,
  }) async {
    try {
      final response = await _apiClient.get(
        ApiEndpoints.featuredProducts,
        queryParameters: {'limit': limit},
      );

      if (response.statusCode != null &&
          response.statusCode! >= 200 &&
          response.statusCode! < 300) {
        final data = response.data as Map<String, dynamic>;
        final products = (data['data'] as List<dynamic>)
            .map((e) => Product.fromJson(e as Map<String, dynamic>))
            .toList();

        return ApiResponse<List<Product>>(
          success: true,
          message: 'Featured products retrieved successfully',
          data: products,
        );
      } else {
        return ApiResponse<List<Product>>(
          success: false,
          message: 'Failed to get featured products',
          data: null,
        );
      }
    } catch (e) {
      return ApiResponse<List<Product>>(
        success: false,
        message: 'Failed to get featured products: ${e.toString()}',
        data: null,
      );
    }
  }

  /// Get popular products
  Future<ApiResponse<List<Product>>> getPopularProducts({
    int limit = 10,
  }) async {
    try {
      final response = await _apiClient.get(
        ApiEndpoints.popularProducts,
        queryParameters: {'limit': limit},
      );

      if (response.statusCode != null &&
          response.statusCode! >= 200 &&
          response.statusCode! < 300) {
        final data = response.data as Map<String, dynamic>;
        final products = (data['data'] as List<dynamic>)
            .map((e) => Product.fromJson(e as Map<String, dynamic>))
            .toList();

        return ApiResponse<List<Product>>(
          success: true,
          message: 'Popular products retrieved successfully',
          data: products,
        );
      } else {
        return ApiResponse<List<Product>>(
          success: false,
          message: 'Failed to get popular products',
          data: null,
        );
      }
    } catch (e) {
      return ApiResponse<List<Product>>(
        success: false,
        message: 'Failed to get popular products: ${e.toString()}',
        data: null,
      );
    }
  }

  /// Get product categories
  Future<ApiResponse<List<ProductCategory>>> getCategories() async {
    try {
      final response = await _apiClient.get(ApiEndpoints.categories);

      if (response.statusCode != null &&
          response.statusCode! >= 200 &&
          response.statusCode! < 300) {
        final data = response.data as Map<String, dynamic>;
        final categories = (data['data'] as List<dynamic>)
            .map((e) => ProductCategory.fromJson(e as Map<String, dynamic>))
            .toList();

        return ApiResponse<List<ProductCategory>>(
          success: true,
          message: 'Categories retrieved successfully',
          data: categories,
        );
      } else {
        return ApiResponse<List<ProductCategory>>(
          success: false,
          message: 'Failed to get categories',
          data: null,
        );
      }
    } catch (e) {
      return ApiResponse<List<ProductCategory>>(
        success: false,
        message: 'Failed to get categories: ${e.toString()}',
        data: null,
      );
    }
  }

  /// Get products by category
  Future<ApiResponse<ProductListResponse>> getProductsByCategory({
    required int categoryId,
    int page = 1,
    int perPage = 20,
    String? sortBy,
    String? sortOrder,
  }) async {
    try {
      final queryParameters = <String, dynamic>{
        'page': page,
        'per_page': perPage,
        if (sortBy != null && sortBy.isNotEmpty) 'sort_by': sortBy,
        if (sortOrder != null && sortOrder.isNotEmpty) 'sort_order': sortOrder,
      };

      final response = await _apiClient.get(
        ApiEndpoints.categoryProducts(categoryId),
        queryParameters: queryParameters,
      );

      if (response.statusCode != null &&
          response.statusCode! >= 200 &&
          response.statusCode! < 300) {
        final data = response.data as Map<String, dynamic>;
        final productListResponse = ProductListResponse.fromJson(data);

        return ApiResponse<ProductListResponse>(
          success: true,
          message: 'Category products retrieved successfully',
          data: productListResponse,
        );
      } else {
        return ApiResponse<ProductListResponse>(
          success: false,
          message: 'Failed to get category products',
          data: null,
        );
      }
    } catch (e) {
      return ApiResponse<ProductListResponse>(
        success: false,
        message: 'Failed to get category products: ${e.toString()}',
        data: null,
      );
    }
  }
}
