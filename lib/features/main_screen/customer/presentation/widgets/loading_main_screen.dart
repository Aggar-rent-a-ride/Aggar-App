import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/features/main_screen/customer/presentation/widgets/loading_main_screen_body.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class LoadingMainScreen extends StatelessWidget {
  const LoadingMainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.white100_1,
      body: Shimmer.fromColors(
        baseColor: context.theme.grey100_1,
        highlightColor: context.theme.white100_1,
        child: const LoadingMainScreenBody(),
      ),
    );
  }
}
