import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/features/payment/presentation/cubit/payment_cubit.dart';
import 'package:aggar/features/payment/presentation/cubit/payment_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

import '../../../../core/cubit/refresh token/token_refresh_cubit.dart';

class PlatformBalanceScreen extends StatefulWidget {
  const PlatformBalanceScreen({super.key});

  @override
  State<PlatformBalanceScreen> createState() => _PlatformBalanceScreenState();
}

class _PlatformBalanceScreenState extends State<PlatformBalanceScreen> {
  @override
  void initState() {
    super.initState();
    fetchePlatformBalance();
  }

  Future<void> fetchePlatformBalance() async {
    final tokenCubit = context.read<TokenRefreshCubit>();
    final token = await tokenCubit.getAccessToken();
    if (token != null) {
      context.read<PaymentCubit>().getPlatformBalance(token);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
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
                    left: 25, right: 25, top: 65, bottom: 16),
                child: Row(
                  children: [
                    Text(
                      "Platform Balance",
                      style: AppStyles.bold20(context).copyWith(
                        color: context.theme.white100_1,
                      ),
                    ),
                    const Spacer(),
                  ],
                ),
              ),
              const PlatformBalanceBody(),
            ],
          ),
        ),
      ),
      backgroundColor: context.theme.white100_1,
    );
  }
}

class PlatformBalanceBody extends StatelessWidget {
  const PlatformBalanceBody({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PaymentCubit, PaymentState>(
      builder: (context, state) {
        if (state is PaymentLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is PaymentPlatformBalanceSuccess) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Account Balance"),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: context.theme.white100_2,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        offset: Offset(0, 0),
                        blurRadius: 4,
                      )
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Total Balance",
                        style: AppStyles.medium20(context).copyWith(
                          color: context.theme.black50,
                        ),
                      ),
                      Text(
                        r"$" "${state.balanceModel.totalBalance}",
                        style: AppStyles.bold36(context).copyWith(
                          color: context.theme.black100,
                        ),
                      ),
                      Text(state.balanceModel.currency)
                    ],
                  ),
                ),
                const Gap(10),
                const Text("Balance Details"),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: context.theme.white100_2,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        offset: Offset(0, 0),
                        blurRadius: 4,
                      )
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            height: 15,
                            width: 15,
                            decoration: BoxDecoration(
                              color: context.theme.green100_1,
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          const Column(
                            children: [
                              Text("Available Balance"),
                              Text(" available for use"),
                            ],
                          ),
                          const Spacer(),
                          Text(r"$" "${state.balanceModel.availableBalance}")
                        ],
                      )
                    ],
                  ),
                ),
                const Gap(10),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: context.theme.white100_2,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        offset: Offset(0, 0),
                        blurRadius: 4,
                      )
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            height: 15,
                            width: 15,
                            decoration: BoxDecoration(
                              color: context.theme.green100_1,
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          const Column(
                            children: [
                              Text("Pending Balance"),
                              Text("processing transactions"),
                            ],
                          ),
                          const Spacer(),
                          Text(r"$" "${state.balanceModel.pendingBalance}")
                        ],
                      )
                    ],
                  ),
                ),
                const Gap(10),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: context.theme.white100_2,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        offset: Offset(0, 0),
                        blurRadius: 4,
                      )
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            height: 15,
                            width: 15,
                            decoration: BoxDecoration(
                              color: context.theme.green100_1,
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          const Column(
                            children: [
                              Text("Connect Reserved"),
                              Text("reserved for connections"),
                            ],
                          ),
                          const Spacer(),
                          Text(r"$" "${state.balanceModel.connectReserved}")
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
          );
        } else {
          return const SizedBox();
        }
      },
    );
  }
}
