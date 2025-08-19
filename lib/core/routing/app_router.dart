import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_structure/core/di/dependency_injection.dart';
import 'package:flutter_structure/features/auth/presentation/blocs/auth_bloc.dart';
import 'package:flutter_structure/features/home/presentation/screens/home_screen.dart';
import 'package:flutter_structure/features/auth/presentation/screens/login_screen.dart';
import 'package:flutter_structure/features/auth/presentation/screens/register_screen.dart';
import 'package:flutter_structure/features/products/presentation/screens/product_list_screen.dart';
import 'package:flutter_structure/features/cart/presentation/screens/cart_screen.dart';

class AppRouter {
  static final GlobalKey<NavigatorState> _rootNavigatorKey =
      GlobalKey<NavigatorState>();

  static GoRouter get router => _router;

  static final GoRouter _router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    debugLogDiagnostics: true,
    initialLocation: '/home',
    routes: [
      // Home Route
      GoRoute(
        path: '/home',
        builder: (context, state) => BlocProvider(
          create: (context) =>
              getIt<AuthBloc>()..add(const AuthStatusChecked()),
          child: const HomeScreen(),
        ),
      ),

      // Auth Routes
      GoRoute(
        path: '/login',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          return LoginScreen(
            redirectPath: extra?['redirectPath'] as String?,
            isRequired: extra?['isRequired'] as bool? ?? false,
          );
        },
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          return RegisterScreen(
            redirectPath: extra?['redirectPath'] as String?,
            isRequired: extra?['isRequired'] as bool? ?? false,
          );
        },
      ),

      // Products Routes
      GoRoute(
        path: '/products',
        builder: (context, state) => BlocProvider(
          create: (context) =>
              getIt<AuthBloc>()..add(const AuthStatusChecked()),
          child: const ProductListScreen(),
        ),
      ),
      GoRoute(
        path: '/products/:id',
        builder: (context, state) {
          final productId = state.pathParameters['id']!;
          return BlocProvider(
            create: (context) =>
                getIt<AuthBloc>()..add(const AuthStatusChecked()),
            child: ProductDetailScreen(productId: productId),
          );
        },
      ),

      // Cart Route
      GoRoute(
        path: '/cart',
        builder: (context, state) => BlocProvider(
          create: (context) =>
              getIt<AuthBloc>()..add(const AuthStatusChecked()),
          child: const CartScreen(),
        ),
      ),

      // Orders Route
      GoRoute(
        path: '/orders',
        builder: (context, state) => BlocProvider(
          create: (context) =>
              getIt<AuthBloc>()..add(const AuthStatusChecked()),
          child: const OrdersScreen(),
        ),
      ),

      // Wishlist Route
      GoRoute(
        path: '/wishlist',
        builder: (context, state) => BlocProvider(
          create: (context) =>
              getIt<AuthBloc>()..add(const AuthStatusChecked()),
          child: const WishlistScreen(),
        ),
      ),

      // Checkout Route
      GoRoute(
        path: '/checkout',
        builder: (context, state) => BlocProvider(
          create: (context) =>
              getIt<AuthBloc>()..add(const AuthStatusChecked()),
          child: const CheckoutScreen(),
        ),
      ),
    ],

    // Redirect logic for authentication
    redirect: (context, state) {
      // Get current auth state if available
      try {
        final authState = context.read<AuthBloc>().state;
        final isLoggedIn = authState is AuthAuthenticated;
        final isLoggingIn =
            state.fullPath == '/login' || state.fullPath == '/register';

        // Allow access to login and register screens
        if (isLoggingIn) {
          return null;
        }

        // Allow access to products and home without authentication
        if (state.fullPath == '/products' ||
            state.fullPath == '/home' ||
            state.fullPath?.startsWith('/products/') == true) {
          return null;
        }

        // Redirect to login for protected routes if not authenticated
        final protectedRoutes = ['/cart', '/orders', '/wishlist', '/checkout'];
        if (protectedRoutes.any(
              (route) => state.fullPath?.startsWith(route) == true,
            ) &&
            !isLoggedIn) {
          return '/login?redirect=${Uri.encodeComponent(state.fullPath ?? '/home')}';
        }

        return null;
      } catch (e) {
        // If we can't access auth state, allow navigation
        return null;
      }
    },

    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            const Text(
              'Page Not Found',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'The page "${state.fullPath}" could not be found.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[600]),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.go('/home'),
              child: const Text('Go Home'),
            ),
          ],
        ),
      ),
    ),
  );
}

// Placeholder screens - to be implemented
class ProductDetailScreen extends StatelessWidget {
  final String productId;

  const ProductDetailScreen({super.key, required this.productId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Product Details')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Product Details for ID: $productId'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.pop(),
              child: const Text('Back'),
            ),
          ],
        ),
      ),
    );
  }
}

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Orders')),
      body: const Center(child: Text('Orders Screen - Coming Soon')),
    );
  }
}

class WishlistScreen extends StatelessWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Wishlist')),
      body: const Center(child: Text('Wishlist Screen - Coming Soon')),
    );
  }
}

class CheckoutScreen extends StatelessWidget {
  const CheckoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Checkout')),
      body: const Center(child: Text('Checkout Screen - Coming Soon')),
    );
  }
}
