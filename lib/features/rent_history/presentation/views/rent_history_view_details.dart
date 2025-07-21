import 'package:aggar/core/api/end_points.dart';
import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/helper/custom_snack_bar.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/features/rent_history/data/models/rental_history_models.dart';
import 'package:aggar/features/rent_history/presentation/views/scanner_qr_code_page.dart';
import 'package:aggar/features/rent_history/presentation/views/create_review_screen.dart';
import 'package:aggar/features/rent_history/data/cubit/rent_history_cubit.dart';
import 'package:aggar/features/rent_history/data/cubit/rent_history_state.dart';
import 'package:aggar/features/rent_history/data/cubit/create_review_cubit.dart';
import 'package:aggar/features/rent_history/presentation/widgets/rental_details_rental_summary_section.dart';
import 'package:aggar/features/rent_history/presentation/widgets/rental_history_vehicle_details_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class RentalHistoryDetail extends StatelessWidget {
  final RentalHistoryItem rentalItem;
  final Color statusColor;

  const RentalHistoryDetail({
    super.key,
    required this.rentalItem,
    required this.statusColor,
  });

  Widget _buildRatingStars(int rating) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        return Icon(
          index < rating ? Icons.star : Icons.star_border,
          color: Colors.amber,
          size: 18.0,
        );
      }),
    );
  }

  void _onScanQRCode(BuildContext context) async {
    try {
      final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => QRScannerPage(rentalId: rentalItem.id),
        ),
      );

      if (result == true) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            customSnackBar(
              context,
              "Loading ...",
              'Updating rental history...',
              SnackBarType.warning,
            ),
          );
          context.read<RentalHistoryCubit>().refreshRentalHistory();
          Navigator.pop(context, true);
        }
      } else if (result == false) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            customSnackBar(
              context,
              "Warning",
              'QR code scanning was cancelled',
              SnackBarType.warning,
            ),
          );
        }
      }
    } catch (e) {
      debugPrint('Error navigating to QR scanner: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          customSnackBar(
            context,
            "Error",
            'Unable to open QR scanner: ${e.toString()}',
            SnackBarType.success,
          ),
        );
        _onScanQRCode(context);
      }
    }
  }

  void _onRefund(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return BlocConsumer<RentalHistoryCubit, RentalHistoryState>(
          listener: (context, state) {
            if (state is RentalHistoryRefundSuccess) {
              Navigator.of(dialogContext).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Row(
                    children: [
                      const Icon(Icons.check_circle, color: Colors.white),
                      const SizedBox(width: 8),
                      Text(state.message),
                    ],
                  ),
                  backgroundColor: Colors.green,
                  duration: const Duration(seconds: 4),
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              );
            } else if (state is RentalHistoryRefundError) {
              Navigator.of(dialogContext).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Row(
                    children: [
                      const Icon(Icons.error, color: Colors.white),
                      const SizedBox(width: 8),
                      Expanded(child: Text(state.message)),
                    ],
                  ),
                  backgroundColor: Colors.red,
                  duration: const Duration(seconds: 4),
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              );
            }
          },
          builder: (context, state) {
            final isLoading = state is RentalHistoryRefundLoading;

            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              backgroundColor: context.theme.white100_2,
              title: Text(
                'Refund Request',
                style: AppStyles.semiBold24(
                  context,
                ).copyWith(color: context.theme.black100),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Are you sure you want to request a refund for this rental?',
                    style: AppStyles.medium18(
                      context,
                    ).copyWith(color: context.theme.black50),
                  ),
                  const Gap(16),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Refund Amount:',
                          style: AppStyles.regular14(
                            context,
                          ).copyWith(color: Colors.grey[600]),
                        ),
                        Text(
                          '\$${rentalItem.finalPrice.toStringAsFixed(2)}',
                          style: AppStyles.bold16(
                            context,
                          ).copyWith(color: Colors.green),
                        ),
                      ],
                    ),
                  ),
                  if (isLoading) ...[
                    const Gap(16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                        const Gap(12),
                        Text(
                          'Processing refund request...',
                          style: AppStyles.medium18(
                            context,
                          ).copyWith(color: context.theme.black50),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
              actions: [
                TextButton(
                  onPressed: isLoading
                      ? null
                      : () => Navigator.of(dialogContext).pop(),
                  child: Text(
                    'Cancel',
                    style: AppStyles.bold15(context).copyWith(
                      color: isLoading
                          ? Colors.grey[400]
                          : context.theme.blue100_1,
                    ),
                  ),
                ),
                TextButton(
                  style: ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(
                      isLoading ? Colors.grey[400] : context.theme.red100_1,
                    ),
                  ),
                  onPressed: isLoading
                      ? null
                      : () {
                          context.read<RentalHistoryCubit>().refundRental(
                            rentalId: rentalItem.id,
                          );
                        },
                  child: isLoading
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          ),
                        )
                      : Text(
                          'Request Refund',
                          style: AppStyles.semiBold15(
                            context,
                          ).copyWith(color: Colors.white),
                        ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  bool _shouldShowActionButtons() {
    final status = rentalItem.rentalStatus.toLowerCase();
    return status != 'refunded' && status != 'confirmed';
  }

  bool _shouldShowReviewButton() {
    final status = rentalItem.rentalStatus.toLowerCase();
    return status == 'confirmed';
  }

  void _onCreateReview(BuildContext context) async {
    const FlutterSecureStorage secureStorage = FlutterSecureStorage();
    final userRole = await secureStorage.read(key: 'userType');
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (context) => CreateReviewCubit(),
          child: CreateReviewScreen(rentalItem: rentalItem, userRole: userRole),
        ),
      ),
    );

    if (result == true) {
      // Refresh the rental history to show the new review
      if (context.mounted) {
        context.read<RentalHistoryCubit>().refreshRentalHistory();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.white100_1,
      appBar: AppBar(
        elevation: 1,
        shadowColor: Colors.grey[900],
        surfaceTintColor: Colors.transparent,
        centerTitle: true,
        backgroundColor: context.theme.white100_1,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: context.theme.black100,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Rental Details',
          style: AppStyles.semiBold24(
            context,
          ).copyWith(color: context.theme.black100),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RentalHistoryVehicleDetailsSection(
                statusColor: statusColor,
                rentalItem: rentalItem,
              ),
              const Gap(20),
              RentalDetailsRentalSummarySection(
                statusColor: statusColor,
                rentalItem: rentalItem,
              ),
              const Gap(20),
              /*if (rentalItem.renterReview != null ||
                  rentalItem.customerReview != null) ...[
                Card(
                  color: Colors.transparent,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: BorderSide(
                      color: statusColor.withOpacity(0.3),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: statusColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(
                                Icons.star,
                                color: statusColor,
                                size: 24,
                              ),
                            ),
                            const Gap(16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Reviews',
                                    style: AppStyles.bold20(context).copyWith(
                                      color: statusColor,
                                    ),
                                  ),
                                  Text(
                                    'Customer feedback',
                                    style:
                                        AppStyles.regular14(context).copyWith(
                                      color: context.theme.black50,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const Gap(20),

                        // Renter Review
                        if (rentalItem.renterReview != null) ...[
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: statusColor.withOpacity(0.05),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                  color: statusColor.withOpacity(0.1)),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Renter Review',
                                  style: AppStyles.semiBold16(context).copyWith(
                                    color: statusColor,
                                  ),
                                ),
                                const Gap(12),
                                Row(
                                  children: [
                                    CircleAvatar(
                                      backgroundColor: context.theme.black10,
                                      radius: 20,
                                      backgroundImage: rentalItem.renterReview!
                                                  .reviewer.imagePath !=
                                              null
                                          ? NetworkImage(
                                              '${EndPoint.baseUrl}${rentalItem.renterReview!.reviewer.imagePath!}')
                                          : null,
                                      child: rentalItem.renterReview!.reviewer
                                                  .imagePath ==
                                              null
                                          ? const Icon(Icons.person, size: 20)
                                          : null,
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            rentalItem
                                                .renterReview!.reviewer.name,
                                            style: AppStyles.semiBold14(context)
                                                .copyWith(
                                              color: context.theme.black100,
                                            ),
                                          ),
                                          Text(
                                            DateFormat('dd MMM yyyy').format(
                                                rentalItem
                                                    .renterReview!.createdAt),
                                            style: AppStyles.regular12(context)
                                                .copyWith(
                                              color: context.theme.black50,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const Gap(12),
                                Text(
                                  rentalItem.renterReview!.comments,
                                  style: AppStyles.regular14(context).copyWith(
                                    color: context.theme.black100,
                                  ),
                                ),
                                const Gap(12),
                                Row(
                                  children: [
                                    Text('Behavior: ',
                                        style: AppStyles.regular12(context)
                                            .copyWith(
                                          color: context.theme.black50,
                                        )),
                                    _buildRatingStars(
                                        rentalItem.renterReview!.behavior),
                                    const SizedBox(width: 16),
                                    Text('Punctuality: ',
                                        style: AppStyles.regular12(context)
                                            .copyWith(
                                          color: context.theme.black50,
                                        )),
                                    _buildRatingStars(
                                        rentalItem.renterReview!.punctuality),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          if (rentalItem.customerReview != null) const Gap(16),
                        ],

                        // Customer Review
                        if (rentalItem.customerReview != null) ...[
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.green.withOpacity(0.05),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                  color: Colors.green.withOpacity(0.1)),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Customer Review',
                                  style: AppStyles.semiBold16(context).copyWith(
                                    color: Colors.green[700],
                                  ),
                                ),
                                const Gap(12),
                                Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 20,
                                      backgroundImage: rentalItem
                                                  .customerReview!
                                                  .reviewer
                                                  .imagePath !=
                                              null
                                          ? NetworkImage(
                                              '${EndPoint.baseUrl}${rentalItem.customerReview!.reviewer.imagePath!}')
                                          : null,
                                      child: rentalItem.customerReview!.reviewer
                                                  .imagePath ==
                                              null
                                          ? const Icon(Icons.person, size: 20)
                                          : null,
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            rentalItem
                                                .customerReview!.reviewer.name,
                                            style:
                                                AppStyles.semiBold14(context),
                                          ),
                                          Text(
                                            DateFormat('dd MMM yyyy').format(
                                                rentalItem
                                                    .customerReview!.createdAt),
                                            style: AppStyles.regular12(context)
                                                .copyWith(
                                              color: Colors.grey[600],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const Gap(12),
                                Text(
                                  rentalItem.customerReview!.comments,
                                  style: AppStyles.regular14(context),
                                ),
                                const Gap(12),
                                Row(
                                  children: [
                                    Text('Behavior: ',
                                        style: AppStyles.regular12(context)),
                                    _buildRatingStars(
                                        rentalItem.customerReview!.behavior),
                                    const SizedBox(width: 16),
                                    Text('Punctuality: ',
                                        style: AppStyles.regular12(context)),
                                    _buildRatingStars(
                                        rentalItem.customerReview!.punctuality),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
                const Gap(20),
              ],*/

              // Action Buttons
              if (_shouldShowActionButtons()) ...[
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => _onScanQRCode(context),
                        icon: const Icon(Icons.qr_code_scanner),
                        label: Text(
                          'Scan QR Code',
                          style: AppStyles.medium16(
                            context,
                          ).copyWith(color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2563EB),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 2,
                        ),
                      ),
                    ),
                    const Gap(12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => _onRefund(context),
                        icon: const Icon(Icons.refresh),
                        label: Text(
                          'Refund',
                          style: AppStyles.medium16(
                            context,
                          ).copyWith(color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 2,
                        ),
                      ),
                    ),
                  ],
                ),
              ],

              // Review Button (only show when status is confirmed)
              if (_shouldShowReviewButton()) ...[
                const Gap(20),
                Text(
                  'Rate Your Experience',
                  style: AppStyles.semiBold18(
                    context,
                  ).copyWith(color: context.theme.black100),
                ),
                const Gap(12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () => _onCreateReview(context),
                    icon: const Icon(Icons.rate_review),
                    label: Text(
                      'Write Review',
                      style: AppStyles.medium16(
                        context,
                      ).copyWith(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: context.theme.blue100_1,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 2,
                    ),
                  ),
                ),
              ],
              const Gap(30),
            ],
          ),
        ),
      ),
    );
  }
}
