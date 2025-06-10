import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class TextWithTextFieldTypeAndBrand extends StatefulWidget {
  final String label;
  final TextEditingController? controller;
  final String? Function(String?)? validator;

  const TextWithTextFieldTypeAndBrand({
    super.key,
    required this.label,
    this.controller,
    this.validator,
  });

  @override
  _TextWithTextFieldTypeAndBrandState createState() =>
      _TextWithTextFieldTypeAndBrandState();
}

class _TextWithTextFieldTypeAndBrandState
    extends State<TextWithTextFieldTypeAndBrand> {
  String? _errorText;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: AppStyles.semiBold14(context).copyWith(
            color: context.theme.blue100_1,
          ),
        ),
        const Gap(10),
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
              color: _errorText != null ? Colors.red : Colors.transparent,
              width: 1,
            ),
          ),
          child: TextField(
            controller: widget.controller,
            style: AppStyles.medium15(context).copyWith(
              color: context.theme.black100,
            ),
            decoration: InputDecoration(
              hintStyle: AppStyles.medium15(context).copyWith(
                color: context.theme.black50,
              ),
              hintText: "Enter the ${widget.label}",
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
            onChanged: (value) {
              if (widget.validator != null) {
                setState(() {
                  _errorText = widget.validator!(value);
                });
              }
            },
          ),
        ),
        if (_errorText != null) ...[
          const Gap(4),
          Text(
            _errorText!,
            style: AppStyles.regular12(context).copyWith(
              color: Colors.red,
            ),
          ),
        ],
      ],
    );
  }
}
