import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:flutter/material.dart';

import '../../../../core/utils/app_styles.dart';

class NameAndEmailSection extends StatelessWidget {
  const NameAndEmailSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Adele Adkins', style: AppStyles.bold20(context)),
        Text(
          'adeleissomeceleb@gmail.com',
          style: AppStyles.medium15(context).copyWith(
            color: context.theme.black50,
          ),
        ),
      ],
    );
  }
}
