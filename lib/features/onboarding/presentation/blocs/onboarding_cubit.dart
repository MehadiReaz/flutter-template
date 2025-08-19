import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Onboarding BLoC for managing onboarding flow
class OnboardingBloc extends Bloc<OnboardingEvent, OnboardingState> {
  OnboardingBloc() : super(const OnboardingInitial()) {
    on<OnboardingStarted>(_onOnboardingStarted);
    on<OnboardingPageChanged>(_onPageChanged);
    on<OnboardingNextPressed>(_onNextPressed);
    on<OnboardingPreviousPressed>(_onPreviousPressed);
    on<OnboardingSkipped>(_onSkipped);
    on<OnboardingCompleted>(_onCompleted);
  }

  final List<OnboardingPageData> _pages = [
    OnboardingPageData(
      title: 'Welcome to Our App',
      description:
          'Discover amazing features and services that will make your life easier.',
      imagePath: 'assets/images/onboarding_1.png',
    ),
    OnboardingPageData(
      title: 'Easy Shopping',
      description:
          'Browse and shop from thousands of products with just a few taps.',
      imagePath: 'assets/images/onboarding_2.png',
    ),
    OnboardingPageData(
      title: 'Fast Delivery',
      description:
          'Get your orders delivered quickly and safely to your doorstep.',
      imagePath: 'assets/images/onboarding_3.png',
    ),
  ];

  void _onOnboardingStarted(
    OnboardingStarted event,
    Emitter<OnboardingState> emit,
  ) {
    emit(
      OnboardingInProgress(
        currentPage: 0,
        totalPages: _pages.length,
        pages: _pages,
      ),
    );
  }

  void _onPageChanged(
    OnboardingPageChanged event,
    Emitter<OnboardingState> emit,
  ) {
    if (state is OnboardingInProgress) {
      final currentState = state as OnboardingInProgress;
      emit(currentState.copyWith(currentPage: event.pageIndex));
    }
  }

  void _onNextPressed(
    OnboardingNextPressed event,
    Emitter<OnboardingState> emit,
  ) {
    if (state is OnboardingInProgress) {
      final currentState = state as OnboardingInProgress;
      final nextPage = currentState.currentPage + 1;

      if (nextPage < _pages.length) {
        emit(currentState.copyWith(currentPage: nextPage));
      } else {
        emit(const OnboardingComplete());
      }
    }
  }

  void _onPreviousPressed(
    OnboardingPreviousPressed event,
    Emitter<OnboardingState> emit,
  ) {
    if (state is OnboardingInProgress) {
      final currentState = state as OnboardingInProgress;
      final previousPage = currentState.currentPage - 1;

      if (previousPage >= 0) {
        emit(currentState.copyWith(currentPage: previousPage));
      }
    }
  }

  void _onSkipped(OnboardingSkipped event, Emitter<OnboardingState> emit) {
    emit(const OnboardingComplete());
  }

  void _onCompleted(OnboardingCompleted event, Emitter<OnboardingState> emit) {
    emit(const OnboardingComplete());
  }
}

/// Onboarding Events
abstract class OnboardingEvent extends Equatable {
  const OnboardingEvent();

  @override
  List<Object?> get props => [];
}

class OnboardingStarted extends OnboardingEvent {
  const OnboardingStarted();
}

class OnboardingPageChanged extends OnboardingEvent {
  const OnboardingPageChanged(this.pageIndex);

  final int pageIndex;

  @override
  List<Object?> get props => [pageIndex];
}

class OnboardingNextPressed extends OnboardingEvent {
  const OnboardingNextPressed();
}

class OnboardingPreviousPressed extends OnboardingEvent {
  const OnboardingPreviousPressed();
}

class OnboardingSkipped extends OnboardingEvent {
  const OnboardingSkipped();
}

class OnboardingCompleted extends OnboardingEvent {
  const OnboardingCompleted();
}

/// Onboarding States
abstract class OnboardingState extends Equatable {
  const OnboardingState();

  @override
  List<Object?> get props => [];
}

class OnboardingInitial extends OnboardingState {
  const OnboardingInitial();
}

class OnboardingInProgress extends OnboardingState {
  const OnboardingInProgress({
    required this.currentPage,
    required this.totalPages,
    required this.pages,
  });

  final int currentPage;
  final int totalPages;
  final List<OnboardingPageData> pages;

  bool get isFirstPage => currentPage == 0;
  bool get isLastPage => currentPage == totalPages - 1;

  OnboardingInProgress copyWith({
    int? currentPage,
    int? totalPages,
    List<OnboardingPageData>? pages,
  }) {
    return OnboardingInProgress(
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
      pages: pages ?? this.pages,
    );
  }

  @override
  List<Object?> get props => [currentPage, totalPages, pages];
}

class OnboardingComplete extends OnboardingState {
  const OnboardingComplete();
}

/// Onboarding page data model
class OnboardingPageData extends Equatable {
  const OnboardingPageData({
    required this.title,
    required this.description,
    required this.imagePath,
  });

  final String title;
  final String description;
  final String imagePath;

  @override
  List<Object?> get props => [title, description, imagePath];
}
