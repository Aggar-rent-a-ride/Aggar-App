import 'dart:io';
import 'package:flutter/material.dart';
/*
class AdditionalImageCard extends StatelessWidget {
  const AdditionalImageCard({
    super.key,
    required this.image,
  });
  final File? image;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        boxShadow: [
          BoxShadow(
            color: AppLightColors.myBlack25,
            offset: const Offset(0, 0),
            blurRadius: 2,
          )
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(5),
        child: Image.file(
          image!,
          fit: BoxFit.cover,
          height: MediaQuery.sizeOf(context).height * 0.03 + 50,
          width: MediaQuery.sizeOf(context).height * 0.03 + 50,
        ),
      ),
    );
  }
}*/

class AdditionalImageCard extends StatelessWidget {
  final File image;
  final VoidCallback? onRemove;

  const AdditionalImageCard({
    super.key,
    required this.image,
    this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: 80,
          height: 80,
          margin: const EdgeInsets.only(right: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            image: DecorationImage(
              image: FileImage(image),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ],
    );
  }
}
