import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/features/payment/presentation/widgets/platform_balance_body.dart';
import 'package:aggar/features/payment/presentation/widgets/platform_balance_header.dart';
import 'package:flutter/material.dart';

class PlatformBalanceScreen extends StatelessWidget {
  const PlatformBalanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.white100_1,
      body: const SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PlatformBalanceHeader(),
            PlatformBalanceBody(),
          ],
        ),
      ),
    );
  }
}
