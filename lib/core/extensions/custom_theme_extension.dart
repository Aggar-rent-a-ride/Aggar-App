import 'package:flutter/material.dart';

class CustomThemeExtension extends ThemeExtension<CustomThemeExtension> {
  final Color black10;
  final Color black25;
  final Color black50;
  final Color black100;

  final Color grey100_1;

  final Color white100_1;
  final Color white50_1;
  final Color white100_2;
  final Color white100_4;

  final Color blue100_1;
  final Color blue100_5;
  final Color blue100_2;
  final Color blue50_2;
  final Color blue10_2;
  final Color blue100_3;
  final Color blue100_4;
  final Color blue100_6;
  final Color blue100_7;
  final Color blue100_8;

  final Color yellow100_1;
  final Color yellow10_1;
  final Color red100_1;
  final Color red10_1;
  final Color green100_1;
  final Color green10_1;

  CustomThemeExtension({
    required this.black10,
    required this.black25,
    required this.black50,
    required this.black100,
    required this.grey100_1,
    required this.white100_1,
    required this.white50_1,
    required this.white100_2,
    required this.white100_4,
    required this.blue100_1,
    required this.blue100_5,
    required this.blue100_2,
    required this.blue50_2,
    required this.blue10_2,
    required this.blue100_3,
    required this.blue100_4,
    required this.blue100_6,
    required this.blue100_7,
    required this.blue100_8,
    required this.yellow100_1,
    required this.yellow10_1,
    required this.red100_1,
    required this.red10_1,
    required this.green100_1,
    required this.green10_1,
  });
  static CustomThemeExtension fallback() {
    return CustomThemeExtension(
      black10: const Color(0x1A000000),
      black25: const Color(0x40000000),
      black50: const Color(0x80000000),
      black100: const Color(0xFF000000),
      grey100_1: const Color(0xFF888888),
      white100_1: const Color(0xFFFFFFFF),
      white50_1: const Color(0x80FFFFFF),
      white100_2: const Color(0xFFF9F9F9),
      white100_4: const Color(0xFFF0F0F0),
      blue100_1: const Color(0xFF2196F3),
      blue100_5: const Color(0xFF0D47A1),
      blue100_2: const Color(0xFF1976D2),
      blue50_2: const Color(0x801976D2),
      blue10_2: const Color(0x1A1976D2),
      blue100_3: const Color(0xFF0D47A1),
      blue100_4: const Color(0xFF3F51B5),
      blue100_6: const Color(0xFF3949AB),
      blue100_7: const Color(0xFF1A237E),
      blue100_8: const Color(0xFF283593),
      yellow100_1: const Color(0xFFFFEB3B),
      yellow10_1: const Color(0x1AFFEB3B),
      red100_1: const Color(0xFFF44336),
      red10_1: const Color(0x1AF44336),
      green100_1: const Color(0xFF4CAF50),
      green10_1: const Color(0x1A4CAF50),
    );
  }

  @override
  ThemeExtension<CustomThemeExtension> copyWith({
    Color? black10,
    Color? black25,
    Color? black50,
    Color? black100,
    Color? grey100_1,
    Color? grey100_3,
    Color? white100_1,
    Color? white50_1,
    Color? white100_2,
    Color? white100_4,
    Color? blue100_1,
    Color? blue100_5,
    Color? blue100_2,
    Color? blue50_2,
    Color? blue10_2,
    Color? blue100_3,
    Color? blue100_4,
    Color? blue100_6,
    Color? blue100_7,
    Color? blue100_8,
    Color? yellow100_1,
    Color? yellow10_1,
    Color? red100_1,
    Color? red10_1,
    Color? green100_1,
    Color? green10_1,
  }) {
    return CustomThemeExtension(
      black10: black10 ?? this.black10,
      black25: black25 ?? this.black25,
      black50: black50 ?? this.black50,
      black100: black100 ?? this.black100,
      grey100_1: grey100_1 ?? this.grey100_1,
      white100_1: white100_1 ?? this.white100_1,
      white50_1: white50_1 ?? this.white50_1,
      white100_2: white100_2 ?? this.white100_2,
      white100_4: white100_4 ?? this.white100_4,
      blue100_1: blue100_1 ?? this.blue100_1,
      blue100_5: blue100_5 ?? this.blue100_5,
      blue100_2: blue100_2 ?? this.blue100_2,
      blue50_2: blue50_2 ?? this.blue50_2,
      blue10_2: blue10_2 ?? this.blue10_2,
      blue100_3: blue100_3 ?? this.blue100_3,
      blue100_4: blue100_4 ?? this.blue100_4,
      blue100_6: blue100_6 ?? this.blue100_6,
      blue100_7: blue100_7 ?? this.blue100_7,
      blue100_8: blue100_8 ?? this.blue100_8,
      yellow100_1: yellow100_1 ?? this.yellow100_1,
      yellow10_1: yellow10_1 ?? this.yellow10_1,
      red100_1: red100_1 ?? this.red100_1,
      red10_1: red10_1 ?? this.red10_1,
      green100_1: green100_1 ?? this.green100_1,
      green10_1: green10_1 ?? this.green10_1,
    );
  }

  @override
  ThemeExtension<CustomThemeExtension> lerp(
      covariant ThemeExtension<CustomThemeExtension>? other, double t) {
    if (other is! CustomThemeExtension) {
      return this;
    }

    return CustomThemeExtension(
      black10: Color.lerp(black10, other.black10, t)!,
      black25: Color.lerp(black25, other.black25, t)!,
      black50: Color.lerp(black50, other.black50, t)!,
      black100: Color.lerp(black100, other.black100, t)!,
      grey100_1: Color.lerp(grey100_1, other.grey100_1, t)!,
      white100_1: Color.lerp(white100_1, other.white100_1, t)!,
      white50_1: Color.lerp(white50_1, other.white50_1, t)!,
      white100_2: Color.lerp(white100_2, other.white100_2, t)!,
      white100_4: Color.lerp(white100_4, other.white100_4, t)!,
      blue100_1: Color.lerp(blue100_1, other.blue100_1, t)!,
      blue100_5: Color.lerp(blue100_5, other.blue100_5, t)!,
      blue100_2: Color.lerp(blue100_2, other.blue100_2, t)!,
      blue50_2: Color.lerp(blue50_2, other.blue50_2, t)!,
      blue10_2: Color.lerp(blue10_2, other.blue10_2, t)!,
      blue100_3: Color.lerp(blue100_3, other.blue100_3, t)!,
      blue100_4: Color.lerp(blue100_4, other.blue100_4, t)!,
      blue100_6: Color.lerp(blue100_6, other.blue100_6, t)!,
      blue100_7: Color.lerp(blue100_7, other.blue100_7, t)!,
      blue100_8: Color.lerp(blue100_8, other.blue100_8, t)!,
      yellow100_1: Color.lerp(yellow100_1, other.yellow100_1, t)!,
      yellow10_1: Color.lerp(yellow10_1, other.yellow10_1, t)!,
      red100_1: Color.lerp(red100_1, other.red100_1, t)!,
      red10_1: Color.lerp(red10_1, other.red10_1, t)!,
      green100_1: Color.lerp(green100_1, other.green100_1, t)!,
      green10_1: Color.lerp(green10_1, other.green10_1, t)!,
    );
  }
}
