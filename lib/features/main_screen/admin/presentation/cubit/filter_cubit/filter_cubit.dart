import 'package:flutter_bloc/flutter_bloc.dart';

part 'filter_state.dart';

class FilterCubit extends Cubit<FilterState> {
  FilterCubit() : super(FilterInitial());

  bool isFilterVisible = true;
  String? selectedType;
  String? selectedStatus;
  String? selectedDate;
  String? selectedSortingDirection;

  final List<String> reportTypes = [
    'Message',
    'CustomerReview',
    'RenterReview',
    'AppUser',
    'Vehicle',
  ];

  void resetFilters() {
    selectedType = null;
    selectedStatus = null;
    selectedDate = null;
    selectedSortingDirection = null;
    emit(FilterVehicleReset());
  }

  void toggleFilterVisibility() {
    isFilterVisible = !isFilterVisible;
    emit(FilterToggleVisibility(isFilterVisible));
  }

  void selectType(String? type) {
    selectedType = type;
    emit(FilterTypeSelected(type));
  }

  void clearTypeFilter() {
    if (selectedType != null) {
      selectedType = null;
      emit(FilterTypeSelected(null));
    }
  }

  bool isTypeSelected(String type) => selectedType == type;

  void selectStatus(String? status) {
    selectedStatus = status;
    emit(FilterStatusSelected(status));
  }

  void clearStatusFilter() {
    if (selectedStatus != null) {
      selectedStatus = null;
      emit(FilterStatusSelected(null));
    }
  }

  bool isStatusSelected(String status) => selectedStatus == status;

  void selectDate(String? date) {
    selectedDate = date;
    emit(FilterDateSelected(date));
  }

  void clearDateFilter() {
    if (selectedDate != null) {
      selectedDate = null;
      emit(FilterDateSelected(null));
    }
  }

  bool isDateSelected(String date) => selectedDate == date;

  void selectSortingDirection(String? sortingDirection) {
    selectedSortingDirection = sortingDirection;
    emit(FilterSortingDirectionSelected(sortingDirection));
  }

  void clearSortingDirectionFilter() {
    if (selectedSortingDirection != null) {
      selectedSortingDirection = null;
      emit(FilterSortingDirectionSelected(null));
    }
  }

  bool isSortingDirectionSelected(String sortingDirection) =>
      selectedSortingDirection == sortingDirection;
}
