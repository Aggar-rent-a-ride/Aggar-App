import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class TextWithTextFieldTypeAndBrand extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final FormFieldValidator<String>? validator;
  final String? initalValue;

  const TextWithTextFieldTypeAndBrand({
    super.key,
    required this.label,
    required this.controller,
    this.validator,
    this.initalValue,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppStyles.semiBold14(context).copyWith(
            color: context.theme.blue100_1,
          ),
        ),
        const Gap(10),
        FormField<String>(
          initialValue: initalValue,
          validator: validator ??
              (value) {
                if (value == null || value.trim().isEmpty) {
                  return "Please enter a $label";
                }
                return null;
              },
          builder: (field) {
            void onChanged(String value) {
              field.didChange(value);
              controller.text = value;
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: const [
                      BoxShadow(
                        blurRadius: 2,
                        color: Colors.black26,
                        offset: Offset(0, 0),
                      ),
                    ],
                    border: Border.all(
                      color: field.hasError ? Colors.red : Colors.transparent,
                      width: 1,
                    ),
                  ),
                  child: TextField(
                    controller: controller,
                    style: AppStyles.medium15(context).copyWith(
                      color: context.theme.black100,
                    ),
                    decoration: InputDecoration(
                      hintStyle: AppStyles.medium15(context).copyWith(
                        color: context.theme.black50,
                      ),
                      hintText: "Enter the $label",
                      filled: true,
                      fillColor: context.theme.white100_1,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                          color: Colors.transparent,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                          color: Colors.transparent,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                          color: Colors.transparent,
                        ),
                      ),
                    ),
                    onChanged: onChanged,
                  ),
                ),
                if (field.hasError) ...[
                  const Gap(4),
                  Text(
                    field.errorText!,
                    style: AppStyles.regular12(context).copyWith(
                      color: Colors.red,
                    ),
                  ),
                ],
              ],
            );
          },
        ),
      ],
    );
  }
}
