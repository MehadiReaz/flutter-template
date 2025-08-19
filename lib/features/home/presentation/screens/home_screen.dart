import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_structure/features/auth/presentation/blocs/auth_bloc.dart';
import 'package:flutter_structure/core/theme/typography/app_text_styles.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text('E-Commerce App', style: AppTextStyles.headlineMedium),
        actions: [
          BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              if (state is AuthAuthenticated) {
                return PopupMenuButton<String>(
                  onSelected: (value) {
                    if (value == 'profile') {
                      // TODO: Navigate to profile
                    } else if (value == 'logout') {
                      context.read<AuthBloc>().add(const LogoutRequested());
                    }
                  },
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 'profile',
                      child: Row(
                        children: [
                          const Icon(Icons.person),
                          const SizedBox(width: 8),
                          Text('Profile', style: AppTextStyles.bodyMedium),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 'logout',
                      child: Row(
                        children: [
                          const Icon(Icons.logout),
                          const SizedBox(width: 8),
                          Text('Logout', style: AppTextStyles.bodyMedium),
                        ],
                      ),
                    ),
                  ],
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CircleAvatar(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      child: Text(
                        state.user.name.isNotEmpty
                            ? state.user.name[0].toUpperCase()
                            : 'U',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                );
              }
              return IconButton(
                icon: const Icon(Icons.person_outlined),
                onPressed: () => context.push('/login'),
              );
            },
          ),
        ],
      ),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthUnauthenticated) {
            // Optional: Show a message when user logs out
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Logged out successfully'),
                backgroundColor: Colors.green,
              ),
            );
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome Section
              BlocBuilder<AuthBloc, AuthState>(
                builder: (context, state) {
                  if (state is AuthAuthenticated) {
                    return Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Theme.of(context).colorScheme.primary,
                            Theme.of(
                              context,
                            ).colorScheme.primary.withOpacity(0.8),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Welcome back,',
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: Colors.white70,
                            ),
                          ),
                          Text(
                            state.user.name,
                            style: AppTextStyles.headlineMedium.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Ready to shop for amazing products?',
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                  return Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          spreadRadius: 1,
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Welcome to E-Commerce',
                          style: AppTextStyles.headlineMedium.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Discover amazing products and great deals!',
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () => context.push('/login'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(
                                context,
                              ).colorScheme.primary,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(
                              'Sign In for Better Experience',
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(height: 24),

              // Quick Actions
              Text(
                'Quick Actions',
                style: AppTextStyles.headlineSmall.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.2,
                children: [
                  _QuickActionCard(
                    icon: Icons.shopping_bag_outlined,
                    title: 'Browse Products',
                    subtitle: 'Discover our catalog',
                    onTap: () => context.push('/products'),
                  ),
                  _QuickActionCard(
                    icon: Icons.shopping_cart_outlined,
                    title: 'My Cart',
                    subtitle: 'View your items',
                    onTap: () {
                      final authState = context.read<AuthBloc>().state;
                      if (authState is AuthAuthenticated) {
                        context.push('/cart');
                      } else {
                        context.push(
                          '/login',
                          extra: {'redirectPath': '/cart', 'isRequired': true},
                        );
                      }
                    },
                  ),
                  _QuickActionCard(
                    icon: Icons.history,
                    title: 'Order History',
                    subtitle: 'Track your orders',
                    onTap: () {
                      final authState = context.read<AuthBloc>().state;
                      if (authState is AuthAuthenticated) {
                        context.push('/orders');
                      } else {
                        context.push(
                          '/login',
                          extra: {
                            'redirectPath': '/orders',
                            'isRequired': true,
                          },
                        );
                      }
                    },
                  ),
                  _QuickActionCard(
                    icon: Icons.favorite_outlined,
                    title: 'Wishlist',
                    subtitle: 'Your saved items',
                    onTap: () {
                      final authState = context.read<AuthBloc>().state;
                      if (authState is AuthAuthenticated) {
                        context.push('/wishlist');
                      } else {
                        context.push(
                          '/login',
                          extra: {
                            'redirectPath': '/wishlist',
                            'isRequired': true,
                          },
                        );
                      }
                    },
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Featured Section
              Text(
                'Featured Categories',
                style: AppTextStyles.headlineSmall.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 120,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    _CategoryCard(
                      title: 'Electronics',
                      icon: Icons.phone_android,
                      color: Colors.blue,
                      onTap: () =>
                          context.push('/products?category=electronics'),
                    ),
                    _CategoryCard(
                      title: 'Clothing',
                      icon: Icons.checkroom,
                      color: Colors.pink,
                      onTap: () => context.push('/products?category=clothing'),
                    ),
                    _CategoryCard(
                      title: 'Home',
                      icon: Icons.home,
                      color: Colors.green,
                      onTap: () => context.push('/products?category=home'),
                    ),
                    _CategoryCard(
                      title: 'Books',
                      icon: Icons.book,
                      color: Colors.orange,
                      onTap: () => context.push('/products?category=books'),
                    ),
                    _CategoryCard(
                      title: 'Sports',
                      icon: Icons.sports_basketball,
                      color: Colors.red,
                      onTap: () => context.push('/products?category=sports'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _QuickActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _QuickActionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 32,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: AppTextStyles.bodySmall.copyWith(
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CategoryCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _CategoryCard({
    required this.title,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      margin: const EdgeInsets.only(right: 12),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 24, color: color),
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: AppTextStyles.bodySmall.copyWith(
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
