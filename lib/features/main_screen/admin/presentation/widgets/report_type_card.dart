import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/features/main_screen/admin/presentation/widgets/line_colored.dart';
import 'package:aggar/features/main_screen/admin/presentation/widgets/report_type_card_content.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class ReportTypeCard extends StatelessWidget {
  const ReportTypeCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        color: context.theme.white100_2,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, 0),
          ),
        ],
      ),
      child: const IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            LineColored(),
            Gap(10),
            ReportTypeCardContent(),
          ],
        ),
      ),
    );
  }
}
