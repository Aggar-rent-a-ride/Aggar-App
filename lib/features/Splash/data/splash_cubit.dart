import 'package:aggar/features/Splash/data/splash_state.dart';
import 'package:aggar/features/main_screen/presentation/views/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:aggar/features/authorization/presentation/views/sign_in_view.dart';
import 'package:aggar/features/onboarding/presentation/views/onboarding_view.dart';

class SplashCubit extends Cubit<SplashState> {
  final _secureStorage = const FlutterSecureStorage();
  final _authService = AuthService();

  SplashCubit() : super(SplashState.initial());

  void initialize(TickerProvider vsync) {
    _initAnimations(vsync);
    _checkAuthAndNavigate();
  }

  void _initAnimations(TickerProvider vsync) {
    final animationController = AnimationController(
      vsync: vsync,
      duration: const Duration(milliseconds: 1500),
    );

    final fadeInAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: animationController,
        curve: const Interval(0.0, 0.7, curve: Curves.easeIn),
      ),
    );

    final scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: animationController,
        curve: const Interval(0.2, 0.8, curve: Curves.easeOutBack),
      ),
    );

    final slidingAnimation =
        Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero).animate(
      CurvedAnimation(
        parent: animationController,
        curve: const Interval(0.3, 1.0, curve: Curves.elasticOut),
      ),
    );

    emit(state.copyWith(
      animationController: animationController,
      fadeInAnimation: fadeInAnimation,
      scaleAnimation: scaleAnimation,
      slidingAnimation: slidingAnimation,
    ));

    animationController.forward();
  }

  Future<void> _checkAuthAndNavigate() async {
    await Future.delayed(const Duration(milliseconds: 2500));

    try {
      final seenOnboarding =
          await _secureStorage.read(key: 'seenOnboarding') == 'true';

      final isAuthenticated = await _authService.isUserAuthenticated();

      Widget destination;
      if (isAuthenticated) {
        destination = const MainScreen();
      } else if (seenOnboarding) {
        destination = const SignInView();
      } else {
        destination = const OnboardingView();
      }

      emit(state.copyWith(navigateTo: destination));
    } catch (e) {
      emit(state.copyWith(navigateTo: const OnboardingView()));
    }
  }

  void dispose() {
    state.animationController?.dispose();
  }

  @override
  Future<void> close() {
    state.animationController?.dispose();
    return super.close();
  }
}

class AuthService {
  final _secureStorage = const FlutterSecureStorage();

  Future<bool> isUserAuthenticated() async {
    try {
      final accessToken = await _secureStorage.read(key: 'accessToken');

      if (accessToken == null || accessToken.isEmpty) {
        return false;
      }

      final tokenCreatedAtString =
          await _secureStorage.read(key: 'tokenCreatedAt');
      if (tokenCreatedAtString != null) {
        final tokenCreatedAt = DateTime.parse(tokenCreatedAtString);
        final now = DateTime.now();

        if (now.difference(tokenCreatedAt).inDays > 7) {
          return false;
        }
      }

      return true;
    } catch (e) {
      print('Error checking authentication status: $e');
      return false;
    }
  }

  Future<bool> refreshTokenIfNeeded() async {
    try {
      final refreshToken = await _secureStorage.read(key: 'refreshToken');
      if (refreshToken == null || refreshToken.isEmpty) {
        return false;
      }

      return false;
    } catch (e) {
      return false;
    }
  }
}
