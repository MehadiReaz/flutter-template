import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:flutter_structure/core/di/dependency_injection.dart';
import 'package:flutter_structure/core/theme/theme_cubit.dart';
import 'package:flutter_structure/core/theme/app_theme.dart';
import 'package:flutter_structure/core/routing/app_router.dart';
import 'package:flutter_structure/shared/screens/splash_screen.dart';

/// The main application widget
/// This widget sets up the app with BLoC providers, theming, and routing
class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // Core app-wide BLoCs
        BlocProvider<ThemeCubit>(create: (context) => getIt<ThemeCubit>()),
        // Add more global BLoCs here as needed
        // BlocProvider<AuthBloc>(
        //   create: (context) => getIt<AuthBloc>(),
        // ),
      ],
      child: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, themeState) {
          return MaterialApp.router(
            // App configuration
            title: 'Flutter Structure',
            debugShowCheckedModeBanner: false,

            // Theming
            theme: AppTheme.light,
            darkTheme: AppTheme.dark,
            themeMode: themeState.themeMode,

            // Routing
            routerConfig: AppRouter.router,

            // Localization
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('en', 'US'), // English
              Locale('es', 'ES'), // Spanish
              Locale('fr', 'FR'), // French
            ],

            // Builder for additional configuration
            builder: (context, child) {
              return MediaQuery(
                // Prevent text scaling beyond reasonable limits
                data: MediaQuery.of(context).copyWith(
                  textScaler: TextScaler.linear(
                    MediaQuery.of(context).textScaleFactor.clamp(0.8, 1.2),
                  ),
                ),
                child: child ?? const SplashScreen(),
              );
            },
          );
        },
      ),
    );
  }
}
