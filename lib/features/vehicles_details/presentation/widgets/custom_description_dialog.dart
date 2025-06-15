// ignore_for_file: use_build_context_synchronously

import 'package:aggar/core/cubit/report/report_creation_cubit.dart';
import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CustomDescriptionDialog extends StatelessWidget {
  const CustomDescriptionDialog({
    super.key,
    required this.id,
    required this.token,
    required this.type,
  });

  final int id;
  final String token;
  final String type;

  @override
  Widget build(BuildContext context) {
    final TextEditingController reportController = TextEditingController();
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();

    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      backgroundColor: context.theme.white100_2,
      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 5),
      title: Text(
        'Create Report',
        style: AppStyles.semiBold24(context).copyWith(
          color: context.theme.black100,
        ),
      ),
      content: Form(
        key: formKey,
        child: SizedBox(
          width: 320,
          child: TextFormField(
            controller: reportController,
            maxLines: 4,
            decoration: InputDecoration(
              hintText: 'Enter report description',
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
              errorStyle: AppStyles.regular12(context).copyWith(
                color: context.theme.red100_1,
              ),
            ),
            style: AppStyles.regular16(context).copyWith(
              color: context.theme.black100,
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter a description';
              }
              return null;
            },
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(
            'Cancel',
            style: AppStyles.semiBold15(context).copyWith(
              color: context.theme.blue100_1,
            ),
          ),
        ),
        TextButton(
          onPressed: () async {
            if (formKey.currentState!.validate()) {
              final description = reportController.text.trim();
              final reportVehicle = context.read<ReportCreationCubit>();
              await reportVehicle.createReport(token, id, type, description);
              Navigator.pop(context);
            }
          },
          child: Text(
            'Submit',
            style: AppStyles.semiBold15(context).copyWith(
              color: context.theme.red100_1,
            ),
          ),
        ),
      ],
    );
  }
}
