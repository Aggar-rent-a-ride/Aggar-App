import 'package:aggar/features/authorization/presentation/views/pick_image.dart';
import 'package:aggar/features/authorization/presentation/views/sign_up_view.dart';
import 'package:flutter/material.dart';

class ScrollViewHome extends StatefulWidget {
  const ScrollViewHome({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ScrollViewHomeState createState() => _ScrollViewHomeState();
}

class _ScrollViewHomeState extends State<ScrollViewHome> {
  final PageController _controller = PageController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _controller,
            physics: const NeverScrollableScrollPhysics(), // Disable swipe
            children: [
              SignUpView(controller: _controller), // Pass controller
              const PickImage(),
            ],
          ),
          // Positioned(
          //   bottom: 20,
          //   left: 0,
          //   right: 0,
          //   child: Center(
          //     child: SmoothPageIndicator(
          //       controller: _controller,
          //       count: 2,
          //       effect: CustomizableEffect(
          //         activeDotDecoration: DotDecoration(
          //           width: 15.0,
          //           height: 15.0,
          //           color: AppColors.myBlue100_2,
          //           borderRadius: BorderRadius.circular(3),
          //         ),
          //         dotDecoration: DotDecoration(
          //           width: 15.0,
          //           height: 15.0,
          //           color: AppColors.myGray100_1,
          //           borderRadius: BorderRadius.circular(3),
          //         ),
          //         spacing: 10.0,
          //       ),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}
