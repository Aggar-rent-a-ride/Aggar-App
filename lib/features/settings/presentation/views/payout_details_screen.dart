import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/features/payment/presentation/cubit/payment_cubit.dart';
import 'package:aggar/features/payment/presentation/cubit/payment_state.dart';
import 'package:aggar/features/settings/presentation/views/loading_renter_payout.dart';
import 'package:aggar/features/settings/presentation/widgets/payment_details_balance_overview_card.dart';
import 'package:aggar/features/settings/presentation/widgets/payout_details_header_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

class PayoutDetailsScreen extends StatelessWidget {
  const PayoutDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.white100_1,
      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const PayoutDetailsHeaderSection(),
            Padding(
              padding: const EdgeInsets.all(20),
              child: BlocBuilder<PaymentCubit, PaymentState>(
                builder: (context, state) {
                  if (state is PaymentLoading) {
                    return const LoadingRenterPayout();
                  } else if (state is PaymentRenterPayoutDetialsSuccess) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        PaymentDetailsBalanceOverviewCard(
                          currentAmount: state
                              .renterPayoutDetialsModel.currentAmount
                              .toDouble(),
                          totalBalance: state
                              .renterPayoutDetialsModel.totalBalance
                              .toDouble(),
                          upcomingAmount: state
                              .renterPayoutDetialsModel.upcomingAmount
                              .toDouble(),
                        ),
                        const Gap(25),
                        Text(
                          "Bank Account Details",
                          style: AppStyles.bold18(context).copyWith(
                            color: context.theme.black100,
                          ),
                        ),
                        const Gap(15),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: context.theme.white100_1,
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(
                              color: context.theme.black50.withOpacity(0.3),
                            ),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 4,
                                offset: Offset(0, 0),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: context.theme.blue100_8
                                          .withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Icon(
                                      Icons.account_balance,
                                      color: context.theme.blue100_8,
                                      size: 24,
                                    ),
                                  ),
                                  const Gap(15),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Bank Account",
                                        style:
                                            AppStyles.bold16(context).copyWith(
                                          color: context.theme.black100,
                                        ),
                                      ),
                                      const Gap(3),
                                      Text(
                                        "******${state.renterPayoutDetialsModel.last4}",
                                        style: AppStyles.medium14(context)
                                            .copyWith(
                                          color: context.theme.black50,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const Gap(20),
                              _buildDetailRow(context, "Account Number",
                                  "******${state.renterPayoutDetialsModel.last4}"),
                              const Gap(12),
                              _buildDetailRow(
                                context,
                                "Routing Number",
                                state.renterPayoutDetialsModel.routingNumber,
                              ),
                              const Gap(12),
                              _buildDetailRow(
                                context,
                                "Currency",
                                state.renterPayoutDetialsModel.currency
                                    .toUpperCase(),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  } else {
                    return const SizedBox();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(BuildContext context, String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppStyles.medium14(context).copyWith(
            color: context.theme.black50,
          ),
        ),
        Text(
          value,
          style: AppStyles.medium14(context).copyWith(
            color: context.theme.black100,
          ),
        ),
      ],
    );
  }
}
