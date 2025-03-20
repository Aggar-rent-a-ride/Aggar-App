import 'package:aggar/core/themes/app_light_colors.dart';
import 'package:aggar/features/messages/views/personal_chat/presentation/widgets/image_and_name_person_message.dart';
import 'package:flutter/material.dart';

class AppBarPersonalMessageSection extends StatelessWidget {
  const AppBarPersonalMessageSection({
    super.key,
    required this.name,
  });

  final String name;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      child: Row(
        children: [
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_ios,
              color: AppLightColors.myWhite100_2,
            ),
          ),
          ImageAndNamePersonMessage(name: name),
          const Spacer(),
          IconButton(
            onPressed: () {},
            icon: Icon(
              color: AppLightColors.myWhite100_2,
              Icons.more_vert_outlined,
            ),
          )
        ],
      ),
    );
  }
}
