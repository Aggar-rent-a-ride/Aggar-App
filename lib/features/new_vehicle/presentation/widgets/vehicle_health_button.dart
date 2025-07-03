import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:flutter/material.dart';

class VehicleHealthButton extends StatelessWidget {
  const VehicleHealthButton({
    super.key,
    required this.text,
    this.isSelected = false,
    required this.onPressed,
  });

  final String text;
  final bool isSelected;
  final Function(String) onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: MediaQuery.of(context).size.width * 0.39,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        boxShadow: const [
          BoxShadow(
            offset: Offset(0, 0),
            color: Colors.black12,
            blurRadius: 4,
          )
        ],
      ),
      child: ElevatedButton(
        style: ButtonStyle(
          elevation: const WidgetStatePropertyAll(0),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: BorderSide(
                color:
                    isSelected ? context.theme.blue100_1 : Colors.transparent,
                width: 1.5,
              ),
            ),
          ),
          padding: const WidgetStatePropertyAll(
            EdgeInsets.symmetric(horizontal: 0, vertical: 0),
          ),
          overlayColor: WidgetStatePropertyAll(
            context.theme.white50_1,
          ),
          backgroundColor: WidgetStatePropertyAll(
            isSelected ? context.theme.white100_1 : context.theme.blue100_1,
          ),
        ),
        onPressed: () => onPressed(text),
        child: Text(
          text,
          style: AppStyles.semiBold16(context).copyWith(
            color:
                isSelected ? context.theme.blue100_1 : context.theme.white100_1,
          ),
        ),
      ),
    );
  }
}
