import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/features/main_screen/admin/presentation/views/search_screen.dart';
import 'package:flutter/material.dart';

class MainScreenSearchField extends StatelessWidget {
  final VoidCallback? onTap;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final FocusNode? focusNode;

  const MainScreenSearchField({
    super.key,
    this.onTap,
    this.controller,
    this.onChanged,
    this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.theme.white100_2,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        focusNode: focusNode,
        onTap: onTap == null
            ? () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return const UserSearchScreen();
                    },
                  ),
                );
              }
            : null,
        decoration: InputDecoration(
          hintText: "search",
          hintStyle: AppStyles.regular18(context).copyWith(
            color: context.theme.black100.withOpacity(0.5),
          ),
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          prefixIcon: Icon(
            Icons.search_rounded,
            color: context.theme.black100.withOpacity(0.5),
          ),
        ),
      ),
    );
  }
}
