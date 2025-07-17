import 'package:aggar/core/cubit/user_review_cubit/user_review_cubit.dart';
import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/features/main_screen/customer/presentation/widgets/loading_all_vehicle.dart';
import 'package:aggar/features/profile/presentation/views/review_error_screen.dart';
import 'package:aggar/features/profile/presentation/widgets/no_review_user.dart';
import 'package:aggar/features/profile/presentation/widgets/review_screen_header.dart';
import 'package:aggar/features/profile/presentation/widgets/review_user_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/cubit/refresh token/token_refresh_cubit.dart';
import '../../../../core/helper/custom_snack_bar.dart';
import '../../../../core/cubit/user_review_cubit/user_review_state.dart';

class ReviewUserScreen extends StatefulWidget {
  const ReviewUserScreen({super.key, required this.userId});
  final String userId;

  @override
  State<ReviewUserScreen> createState() => _ReviewUserScreenState();
}

class _ReviewUserScreenState extends State<ReviewUserScreen> {
  late ScrollController _scrollController;
  late UserReviewCubit _cubit;
  String? token;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
    _cubit = context.read<UserReviewCubit>();
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
      _cubit.getUserReviews(widget.userId, token!);
    }
  }

  void _onScroll() {
    if (_isBottom && token != null) {
      _cubit.loadMoreUserReviews(widget.userId, token!);
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
            child: BlocConsumer<UserReviewCubit, UserReviewState>(
              listener: (context, state) {
                if (state is UserReviewFailure) {
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
                if (state is UserReviewLoading) {
                  return const LoadingAllVehicle();
                }
                if (state is UserReviewSuccess ||
                    state is UserReviewLoadingMore) {
                  final reviews = state is UserReviewSuccess
                      ? state.review!.data
                      : _cubit.userReviews;
                  final canLoadMore = _cubit.canLoadMoreUserReviews;
                  final isLoadingMore = state is UserReviewLoadingMore;
                  if (reviews.isEmpty && !isLoadingMore) {
                    return const NoReviewUser();
                  }

                  return ReviewUserList(
                    scrollController: _scrollController,
                    reviews: reviews,
                    canLoadMore: canLoadMore,
                    isLoadingMore: isLoadingMore,
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
