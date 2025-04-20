import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:flutter/material.dart';

class AddImageButton extends StatelessWidget {
  const AddImageButton({super.key, this.onPressed});

  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    const double buttonSize = 50;

    return Container(
      width: buttonSize,
      height: buttonSize,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: context.theme.black25,
            offset: const Offset(0, 0),
            blurRadius: 4,
          )
        ],
        shape: BoxShape.circle,
      ),
      child: ClipOval(
        child: MaterialButton(
          padding: EdgeInsets.zero,
          elevation: 0,
          color: context.theme.blue100_2,
          splashColor: context.theme.white50_1,
          highlightColor: context.theme.white50_1,
          shape: const CircleBorder(),
          onPressed: onPressed,
          child: Icon(
            Icons.add,
            size: MediaQuery.sizeOf(context).height * 0.03,
            color: context.theme.white100_1,
          ),
        ),
      ),
    );
  }
}
