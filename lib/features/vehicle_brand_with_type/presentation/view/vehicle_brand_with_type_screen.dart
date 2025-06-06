import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class VehicleBrandWithTypeScreen extends StatelessWidget {
  const VehicleBrandWithTypeScreen({super.key});
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
          'Vehilce Settings',
          style: AppStyles.semiBold24(context).copyWith(
            color: context.theme.black100,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () async {},
            icon: Icon(
              Icons.search,
              color: context.theme.black50,
            ),
          ),
          const Gap(20),
        ],
      ),
      backgroundColor: context.theme.white100_1,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select a Vehicle Brand',
              style: AppStyles.medium16(context).copyWith(
                color: context.theme.black100,
              ),
            ),
            const Gap(16),
            const Wrap(
              spacing: 10, // Horizontal spacing between items
              runSpacing: 10, // Vertical spacing between lines
            ),
          ],
        ),
      ),
    );
  }
}
