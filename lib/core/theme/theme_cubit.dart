import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

/// Theme state management using Cubit
/// Handles switching between light and dark themes
class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit() : super(const ThemeState(themeMode: ThemeMode.system));

  /// Toggle between light and dark theme
  void toggleTheme() {
    switch (state.themeMode) {
      case ThemeMode.light:
        emit(state.copyWith(themeMode: ThemeMode.dark));
        break;
      case ThemeMode.dark:
        emit(state.copyWith(themeMode: ThemeMode.light));
        break;
      case ThemeMode.system:
        emit(state.copyWith(themeMode: ThemeMode.light));
        break;
    }
  }

  /// Set specific theme mode
  void setThemeMode(ThemeMode themeMode) {
    emit(state.copyWith(themeMode: themeMode));
  }

  /// Set light theme
  void setLightTheme() {
    emit(state.copyWith(themeMode: ThemeMode.light));
  }

  /// Set dark theme
  void setDarkTheme() {
    emit(state.copyWith(themeMode: ThemeMode.dark));
  }

  /// Set system theme
  void setSystemTheme() {
    emit(state.copyWith(themeMode: ThemeMode.system));
  }
}

/// Theme state
class ThemeState extends Equatable {
  const ThemeState({required this.themeMode});

  final ThemeMode themeMode;

  /// Check if current theme is light
  bool get isLight => themeMode == ThemeMode.light;

  /// Check if current theme is dark
  bool get isDark => themeMode == ThemeMode.dark;

  /// Check if current theme is system
  bool get isSystem => themeMode == ThemeMode.system;

  /// Copy with method for state updates
  ThemeState copyWith({ThemeMode? themeMode}) {
    return ThemeState(themeMode: themeMode ?? this.themeMode);
  }

  @override
  List<Object> get props => [themeMode];
}
