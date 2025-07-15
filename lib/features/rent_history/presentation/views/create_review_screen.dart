import 'package:aggar/core/api/dio_consumer.dart';
import 'package:aggar/core/api/end_points.dart';
import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/helper/custom_snack_bar.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/features/rent_history/data/models/rental_history_models.dart';
import 'package:aggar/features/rent_history/data/cubit/create_review_cubit.dart';
import 'package:aggar/features/rent_history/data/cubit/create_review_state.dart';
import 'package:aggar/core/cubit/refresh%20token/token_refresh_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class CreateReviewScreen extends StatefulWidget {
  final RentalHistoryItem rentalItem;
  final String? userRole;

  const CreateReviewScreen({
    super.key,
    required this.rentalItem,
    this.userRole,
  });

  @override
  State<CreateReviewScreen> createState() => _CreateReviewScreenState();
}

class _CreateReviewScreenState extends State<CreateReviewScreen> {
  final TextEditingController _commentsController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  double _behaviorRating = 0;
  double _punctualityRating = 0;
  double _careOrTruthfulnessRating = 0;
  late final String? _userRole;
  late final bool _isRenterReview;

  @override
  void initState() {
    super.initState();
    _userRole = widget.userRole;
    _isRenterReview = _userRole == 'Renter';
  }

  @override
  void dispose() {
    _commentsController.dispose();
    super.dispose();
  }

  Widget _buildRatingSection({
    required String title,
    required double rating,
    required Function(double) onRatingChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppStyles.semiBold16(context).copyWith(
            color: context.theme.black100,
          ),
        ),
        const Gap(8),
        Row(
          children: List.generate(5, (index) {
            final starPosition = index + 1;
            return Stack(
              children: [
                const Icon(
                  Icons.star_border_rounded,
                  color: Colors.amber,
                  size: 32,
                ),
                if (rating >= starPosition)
                  const Icon(
                    Icons.star_rounded,
                    color: Colors.amber,
                    size: 32,
                  )
                else if (rating > index && rating < starPosition)
                  const Icon(
                    Icons.star_half_rounded,
                    color: Colors.amber,
                    size: 32,
                  ),
                Positioned.fill(
                  right: 16,
                  child: GestureDetector(
                    onTap: () {
                      onRatingChanged(index + 0.5);
                    },
                  ),
                ),
                Positioned.fill(
                  left: 16,
                  child: GestureDetector(
                    onTap: () {
                      onRatingChanged(starPosition.toDouble());
                    },
                  ),
                ),
              ],
            );
          }),
        ),
        const Gap(16),
      ],
    );
  }

  Future<void> _submitReview() async {
    if (!_formKey.currentState!.validate()) return;
    if (_behaviorRating == 0 ||
        _punctualityRating == 0 ||
        _careOrTruthfulnessRating == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        customSnackBar(
          context,
          "Warning",
          "Please provide all ratings",
          SnackBarType.warning,
        ),
      );
      return;
    }

    // Get token from secure storage or context
    final token = await _getAccessToken();

    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        customSnackBar(
          context,
          "Error",
          "Authentication token not available",
          SnackBarType.error,
        ),
      );
      return;
    }

    // Submit review using cubit
    if (_isRenterReview) {
      context.read<CreateReviewCubit>().createReview(
            accessToken: token,
            rentalId: widget.rentalItem.id,
            behavior: _behaviorRating,
            punctuality: _punctualityRating,
            comments: _commentsController.text.trim(),
            care: _careOrTruthfulnessRating,
          );
    } else {
      context.read<CreateReviewCubit>().createReview(
            accessToken: token,
            rentalId: widget.rentalItem.id,
            behavior: _behaviorRating,
            punctuality: _punctualityRating,
            comments: _commentsController.text.trim(),
            truthfulness: _careOrTruthfulnessRating,
          );
    }
  }

  Future<String?> _getAccessToken() async {
    try {
      // Get token from TokenRefreshCubit
      final tokenRefreshCubit = context.read<TokenRefreshCubit>();
      return await tokenRefreshCubit.getAccessToken();
    } catch (e) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isCustomerReview = _userRole == 'Customer';
    final careOrTruthfulnessTitle =
        _isRenterReview ? 'Care' : (isCustomerReview ? 'Truthfulness' : '');
    final reviewTarget =
        _isRenterReview ? widget.rentalItem.user.name : 'Vehicle';

    return BlocListener<CreateReviewCubit, CreateReviewState>(
      listener: (context, state) {
        if (state is CreateReviewSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            customSnackBar(
              context,
              "Success",
              state.message,
              SnackBarType.success,
            ),
          );
          Navigator.pop(context, true); // Return true to indicate success
        } else if (state is CreateReviewFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            customSnackBar(
              context,
              "Error",
              state.errorMessage,
              SnackBarType.error,
            ),
          );
        }
      },
      child: Scaffold(
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
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            'Write Review',
            style: AppStyles.semiBold24(context).copyWith(
              color: context.theme.black100,
            ),
          ),
        ),
        body: BlocBuilder<CreateReviewCubit, CreateReviewState>(
          builder: (context, state) {
            final isLoading = state is CreateReviewLoading;

            return Form(
              key: _formKey,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header with vehicle info
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: context.theme.blue100_1.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: context.theme.blue100_1.withOpacity(0.2),
                        ),
                      ),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              '${EndPoint.baseUrl}${widget.rentalItem.vehicle.mainImagePath}',
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  width: 60,
                                  height: 60,
                                  color: Colors.grey[300],
                                  child: const Icon(Icons.directions_car,
                                      size: 30),
                                );
                              },
                            ),
                          ),
                          const Gap(12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Review for $reviewTarget',
                                  style: AppStyles.semiBold16(context).copyWith(
                                    color: context.theme.black100,
                                  ),
                                ),
                                Text(
                                  widget.rentalItem.vehicle.address,
                                  style: AppStyles.regular14(context).copyWith(
                                    color: context.theme.black50,
                                  ),
                                ),
                                const Gap(4),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: _isRenterReview
                                        ? Colors.blue.withOpacity(0.1)
                                        : (isCustomerReview
                                            ? Colors.green.withOpacity(0.1)
                                            : Colors.grey.withOpacity(0.1)),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    _isRenterReview
                                        ? 'Renter Review'
                                        : (isCustomerReview
                                            ? 'Customer Review'
                                            : 'Review'),
                                    style:
                                        AppStyles.regular12(context).copyWith(
                                      color: _isRenterReview
                                          ? Colors.blue[700]
                                          : (isCustomerReview
                                              ? Colors.green[700]
                                              : Colors.grey[700]),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Gap(24),

                    // Rating sections
                    _buildRatingSection(
                      title: 'Behavior',
                      rating: _behaviorRating,
                      onRatingChanged: (rating) {
                        setState(() {
                          _behaviorRating = rating;
                        });
                      },
                    ),

                    _buildRatingSection(
                      title: 'Punctuality',
                      rating: _punctualityRating,
                      onRatingChanged: (rating) {
                        setState(() {
                          _punctualityRating = rating;
                        });
                      },
                    ),

                    if (_isRenterReview)
                      _buildRatingSection(
                        title: 'Care',
                        rating: _careOrTruthfulnessRating,
                        onRatingChanged: (rating) {
                          setState(() {
                            _careOrTruthfulnessRating = rating;
                          });
                        },
                      ),
                    if (isCustomerReview)
                      _buildRatingSection(
                        title: 'Truthfulness',
                        rating: _careOrTruthfulnessRating,
                        onRatingChanged: (rating) {
                          setState(() {
                            _careOrTruthfulnessRating = rating;
                          });
                        },
                      ),

                    // Comments section
                    Text(
                      'Comments',
                      style: AppStyles.semiBold16(context).copyWith(
                        color: context.theme.black100,
                      ),
                    ),
                    const Gap(8),
                    TextFormField(
                      controller: _commentsController,
                      maxLines: 4,
                      decoration: InputDecoration(
                        hintText: 'Share your experience...',
                        hintStyle: AppStyles.regular14(context).copyWith(
                          color: context.theme.black50,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey[300]!),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide:
                              BorderSide(color: context.theme.blue100_1),
                        ),
                        filled: true,
                        fillColor: Colors.grey[50],
                      ),
                      style: AppStyles.regular14(context).copyWith(
                        color: context.theme.black100,
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please provide your comments';
                        }
                        return null;
                      },
                    ),
                    const Gap(32),

                    // Submit button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: isLoading ? null : _submitReview,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: context.theme.blue100_1,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 2,
                        ),
                        child: isLoading
                            ? const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          Colors.white),
                                    ),
                                  ),
                                  Gap(12),
                                  Text('Submitting...'),
                                ],
                              )
                            : Text(
                                'Submit Review',
                                style: AppStyles.semiBold16(context).copyWith(
                                  color: Colors.white,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
