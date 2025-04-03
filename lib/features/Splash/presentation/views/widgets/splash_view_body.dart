import 'package:aggar/features/Splash/data/splash_cubit.dart';
import 'package:aggar/features/Splash/data/splash_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';

class SplashViewBody extends StatefulWidget {
  const SplashViewBody({super.key});

  @override
  State<SplashViewBody> createState() => _SplashViewBodyState();
}

class _SplashViewBodyState extends State<SplashViewBody>
    with SingleTickerProviderStateMixin {
  late SplashCubit _splashCubit;

  @override
  void initState() {
    super.initState();
    _splashCubit = SplashCubit();
    _splashCubit.initialize(this);
  }

  @override
  void dispose() {
    _splashCubit.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _splashCubit,
      child: BlocConsumer<SplashCubit, SplashState>(
        listener: (context, state) {
          if (state.navigateTo != null) {
            Navigator.pushReplacement(
              context,
              PageRouteBuilder(
                pageBuilder: (_, animation, __) => state.navigateTo!,
                transitionsBuilder: (_, animation, __, child) {
                  return FadeTransition(
                    opacity:
                        Tween<double>(begin: 0.0, end: 1.0).animate(animation),
                    child: child,
                  );
                },
                transitionDuration: const Duration(milliseconds: 500),
              ),
            );
          }
        },
        builder: (context, state) {
          if (state.animationController == null) {
            return const Center(child: CircularProgressIndicator());
          }

          return Center(
            child: AnimatedBuilder(
              animation: state.animationController!,
              builder: (context, child) {
                return FadeTransition(
                  opacity: state.fadeInAnimation!,
                  child: ScaleTransition(
                    scale: state.scaleAnimation!,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 200,
                          width: 200,
                          child: Lottie.asset(
                            "assets/lottie/Splash_car.json",
                            fit: BoxFit.contain,
                          ),
                        ),
                        const SizedBox(height: 20),
                        SlideTransition(
                          position: state.slidingAnimation!,
                          child: const Text(
                            "Agger",
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.blueAccent,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        SlideTransition(
                          position: state.slidingAnimation!,
                          child: const Text(
                            "Your way for new car",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
