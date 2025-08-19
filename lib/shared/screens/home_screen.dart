import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_structure/core/theme/theme_cubit.dart';
import 'package:flutter_structure/core/navigation/app_router.dart';

/// Home screen - main screen of the application
/// This screen demonstrates the template structure and BLoC usage
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Structure'),
        actions: [
          // Theme toggle button
          BlocBuilder<ThemeCubit, ThemeState>(
            builder: (context, state) {
              return IconButton(
                onPressed: () => context.read<ThemeCubit>().toggleTheme(),
                icon: Icon(state.isDark ? Icons.light_mode : Icons.dark_mode),
                tooltip: 'Toggle theme',
              );
            },
          ),

          // Settings button
          IconButton(
            onPressed: () => context.pushNamed('settings'),
            icon: const Icon(Icons.settings),
            tooltip: 'Settings',
          ),
        ],
      ),
      body: const _HomeBody(),
      bottomNavigationBar: const _BottomNavigation(),
    );
  }
}

class _HomeBody extends StatelessWidget {
  const _HomeBody();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Welcome card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome to Flutter Structure! 🚀',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'This is a comprehensive Flutter template with clean architecture, BLoC state management, and modern development practices.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Features section
          Text('Features', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 12),

          const _FeatureCard(
            icon: Icons.architecture,
            title: 'Clean Architecture',
            description: 'Domain, Data, and Presentation layers',
          ),
          const SizedBox(height: 8),

          const _FeatureCard(
            icon: Icons.auto_awesome_motion,
            title: 'BLoC State Management',
            description: 'Predictable state management with flutter_bloc',
          ),
          const SizedBox(height: 8),

          const _FeatureCard(
            icon: Icons.route,
            title: 'Go Router Navigation',
            description: 'Declarative routing with go_router',
          ),
          const SizedBox(height: 8),

          const _FeatureCard(
            icon: Icons.palette,
            title: 'Dynamic Theming',
            description: 'Light and dark theme support',
          ),
          const SizedBox(height: 8),

          const _FeatureCard(
            icon: Icons.storage,
            title: 'Multiple Storage Options',
            description: 'Hive, SharedPreferences, and Secure Storage',
          ),
          const SizedBox(height: 16),

          // Navigation demo section
          Text(
            'Navigation Demo',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 12),

          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              ElevatedButton(
                onPressed: () => context.pushNamed('login'),
                child: const Text('Login'),
              ),
              ElevatedButton(
                onPressed: () => context.pushNamed('register'),
                child: const Text('Register'),
              ),
              ElevatedButton(
                onPressed: () => context.pushNamed('onboarding'),
                child: const Text('Onboarding'),
              ),
              ElevatedButton(
                onPressed: () => context.pushNamed('profile'),
                child: const Text('Profile'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _FeatureCard extends StatelessWidget {
  const _FeatureCard({
    required this.icon,
    required this.title,
    required this.description,
  });

  final IconData icon;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(icon, color: Theme.of(context).colorScheme.primary),
        title: Text(title),
        subtitle: Text(description),
      ),
    );
  }
}

class _BottomNavigation extends StatelessWidget {
  const _BottomNavigation();

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: 0,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.explore), label: 'Explore'),
        BottomNavigationBarItem(icon: Icon(Icons.bookmark), label: 'Bookmarks'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
      ],
      onTap: (index) {
        // Handle navigation
        switch (index) {
          case 0:
            // Already on home
            break;
          case 1:
            // Navigate to explore
            break;
          case 2:
            // Navigate to bookmarks
            break;
          case 3:
            context.pushNamed('profile');
            break;
        }
      },
    );
  }
}
