import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:flutter/material.dart';

class BottomNavigationBarContent extends StatelessWidget {
  const BottomNavigationBarContent({
    super.key,
    this.onPressed,
    required this.title,
    this.color,
  });
  final void Function()? onPressed;
  final String title;
  final Color? color;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.theme.white100_1,
        boxShadow: [
          BoxShadow(
            color: context.theme.black10,
            offset: const Offset(0, -1),
            blurRadius: 10,
          ),
        ],
      ),
      child: Padding(
        padding:
            const EdgeInsets.only(top: 15, right: 20, left: 20, bottom: 25),
        child: ElevatedButton(
          style: ButtonStyle(
            elevation: const WidgetStatePropertyAll(0),
            shape: WidgetStatePropertyAll(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            padding: const WidgetStatePropertyAll(
              EdgeInsets.symmetric(horizontal: 0, vertical: 20),
            ),
            overlayColor: WidgetStatePropertyAll(
              context.theme.white50_1,
            ),
            backgroundColor: WidgetStatePropertyAll(
              color ?? context.theme.blue100_2,
            ),
          ),
          onPressed: onPressed,
          child: Text(
            title,
            style: AppStyles.bold20(context).copyWith(
              color: context.theme.white100_1,
            ),
          ),
        ),
      ),
    );
  }
}
