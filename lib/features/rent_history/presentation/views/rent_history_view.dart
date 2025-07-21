import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/features/rent_history/data/cubit/rent_history_cubit.dart';
import 'package:aggar/features/rent_history/data/cubit/rent_history_state.dart';
import 'package:aggar/features/rent_history/presentation/widgets/rent_history_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RentHistoryView extends StatelessWidget {
  const RentHistoryView({super.key, required this.isRenter});
  final bool isRenter;

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
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: context.theme.black100,
            size: 23,
          ),
        ),
        surfaceTintColor: Colors.transparent,
        centerTitle: false,
        backgroundColor: context.theme.white100_1,
        title: Text(
          'Rent History',
          style: AppStyles.semiBold24(
            context,
          ).copyWith(color: context.theme.black100),
        ),
        actions: [
          Builder(
            builder: (context) {
              return PopupMenuButton<String>(
                color: context.theme.white100_2,
                icon: const Icon(Icons.filter_list),
                onSelected: (value) {
                  final cubit = context.read<RentalHistoryCubit>();
                  cubit.filterRentals(value);
                },
                itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                  PopupMenuItem<String>(
                    value: 'all',
                    child: Row(
                      children: [
                        const Icon(Icons.all_inclusive, size: 18),
                        const SizedBox(width: 8),
                        Text(
                          'All Rentals',
                          style: AppStyles.bold16(context).copyWith(
                            color: context.theme.black100,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
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
                        Text(
                          'Confirmed',
                          style: AppStyles.bold16(context).copyWith(
                            color: context.theme.black100,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
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
                        Text(
                          'Not Started',
                          style: AppStyles.bold16(context).copyWith(
                            color: context.theme.black100,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
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
                        Text(
                          'Refunded',
                          style: AppStyles.bold16(context).copyWith(
                            color: context.theme.black100,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
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
      body: BlocListener<RentalHistoryCubit, RentalHistoryState>(
        listener: (context, state) {
          if (state is RentalHistoryRefundSuccess) {
            context.read<RentalHistoryCubit>().refreshRentalHistory();
          }
        },
        child: const RentHistoryBody(),
      ),
    );
  }
}
