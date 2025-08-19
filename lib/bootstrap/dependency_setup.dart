import 'package:flutter_structure/core/di/dependency_injection.dart';
import 'package:flutter_structure/features/auth/presentation/blocs/auth_bloc.dart';
import 'package:flutter_structure/features/onboarding/presentation/blocs/onboarding_bloc.dart';
import 'package:flutter_structure/core/theme/theme_cubit.dart';

/// Dependency setup for features and modules
/// This class registers all feature-specific dependencies including Blocs/Cubits
class DependencySetup {
  /// Setup all feature dependencies
  static Future<void> setupDependencies() async {
    await _setupCoreBlocs();
    await _setupFeatureBlocs();
  }

  /// Setup core application blocs
  static Future<void> _setupCoreBlocs() async {
    // Theme cubit
    getIt.registerLazySingleton<ThemeCubit>(() => ThemeCubit());
  }

  /// Setup feature-specific blocs
  static Future<void> _setupFeatureBlocs() async {
    // Auth feature blocs
    getIt.registerFactory<AuthBloc>(
      () => AuthBloc(
        loginUseCase: getIt(),
        logoutUseCase: getIt(),
        refreshTokenUseCase: getIt(),
        getProfileUseCase: getIt(),
      ),
    );

    // Onboarding feature blocs
    getIt.registerFactory<OnboardingBloc>(() => OnboardingBloc());

    // Add more feature blocs here as they are implemented
    // Example:
    // getIt.registerFactory<FlightsBloc>(() => FlightsBloc(getIt()));
    // getIt.registerFactory<HotelsBloc>(() => HotelsBloc(getIt()));
    // getIt.registerFactory<BookingBloc>(() => BookingBloc(getIt()));
  }
}
