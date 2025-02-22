import 'package:aggar/features/vehicles_details/presentation/views/properities_tab_bar/widgets/gallary_section.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class ProperitiesTabBarView extends StatelessWidget {
  const ProperitiesTabBarView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [GallarySection(), Gap(12)],
    );
  }
}
