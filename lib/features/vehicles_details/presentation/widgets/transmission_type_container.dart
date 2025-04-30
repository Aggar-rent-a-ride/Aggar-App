import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:flutter/material.dart';

class TransmissionTypeContainer extends StatelessWidget {
  const TransmissionTypeContainer({
    super.key,
    required this.transmissionType,
  });

  final String transmissionType;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 12),
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            offset: Offset(0, 0),
            blurRadius: 4,
          ),
        ],
        color: context.theme.blue10_2,
      ),
      child: Text(
        transmissionType,
        style: AppStyles.semiBold14(context).copyWith(
          color: context.theme.blue100_2,
        ),
      ),
    );
  }
}
