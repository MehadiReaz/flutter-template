import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Navigation service for programmatic navigation
/// Provides methods for navigating without BuildContext
class NavigationService {
  /// Global navigator key
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  /// Get current context
  BuildContext? get currentContext => navigatorKey.currentContext;

  /// Navigate to named route
  void pushNamed(String routeName, {Map<String, String>? pathParameters}) {
    final context = currentContext;
    if (context != null) {
      context.pushNamed(routeName, pathParameters: pathParameters ?? {});
    }
  }

  /// Navigate and replace current route
  void goNamed(String routeName, {Map<String, String>? pathParameters}) {
    final context = currentContext;
    if (context != null) {
      context.goNamed(routeName, pathParameters: pathParameters ?? {});
    }
  }

  /// Push route
  void push(String path) {
    final context = currentContext;
    if (context != null) {
      context.push(path);
    }
  }

  /// Go to route
  void go(String path) {
    final context = currentContext;
    if (context != null) {
      context.go(path);
    }
  }

  /// Pop current route
  void pop() {
    final context = currentContext;
    if (context != null) {
      context.pop();
    }
  }

  /// Check if can pop
  bool canPop() {
    final context = currentContext;
    if (context != null) {
      return context.canPop();
    }
    return false;
  }

  /// Show dialog
  Future<T?> showCustomDialog<T>({
    required Widget dialog,
    bool barrierDismissible = true,
  }) {
    final context = currentContext;
    if (context != null) {
      return showDialog<T>(
        context: context,
        builder: (_) => dialog,
        barrierDismissible: barrierDismissible,
      );
    }
    return Future.value(null);
  }

  /// Show bottom sheet
  Future<T?> showBottomSheet<T>({
    required Widget bottomSheet,
    bool isScrollControlled = false,
  }) {
    final context = currentContext;
    if (context != null) {
      return showModalBottomSheet<T>(
        context: context,
        builder: (_) => bottomSheet,
        isScrollControlled: isScrollControlled,
      );
    }
    return Future.value(null);
  }

  /// Show snackbar
  void showSnackBar({
    required String message,
    SnackBarAction? action,
    Duration duration = const Duration(seconds: 4),
  }) {
    final context = currentContext;
    if (context != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message), action: action, duration: duration),
      );
    }
  }
}
