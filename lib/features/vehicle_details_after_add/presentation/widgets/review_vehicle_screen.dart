import 'package:aggar/core/cubit/refresh%20token/token_refresh_cubit.dart';
import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/helper/custom_snack_bar.dart';
import 'package:aggar/core/widgets/comment_section.dart';
import 'package:aggar/features/main_screen/customer/presentation/widgets/loading_all_vehicle.dart';
import 'package:aggar/features/profile/presentation/views/review_error_screen.dart';
import 'package:aggar/features/profile/presentation/widgets/no_review_user.dart';
import 'package:aggar/features/profile/presentation/widgets/review_screen_header.dart';
import 'package:aggar/features/vehicle_details_after_add/presentation/cubit/review_cubit/review_cubit.dart';
import 'package:aggar/features/vehicle_details_after_add/presentation/cubit/review_cubit/review_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class ReviewVehicleScreen extends StatefulWidget {
  const ReviewVehicleScreen({
    super.key,
    required this.vehicleId,
    required this.type,
  });
  final String vehicleId;
  final String type;

  @override
  State<ReviewVehicleScreen> createState() => _ReviewVehicleScreenState();
}

class _ReviewVehicleScreenState extends State<ReviewVehicleScreen> {
  late ScrollController _scrollController;
  late ReviewCubit _cubit;
  String? token;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
    _cubit = context.read<ReviewCubit>();
    _fetchInitialData();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _fetchInitialData() async {
    final tokenCubit = context.read<TokenRefreshCubit>();
    final tokenn = await tokenCubit.ensureValidToken();
    if (tokenn != null) {
      setState(() {
        token = tokenn;
      });
      _cubit.getVehicleReviews(widget.vehicleId, token!);
    }
  }

  void _onScroll() {
    if (_isBottom && token != null) {
      _cubit.loadMoreVehicleReviews(widget.vehicleId, token!);
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.white100_1,
      body: Column(
        children: [
          const ReviewScreenHeader(),
          Expanded(
            child: BlocConsumer<ReviewCubit, ReviewState>(
              listener: (context, state) {
                if (state is ReviewFailure) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    customSnackBar(
                      context,
                      "Error",
                      "Review Error: ${state.errorMsg}",
                      SnackBarType.error,
                    ),
                  );
                }
              },
              builder: (context, state) {
                if (state is ReviewLoading) {
                  return const LoadingAllVehicle();
                }
                if (state is ReviewSuccess || state is ReviewLoadingMore) {
                  final reviews = state is ReviewSuccess
                      ? state.review!.data
                      : _cubit.vehicleReviews;
                  final canLoadMore = _cubit.canLoadMoreVehicleReviews;
                  final isLoadingMore = state is ReviewLoadingMore;
                  if (reviews.isEmpty && !isLoadingMore) {
                    return const NoReviewUser();
                  }
                  return Column(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: ListView.builder(
                            padding: const EdgeInsets.only(top: 16, bottom: 16),
                            controller: _scrollController,
                            itemCount:
                                reviews.length +
                                (canLoadMore || isLoadingMore ? 1 : 0),
                            itemBuilder: (context, index) {
                              if (index == reviews.length) {
                                if (isLoadingMore) {
                                  return Container(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 24,
                                    ),
                                    child: Center(
                                      child: CircularProgressIndicator(
                                        color: context.theme.blue100_8,
                                      ),
                                    ),
                                  );
                                }
                                return const SizedBox.shrink();
                              }
                              final review = reviews[index];
                              DateTime datetime = DateTime.parse(
                                review.createdAt,
                              );
                              String formattedDate = DateFormat(
                                'MMM d, yyyy',
                              ).format(datetime);

                              return CommentSection(
                                imageUrl: review.reviewer.imagePath ?? "",
                                name: review.reviewer.name,
                                commentText: review.comments,
                                date: formattedDate,
                                rate: review.rate,
                                id: review.id,
                                typeOfReport: widget.type,
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  );
                }

                return const ReviewErrorScreen();
              },
            ),
          ),
        ],
      ),
    );
  }
}
