import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter_structure/bootstrap/environment_config.dart';
import 'package:flutter_structure/core/navigation/navigation_service.dart';
import 'package:flutter_structure/core/network/api_client.dart';
import 'package:flutter_structure/core/network/services/auth_api_service.dart';
import 'package:flutter_structure/core/network/services/cart_api_service.dart';
import 'package:flutter_structure/core/network/services/order_api_service.dart';
import 'package:flutter_structure/core/network/services/product_api_service.dart';
import 'package:flutter_structure/core/services/analytics/analytics_service.dart';
import 'package:flutter_structure/core/services/notification/notification_service.dart';
import 'package:flutter_structure/core/storage/implementations/flutter_secure_storage.dart'
    as secure_impl;
import 'package:flutter_structure/core/storage/implementations/shared_preferences_storage.dart'
    as prefs_impl;
import 'package:flutter_structure/core/storage/storage_manager.dart';
import 'package:flutter_structure/core/theme/theme_cubit.dart';
import 'package:flutter_structure/features/auth/presentation/blocs/auth_bloc.dart';
import 'package:flutter_structure/features/products/presentation/blocs/products_bloc.dart';

/// Global service locator instance
final getIt = GetIt.instance;

/// Dependency injection setup
/// This class handles the registration of all core dependencies
class DependencyInjection {
  /// Initialize dependency injection
  static Future<void> init() async {
    await _registerExternalDependencies();
    await _registerCoreDependencies();
    await _registerServices();
    await _registerRepositories();
    await _registerUseCases();
  }

  /// Register external package dependencies
  static Future<void> _registerExternalDependencies() async {
    // SharedPreferences
    final sharedPreferences = await SharedPreferences.getInstance();
    getIt.registerLazySingleton<SharedPreferences>(() => sharedPreferences);

    // Flutter Secure Storage
    getIt.registerLazySingleton<FlutterSecureStorage>(
      () => const FlutterSecureStorage(
        aOptions: AndroidOptions(encryptedSharedPreferences: true),
        iOptions: IOSOptions(
          accessibility: KeychainAccessibility.first_unlock_this_device,
        ),
      ),
    );

    // Connectivity
    getIt.registerLazySingleton<Connectivity>(() => Connectivity());

    // Dio HTTP client
    getIt.registerLazySingleton<Dio>(() {
      final dio = Dio(
        BaseOptions(
          baseUrl: EnvironmentConfig.fullApiUrl,
          connectTimeout: Duration(milliseconds: EnvironmentConfig.apiTimeout),
          receiveTimeout: Duration(milliseconds: EnvironmentConfig.apiTimeout),
          sendTimeout: Duration(milliseconds: EnvironmentConfig.apiTimeout),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      );

      // Add interceptors in debug mode
      if (EnvironmentConfig.debugMode) {
        dio.interceptors.add(
          LogInterceptor(
            requestBody: true,
            responseBody: true,
            requestHeader: true,
            responseHeader: false,
            error: true,
            logPrint: (obj) => print(obj),
          ),
        );
      }

      return dio;
    });
  }

  /// Register core infrastructure dependencies
  static Future<void> _registerCoreDependencies() async {
    // Storage implementations
    getIt.registerLazySingleton<prefs_impl.SharedPreferencesStorage>(
      () => prefs_impl.SharedPreferencesStorage(getIt()),
    );

    getIt.registerLazySingleton<secure_impl.FlutterSecureStorageImpl>(
      () => secure_impl.FlutterSecureStorageImpl(getIt()),
    );

    // Storage manager
    getIt.registerLazySingleton<StorageManager>(
      () => StorageManager(
        sharedPreferencesStorage: getIt(),
        secureStorage: getIt(),
      ),
    );

    // API client
    getIt.registerLazySingleton<ApiClient>(() => ApiClient(getIt()));
  }

  /// Register application services
  static Future<void> _registerServices() async {
    // Navigation service
    getIt.registerLazySingleton<NavigationService>(() => NavigationService());

    // Analytics service - Create a concrete implementation
    getIt.registerLazySingleton<AnalyticsService>(
      () => DefaultAnalyticsService(),
    );

    // Notification service
    getIt.registerLazySingleton<NotificationService>(
      () => NotificationService(),
    );

    // API services
    getIt.registerLazySingleton<AuthApiService>(() => AuthApiService(getIt()));

    getIt.registerLazySingleton<ProductApiService>(
      () => ProductApiService(getIt()),
    );

    getIt.registerLazySingleton<CartApiService>(() => CartApiService(getIt()));

    getIt.registerLazySingleton<OrderApiService>(
      () => OrderApiService(getIt()),
    );

    // BLoCs - Register as factories so each usage gets a new instance
    getIt.registerFactory<ThemeCubit>(() => ThemeCubit());

    getIt.registerFactory<AuthBloc>(
      () => AuthBloc(
        loginUseCase: null, // TODO: Implement use cases
        logoutUseCase: null,
        refreshTokenUseCase: null,
        getProfileUseCase: null,
      ),
    );

    getIt.registerFactory<ProductsBloc>(() => ProductsBloc());
  }

  /// Register repository implementations
  static Future<void> _registerRepositories() async {
    // Repository registrations will be added here
    // Example:
    // getIt.registerLazySingleton<AuthRepository>(
    //   () => AuthRepositoryImpl(getIt(), getIt()),
    // );
  }

  /// Register use case implementations
  static Future<void> _registerUseCases() async {
    // Use case registrations will be added here
    // Example:
    // getIt.registerLazySingleton<LoginUseCase>(
    //   () => LoginUseCase(getIt()),
    // );
  }
}
