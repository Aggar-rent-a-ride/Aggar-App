import 'dart:io';
import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/widgets/custom_dialog.dart';
import 'package:aggar/core/widgets/full_screen_photo_view.dart';
import 'package:flutter/material.dart';

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
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FullScreenPhotoView(
              image: image,
              onRemove: onRemove,
            ),
          ),
        );
      },
      onLongPress: onRemove != null
          ? () => showDialog(
                context: context,
                builder: (context) => CustomDialog(
                  title: "Remove Image",
                  actionTitle: "Remove",
                  subtitle: 'Are you sure you want to remove this image?',
                  onPressed: () {
                    Navigator.pop(context);
                    onRemove?.call();
                  },
                ),
              )
          : null,
      child: Container(
        margin: const EdgeInsets.only(right: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          boxShadow: [
            BoxShadow(
              color: context.theme.black25,
              offset: const Offset(0, 0),
              blurRadius: 2,
            )
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(5),
          child: Image.file(
            image,
            fit: BoxFit.cover,
            height: MediaQuery.sizeOf(context).height * 0.03 + 50,
            width: MediaQuery.sizeOf(context).height * 0.03 + 50,
          ),
        ),
      ),
    );
  }
}
