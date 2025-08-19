import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_structure/core/errors/error_logger.dart';

/// Global Bloc observer for monitoring all Bloc state changes and events
/// This helps with debugging and logging in development
class AppBlocObserver extends BlocObserver {
  @override
  void onCreate(BlocBase<dynamic> bloc) {
    super.onCreate(bloc);
    ErrorLogger.logDebug('Bloc Created: ${bloc.runtimeType}');
  }

  @override
  void onEvent(BlocBase<dynamic> bloc, Object? event) {
    // Only log events for actual Blocs, not Cubits
    if (bloc is Bloc) {
      super.onEvent(bloc, event);
      ErrorLogger.logDebug('Bloc Event: ${bloc.runtimeType} -> $event');
    }
  }

  @override
  void onChange(BlocBase<dynamic> bloc, Change<dynamic> change) {
    super.onChange(bloc, change);
    ErrorLogger.logDebug(
      'Bloc State Change: ${bloc.runtimeType}\n'
      'From: ${change.currentState}\n'
      'To: ${change.nextState}',
    );
  }

  @override
  void onTransition(
    BlocBase<dynamic> bloc,
    Transition<dynamic, dynamic> transition,
  ) {
    // Only log transitions for actual Blocs, not Cubits
    if (bloc is Bloc) {
      super.onTransition(bloc, transition);
      ErrorLogger.logDebug(
        'Bloc Transition: ${bloc.runtimeType}\n'
        'Event: ${transition.event}\n'
        'From: ${transition.currentState}\n'
        'To: ${transition.nextState}',
      );
    }
  }

  @override
  void onError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace) {
    super.onError(bloc, error, stackTrace);
    ErrorLogger.logError(
      'Bloc Error in ${bloc.runtimeType}: $error',
      stackTrace,
    );
  }

  @override
  void onClose(BlocBase<dynamic> bloc) {
    super.onClose(bloc);
    ErrorLogger.logDebug('Bloc Closed: ${bloc.runtimeType}');
  }
}
