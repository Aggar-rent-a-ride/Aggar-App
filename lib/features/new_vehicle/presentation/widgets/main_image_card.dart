import 'dart:io';
import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:flutter/material.dart';

class MainImageCard extends StatelessWidget {
  const MainImageCard({
    super.key,
    required this.image,
  });

  final File? image;

  @override
  Widget build(BuildContext context) {
    //TODO:make it clickable
    return Container(
      decoration:
          BoxDecoration(borderRadius: BorderRadius.circular(5), boxShadow: [
        BoxShadow(
          color: context.theme.black25,
          offset: const Offset(0, 0),
          blurRadius: 2,
        )
      ]),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(5),
        child: Image.file(
          image!,
          fit: BoxFit.cover,
          height: MediaQuery.of(context).size.height * 0.25,
          width: double.infinity,
        ),
      ),
    );
  }
}
