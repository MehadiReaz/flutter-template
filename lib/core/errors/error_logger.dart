import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

/// Error logger for handling and logging application errors
class ErrorLogger {
  static final Logger _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 2,
      errorMethodCount: 8,
      lineLength: 120,
      colors: true,
      printEmojis: true,
      printTime: true,
    ),
  );

  /// Log an error with optional stack trace
  static void logError(dynamic error, [StackTrace? stackTrace]) {
    if (kDebugMode) {
      _logger.e('Error occurred', error: error, stackTrace: stackTrace);
    }

    // In production, you might want to send errors to a service like Crashlytics
    // FirebaseCrashlytics.instance.recordError(error, stackTrace);
  }

  /// Log info message
  static void logInfo(String message) {
    if (kDebugMode) {
      _logger.i(message);
    }
  }

  /// Log warning message
  static void logWarning(String message) {
    if (kDebugMode) {
      _logger.w(message);
    }
  }

  /// Log debug message
  static void logDebug(String message) {
    if (kDebugMode) {
      _logger.d(message);
    }
  }
}
