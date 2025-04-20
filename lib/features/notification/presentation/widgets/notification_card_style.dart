import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:flutter/material.dart';

class NotificationCardStyle extends StatelessWidget {
  const NotificationCardStyle({
    super.key,
    required this.widget,
  });
  final Widget widget;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: context.theme.black10,
            width: 0.5,
          ),
          top: BorderSide(
            color: context.theme.black10,
            width: 0.5,
          ),
        ),
      ),
      child: ElevatedButton(
        style: ButtonStyle(
          overlayColor: WidgetStateProperty.all(context.theme.blue10_2),
          backgroundColor: WidgetStateProperty.all(
            Colors.transparent,
          ),
          elevation: WidgetStateProperty.all(0),
          shape: WidgetStateProperty.all(
            const RoundedRectangleBorder(
              borderRadius: BorderRadius.zero,
            ),
          ),
          padding: WidgetStateProperty.all(
            const EdgeInsets.symmetric(
              vertical: 10,
              horizontal: 25,
            ),
          ),
        ),
        onPressed: () {},
        child: widget,
      ),
    );
  }
}
