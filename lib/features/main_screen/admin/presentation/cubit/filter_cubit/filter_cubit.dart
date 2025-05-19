import 'package:flutter_bloc/flutter_bloc.dart';

part 'filter_state.dart';

class FilterCubit extends Cubit<FilterState> {
  FilterCubit() : super(FilterInitial());

  bool isFilterVisible = true;
  String? selectedType;
  String? selectedStatus;
  String? selectedDate;
  String? selectedSortingDirection;
  bool isTypeFilterSelected = false;
  bool isStatusFilterSelected = false;
  bool isDateFilterSelected = false;
  bool isSortingDirectionFilterSelected = false;

  final List<String> reportTypes = [
    'Message',
    'CustomerReview',
    'RenterReview',
    'AppUser',
    'Vehicle',
    'Booking',
    'Rental'
  ];

  void resetFilters() {
    selectedType = null;
    selectedStatus = null;
    selectedDate = null;
    selectedSortingDirection = null;

    isTypeFilterSelected = false;
    isStatusFilterSelected = false;
    isDateFilterSelected = false;
    isSortingDirectionFilterSelected = false;
    emit(FilterReset());
  }

  void toggleFilterVisibility() {
    isFilterVisible = !isFilterVisible;
    emit(FilterToggleVisibility(isFilterVisible));
  }

  void selectType(String? type) {
    selectedType = type;
    isTypeFilterSelected = type != null;
    emit(FilterTypeSelected(selectedType));
  }

  void clearTypeFilter() {
    if (selectedType != null) {
      selectedType = null;
      isTypeFilterSelected = false;
      emit(FilterTypeSelected(null));
    }
  }

  bool isTypeSelected(String type) {
    return selectedType == type;
  }

  void selectStatus(String? status) {
    selectedStatus = status;
    isStatusFilterSelected = status != null;
    emit(FilterStatusSelected(selectedStatus));
  }

  void clearStatusFilter() {
    if (selectedStatus != null) {
      selectedStatus = null;
      isStatusFilterSelected = false;
      emit(FilterStatusSelected(null));
    }
  }

  bool isStatusSelected(String status) {
    return selectedStatus == status;
  }

  void selectDate(String? date) {
    selectedDate = date;
    isDateFilterSelected = date != null;
    emit(FilterDateSelected(selectedDate));
  }

  void clearDateFilter() {
    if (selectedDate != null) {
      selectedDate = null;
      isDateFilterSelected = false;
      emit(FilterDateSelected(null));
    }
  }

  bool isDateSelected(String date) {
    return selectedDate == date;
  }

  void selectSortingDirection(String? sortingDirection) {
    selectedSortingDirection = sortingDirection;
    isSortingDirectionFilterSelected = sortingDirection != null;
    emit(FilterSortingDirectionSelected(selectedSortingDirection));
  }

  void clearSortingDirectionFilter() {
    if (selectedSortingDirection != null) {
      selectedSortingDirection = null;
      isSortingDirectionFilterSelected = false;
      emit(FilterSortingDirectionSelected(null));
    }
  }

  bool isSortingDirectionSelected(String sortingDirection) {
    return selectedSortingDirection == sortingDirection;
  }
}
