import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/features/main_screen/admin/model/user_model.dart';
import 'package:flutter/material.dart';

class DurationBanTextField extends StatelessWidget {
  const DurationBanTextField({
    super.key,
    required this.user,
    required this.durationController,
  });

  final UserModel user;
  final TextEditingController durationController;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      spacing: 5,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          "What a duration do you want to ban ${user.name}?",
          style: AppStyles.medium18(context).copyWith(
            color: context.theme.black100,
          ),
        ),
        SizedBox(
          width: 300,
          height: 40,
          child: TextField(
            controller: durationController,
            maxLines: 1,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              hintText: "Enter ban duration (in days)",
              hintStyle: AppStyles.regular14(context).copyWith(
                color: context.theme.black50,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
              ),
              errorBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: context.theme.red100_1,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(5),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: context.theme.blue100_1,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(5),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
