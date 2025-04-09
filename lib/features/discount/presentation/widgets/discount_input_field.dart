import 'package:flutter/material.dart';

class DiscountInputField extends StatelessWidget {
  final String hintText;
  final String suffixText;
  final String? initialValue;
  final Function(String) onChanged;

  const DiscountInputField({
    super.key,
    required this.hintText,
    required this.suffixText,
    this.initialValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: TextEditingController(text: initialValue),
      keyboardType: TextInputType.number,
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 12,
        ),
        suffixText: suffixText,
      ),
    );
  }
}
