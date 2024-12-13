import 'package:aggar/core/utils/app_colors.dart';
import 'package:flutter/material.dart';

class PickImage extends StatelessWidget {
  const PickImage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.myWhite100_1,
      body: const Padding(
        padding: EdgeInsets.all(25.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Text("Pick an image:"),],
        ),
      ),
    );
  }
}
