import 'package:aggar/features/rent_history/data/models/rental_history_models.dart';

abstract class RentalHistoryState {}

class RentalHistoryInitial extends RentalHistoryState {}

class RentalHistoryLoading extends RentalHistoryState {}

class RentalHistoryLoaded extends RentalHistoryState {
  final List<RentalHistoryItem> rentals;
  final int currentPage;
  final bool hasMoreData;

  RentalHistoryLoaded({
    required this.rentals,
    required this.currentPage,
    required this.hasMoreData,
  });
}

class RentalHistoryError extends RentalHistoryState {
  final String message;

  RentalHistoryError({required this.message});
}

// New refund-specific states
class RentalHistoryRefundLoading extends RentalHistoryState {}

class RentalHistoryRefundSuccess extends RentalHistoryState {
  final String message;

  RentalHistoryRefundSuccess({required this.message});
}

class RentalHistoryRefundError extends RentalHistoryState {
  final String message;

  RentalHistoryRefundError({required this.message});
}
