import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/translations/l10n.dart';
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
    final localizations = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: context.theme.white100_1,
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
            children: [
              CustomPageView(
                img: Theme.of(context).brightness == Brightness.light
                    ? AppAssets.assetsImagesOnboarding1
                    : AppAssets.assetsImagesOnboarding1dark,
                title: localizations.translate('onboarding_title_1'),
                description: localizations.translate('onboarding_subtitle_1'),
              ),
              CustomPageView(
                img: Theme.of(context).brightness == Brightness.light
                    ? AppAssets.assetsImagesOnboarding2
                    : AppAssets.assetsImagesOnboarding2dark,
                title: localizations.translate('onboarding_title_2'),
                description: localizations.translate('onboarding_subtitle_2'),
              ),
              CustomPageView(
                img: Theme.of(context).brightness == Brightness.light
                    ? AppAssets.assetsImagesOnboarding3
                    : AppAssets.assetsImagesOnboarding3dark,
                title: localizations.translate('onboarding_title_3'),
                description: localizations.translate('onboarding_subtitle_3'),
              ),
            ],
          ),
          Container(
            alignment: const Alignment(0, 0.75),
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                firstPage
                    ? const Text("       ")
                    : NextandBackButtonWidget(
                        label: localizations.translate('skip'),
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
                    dotColor: context.theme.grey100_1,
                    activeDotColor: context.theme.blue100_1,
                  ),
                ),
                lastPage
                    ? StartNowWidget(controller: controller)
                    : NextandBackButtonWidget(
                        label: localizations.translate('next'),
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
