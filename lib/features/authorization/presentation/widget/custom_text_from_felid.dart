import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:flutter/material.dart';
import 'package:aggar/core/utils/app_styles.dart';

class CustomTextField extends StatefulWidget {
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
    this.maxLines = 1,
    this.onTap,
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
  final int maxLines;
  final VoidCallback? onTap;

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  void initState() {
    super.initState();
    if (widget.controller != null) {
      widget.controller!.addListener(_syncController);
    }
  }

  @override
  void dispose() {
    if (widget.controller != null) {
      widget.controller!.removeListener(_syncController);
    }
    super.dispose();
  }

  void _syncController() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return FormField<String>(
      initialValue: widget.initialValue,
      validator: (value) =>
          widget.validator?.call(widget.controller?.text ?? value),
      autovalidateMode: AutovalidateMode.disabled,
      builder: (FormFieldState<String> state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(
                widget.labelText,
                style: AppStyles.medium20(context).copyWith(
                  color: context.theme.black100,
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 2,
                    offset: Offset(0, 0),
                  ),
                ],
              ),
              child: TextField(
                style: AppStyles.regular16(context).copyWith(
                  color: context.theme.black100,
                ),
                textAlign: TextAlign.start,
                keyboardType: widget.inputType,
                maxLines: widget.obscureText ? 1 : widget.maxLines,
                onTap: widget.onTap,
                onChanged: (value) {
                  if (state.mounted) {
                    state.didChange(value);
                  }
                  widget.onChanged?.call(value);
                },
                obscureText: widget.obscureText,
                controller: widget.controller,
                decoration: InputDecoration(
                  hintText: widget.hintText,
                  hintStyle: AppStyles.regular16(context).copyWith(
                    color: context.theme.black50,
                  ),
                  filled: true,
                  fillColor: context.theme.black10,
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 19,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide: state.hasError
                        ? BorderSide(
                            color: context.theme.red100_1,
                            width: 1.5,
                          )
                        : BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide: state.hasError
                        ? BorderSide(
                            color: context.theme.red100_1,
                            width: 2.0,
                          )
                        : BorderSide.none,
                  ),
                  suffixIcon: widget.suffixIcon != null
                      ? IconButton(
                          color: context.theme.black50,
                          icon: widget.suffixIcon!,
                          onPressed: widget.onSuffixIconPressed,
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
                    color: context.theme.red100_1,
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            const SizedBox(height: 8),
          ],
        );
      },
    );
  }
}
