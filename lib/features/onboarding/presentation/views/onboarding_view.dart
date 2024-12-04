import 'package:aggar/core/utils/app_colors.dart';
import 'package:aggar/features/onboarding/presentation/views/page_view_1.dart';
import 'package:aggar/features/onboarding/presentation/views/page_view_2.dart';
import 'package:aggar/features/onboarding/presentation/views/page_view_3.dart';
import 'package:aggar/features/onboarding/presentation/widgets/next_and_back_button_widget.dart';
import 'package:aggar/features/onboarding/presentation/widgets/start_now_widget.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingView extends StatefulWidget {
  const OnboardingView({super.key});

  @override
  State<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView> {
  PageController controller = PageController();
  bool lastPage = false;
  bool firstPage = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: controller,
            onPageChanged: (index) {
              setState(() {
                lastPage = (index == 2);
                firstPage = (index == 0);
              });
            },
            children: const [
              PageView1(),
              PageView2(),
              PageView3(),
            ],
          ),
          Container(
            alignment: const Alignment(0, 0.75),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                firstPage
                    ? const Text("       ")
                    : NextandBackButtonWidget(
                        label: "Back",
                        onPressed: () {
                          controller.previousPage(
                            duration: const Duration(
                              milliseconds: 400,
                            ),
                            curve: Curves.easeIn,
                          );
                        },
                      ),
                SmoothPageIndicator(
                  controller: controller,
                  count: 3,
                  effect: WormEffect(
                    dotColor: AppColors.myGray100_1,
                    activeDotColor: AppColors.myBlue100_2,
                  ),
                ),
                lastPage
                    ? StartNowWidget(controller: controller)
                    : NextandBackButtonWidget(
                        label: "Next",
                        onPressed: () {
                          controller.nextPage(
                            duration: const Duration(
                              milliseconds: 400,
                            ),
                            curve: Curves.easeIn,
                          );
                        },
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
