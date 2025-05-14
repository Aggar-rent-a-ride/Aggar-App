import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/features/rent_history/presentation/widgets/rent_history_body.dart';
import 'package:flutter/material.dart';

class RentHistoryView extends StatelessWidget {
  const RentHistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        shadowColor: Colors.grey[900],
        surfaceTintColor: Colors.transparent,
        centerTitle: false,
        backgroundColor: context.theme.white100_1,
        title: Text(
          'Rent History',
          style: AppStyles.semiBold24(context)
              .copyWith(color: context.theme.black100),
        ),
    
      ),
      backgroundColor: context.theme.white100_1,
      body: const RentHistoryBody(),
    );
  }
}
