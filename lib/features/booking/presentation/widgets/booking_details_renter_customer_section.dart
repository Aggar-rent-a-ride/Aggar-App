import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/helper/custom_snack_bar.dart';
import 'package:aggar/core/utils/app_assets.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/features/rent_history/data/cubit/rent_history_cubit.dart';
import 'package:aggar/features/rent_history/presentation/views/rent_history_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BookingDetailsRenterCustomerSection extends StatelessWidget {
  final int customerId;
  final String customerName;
  final String? customerImage;
  final VoidCallback? onProfileTap;
  final VoidCallback? onChat;

  const BookingDetailsRenterCustomerSection({
    super.key,
    required this.customerId,
    required this.customerName,
    this.customerImage,
    this.onProfileTap,
    this.onChat,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Customer',
            style: AppStyles.bold18(context).copyWith(color: theme.black100),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Row(
              children: [
                GestureDetector(
                  onTap: onProfileTap,
                  child: Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: theme.grey100_1,
                          boxShadow: const [
                            BoxShadow(
                              offset: Offset(0, 0),
                              color: Colors.black12,
                              spreadRadius: 0,
                              blurRadius: 4,
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: const BorderRadius.all(
                            Radius.circular(50),
                          ),
                          child: customerImage == null
                              ? Image.asset(
                                  AppAssets.assetsImagesDefaultPfp0,
                                  height: 45,
                                  color: theme.black50,
                                )
                              : Image.network(customerImage!, height: 45),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              customerName,
                              style: AppStyles.bold16(
                                context,
                              ).copyWith(color: theme.blue100_2),
                            ),
                            Text(
                              'Order this car',
                              style: AppStyles.semiBold14(
                                context,
                              ).copyWith(color: theme.black50),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: onChat,
                  child: Container(
                    height: 40,
                    width: 40,
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: theme.white100_2,
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          offset: Offset(0, 0),
                          spreadRadius: 0,
                          blurRadius: 4,
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.chat_bubble_outline,
                      size: 25,
                      color: theme.blue100_1,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class BookingDetailsRenterConfirmedBox extends StatelessWidget {
  const BookingDetailsRenterConfirmedBox({super.key, required this.isRenter});
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
                'This booking has been confirmed and added to your rental history.',
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
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.history,
                        color: context.theme.white100_1,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
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
          'You can manage this rental from the Rental History section.',
          style: AppStyles.medium13(
            context,
          ).copyWith(color: context.theme.black50),
        ),
        const SizedBox(height: 12),
      ],
    );
  }
}
