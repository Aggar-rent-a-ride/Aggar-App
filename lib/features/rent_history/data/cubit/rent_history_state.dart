import 'package:aggar/features/rent_history/data/models/rental_history_models.dart';

abstract class RentalHistoryState {}

class RentalHistoryInitial extends RentalHistoryState {}

class RentalHistoryLoading extends RentalHistoryState {}

class RentalHistoryLoaded extends RentalHistoryState {
  final List<RentalHistoryItem> rentals; // All rentals from API
  final List<RentalHistoryItem>?
      displayedRentals; // Filtered rentals for display
  final int currentPage;
  final bool hasMoreData;
  final String activeFilter; // Current active filter

  RentalHistoryLoaded({
    required this.rentals,
    this.displayedRentals,
    required this.currentPage,
    required this.hasMoreData,
    this.activeFilter = 'all',
  });

  // Helper method to get the rentals that should be displayed
  List<RentalHistoryItem> get effectiveRentals => displayedRentals ?? rentals;

  // Check if a filter is currently active
  bool get hasActiveFilter => activeFilter != 'all';

  // Get the count of filtered rentals
  int get filteredCount => displayedRentals?.length ?? rentals.length;

  // Create a copy with updated values
  RentalHistoryLoaded copyWith({
    List<RentalHistoryItem>? rentals,
    List<RentalHistoryItem>? displayedRentals,
    int? currentPage,
    bool? hasMoreData,
    String? activeFilter,
  }) {
    return RentalHistoryLoaded(
      rentals: rentals ?? this.rentals,
      displayedRentals: displayedRentals ?? this.displayedRentals,
      currentPage: currentPage ?? this.currentPage,
      hasMoreData: hasMoreData ?? this.hasMoreData,
      activeFilter: activeFilter ?? this.activeFilter,
    );
  }
}

class RentalHistoryError extends RentalHistoryState {
  final String message;

  RentalHistoryError({required this.message});
}

// Refund-specific states
class RentalHistoryRefundLoading extends RentalHistoryState {}

class RentalHistoryRefundSuccess extends RentalHistoryState {
  final String message;

  RentalHistoryRefundSuccess({required this.message});
}

class RentalHistoryRefundError extends RentalHistoryState {
  final String message;

  RentalHistoryRefundError({required this.message});
}
