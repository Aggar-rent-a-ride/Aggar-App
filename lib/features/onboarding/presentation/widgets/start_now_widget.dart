import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/features/authorization/presentation/views/sign_in_view.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class StartNowWidget extends StatelessWidget {
  const StartNowWidget({
    super.key,
    required this.controller,
  });

  final PageController controller;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        padding: const WidgetStatePropertyAll(
          EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 5,
          ),
        ),
        foregroundColor: WidgetStatePropertyAll(
          context.theme.white100_1,
        ),
        backgroundColor: WidgetStatePropertyAll(
          context.theme.blue100_1,
        ),
      ),
      onPressed: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const SignInView(),
          ),
        );
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text("Start Now"),
          const Gap(8),
          Icon(
            Icons.arrow_forward_rounded,
            color: context.theme.white100_1,
            size: 15,
          ),
        ],
      ),
    );
  }
}
