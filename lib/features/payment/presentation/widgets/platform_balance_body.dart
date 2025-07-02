import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/features/payment/presentation/cubit/payment_cubit.dart';
import 'package:aggar/features/payment/presentation/cubit/payment_state.dart';
import 'package:aggar/features/payment/presentation/views/payment_error_screen.dart';
import 'package:aggar/features/payment/presentation/widgets/LoadingPlatformBalance.dart';
import 'package:aggar/features/payment/presentation/widgets/account_balance_section.dart';
import 'package:aggar/features/payment/presentation/widgets/balance_details_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

class PlatformBalanceBody extends StatelessWidget {
  const PlatformBalanceBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PaymentCubit, PaymentState>(
      builder: (context, state) {
        if (state is PaymentPlatformBalanceSuccess) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AccountBalanceSection(state: state),
                const Gap(20),
                BalanceDetailsSection(state: state),
              ],
            ),
          );
        } else if (state is PaymentLoading) {
          return const ShimmerLoading();
        } else if (state is PaymentError) {
          return const PaymentErrorScreen();
        }
        return Center(
          child: Text(
            "No balance data available",
            style: AppStyles.medium18(context).copyWith(
              color: context.theme.black50,
            ),
          ),
        );
      },
    );
  }
}
