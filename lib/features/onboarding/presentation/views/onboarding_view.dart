import 'package:aggar/core/utils/app_colors.dart';
import 'package:aggar/features/onboarding/presentation/widgets/custom_page_view.dart';
import 'package:aggar/features/onboarding/presentation/widgets/next_and_back_button_widget.dart';
import 'package:aggar/features/onboarding/presentation/widgets/start_now_widget.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../../core/utils/app_assets.dart';

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
      backgroundColor: AppColors.myWhite100_1,
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
              CustomPageView(
                img: AppAssets.assetsImagesImg1,
                title: "Welcome to Agger",
                description:
                    "Whether you're exploring new cities or need a ride for the day, we’ve got you covered with our easy-to-use platform.",
              ),
              CustomPageView(
                img: AppAssets.assetsImagesImg2,
                title: "Meet the owner",
                description:
                    "You can connect with the owner for a personalized experience, ensuring you get exactly what you need for a memorable trip.",
              ),
              CustomPageView(
                img: AppAssets.assetsImagesImg3,
                title: "Book your car ",
                description:
                    "Agger offers a wide range of vehicles to suit your needs, ensuring a smooth and convenient booking experience.",
              ),
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
