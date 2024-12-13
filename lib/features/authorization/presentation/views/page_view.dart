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
            controller: controller,
            onPageChanged: (index) {},
            children: const [SignUpView(), PickImage()],
          ),
          Container(
            alignment: const Alignment(0, 0.42),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SmoothPageIndicator(
                  controller: controller,
                  count: 2,
                  effect: WormEffect(
                    dotColor: AppColors.myGray100_1,
                    activeDotColor: AppColors.myBlue100_2,
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
