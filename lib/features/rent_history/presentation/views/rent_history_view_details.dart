import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/features/rent_history/data/models/rental_history_models.dart';
import 'package:aggar/features/rent_history/presentation/views/scanner_qr_code_page.dart';
import 'package:aggar/features/rent_history/data/cubit/rent_history_cubit.dart';
import 'package:aggar/features/rent_history/data/cubit/rent_history_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';

class RentalHistoryDetail extends StatelessWidget {
  final RentalHistoryItem rentalItem;
  final Color statusColor;

  const RentalHistoryDetail({
    super.key,
    required this.rentalItem,
    required this.statusColor,
  });

  // Method to construct the full image URL
  String _getFullImageUrl(String imagePath) {
    const String baseUrl = "https://aggarapi.runasp.net";
    if (imagePath.startsWith('http')) {
      return imagePath; // Already a full URL
    }
    return baseUrl + imagePath;
  }

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

  Widget _buildInfoCard({
    required BuildContext context,
    required String title,
    required String value,
    IconData? icon,
    Color? valueColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              size: 20,
              color: Colors.grey.shade600,
            ),
            const SizedBox(width: 12),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppStyles.regular12(context).copyWith(
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: AppStyles.semiBold16(context).copyWith(
                    color: valueColor ?? Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _onScanQRCode(BuildContext context) async {
    try {
      final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => QRScannerPage(
            rentalId: rentalItem.id,
          ),
        ),
      );

      // Handle the result from QR scanner
      if (result == true) {
        // QR code was successfully scanned and rental confirmed
        if (context.mounted) {
          // Show loading indicator
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Row(
                children: [
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ),
                  SizedBox(width: 16),
                  Text('Updating rental history...'),
                ],
              ),
              duration: Duration(seconds: 2),
            ),
          );

          // Refresh the rental history to get updated data
          context.read<RentalHistoryCubit>().refreshRentalHistory();

          // Navigate back to the previous screen
          Navigator.pop(context, true);
        }
      } else if (result == false) {
        // QR scan failed or was cancelled
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('QR code scanning was cancelled'),
              backgroundColor: Colors.orange,
            ),
          );
        }
      }
      // If result is null, handle silently (user probably just closed the scanner)
    } catch (e) {
      // Handle any navigation errors
      debugPrint('Error navigating to QR scanner: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Unable to open QR scanner: ${e.toString()}'),
            backgroundColor: Colors.red,
            action: SnackBarAction(
              label: 'Retry',
              onPressed: () => _onScanQRCode(context),
            ),
          ),
        );
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
              Navigator.of(dialogContext).pop(); // Close dialog
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
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              );
            } else if (state is RentalHistoryRefundError) {
              Navigator.of(dialogContext).pop(); // Close dialog
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
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              );
            }
          },
          builder: (context, state) {
            final isLoading = state is RentalHistoryRefundLoading;

            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: const Row(
                children: [
                  Icon(
                    Icons.refresh,
                    color: Colors.red,
                    size: 24,
                  ),
                  SizedBox(width: 8),
                  Text('Refund Request'),
                ],
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Are you sure you want to request a refund for this rental?',
                    style: AppStyles.regular16(context),
                  ),
                  const Gap(16),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Amount:',
                              style: AppStyles.regular14(context).copyWith(
                                color: Colors.grey[600],
                              ),
                            ),
                            Text(
                              '\$${rentalItem.finalPrice.toStringAsFixed(2)}',
                              style: AppStyles.semiBold14(context).copyWith(
                                color: Colors.green,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  if (isLoading) ...[
                    const Gap(16),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                        Gap(12),
                        Text('Processing refund request...'),
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
                    style: AppStyles.medium16(context).copyWith(
                      color: isLoading ? Colors.grey[400] : Colors.grey[600],
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: isLoading
                      ? null
                      : () {
                          // Call the cubit method to handle refund
                          context.read<RentalHistoryCubit>().refundRental(
                                rentalId: rentalItem.id,
                              );
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isLoading ? Colors.grey[400] : Colors.red,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: isLoading
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : Text(
                          'Request Refund',
                          style: AppStyles.medium16(context).copyWith(
                            color: Colors.white,
                          ),
                        ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // Helper method to check if buttons should be shown
  bool _shouldShowActionButtons() {
    final status = rentalItem.rentalStatus.toLowerCase();
    return status != 'refunded' && status != 'confirmed';
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd MMM yyyy');

    return Scaffold(
      backgroundColor: context.theme.white100_1,
      appBar: AppBar(
        backgroundColor: context.theme.white100_1,
        title: Text(
          'Rental Details',
          style: AppStyles.semiBold20(context),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Status Header Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      statusColor.withOpacity(0.1),
                      statusColor.withOpacity(0.05),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: statusColor.withOpacity(0.3)),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Rental #${rentalItem.id}',
                          style: AppStyles.bold20(context),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: statusColor,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            rentalItem.rentalStatus,
                            style: AppStyles.semiBold14(context).copyWith(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Gap(16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Total Amount',
                              style: AppStyles.regular14(context).copyWith(
                                color: Colors.grey[600],
                              ),
                            ),
                            Text(
                              '\$${rentalItem.finalPrice.toStringAsFixed(2)}',
                              style: AppStyles.bold24(context).copyWith(
                                color: statusColor,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              'Duration',
                              style: AppStyles.regular14(context).copyWith(
                                color: Colors.grey[600],
                              ),
                            ),
                            Text(
                              '${rentalItem.totalDays} Days',
                              style: AppStyles.bold18(context),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const Gap(24),

              // Customer Information
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.person,
                            color: statusColor,
                            size: 24,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Customer Information',
                            style: AppStyles.bold18(context),
                          ),
                        ],
                      ),
                      const Gap(16),
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 35,
                            backgroundColor: statusColor.withOpacity(0.1),
                            backgroundImage: rentalItem.user.imagePath != null
                                ? NetworkImage(_getFullImageUrl(
                                    rentalItem.user.imagePath!))
                                : null,
                            child: rentalItem.user.imagePath == null
                                ? Icon(
                                    Icons.person,
                                    size: 35,
                                    color: statusColor,
                                  )
                                : null,
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  rentalItem.user.name,
                                  style: AppStyles.bold18(context),
                                ),
                                const Gap(4),
                                Text(
                                  'Customer ID: #${rentalItem.user.id ?? 'N/A'}',
                                  style: AppStyles.regular14(context).copyWith(
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const Gap(16),

              // Rental Period
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.calendar_today,
                            color: statusColor,
                            size: 24,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Rental Period',
                            style: AppStyles.bold18(context),
                          ),
                        ],
                      ),
                      const Gap(16),
                      Row(
                        children: [
                          Expanded(
                            child: _buildInfoCard(
                              title: 'Start Date',
                              value: dateFormat.format(rentalItem.startDate),
                              icon: Icons.play_arrow,
                              valueColor: Colors.green,
                              context: context,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildInfoCard(
                              title: 'End Date',
                              value: dateFormat.format(rentalItem.endDate),
                              icon: Icons.stop,
                              valueColor: Colors.red,
                              context: context,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const Gap(16),

              // Vehicle Information
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.directions_car,
                            color: statusColor,
                            size: 24,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Vehicle Details',
                            style: AppStyles.bold18(context),
                          ),
                        ],
                      ),
                      const Gap(16),
                      Container(
                        width: double.infinity,
                        height: 200,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.grey.shade100,
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: rentalItem.vehicle.mainImagePath.isNotEmpty
                              ? Image.network(
                                  _getFullImageUrl(
                                      rentalItem.vehicle.mainImagePath),
                                  fit: BoxFit.cover,
                                  loadingBuilder:
                                      (context, child, loadingProgress) {
                                    if (loadingProgress == null) return child;
                                    return Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          CircularProgressIndicator(
                                            value: loadingProgress
                                                        .expectedTotalBytes !=
                                                    null
                                                ? loadingProgress
                                                        .cumulativeBytesLoaded /
                                                    loadingProgress
                                                        .expectedTotalBytes!
                                                : null,
                                            color: statusColor,
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            'Loading image...',
                                            style: AppStyles.regular14(context)
                                                .copyWith(
                                              color: Colors.grey[600],
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      decoration: BoxDecoration(
                                        color: Colors.grey[100],
                                        borderRadius:
                                            BorderRadius.circular(12.0),
                                      ),
                                      child: Center(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.broken_image,
                                              size: 48,
                                              color: Colors.grey[400],
                                            ),
                                            const SizedBox(height: 8),
                                            Text(
                                              'Image Not Available',
                                              style:
                                                  AppStyles.regular14(context)
                                                      .copyWith(
                                                color: Colors.grey[600],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                )
                              : Container(
                                  decoration: BoxDecoration(
                                    color: Colors.grey[100],
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                  child: Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.image,
                                          size: 48,
                                          color: Colors.grey[400],
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          'No Image Available',
                                          style: AppStyles.regular14(context)
                                              .copyWith(
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                        ),
                      ),
                      const Gap(16),
                      // Location takes full width, price per day removed
                      _buildInfoCard(
                        title: 'Location',
                        value: rentalItem.vehicle.address,
                        icon: Icons.location_on,
                        context: context,
                      ),
                    ],
                  ),
                ),
              ),

              const Gap(16),

              // Pricing Information
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.receipt,
                            color: statusColor,
                            size: 24,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Pricing Details',
                            style: AppStyles.bold18(context),
                          ),
                        ],
                      ),
                      const Gap(16),
                      Row(
                        children: [
                          Expanded(
                            child: _buildInfoCard(
                              title: 'Final Price',
                              value:
                                  '\$${rentalItem.finalPrice.toStringAsFixed(2)}',
                              icon: Icons.payment,
                              valueColor: statusColor,
                              context: context,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildInfoCard(
                              title: 'Discount',
                              value: '${rentalItem.discount.toInt()}%',
                              icon: Icons.discount,
                              valueColor: Colors.green,
                              context: context,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // Reviews Section
              if (rentalItem.renterReview != null ||
                  rentalItem.customerReview != null) ...[
                const Gap(16),
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.star,
                              color: statusColor,
                              size: 24,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Reviews',
                              style: AppStyles.bold18(context),
                            ),
                          ],
                        ),
                        const Gap(16),

                        // Renter Review
                        if (rentalItem.renterReview != null) ...[
                          Text(
                            'Renter Review',
                            style: AppStyles.semiBold16(context),
                          ),
                          const Gap(8),
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 20,
                                backgroundImage: rentalItem
                                            .renterReview!.reviewer.imagePath !=
                                        null
                                    ? NetworkImage(_getFullImageUrl(rentalItem
                                        .renterReview!.reviewer.imagePath!))
                                    : null,
                                child: rentalItem
                                            .renterReview!.reviewer.imagePath ==
                                        null
                                    ? const Icon(Icons.person, size: 20)
                                    : null,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      rentalItem.renterReview!.reviewer.name,
                                      style: AppStyles.semiBold14(context),
                                    ),
                                    Text(
                                      DateFormat('dd MMM yyyy').format(
                                          rentalItem.renterReview!.createdAt),
                                      style:
                                          AppStyles.regular12(context).copyWith(
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const Gap(8),
                          Text(
                            rentalItem.renterReview!.comments,
                            style: AppStyles.regular14(context),
                          ),
                          const Gap(8),
                          Row(
                            children: [
                              Text('Behavior: ',
                                  style: AppStyles.regular12(context)),
                              _buildRatingStars(
                                  rentalItem.renterReview!.behavior),
                              const SizedBox(width: 16),
                              Text('Punctuality: ',
                                  style: AppStyles.regular12(context)),
                              _buildRatingStars(
                                  rentalItem.renterReview!.punctuality),
                            ],
                          ),
                          if (rentalItem.customerReview != null) const Gap(16),
                        ],

                        // Customer Review
                        if (rentalItem.customerReview != null) ...[
                          Text(
                            'Customer Review',
                            style: AppStyles.semiBold16(context),
                          ),
                          const Gap(8),
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 20,
                                backgroundImage: rentalItem.customerReview!
                                            .reviewer.imagePath !=
                                        null
                                    ? NetworkImage(_getFullImageUrl(rentalItem
                                        .customerReview!.reviewer.imagePath!))
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      rentalItem.customerReview!.reviewer.name,
                                      style: AppStyles.semiBold14(context),
                                    ),
                                    Text(
                                      DateFormat('dd MMM yyyy').format(
                                          rentalItem.customerReview!.createdAt),
                                      style:
                                          AppStyles.regular12(context).copyWith(
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const Gap(8),
                          Text(
                            rentalItem.customerReview!.comments,
                            style: AppStyles.regular14(context),
                          ),
                          const Gap(8),
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
                      ],
                    ),
                  ),
                ),
              ],

              // Action Buttons - Only show if rental is not refunded or confirmed
              if (_shouldShowActionButtons()) ...[
                const Gap(24),
                Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () => _onScanQRCode(context),
                        icon: const Icon(Icons.qr_code_scanner),
                        label: Text(
                          'Scan QR Code',
                          style: AppStyles.medium16(context).copyWith(
                            color: Colors.white,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2563EB),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 2,
                        ),
                      ),
                    ),
                    const Gap(12),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () => _onRefund(context),
                        icon: const Icon(Icons.refresh),
                        label: Text(
                          'Refund',
                          style: AppStyles.medium16(context).copyWith(
                            color: Colors.white,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 2,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
              const Gap(24),
            ],
          ),
        ),
      ),
    );
  }
}
