import 'package:aggar/core/utils/app_colors.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class AddVehicleScreen extends StatelessWidget {
  const AddVehicleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.myWhite100_1,
      appBar: AppBar(
        backgroundColor: AppColors.myWhite100_1,
        title: const Text('Add Vehicle'),
      ),
      body: const SingleChildScrollView(
        child: Column(
          children: [
            Column(
              children: [
                Text("Vehicle Name"),
                Row(
                  children: [
                    InputNameWithInputFieldSection(
                      hintText: "ex: Toyota",
                      label: "brand",
                    ),
                    Gap(10),
                    InputNameWithInputFieldSection(
                      hintText: "ex: model x",
                      label: "model",
                    ),
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class InputNameWithInputFieldSection extends StatelessWidget {
  const InputNameWithInputFieldSection({
    super.key,
    required this.label,
    required this.hintText,
  });
  final String label;
  final String hintText;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppStyles.medium18(context).copyWith(
            color: AppColors.myBlue100_1,
          ),
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.3,
          child: TextField(
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: AppStyles.medium15(context).copyWith(
                color: AppColors.myBlack50,
              ),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
              fillColor: AppColors.myWhite100_1,
              filled: true,
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
                borderSide: BorderSide(
                  color: AppColors.myBlack25,
                  width: 1,
                  style: BorderStyle.solid,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
                borderSide: BorderSide(
                  color: AppColors.myBlack25,
                  width: 1,
                  style: BorderStyle.solid,
                ),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
                borderSide: BorderSide(
                  color: AppColors.myBlack25,
                  width: 1,
                  style: BorderStyle.solid,
                ),
              ),
            ),
            style: AppStyles.medium15(context).copyWith(
              color: AppColors.myBlack100,
            ),
          ),
        )
      ],
    );
  }
}
