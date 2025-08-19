import 'package:flutter_structure/core/network/api_client.dart';
import 'package:flutter_structure/core/network/api_endpoints.dart';
import 'package:flutter_structure/core/network/api_response.dart';
import 'package:flutter_structure/core/network/models/auth_requests.dart';
import 'package:flutter_structure/core/network/models/auth_responses.dart';

/// Authentication API service
class AuthApiService {
  AuthApiService(this._apiClient);

  final ApiClient _apiClient;

  /// Login user
  Future<ApiResponse<LoginResponse>> login(LoginRequest request) async {
    try {
      final response = await _apiClient.post(
        ApiEndpoints.login,
        data: request.toJson(),
      );

      if (response.statusCode != null &&
          response.statusCode! >= 200 &&
          response.statusCode! < 300) {
        final data = response.data as Map<String, dynamic>;
        final loginResponse = LoginResponse.fromJson(
          data['data'] as Map<String, dynamic>,
        );

        return ApiResponse<LoginResponse>(
          success: true,
          message: data['message'] as String? ?? 'Login successful',
          data: loginResponse,
        );
      } else {
        return ApiResponse<LoginResponse>(
          success: false,
          message: 'Login failed',
          data: null,
        );
      }
    } catch (e) {
      return ApiResponse<LoginResponse>(
        success: false,
        message: 'Login failed: ${e.toString()}',
        data: null,
      );
    }
  }

  /// Register user
  Future<ApiResponse<RegisterResponse>> register(
    RegisterRequest request,
  ) async {
    try {
      final response = await _apiClient.post(
        ApiEndpoints.register,
        data: request.toJson(),
      );

      if (response.statusCode != null &&
          response.statusCode! >= 200 &&
          response.statusCode! < 300) {
        final data = response.data as Map<String, dynamic>;
        final registerResponse = RegisterResponse.fromJson(
          data['data'] as Map<String, dynamic>,
        );

        return ApiResponse<RegisterResponse>(
          success: true,
          message: data['message'] as String? ?? 'Registration successful',
          data: registerResponse,
        );
      } else {
        return ApiResponse<RegisterResponse>(
          success: false,
          message: 'Registration failed',
          data: null,
        );
      }
    } catch (e) {
      return ApiResponse<RegisterResponse>(
        success: false,
        message: 'Registration failed: ${e.toString()}',
        data: null,
      );
    }
  }

  /// Logout user
  Future<ApiResponse<void>> logout() async {
    try {
      final response = await _apiClient.post(ApiEndpoints.logout);

      final isSuccess =
          response.statusCode != null &&
          response.statusCode! >= 200 &&
          response.statusCode! < 300;

      return ApiResponse<void>(
        success: isSuccess,
        message: isSuccess ? 'Logout successful' : 'Logout failed',
        data: null,
      );
    } catch (e) {
      return ApiResponse<void>(
        success: false,
        message: 'Logout failed: ${e.toString()}',
        data: null,
      );
    }
  }

  /// Forgot password
  Future<ApiResponse<ForgotPasswordResponse>> forgotPassword(
    ForgotPasswordRequest request,
  ) async {
    try {
      final response = await _apiClient.post(
        ApiEndpoints.forgotPassword,
        data: request.toJson(),
      );

      if (response.statusCode != null &&
          response.statusCode! >= 200 &&
          response.statusCode! < 300) {
        final data = response.data as Map<String, dynamic>;
        final forgotPasswordResponse = ForgotPasswordResponse.fromJson(
          data['data'] as Map<String, dynamic>,
        );

        return ApiResponse<ForgotPasswordResponse>(
          success: true,
          message: data['message'] as String? ?? 'Password reset request sent',
          data: forgotPasswordResponse,
        );
      } else {
        return ApiResponse<ForgotPasswordResponse>(
          success: false,
          message: 'Password reset request failed',
          data: null,
        );
      }
    } catch (e) {
      return ApiResponse<ForgotPasswordResponse>(
        success: false,
        message: 'Password reset request failed: ${e.toString()}',
        data: null,
      );
    }
  }

  /// Reset password
  Future<ApiResponse<void>> resetPassword(ResetPasswordRequest request) async {
    try {
      final response = await _apiClient.post(
        ApiEndpoints.resetPassword,
        data: request.toJson(),
      );

      final isSuccess =
          response.statusCode != null &&
          response.statusCode! >= 200 &&
          response.statusCode! < 300;

      return ApiResponse<void>(
        success: isSuccess,
        message: isSuccess
            ? 'Password reset successful'
            : 'Password reset failed',
        data: null,
      );
    } catch (e) {
      return ApiResponse<void>(
        success: false,
        message: 'Password reset failed: ${e.toString()}',
        data: null,
      );
    }
  }

  /// Get user profile
  Future<ApiResponse<User>> getProfile() async {
    try {
      final response = await _apiClient.get(ApiEndpoints.profile);

      if (response.statusCode != null &&
          response.statusCode! >= 200 &&
          response.statusCode! < 300) {
        final data = response.data as Map<String, dynamic>;
        final user = User.fromJson(data['data'] as Map<String, dynamic>);

        return ApiResponse<User>(
          success: true,
          message: data['message'] as String? ?? 'Profile retrieved',
          data: user,
        );
      } else {
        return ApiResponse<User>(
          success: false,
          message: 'Failed to get profile',
          data: null,
        );
      }
    } catch (e) {
      return ApiResponse<User>(
        success: false,
        message: 'Failed to get profile: ${e.toString()}',
        data: null,
      );
    }
  }

  /// Refresh token
  Future<ApiResponse<LoginResponse>> refreshToken() async {
    try {
      final response = await _apiClient.post(ApiEndpoints.refreshToken);

      if (response.statusCode != null &&
          response.statusCode! >= 200 &&
          response.statusCode! < 300) {
        final data = response.data as Map<String, dynamic>;
        final loginResponse = LoginResponse.fromJson(
          data['data'] as Map<String, dynamic>,
        );

        return ApiResponse<LoginResponse>(
          success: true,
          message: data['message'] as String? ?? 'Token refreshed',
          data: loginResponse,
        );
      } else {
        return ApiResponse<LoginResponse>(
          success: false,
          message: 'Token refresh failed',
          data: null,
        );
      }
    } catch (e) {
      return ApiResponse<LoginResponse>(
        success: false,
        message: 'Token refresh failed: ${e.toString()}',
        data: null,
      );
    }
  }
}
