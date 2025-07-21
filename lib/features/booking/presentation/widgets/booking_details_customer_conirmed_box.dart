import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/helper/custom_snack_bar.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/features/rent_history/data/cubit/rent_history_cubit.dart';
import 'package:aggar/features/rent_history/presentation/views/rent_history_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BookingDetailsCustomerConirmedBox extends StatelessWidget {
  const BookingDetailsCustomerConirmedBox({super.key, required this.isRenter});
  final bool isRenter;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: context.theme.green100_1.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: context.theme.green100_1),
          ),
          child: Column(
            children: [
              Icon(
                Icons.check_circle,
                color: context.theme.green100_1,
                size: 48,
              ),
              const SizedBox(height: 8),
              Text(
                'Booking Confirmed!',
                style: AppStyles.bold18(
                  context,
                ).copyWith(color: context.theme.green100_1),
              ),
              const SizedBox(height: 4),
              Text(
                'Your booking has been confirmed and payment processed successfully.',
                textAlign: TextAlign.center,
                style: AppStyles.medium14(
                  context,
                ).copyWith(color: context.theme.green100_1.withOpacity(0.8)),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () {
                    try {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BlocProvider.value(
                            value: context.read<RentalHistoryCubit>(),
                            child: RentHistoryView(isRenter: isRenter),
                          ),
                        ),
                      );
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        customSnackBar(
                          context,
                          "Error",
                          'Error navigating to rental history: $e',
                          SnackBarType.error,
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: context.theme.green100_1,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Row(
                    spacing: 8,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.history,
                        color: context.theme.white100_1,
                        size: 20,
                      ),
                      Text(
                        'View in Rental History',
                        style: AppStyles.semiBold16(
                          context,
                        ).copyWith(color: context.theme.white100_1),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Text(
          textAlign: TextAlign.center,
          'You can manage your rental (scan QR code, request refunds, etc.) from the Rental History section.',
          style: AppStyles.medium13(
            context,
          ).copyWith(color: context.theme.black50),
        ),
        const SizedBox(height: 12),
      ],
    );
  }
}
