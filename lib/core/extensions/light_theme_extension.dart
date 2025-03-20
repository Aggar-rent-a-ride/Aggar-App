import '../themes/app_light_colors.dart';
import 'custom_theme_extension.dart';

final lightThemeEx = CustomThemeExtension(
  gradientTableColors: [
    AppLightColor.commonGredient1,
    AppLightColor.commonGredient2,
  ],
  commonGradientColors: [
    AppLightColor.commonGredient1,
    AppLightColor.commonGredient2,
  ],
  subTitleColor: AppLightColor.subtitleColor,
  drawerItemColor: AppLightColor.commonGredient1,
  carInfoGradientColors: [
    AppLightColor.carInfoCardGredient1,
    AppLightColor.carInfoCardGredient2,
    AppLightColor.carInfoCardGredient3,
  ],
  hintColor: AppLightColor.greyColor,
);
