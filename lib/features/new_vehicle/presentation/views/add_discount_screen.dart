import 'package:aggar/core/themes/app_light_colors.dart';
import 'package:aggar/features/new_vehicle/presentation/widgets/bottom_navigation_bar_content.dart';
import 'package:flutter/material.dart';
import '../../../../core/utils/app_styles.dart';

class DiscountScreen extends StatefulWidget {
  const DiscountScreen({super.key});

  @override
  State<DiscountScreen> createState() => _DiscountScreenState();
}

class _DiscountScreenState extends State<DiscountScreen> {
  bool showDiscountList = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppLightColors.myWhite100_1,
      appBar: AppBar(
        elevation: 1,
        shadowColor: AppLightColors.myBlack50,
        centerTitle: false,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios,
            color: AppLightColors.myBlack100,
          ),
        ),
        backgroundColor: AppLightColors.myWhite100_1,
        title: Text(
          'Discounts',
          style: AppStyles.semiBold24(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            const Text(
              'Add Discount to this vehicle ?',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF2B3674),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: showDiscountList
                          ? Colors.white
                          : const Color(0xFF4A6FFF),
                      foregroundColor: showDiscountList
                          ? const Color(0xFF4A6FFF)
                          : Colors.white,
                      side: const BorderSide(
                        color: Color(0xFF4A6FFF),
                        width: 1,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text('Yes'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: showDiscountList
                          ? const Color(0xFF4A6FFF)
                          : Colors.white,
                      foregroundColor: showDiscountList
                          ? Colors.white
                          : const Color(0xFF4A6FFF),
                      side: const BorderSide(
                        color: Color(0xFF4A6FFF),
                        width: 1,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text('No'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBarContent(
        title: "Continue",
        onPressed: () {},
      ),
    );
  }
}
