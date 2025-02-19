import 'package:aggar/core/helper/get_font_size.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppStyles {
  // Regular font weight
  static final regular = GoogleFonts.harmattan(
    fontWeight: FontWeight.w400,
  );

  // Medium font weight
  static final medium = GoogleFonts.harmattan(
    fontWeight: FontWeight.w500,
  );

  // SemiBold font weight
  static final semiBold = GoogleFonts.harmattan(
    fontWeight: FontWeight.w600,
  );

  // Bold font weight
  static final bold = GoogleFonts.harmattan(
    fontWeight: FontWeight.w700,
  );

  //////////////////////////////////
  ////////////////////////////////////////
  // Regular styles with dynamic font sizes
  // TextStyle for font size 36
  static TextStyle regular36(BuildContext context) => regular.copyWith(
        fontSize: getFontSize(context, 36),
        color: const Color(0xFF000000),
      );

// TextStyle for font size 24
  static TextStyle regular24(BuildContext context) => regular.copyWith(
        fontSize: getFontSize(context, 24),
        color: const Color(0xFF000000),
      );

// TextStyle for font size 28
  static TextStyle regular28(BuildContext context) => regular.copyWith(
        fontSize: getFontSize(context, 28),
        color: const Color(0xFF000000),
      );

// TextStyle for font size 20
  static TextStyle regular20(BuildContext context) => regular.copyWith(
        fontSize: getFontSize(context, 20),
        color: const Color(0xFF000000),
      );

// TextStyle for font size 18
  static TextStyle regular18(BuildContext context) => regular.copyWith(
        fontSize: getFontSize(context, 18),
        color: const Color(0xFF000000),
      );

// TextStyle for font size 16
  static TextStyle regular16(BuildContext context) => regular.copyWith(
        fontSize: getFontSize(context, 16),
        color: const Color(0xFF000000),
      );

// TextStyle for font size 15
  static TextStyle regular15(BuildContext context) => regular.copyWith(
        fontSize: getFontSize(context, 15),
        color: const Color(0xFF000000),
      );

// TextStyle for font size 14
  static TextStyle regular14(BuildContext context) => regular.copyWith(
        fontSize: getFontSize(context, 14),
        color: const Color(0xFF000000),
      );

// TextStyle for font size 12
  static TextStyle regular12(BuildContext context) => regular.copyWith(
        fontSize: getFontSize(context, 12),
        color: const Color(0xFF000000),
      );

// TextStyle for font size 10
  static TextStyle regular10(BuildContext context) => regular.copyWith(
        fontSize: getFontSize(context, 10),
        color: const Color(0xFF000000),
      );

///////////////////////////////////////////////
///////////////////////////////////////////////
  // Medium styles with dynamic font sizes
  // TextStyle for font size 36
  static TextStyle medium36(BuildContext context) => medium.copyWith(
        fontSize: getFontSize(context, 36),
        color: const Color(0xFF000000),
      );

// TextStyle for font size 24
  static TextStyle medium24(BuildContext context) => medium.copyWith(
        fontSize: getFontSize(context, 24),
        color: const Color(0xFF000000),
      );

// TextStyle for font size 28
  static TextStyle medium28(BuildContext context) => medium.copyWith(
        fontSize: getFontSize(context, 28),
        color: const Color(0xFF000000),
      );

// TextStyle for font size 20
  static TextStyle medium20(BuildContext context) => medium.copyWith(
        fontSize: getFontSize(context, 20),
        color: const Color(0xFF000000),
      );

// TextStyle for font size 18
  static TextStyle medium18(BuildContext context) => medium.copyWith(
        fontSize: getFontSize(context, 18),
        color: const Color(0xFF000000),
      );

// TextStyle for font size 16
  static TextStyle medium16(BuildContext context) => medium.copyWith(
        fontSize: getFontSize(context, 16),
        color: const Color(0xFF000000),
      );

// TextStyle for font size 15
  static TextStyle medium15(BuildContext context) => medium.copyWith(
        fontSize: getFontSize(context, 15),
        color: const Color(0xFF000000),
      );

// TextStyle for font size 14
  static TextStyle medium14(BuildContext context) => medium.copyWith(
        fontSize: getFontSize(context, 14),
        color: const Color(0xFF000000),
      );

// TextStyle for font size 12
  static TextStyle medium12(BuildContext context) => medium.copyWith(
        fontSize: getFontSize(context, 12),
        color: const Color(0xFF000000),
      );

// TextStyle for font size 10
  static TextStyle medium10(BuildContext context) => medium.copyWith(
        fontSize: getFontSize(context, 10),
        color: const Color(0xFF000000),
      );

  //////////////////////////////////////////////////
  //////////////////////////////////////////////
  // SemiBold styles with dynamic font sizes
  // TextStyle for font size 36
  static TextStyle semiBold36(BuildContext context) => semiBold.copyWith(
        fontSize: getFontSize(context, 36),
        color: const Color(0xFF000000),
      );

// TextStyle for font size 24
  static TextStyle semiBold24(BuildContext context) => semiBold.copyWith(
        fontSize: getFontSize(context, 24),
        color: const Color(0xFF000000),
      );

// TextStyle for font size 28
  static TextStyle semiBold28(BuildContext context) => semiBold.copyWith(
        fontSize: getFontSize(context, 28),
        color: const Color(0xFF000000),
      );

// TextStyle for font size 20
  static TextStyle semiBold20(BuildContext context) => semiBold.copyWith(
        fontSize: getFontSize(context, 20),
        color: const Color(0xFF000000),
      );

// TextStyle for font size 18
  static TextStyle semiBold18(BuildContext context) => semiBold.copyWith(
        fontSize: getFontSize(context, 18),
        color: const Color(0xFF000000),
      );

// TextStyle for font size 16
  static TextStyle semiBold16(BuildContext context) => semiBold.copyWith(
        fontSize: getFontSize(context, 16),
        color: const Color(0xFF000000),
      );

// TextStyle for font size 15
  static TextStyle semiBold15(BuildContext context) => semiBold.copyWith(
        fontSize: getFontSize(context, 15),
        color: const Color(0xFF000000),
      );

// TextStyle for font size 14
  static TextStyle semiBold14(BuildContext context) => semiBold.copyWith(
        fontSize: getFontSize(context, 14),
        color: const Color(0xFF000000),
      );

// TextStyle for font size 12
  static TextStyle semiBold12(BuildContext context) => semiBold.copyWith(
        fontSize: getFontSize(context, 12),
        color: const Color(0xFF000000),
      );

// TextStyle for font size 10
  static TextStyle semiBold10(BuildContext context) => semiBold.copyWith(
        fontSize: getFontSize(context, 10),
        color: const Color(0xFF000000),
      );

///////////////////////////////////////////
////////////////////////////////////////////
// Bold styles with dynamic font sizes
// TextStyle for font size 36
  static TextStyle bold36(BuildContext context) => bold.copyWith(
        fontSize: getFontSize(context, 36),
        color: const Color(0xFF000000),
      );

// TextStyle for font size 24
  static TextStyle bold24(BuildContext context) => bold.copyWith(
        fontSize: getFontSize(context, 24),
        color: const Color(0xFF000000),
      );

// TextStyle for font size 28
  static TextStyle bold28(BuildContext context) => bold.copyWith(
        fontSize: getFontSize(context, 28),
        color: const Color(0xFF000000),
      );
// TextStyle for font size 22
  static TextStyle bold22(BuildContext context) => bold.copyWith(
        fontSize: getFontSize(context, 22),
        color: const Color(0xFF000000),
      );

// TextStyle for font size 20
  static TextStyle bold20(BuildContext context) => bold.copyWith(
        fontSize: getFontSize(context, 20),
        color: const Color(0xFF000000),
      );

// TextStyle for font size 18
  static TextStyle bold18(BuildContext context) => bold.copyWith(
        fontSize: getFontSize(context, 18),
        color: const Color(0xFF000000),
      );

// TextStyle for font size 16
  static TextStyle bold16(BuildContext context) => bold.copyWith(
        fontSize: getFontSize(context, 16),
        color: const Color(0xFF000000),
      );

// TextStyle for font size 15
  static TextStyle bold15(BuildContext context) => bold.copyWith(
        fontSize: getFontSize(context, 15),
        color: const Color(0xFF000000),
      );

// TextStyle for font size 14
  static TextStyle bold14(BuildContext context) => bold.copyWith(
        fontSize: getFontSize(context, 14),
        color: const Color(0xFF000000),
      );

// TextStyle for font size 12
  static TextStyle bold12(BuildContext context) => bold.copyWith(
        fontSize: getFontSize(context, 12),
        color: const Color(0xFF000000),
      );

// TextStyle for font size 10
  static TextStyle bold10(BuildContext context) => bold.copyWith(
        fontSize: getFontSize(context, 10),
        color: const Color(0xFF000000),
      );
  //////////////////////////////////////////////////
}
