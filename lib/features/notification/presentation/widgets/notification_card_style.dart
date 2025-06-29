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
      child: widget,
    );
  }
}
