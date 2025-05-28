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
                  switch (value) {
                    case 'all':
                      cubit.refreshRentalHistory();
                      break;
                    case 'Completed':
                      _showFilteredRentals(
                          context, cubit.getCompletedRentals());
                      break;
                    case 'In Progress':
                      _showFilteredRentals(
                          context, cubit.getInProgressRentals());
                      break;
                    case 'Not Started':
                      _showFilteredRentals(
                          context, cubit.getNotStartedRentals());
                      break;
                    case 'Cancelled':
                      _showFilteredRentals(
                          context, cubit.getCancelledRentals());
                      break;
                  }
                },
                itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                  const PopupMenuItem<String>(
                    value: 'all',
                    child: Text('All Rentals'),
                  ),
                  const PopupMenuItem<String>(
                    value: 'Completed',
                    child: Text('Completed'),
                  ),
                  const PopupMenuItem<String>(
                    value: 'In Progress',
                    child: Text('In Progress'),
                  ),
                  const PopupMenuItem<String>(
                    value: 'Not Started',
                    child: Text('Not Started'),
                  ),
                  const PopupMenuItem<String>(
                    value: 'Cancelled',
                    child: Text('Cancelled'),
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

  void _showFilteredRentals(BuildContext context, List rentals) {
    final snackBar = SnackBar(
      content: Text('Showing ${rentals.length} rentals'),
      duration: const Duration(seconds: 2),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
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
                        // Fixed: Navigate to detail page instead of showing snackbar
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RentalHistoryDetail(
                              rentalItem: rental,
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
