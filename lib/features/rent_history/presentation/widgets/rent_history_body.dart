import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/features/rent_history/data/cubit/rent_history_cubit.dart';
import 'package:aggar/features/rent_history/data/cubit/rent_history_state.dart';
import 'package:aggar/features/rent_history/presentation/views/rent_history_view_details.dart';
import 'package:aggar/features/rent_history/presentation/widgets/rent_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

class RentHistoryBody extends StatefulWidget {
  const RentHistoryBody({super.key});

  @override
  State<RentHistoryBody> createState() => _RentHistoryBodyState();
}

class _RentHistoryBodyState extends State<RentHistoryBody> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    context.read<RentalHistoryCubit>().getRentalHistory();

    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) {
      context.read<RentalHistoryCubit>().loadMoreRentals();
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'confirmed':
        return Colors.green;
      case 'not started':
      case 'notstarted':
        return Colors.orange;
      case 'refunded':
        return Colors.red;
      default:
        return Colors.grey;
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
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: RefreshIndicator(
          onRefresh: () async {
            context.read<RentalHistoryCubit>().refreshRentalHistory();
          },
          child: BlocBuilder<RentalHistoryCubit, RentalHistoryState>(
            builder: (context, state) {
              if (state is RentalHistoryInitial) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is RentalHistoryLoading &&
                  state is! RentalHistoryLoaded) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is RentalHistoryLoaded) {
                final rentals = state.rentals;

                if (rentals.isEmpty) {
                  return Center(
                    child: Text(
                      'No rental history found',
                      style: AppStyles.medium18(context),
                    ),
                  );
                }

                return ListView.separated(
                  controller: _scrollController,
                  itemCount: rentals.length + (state.hasMoreData ? 1 : 0),
                  separatorBuilder: (context, index) => const Gap(15),
                  itemBuilder: (context, index) {
                    if (index >= rentals.length) {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 15),
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }

                    final rental = rentals[index];
                    return RentalCard(
                      rental: rental,
                      onViewMore: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RentalHistoryDetail(
                              rentalItem: rental,
                              statusColor: _getStatusColor(rental.rentalStatus),
                            ),
                          ),
                        );
                      },
                    );
                  },
                );
              } else if (state is RentalHistoryError) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Failed to load rental history',
                        style: AppStyles.medium18(context),
                      ),
                      const Gap(10),
                      Text(
                        state.message,
                        style: AppStyles.regular16(context)
                            .copyWith(color: Colors.red),
                        textAlign: TextAlign.center,
                      ),
                      const Gap(20),
                      ElevatedButton(
                        onPressed: () {
                          context
                              .read<RentalHistoryCubit>()
                              .refreshRentalHistory();
                        },
                        child: const Text('Try Again'),
                      ),
                    ],
                  ),
                );
              }

              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }
}
