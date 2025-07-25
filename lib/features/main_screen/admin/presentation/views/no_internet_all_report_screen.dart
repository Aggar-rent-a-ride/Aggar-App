import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/features/main_screen/admin/presentation/widgets/filter_button.dart';
import 'package:flutter/material.dart';

class NoInternetAllReportScreen extends StatelessWidget {
  const NoInternetAllReportScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.white100_1,
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                color: context.theme.blue100_8,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              padding: const EdgeInsets.only(
                  left: 16, right: 16, top: 55, bottom: 12),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: context.theme.white100_1,
                      size: 20,
                    ),
                  ),
                  Text(
                    "All Reports",
                    style: AppStyles.bold20(context).copyWith(
                      color: context.theme.white100_1,
                    ),
                  ),
                  const Spacer(),
                  const FilterButton(
                    accessToken: '',
                  ),
                ],
              ),
            ),
            Center(
              child: Text(
                "No Internet Connection",
                style: AppStyles.semiBold18(context).copyWith(
                  color: context.theme.black100,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
