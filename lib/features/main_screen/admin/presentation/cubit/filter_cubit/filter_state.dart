part of 'filter_cubit.dart';

abstract class FilterState {}

class FilterInitial extends FilterState {}

class FilterToggleVisibility extends FilterState {
  final bool isVisible;

  FilterToggleVisibility(this.isVisible);
}

class FilterTypeSelected extends FilterState {
  final String? type;

  FilterTypeSelected(this.type);
}

class FilterStatusSelected extends FilterState {
  final String? status;

  FilterStatusSelected(this.status);
}

class FilterDateSelected extends FilterState {
  final String? date;

  FilterDateSelected(this.date);
}

class FilterSortingDirectionSelected extends FilterState {
  final String? sortingDirection;

  FilterSortingDirectionSelected(this.sortingDirection);
}

class FilterVehicleReset extends FilterState {}
