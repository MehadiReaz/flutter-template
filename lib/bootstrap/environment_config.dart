import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Environment configuration manager
/// Handles different environment settings (development, staging, production)
class EnvironmentConfig {
  static late Environment _environment;
  static late String _apiBaseUrl;
  static late String _apiVersion;
  static late int _apiTimeout;
  static late bool _enableLogging;
  static late bool _debugMode;

  /// Initialize environment configuration
  static void initialize() {
    final envString = dotenv.env['ENVIRONMENT'] ?? 'development';
    _environment = Environment.values.firstWhere(
      (e) => e.name == envString,
      orElse: () => Environment.development,
    );

    _apiBaseUrl = dotenv.env['API_BASE_URL'] ?? 'https://api.example.com';
    _apiVersion = dotenv.env['API_VERSION'] ?? 'v1';
    _apiTimeout = int.tryParse(dotenv.env['API_TIMEOUT'] ?? '30000') ?? 30000;
    _enableLogging = dotenv.env['ENABLE_LOGGING']?.toLowerCase() == 'true';
    _debugMode =
        dotenv.env['DEBUG_MODE']?.toLowerCase() == 'true' || kDebugMode;
  }

  /// Current environment
  static Environment get environment => _environment;

  /// API base URL
  static String get apiBaseUrl => _apiBaseUrl;

  /// API version
  static String get apiVersion => _apiVersion;

  /// API timeout in milliseconds
  static int get apiTimeout => _apiTimeout;

  /// Full API URL
  static String get fullApiUrl => '$_apiBaseUrl/$_apiVersion';

  /// Whether logging is enabled
  static bool get enableLogging => _enableLogging;

  /// Whether debug mode is enabled
  static bool get debugMode => _debugMode;

  /// Whether this is development environment
  static bool get isDevelopment => _environment == Environment.development;

  /// Whether this is staging environment
  static bool get isStaging => _environment == Environment.staging;

  /// Whether this is production environment
  static bool get isProduction => _environment == Environment.production;

  /// Firebase configuration
  static FirebaseConfig get firebase => FirebaseConfig();

  /// Third-party service configurations
  static ThirdPartyConfig get thirdParty => ThirdPartyConfig();
}

/// Available environments
enum Environment { development, staging, production }

/// Firebase configuration
class FirebaseConfig {
  String get apiKey => dotenv.env['FIREBASE_API_KEY'] ?? '';
  String get appId => dotenv.env['FIREBASE_APP_ID'] ?? '';
  String get projectId => dotenv.env['FIREBASE_PROJECT_ID'] ?? '';
  String get messagingSenderId =>
      dotenv.env['FIREBASE_MESSAGING_SENDER_ID'] ?? '';
}

/// Third-party service configuration
class ThirdPartyConfig {
  String get googleMapsApiKey => dotenv.env['GOOGLE_MAPS_API_KEY'] ?? '';
  String get stripePublishableKey => dotenv.env['STRIPE_PUBLISHABLE_KEY'] ?? '';
  String get mixpanelToken => dotenv.env['MIXPANEL_TOKEN'] ?? '';
}
