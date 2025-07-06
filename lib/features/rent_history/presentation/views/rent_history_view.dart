import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/features/rent_history/data/cubit/rent_history_cubit.dart';
import 'package:aggar/features/rent_history/data/cubit/rent_history_state.dart';
import 'package:aggar/features/rent_history/presentation/views/rent_history_view_details.dart';
import 'package:aggar/features/rent_history/presentation/widgets/rent_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

class RentHistoryView extends StatelessWidget {
  const RentHistoryView({super.key});

  // Helper method to get color for rental status
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        shadowColor: Colors.grey[900],
        surfaceTintColor: Colors.transparent,
        centerTitle: false,
        backgroundColor: context.theme.white100_1,
        title: Text(
          'Rent History',
          style: AppStyles.semiBold24(context)
              .copyWith(color: context.theme.black100),
        ),
        actions: [
          // Tab Filter for rental status
          Builder(
            builder: (context) {
              return PopupMenuButton<String>(
                icon: const Icon(Icons.filter_list),
                onSelected: (value) {
                  final cubit = context.read<RentalHistoryCubit>();
                  cubit.filterRentals(value);
                },
                itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                  const PopupMenuItem<String>(
                    value: 'all',
                    child: Row(
                      children: [
                        Icon(Icons.all_inclusive, size: 18),
                        SizedBox(width: 8),
                        Text('All Rentals'),
                      ],
                    ),
                  ),
                  PopupMenuItem<String>(
                    value: 'Confirmed',
                    child: Row(
                      children: [
                        Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            color: _getStatusColor('confirmed'),
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Text('Confirmed'),
                      ],
                    ),
                  ),
                  PopupMenuItem<String>(
                    value: 'Not Started',
                    child: Row(
                      children: [
                        Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            color: _getStatusColor('not started'),
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Text('Not Started'),
                      ],
                    ),
                  ),
                  PopupMenuItem<String>(
                    value: 'Refunded',
                    child: Row(
                      children: [
                        Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            color: _getStatusColor('refunded'),
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Text('Refunded'),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
      backgroundColor: context.theme.white100_1,
      body: const RentHistoryBody(),
    );
  }
}

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
    // Load rental history when widget is first created
    context.read<RentalHistoryCubit>().getRentalHistory();

    // Setup scroll listener for pagination
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

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  // Helper method to get color for rental status
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
                final rentals = state.displayedRentals ?? state.rentals;

                if (rentals.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.history,
                          size: 64,
                          color: Colors.grey.shade400,
                        ),
                        const Gap(16),
                        Text(
                          state.activeFilter == 'all'
                              ? 'No rental history found'
                              : 'No ${state.activeFilter.toLowerCase()} rentals found',
                          style: AppStyles.medium18(context)
                              .copyWith(color: Colors.grey.shade600),
                        ),
                        if (state.activeFilter != 'all') ...[
                          const Gap(8),
                          TextButton(
                            onPressed: () {
                              context
                                  .read<RentalHistoryCubit>()
                                  .filterRentals('all');
                            },
                            child: const Text('Show All Rentals'),
                          ),
                        ],
                      ],
                    ),
                  );
                }

                return Column(
                  children: [
                    // Filter indicator
                    if (state.activeFilter != 'all')
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        margin: const EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.blue.shade200),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.filter_list,
                              size: 16,
                              color: Colors.blue.shade700,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Showing ${rentals.length} ${state.activeFilter} rentals',
                              style: TextStyle(
                                color: Colors.blue.shade700,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const Spacer(),
                            GestureDetector(
                              onTap: () {
                                context
                                    .read<RentalHistoryCubit>()
                                    .filterRentals('all');
                              },
                              child: Icon(
                                Icons.close,
                                size: 16,
                                color: Colors.blue.shade700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    // Rental list
                    Expanded(
                      child: ListView.separated(
                        controller: _scrollController,
                        itemCount: rentals.length +
                            (state.hasMoreData && state.activeFilter == 'all'
                                ? 1
                                : 0),
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
                                    statusColor:
                                        _getStatusColor(rental.rentalStatus),
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ],
                );
              } else if (state is RentalHistoryError) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 64,
                        color: Colors.red.shade400,
                      ),
                      const Gap(16),
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
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                        ),
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
