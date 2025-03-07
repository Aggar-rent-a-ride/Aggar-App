import 'package:flutter/material.dart';
import 'package:aggar/features/authorization/presentation/views/pick_image.dart';
import 'package:aggar/features/authorization/presentation/views/sign_up_view.dart';

class ScrollViewHome extends StatefulWidget {
  const ScrollViewHome({super.key});
  
  @override
  State<ScrollViewHome> createState() => _ScrollViewHomeState();
}

class _ScrollViewHomeState extends State<ScrollViewHome> {
  final PageController _controller = PageController();
  final Map<String, dynamic> _userData = {};
  
  void _updateUserData(Map<String, String> formData) {
    setState(() {
      _userData.addAll(formData);
    });
  }
  
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
            physics: const NeverScrollableScrollPhysics(), 
            children: [
              SignUpView(
                controller: _controller,
                onFormDataSubmitted: _updateUserData,
              ),
              PickImage(
                userData: _userData,
              ),
            ],
          ),
          // Page indicator can be uncommented and implemented here
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