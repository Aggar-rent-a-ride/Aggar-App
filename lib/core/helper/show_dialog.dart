import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/features/main_screen/customer/presentation/cubit/main_screen/main_screen_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void showNoNetworkDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        backgroundColor: context.theme.white100_2,
        title: Text(
          'No Internet Connection',
          style: AppStyles.semiBold24(context).copyWith(
            color: context.theme.black100,
          ),
        ),
        content: Text(
          'Please check your internet connection and try again.',
          style: AppStyles.medium18(context).copyWith(
            color: context.theme.black50,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.read<MainCubit>().checkInternetConnection();
            },
            child: Text(
              'Retry',
              style: AppStyles.bold15(context).copyWith(
                color: context.theme.blue100_1,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              SystemNavigator.pop();
            },
            child: Text(
              "Exit",
              style: AppStyles.semiBold15(context).copyWith(
                color: context.theme.red100_1,
              ),
            ),
          ),
        ],
      );
    },
  );
}
