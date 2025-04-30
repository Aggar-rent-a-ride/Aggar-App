import 'package:flutter/material.dart';

import 'custom_theme_extension.dart';

extension ContextColorsExtension on BuildContext {
  CustomThemeExtension get theme {
    try {
      return Theme.of(this).extension<CustomThemeExtension>()!;
    } catch (e) {
      return CustomThemeExtension.fallback();
    }
  }
}
