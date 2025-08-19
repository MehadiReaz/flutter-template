import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_structure/bootstrap/dependency_setup.dart';
import 'package:flutter_structure/bootstrap/environment_config.dart';
import 'package:flutter_structure/core/bloc/app_bloc_observer.dart';
import 'package:flutter_structure/core/di/dependency_injection.dart';
import 'package:flutter_structure/core/errors/error_logger.dart';

/// Bootstrap the application with all necessary setup
/// This function handles:
/// - Environment configuration
/// - Dependency injection setup
/// - Firebase initialization
/// - Local storage initialization
/// - Bloc observer setup
/// - Error handling setup
Future<void> bootstrap() async {
  try {
    // Ensure Flutter is initialized
    WidgetsFlutterBinding.ensureInitialized();

    // Set preferred orientations
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    // Load environment variables
    await dotenv.load(fileName: '.env');

    // Initialize environment configuration
    EnvironmentConfig.initialize();

    // Initialize local storage (Hive)
    await Hive.initFlutter();

    // Initialize Firebase
    await Firebase.initializeApp();

    // Setup dependency injection
    await DependencyInjection.init();

    // Setup feature modules and blocs
    await DependencySetup.setupDependencies();

    // Setup Bloc observer for debugging and logging
    Bloc.observer = AppBlocObserver();

    // Setup error handling
    FlutterError.onError = (FlutterErrorDetails details) {
      ErrorLogger.logError(details.exception, details.stack);
      if (kDebugMode) {
        FlutterError.dumpErrorToConsole(details);
      }
    };

    // Setup platform-specific error handling
    PlatformDispatcher.instance.onError = (error, stack) {
      ErrorLogger.logError(error, stack);
      return true;
    };
  } catch (e, stackTrace) {
    // Log bootstrap errors
    ErrorLogger.logError(e, stackTrace);

    // In debug mode, re-throw the error to see it in console
    if (kDebugMode) {
      rethrow;
    }
  }
}
