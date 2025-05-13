// search_state.dart
import 'package:aggar/features/main_screen/data/model/list_vehicle_model.dart';

abstract class SearchCubitState {}

class SearchCubitInitial extends SearchCubitState {}

class SearchCubitLoading extends SearchCubitState {}

class SearchCubitToggleFilter extends SearchCubitState {
  final bool isFilterVisible;
  SearchCubitToggleFilter(this.isFilterVisible);
}

class SearchCubitEmpty extends SearchCubitState {}

class SearchCubitLoaded extends SearchCubitState {
  final ListVehicleModel vehicles;
  final bool canLoadMore;
  final int currentPage;
  final int totalPages;

  SearchCubitLoaded({
    required this.vehicles,
    this.canLoadMore = false,
    this.currentPage = 1,
    this.totalPages = 1,
  });
}

class SearchCubitError extends SearchCubitState {
  final String message;

  SearchCubitError({required this.message});
}

// Filter-specific states
class SearchCubitBrandSelected extends SearchCubitState {
  final int? selectedBrand;

  SearchCubitBrandSelected(this.selectedBrand);
}

class SearchCubitTypeSelected extends SearchCubitState {
  final int? selectedType;

  SearchCubitTypeSelected(this.selectedType);
}

class SearchCubitTransmissionSelected extends SearchCubitState {
  final String? selectedTransmission;

  SearchCubitTransmissionSelected(this.selectedTransmission);
}

class SearchCubitPriceRangeSelected extends SearchCubitState {
  final double? minPrice;
  final double? maxPrice;

  SearchCubitPriceRangeSelected(this.minPrice, this.maxPrice);
}

class SearchCubitYearSelected extends SearchCubitState {
  final String? selectedYear;

  SearchCubitYearSelected(this.selectedYear);
}
