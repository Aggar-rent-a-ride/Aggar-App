import 'package:aggar/core/helper/get_font_size.dart';
import 'package:flutter/material.dart';

class AppStyles {
  // Light font weight
  static const light = TextStyle(
    fontFamily: 'Beiruti',
    fontWeight: FontWeight.w300,
  );
  // Regular font weight
  static const regular = TextStyle(
    fontFamily: 'Beiruti',
    fontWeight: FontWeight.w400,
  );

  // Medium font weight
  static const medium = TextStyle(
    fontFamily: 'Beiruti',
    fontWeight: FontWeight.w500,
  );

  // Bold font weight
  static const bold = TextStyle(
    fontFamily: 'Beiruti',
    fontWeight: FontWeight.w700,
  );

  // Extra bold font weight
  static const extraBold = TextStyle(
    fontFamily: 'Beiruti',
    fontWeight: FontWeight.w800,
  );

  // Black font weight
  static const black = TextStyle(
    fontFamily: 'Beiruti',
    fontWeight: FontWeight.w900,
  );

  // Regular styles with dynamic font sizes
  static TextStyle regular9(BuildContext context) => regular.copyWith(
        fontSize: getFontSize(context, 9),
        color: const Color(0xFFFFFFFF),
      );
}
