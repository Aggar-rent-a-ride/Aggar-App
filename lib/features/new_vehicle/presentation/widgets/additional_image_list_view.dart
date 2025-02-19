import 'package:aggar/features/new_vehicle/presentation/widgets/add_image_button.dart';
import 'package:aggar/features/new_vehicle/presentation/widgets/additional_image_button.dart';
import 'package:flutter/material.dart';

class AdditionalImageListView extends StatelessWidget {
  const AdditionalImageListView({
    super.key,
    required this.len,
  });

  final int len;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 90,
      width: double.infinity,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: len,
        itemBuilder: (context, index) => Row(
          children: [
            const AdditionalImageButton(),
            index == len - 1 ? const AddImageButton() : const SizedBox(),
          ],
        ),
      ),
    );
  }
}
