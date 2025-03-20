import 'package:aggar/core/themes/app_light_colors.dart';
import 'package:aggar/features/vehicles_details/presentation/widgets/bottom_navigation_bar_rental_price.dart';
import 'package:aggar/features/vehicles_details/presentation/widgets/bottom_navigation_bar_book_button.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class BottomNavigationBarSection extends StatelessWidget {
  const BottomNavigationBarSection({
    super.key,
    required this.price,
    required this.onPressed,
  });
  final double price;
  final void Function()? onPressed;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppLightColors.myWhite100_1,
        boxShadow: [
          BoxShadow(
            color: AppLightColors.myBlack10,
            offset: const Offset(0, -1),
            blurRadius: 10,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        child: Row(
          children: [
            BottomNavigationBarRentalPrice(price: price),
            const Gap(15),
            BottomNavigationBarBookButton(onPressed: onPressed),
          ],
        ),
      ),
    );
  }
}
