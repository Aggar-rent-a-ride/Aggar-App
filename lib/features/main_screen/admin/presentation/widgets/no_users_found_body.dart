import 'package:aggar/core/utils/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class NoUsersFoundBody extends StatelessWidget {
  const NoUsersFoundBody({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.search_off, size: 100, color: Colors.grey),
          const Gap(16),
          Text(
            'No users found',
            style: AppStyles.medium16(context).copyWith(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
