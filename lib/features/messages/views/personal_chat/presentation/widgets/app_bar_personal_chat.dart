import 'package:aggar/core/themes/app_colors.dart';
import 'package:aggar/features/messages/views/personal_chat/presentation/widgets/app_bar_personal_message_section.dart';
import 'package:flutter/material.dart';

class AppBarPersonalChat extends StatelessWidget {
  const AppBarPersonalChat({
    super.key,
    required this.name,
  });

  final String name;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.sizeOf(context).height * 0.13,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppLightColors.myBlue100_1,
        boxShadow: [
          BoxShadow(
            color: AppLightColors.myBlack10,
            blurRadius: 4,
            spreadRadius: 0,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Align(
        alignment: Alignment.bottomLeft,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: AppBarPersonalMessageSection(name: name),
        ),
      ),
    );
  }
}
