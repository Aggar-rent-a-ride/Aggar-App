import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/features/payment/presentation/cubit/payment_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PlatformBalanceScreen extends StatefulWidget {
  const PlatformBalanceScreen({super.key});

  @override
  State<PlatformBalanceScreen> createState() => _PlatformBalanceScreenState();
}

class _PlatformBalanceScreenState extends State<PlatformBalanceScreen> {
  @override
  void initState() {
    super.initState();

    context.read<PaymentCubit>().getPlatformBalance(
        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIyMDgxIiwianRpIjoiNmIwOGU5OGMtNzU2OC00OWE2LWJkNDItMzk1MzEzMWZiZDc3IiwidXNlcm5hbWUiOiJCbHVlIiwidWlkIjoiMjA4MSIsInJvbGVzIjpbIkFkbWluIiwiVXNlciJdLCJleHAiOjE3NTAyNjI5NzMsImlzcyI6IkFnZ2FyQXBpIiwiYXVkIjoiRmx1dHRlciJ9.5HPKPquO9s8C_6f4UTsaXRQgPJ7GPlLQ_WGCNWUGPLU");
    context.read<PaymentCubit>().createConnectedAccount(
        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIyMDg3IiwianRpIjoiZWYyYjg1ZjEtMTllNS00YjI4LWE0MDItYWI5YTU3MTU1ZGJiIiwidXNlcm5hbWUiOiJSZW50ZXIzIiwidWlkIjoiMjA4NyIsInJvbGVzIjpbIlVzZXIiLCJSZW50ZXIiXSwiZXhwIjoxNzUwMjYzNDM2LCJpc3MiOiJBZ2dhckFwaSIsImF1ZCI6IkZsdXR0ZXIifQ.Tv-ttMISwiFvQKuXYGWEKafERTg1a51xz8fM5nYYgoo",
        "+18005551234",
        "000123456789",
        "110000000");
    context.read<PaymentCubit>().getRenterPayoutDetails(
        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIyMCIsImp0aSI6IjRmMjU5NGYxLWYzMTktNDMyMy1iMzEwLTY4MWNmNWJmZjUzMiIsInVzZXJuYW1lIjoiUmVudGVyIiwidWlkIjoiMjAiLCJyb2xlcyI6WyJVc2VyIiwiUmVudGVyIl0sImV4cCI6MTc1MDI2MTYxNywiaXNzIjoiQWdnYXJBcGkiLCJhdWQiOiJGbHV0dGVyIn0.CjS9-yMX4C2QBtlTwYaULJDjx7ZtpijoyRdjGtDHtbs");
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
              const Text("fff"),
            ],
          ),
        ),
      ),
      backgroundColor: context.theme.white100_1,
    );
  }
}
