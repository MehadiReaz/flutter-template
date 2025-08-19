import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:flutter_structure/shared/screens/splash_screen.dart';
import 'package:flutter_structure/shared/screens/home_screen.dart';
import 'package:flutter_structure/shared/screens/not_found_screen.dart';

/// Application router configuration using go_router
/// Defines all app routes and navigation logic
class AppRouter {
  AppRouter._();

  /// Global navigator key for programmatic navigation
  static final navigatorKey = GlobalKey<NavigatorState>();

  /// Router configuration
  static final GoRouter router = GoRouter(
    navigatorKey: navigatorKey,
    initialLocation: '/',
    errorBuilder: (context, state) => const NotFoundScreen(),
    routes: [
      // Splash route
      GoRoute(
        path: '/',
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),

      // Home route
      GoRoute(
        path: '/home',
        name: 'home',
        builder: (context, state) => const HomeScreen(),
      ),

      // Auth routes
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const Scaffold(
          body: Center(child: Text('Login Screen - To be implemented')),
        ),
      ),

      GoRoute(
        path: '/register',
        name: 'register',
        builder: (context, state) => const Scaffold(
          body: Center(child: Text('Register Screen - To be implemented')),
        ),
      ),

      // Onboarding routes
      GoRoute(
        path: '/onboarding',
        name: 'onboarding',
        builder: (context, state) => const Scaffold(
          body: Center(child: Text('Onboarding Screen - To be implemented')),
        ),
      ),

      // Settings route
      GoRoute(
        path: '/settings',
        name: 'settings',
        builder: (context, state) => const Scaffold(
          body: Center(child: Text('Settings Screen - To be implemented')),
        ),
      ),

      // Profile route
      GoRoute(
        path: '/profile',
        name: 'profile',
        builder: (context, state) => const Scaffold(
          body: Center(child: Text('Profile Screen - To be implemented')),
        ),
      ),
    ],
  );
}

/// Route names for type-safe navigation
class AppRoutes {
  AppRoutes._();

  static const String splash = '/';
  static const String home = '/home';
  static const String login = '/login';
  static const String register = '/register';
  static const String onboarding = '/onboarding';
  static const String settings = '/settings';
  static const String profile = '/profile';
}

/// Navigation extension for easy navigation
extension AppNavigation on BuildContext {
  /// Navigate to a named route
  void pushNamed(String name, {Map<String, String>? pathParameters}) {
    GoRouter.of(this).pushNamed(name, pathParameters: pathParameters ?? {});
  }

  /// Navigate and replace current route
  void goNamed(String name, {Map<String, String>? pathParameters}) {
    GoRouter.of(this).goNamed(name, pathParameters: pathParameters ?? {});
  }

  /// Pop current route
  void pop() {
    GoRouter.of(this).pop();
  }

  /// Check if can pop
  bool canPop() {
    return GoRouter.of(this).canPop();
  }
}
