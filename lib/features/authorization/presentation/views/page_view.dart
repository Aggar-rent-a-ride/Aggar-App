import 'package:aggar/core/utils/app_colors.dart';
import 'package:aggar/features/authorization/presentation/views/pick_image.dart';
import 'package:aggar/features/authorization/presentation/views/sign_up_view.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class ScrollViewHome extends StatelessWidget {
  const ScrollViewHome({super.key});

  @override
  Widget build(BuildContext context) {
    PageController controller = PageController();
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            physics: const NeverScrollableScrollPhysics(), //to make it never scroll
            controller: controller,
            onPageChanged: (index) {},
            children: const [SignUpView(), PickImage()],
          ),
          Container(
            alignment: const Alignment(0, 0.45),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SmoothPageIndicator(
                  controller: controller,
                  count: 2,
                  effect: CustomizableEffect(
                    activeDotDecoration: DotDecoration(
                      width: 15.0,
                      height: 15.0,
                      color: AppColors.myBlue100_2,
                      borderRadius: BorderRadius.circular(3),
                    ),
                    dotDecoration: DotDecoration(
                      width: 15.0,
                      height: 15.0,
                      color: AppColors.myGray100_1,
                      borderRadius: BorderRadius.circular(3),
                    ),
                    spacing: 10.0,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
