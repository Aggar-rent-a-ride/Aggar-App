import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/features/rent_history/data/models/rental_history_models.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class RentalHistoryDetail extends StatelessWidget {
  final RentalHistoryItem rentalItem;

  const RentalHistoryDetail({super.key, required this.rentalItem});

  Widget _buildRatingStars(int rating) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        return Icon(
          index < rating ? Icons.star : Icons.star_border,
          color: Colors.amber,
          size: 16.0,
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd/MM/yyyy');

    return Scaffold(
      backgroundColor: context.theme.white100_1,
      appBar: AppBar(
        backgroundColor: context.theme.white100_1,
        title: Text(
          'Rent History',
          style: AppStyles.semiBold18(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            elevation: 4.0,
            color: Colors.white, // Explicitly set card color to white
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Rental Details',
                        style: AppStyles.bold18(context),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 4.0),
                        decoration: BoxDecoration(
                          color: Colors.cyan[100],
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                        child: Text(
                          rentalItem.rentalStatus,
                          style: AppStyles.bold12(context).copyWith(
                            color: Colors.cyan[800],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 24.0),
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundImage: rentalItem.user.imagePath != null
                            ? NetworkImage(rentalItem.user.imagePath!)
                            : null,
                        child: rentalItem.user.imagePath == null
                            ? const Icon(Icons.person, size: 30)
                            : null,
                      ),
                      const SizedBox(width: 16.0),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Customer Name',
                            style: AppStyles.regular12(context).copyWith(
                              color: Colors.grey,
                            ),
                          ),
                          Text(
                            rentalItem.user.name,
                            style: AppStyles.medium16(context),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Start Date',
                            style: AppStyles.regular12(context).copyWith(
                              color: Colors.grey,
                            ),
                          ),
                          Text(
                            dateFormat.format(rentalItem.startDate),
                            style: AppStyles.medium16(context),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'End Date',
                            style: AppStyles.regular12(context).copyWith(
                              color: Colors.grey,
                            ),
                          ),
                          Text(
                            dateFormat.format(rentalItem.endDate),
                            style: AppStyles.medium16(context),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Total Days',
                            style: AppStyles.regular12(context).copyWith(
                              color: Colors.grey,
                            ),
                          ),
                          Text(
                            '${rentalItem.totalDays} Days',
                            style: AppStyles.medium16(context),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Price Per Day',
                            style: AppStyles.regular12(context).copyWith(
                              color: Colors.grey,
                            ),
                          ),
                          Text(
                            '\$${rentalItem.vehicle.pricePerDay.toStringAsFixed(2)}',
                            style: AppStyles.medium16(context),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 24.0),
                  Text(
                    'Vehicle Details',
                    style: AppStyles.bold18(context),
                  ),
                  const Divider(height: 24.0),
                  Center(
                    child: Container(
                      width: double.infinity,
                      height: 200.0,
                      color: Colors.grey[300],
                      child: rentalItem.vehicle.mainImagePath.isNotEmpty
                          ? Image.network(
                              rentalItem.vehicle.mainImagePath,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Center(
                                    child: Text(
                                        'Image Not Available: ${rentalItem.vehicle.mainImagePath}'));
                              },
                            )
                          : const Center(child: Text('Image Placeholder')),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Location',
                        style: AppStyles.regular12(context).copyWith(
                          color: Colors.grey,
                        ),
                      ),
                      Text(
                        rentalItem.vehicle.address,
                        style: AppStyles.medium16(context),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24.0),

                  // Renter Review Section
                  if (rentalItem.renterReview != null) ...[
                    Text(
                      'Renter Review',
                      style: AppStyles.bold18(context),
                    ),
                    const Divider(height: 24.0),
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 20,
                          backgroundImage: rentalItem
                                      .renterReview!.reviewer.imagePath !=
                                  null
                              ? NetworkImage(
                                  rentalItem.renterReview!.reviewer.imagePath!)
                              : null,
                          child: rentalItem.renterReview!.reviewer.imagePath ==
                                  null
                              ? const Icon(Icons.person, size: 20)
                              : null,
                        ),
                        const SizedBox(width: 12.0),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              rentalItem.renterReview!.reviewer.name,
                              style: AppStyles.semiBold16(context),
                            ),
                            Text(
                              DateFormat('dd/MM/yyyy')
                                  .format(rentalItem.renterReview!.createdAt),
                              style: AppStyles.regular12(context).copyWith(
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 16.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Behavior',
                              style: AppStyles.regular12(context).copyWith(
                                color: Colors.grey,
                              ),
                            ),
                            _buildRatingStars(
                                rentalItem.renterReview!.behavior),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Punctuality',
                              style: AppStyles.regular12(context).copyWith(
                                color: Colors.grey,
                              ),
                            ),
                            _buildRatingStars(
                                rentalItem.renterReview!.punctuality),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Care',
                              style: AppStyles.regular12(context).copyWith(
                                color: Colors.grey,
                              ),
                            ),
                            _buildRatingStars(
                                rentalItem.renterReview!.care ?? 0),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 16.0),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Comments:',
                          style: AppStyles.regular12(context).copyWith(
                            color: Colors.grey,
                          ),
                        ),
                        Text(
                          rentalItem.renterReview!.comments,
                          style: AppStyles.medium16(context),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24.0),
                  ],

                  // Customer Review Section
                  if (rentalItem.customerReview != null) ...[
                    Text(
                      'Customer Review',
                      style: AppStyles.bold18(context),
                    ),
                    const Divider(height: 24.0),
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 20,
                          backgroundImage:
                              rentalItem.customerReview!.reviewer.imagePath !=
                                      null
                                  ? NetworkImage(rentalItem
                                      .customerReview!.reviewer.imagePath!)
                                  : null,
                          child:
                              rentalItem.customerReview!.reviewer.imagePath ==
                                      null
                                  ? const Icon(Icons.person, size: 20)
                                  : null,
                        ),
                        const SizedBox(width: 12.0),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              rentalItem.customerReview!.reviewer.name,
                              style: AppStyles.semiBold16(context),
                            ),
                            Text(
                              DateFormat('dd/MM/yyyy')
                                  .format(rentalItem.customerReview!.createdAt),
                              style: AppStyles.regular12(context).copyWith(
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 16.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Behavior',
                              style: AppStyles.regular12(context).copyWith(
                                color: Colors.grey,
                              ),
                            ),
                            _buildRatingStars(
                                rentalItem.customerReview!.behavior),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Punctuality',
                              style: AppStyles.regular12(context).copyWith(
                                color: Colors.grey,
                              ),
                            ),
                            _buildRatingStars(
                                rentalItem.customerReview!.punctuality),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Truthfulness',
                              style: AppStyles.regular12(context).copyWith(
                                color: Colors.grey,
                              ),
                            ),
                            _buildRatingStars(
                                rentalItem.customerReview!.truthfulness ?? 0),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 16.0),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Comments:',
                          style: AppStyles.regular12(context).copyWith(
                            color: Colors.grey,
                          ),
                        ),
                        Text(
                          rentalItem.customerReview!.comments,
                          style: AppStyles.medium16(context),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24.0),
                  ],

                  // Price Details
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Final Price',
                            style: AppStyles.regular14(context).copyWith(
                              color: Colors.grey,
                            ),
                          ),
                          Text(
                            '\$${rentalItem.finalPrice.toStringAsFixed(2)}',
                            style: AppStyles.bold20(context),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'Discount',
                            style: AppStyles.regular12(context).copyWith(
                              color: Colors.grey,
                            ),
                          ),
                          Text(
                            '${rentalItem.discount.toInt()}%',
                            style: AppStyles.semiBold16(context).copyWith(
                              color: Colors.green,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
