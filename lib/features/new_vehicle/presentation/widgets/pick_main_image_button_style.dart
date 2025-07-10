import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:flutter/material.dart';

class PickMainImageButtonStyle extends StatelessWidget {
  const PickMainImageButtonStyle({
    super.key,
    required this.widget,
    this.onPressed,
  });
  final Widget widget;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.25,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
      ),
      child: ElevatedButton(
        style: ButtonStyle(
          elevation: WidgetStateProperty.all(0),
          overlayColor: WidgetStateProperty.all(
            context.theme.blue100_1.withOpacity(0.5),
          ),
          backgroundColor: WidgetStateProperty.all(
            context.theme.blue100_1.withOpacity(0.15),
          ),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
          ),
          padding: WidgetStateProperty.all(
            const EdgeInsets.symmetric(
              vertical: 10,
              horizontal: 25,
            ),
          ),
        ),
        onPressed: onPressed,
        child: widget,
      ),
    );
  }
}
