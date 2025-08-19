import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

// Events
abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class LoginRequested extends AuthEvent {
  const LoginRequested({required this.email, required this.password});

  final String email;
  final String password;

  @override
  List<Object> get props => [email, password];
}

class LogoutRequested extends AuthEvent {
  const LogoutRequested();
}

class AuthStatusChecked extends AuthEvent {
  const AuthStatusChecked();
}

class TokenRefreshRequested extends AuthEvent {
  const TokenRefreshRequested();
}

// States
abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {
  const AuthInitial();
}

class AuthLoading extends AuthState {
  const AuthLoading();
}

class AuthAuthenticated extends AuthState {
  const AuthAuthenticated({required this.user});

  final AuthUser user;

  @override
  List<Object> get props => [user];
}

class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated();
}

class AuthError extends AuthState {
  const AuthError({required this.message});

  final String message;

  @override
  List<Object> get props => [message];
}

// User model
class AuthUser extends Equatable {
  const AuthUser({
    required this.id,
    required this.email,
    required this.name,
    this.avatar,
  });

  final String id;
  final String email;
  final String name;
  final String? avatar;

  @override
  List<Object?> get props => [id, email, name, avatar];
}

// BLoC
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({
    required this.loginUseCase,
    required this.logoutUseCase,
    required this.refreshTokenUseCase,
    required this.getProfileUseCase,
  }) : super(const AuthInitial()) {
    on<LoginRequested>(_onLoginRequested);
    on<LogoutRequested>(_onLogoutRequested);
    on<AuthStatusChecked>(_onAuthStatusChecked);
    on<TokenRefreshRequested>(_onTokenRefreshRequested);
  }

  final dynamic loginUseCase;
  final dynamic logoutUseCase;
  final dynamic refreshTokenUseCase;
  final dynamic getProfileUseCase;

  Future<void> _onLoginRequested(
    LoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    try {
      // TODO: Implement login use case
      await Future.delayed(const Duration(seconds: 2)); // Simulate API call

      // Mock successful login
      const user = AuthUser(
        id: '1',
        email: 'user@example.com',
        name: 'John Doe',
      );

      emit(const AuthAuthenticated(user: user));
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  Future<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    try {
      // TODO: Implement logout use case
      await Future.delayed(const Duration(seconds: 1)); // Simulate API call

      emit(const AuthUnauthenticated());
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  Future<void> _onAuthStatusChecked(
    AuthStatusChecked event,
    Emitter<AuthState> emit,
  ) async {
    try {
      // TODO: Check if user is authenticated
      // This would typically check stored tokens
      await Future.delayed(const Duration(milliseconds: 500));

      // Mock check - always return unauthenticated for now
      emit(const AuthUnauthenticated());
    } catch (e) {
      emit(const AuthUnauthenticated());
    }
  }

  Future<void> _onTokenRefreshRequested(
    TokenRefreshRequested event,
    Emitter<AuthState> emit,
  ) async {
    try {
      // TODO: Implement token refresh use case
      await Future.delayed(const Duration(seconds: 1));

      // For now, just maintain current state
    } catch (e) {
      emit(const AuthUnauthenticated());
    }
  }
}
