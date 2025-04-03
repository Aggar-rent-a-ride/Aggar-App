import 'package:flutter/material.dart';

class SplashState {
  final AnimationController? animationController;
  final Animation<double>? fadeInAnimation;
  final Animation<double>? scaleAnimation;
  final Animation<Offset>? slidingAnimation;
  final Widget? navigateTo;

  const SplashState({
    this.animationController,
    this.fadeInAnimation,
    this.scaleAnimation,
    this.slidingAnimation,
    this.navigateTo,
  });

  factory SplashState.initial() {
    return const SplashState();
  }

  SplashState copyWith({
    AnimationController? animationController,
    Animation<double>? fadeInAnimation,
    Animation<double>? scaleAnimation,
    Animation<Offset>? slidingAnimation,
    Widget? navigateTo,
  }) {
    return SplashState(
      animationController: animationController ?? this.animationController,
      fadeInAnimation: fadeInAnimation ?? this.fadeInAnimation,
      scaleAnimation: scaleAnimation ?? this.scaleAnimation,
      slidingAnimation: slidingAnimation ?? this.slidingAnimation,
      navigateTo: navigateTo ?? this.navigateTo,
    );
  }
}