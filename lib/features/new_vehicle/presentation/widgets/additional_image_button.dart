import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/utils/app_assets.dart';
import 'package:flutter/material.dart';

class AdditionalImageButton extends StatelessWidget {
  const AdditionalImageButton({
    super.key,
    this.onPressed,
  });
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 3,
        right: 10,
      ),
      child: Container(
        decoration:
            BoxDecoration(borderRadius: BorderRadius.circular(5), boxShadow: [
          BoxShadow(
            color: context.theme.black25,
            offset: const Offset(0, 0),
            blurRadius: 2,
          )
        ]),
        child: ElevatedButton(
          onPressed: onPressed,
          style: ButtonStyle(
            elevation: WidgetStateProperty.all(0),
            overlayColor: WidgetStateProperty.all(context.theme.blue50_2),
            backgroundColor: WidgetStateProperty.all(
              context.theme.blue10_2,
            ),
            shape: WidgetStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
            ),
            padding: WidgetStateProperty.all(
              const EdgeInsets.symmetric(
                vertical: 25,
                horizontal: 25,
              ),
            ),
          ),
          child: Image(
            image: const AssetImage(
              AppAssets.assetsIconsAdditionalImage,
            ),
            height: MediaQuery.sizeOf(context).height * 0.03,
          ),
        ),
      ),
    );
  }
}
