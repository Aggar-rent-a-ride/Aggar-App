import 'package:aggar/features/main_screen/admin/presentation/widgets/main_screen_search_field.dart';
import 'package:flutter/material.dart';

class MainScreenSearchFieldWithFilterIcon extends StatelessWidget {
  const MainScreenSearchFieldWithFilterIcon({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Expanded(
          child: MainScreenSearchField(),
        ),
      ],
    );
  }
}
