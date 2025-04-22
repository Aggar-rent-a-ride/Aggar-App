import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:flutter/material.dart';
import 'package:aggar/core/utils/app_styles.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    required this.labelText,
    this.hintText,
    this.initialValue,
    this.validator,
    this.onChanged,
    this.controller,
    required this.inputType,
    this.suffixIcon,
    required this.obscureText,
    this.onSuffixIconPressed,
  });

  final String labelText;
  final String? hintText;
  final String? initialValue;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final TextEditingController? controller;
  final TextInputType inputType;
  final Widget? suffixIcon;
  final bool obscureText;
  final VoidCallback? onSuffixIconPressed;

  @override
  Widget build(BuildContext context) {
    return FormField<String>(
      initialValue: initialValue ?? controller?.text,
      validator: validator,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      builder: (FormFieldState<String> state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(
                labelText,
                style: AppStyles.medium20(context).copyWith(
                  color: context.theme.black100,
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 4,
                    offset: Offset(4, 4),
                  ),
                ],
              ),
              child: TextFormField(
                style: AppStyles.regular16(context).copyWith(
                  color: context.theme.black100,
                ),
                textAlign: TextAlign.start,
                keyboardType: inputType,
                initialValue: initialValue,
                onChanged: (value) {
                  state.didChange(value);
                  onChanged?.call(value);
                },
                obscureText: obscureText,
                controller: controller,
                decoration: InputDecoration(
                  hintText: hintText,
                  hintStyle: AppStyles.regular16(context).copyWith(
                    color: context.theme.black50,
                  ),
                  filled: true,
                  fillColor: context.theme.gray100_1,
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 14,
                    horizontal: 19,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide.none,
                  ),
                  errorStyle:
                      const TextStyle(height: 0, color: Colors.transparent),
                  suffixIcon: suffixIcon != null
                      ? IconButton(
                          icon: suffixIcon!,
                          onPressed: onSuffixIconPressed,
                        )
                      : null,
                ),
              ),
            ),
            if (state.hasError)
              Padding(
                padding: const EdgeInsets.only(top: 6, left: 4),
                child: Text(
                  state.errorText!,
                  style: TextStyle(
                    color: context.theme.red10_1,
                    fontSize: 12,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
