// search_cubit.dart
import 'package:aggar/core/api/dio_consumer.dart';
import 'package:aggar/core/api/end_points.dart';
import 'package:aggar/core/helper/handle_error.dart';
import 'package:aggar/features/main_screen/data/model/list_vehicle_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:aggar/features/main_screen/presentation/cubit/search_field/search_state.dart';

class SearchCubit extends Cubit<SearchCubitState> {
  final TextEditingController textController = TextEditingController();

  String query = '';
  final DioConsumer dioConsumer = DioConsumer(dio: Dio());
  bool isFilterVisible = true;
  int? selectedBrand;
  int? selectedType;
  String? selectedTransmission;
  String? selectedYear;
  double? minPrice;
  double? maxPrice;
  double? selectedRate;
  bool isBrandFilterSelected = false;
  bool isTypeFilterSelected = false;
  bool isTransmissionFilterSelected = false;
  bool isYearFilterSelected = false;
  bool isPriceFilterSelected = false;
  bool isRateFilterSelected = false;
  bool isNearestFilterSelected = false;

  SearchCubit() : super(SearchCubitInitial()) {
    textController.addListener(onTextChanged);
  }

  void onTextChanged() {
    if (textController.text != query) {
      updateQuery(textController.text);
    }
  }

  void updateQuery(String newQuery) {
    query = newQuery;
    if (query.isEmpty) {
      emit(SearchCubitEmpty());
      return;
    }
    fetchSearch();
  }

  void clearSearch() {
    textController.clear();
    query = '';
    resetFilters();
    emit(SearchCubitEmpty());
  }

  void resetFilters() {
    selectedBrand = null;
    selectedType = null;
    selectedTransmission = null;
    selectedYear = null;
    minPrice = null;
    maxPrice = null;

    isBrandFilterSelected = false;
    isTypeFilterSelected = false;
    isTransmissionFilterSelected = false;
    isYearFilterSelected = false;
    isPriceFilterSelected = false;
  }

  void toggleFilterVisibility() {
    isFilterVisible = !isFilterVisible;
    emit(SearchCubitToggleFilter(isFilterVisible));
  }

  void selectBrand(int? brand) {
    selectedBrand = brand;
    isBrandFilterSelected = brand != null;
    emit(SearchCubitBrandSelected(selectedBrand));
    fetchSearch();
  }

  void clearBrandFilter() {
    if (selectedBrand != null) {
      selectedBrand = null;
      isBrandFilterSelected = false;
      emit(SearchCubitBrandSelected(null));
      fetchSearch();
    }
  }

  bool isBrandSelected(int brand) {
    return selectedBrand == brand;
  }

  void selectType(int? type) {
    selectedType = type;
    isTypeFilterSelected = type != null;
    emit(SearchCubitTypeSelected(selectedType));
    fetchSearch();
  }

  void clearTypeFilter() {
    if (selectedType != null) {
      selectedType = null;
      isTypeFilterSelected = false;
      emit(SearchCubitTypeSelected(null));
      fetchSearch();
    }
  }

  bool isTypeSelected(int type) {
    return selectedType == type;
  }

  void selectTransmission(String? transmission) {
    selectedTransmission = transmission;
    isTransmissionFilterSelected = transmission != null;
    emit(SearchCubitTransmissionSelected(selectedTransmission));
    fetchSearch();
  }

  void clearTransmissionFilter() {
    if (selectedTransmission != null) {
      selectedTransmission = null;
      isTransmissionFilterSelected = false;
      emit(SearchCubitTransmissionSelected(null));
      fetchSearch();
    }
  }

  bool isTransmissionSelected(String transmission) {
    return selectedTransmission == transmission;
  }

  void selectYear(String? year) {
    selectedYear = year;
    isYearFilterSelected = year != null;
    emit(SearchCubitYearSelected(selectedYear));
    fetchSearch();
  }

  void clearYearFilter() {
    if (selectedYear != null) {
      selectedYear = null;
      isYearFilterSelected = false;
      emit(SearchCubitYearSelected(null));
      fetchSearch();
    }
  }

  bool isYearSelected(String year) {
    return selectedYear == year;
  }

  void selectRate(double? rate) {
    selectedRate = rate;
    isRateFilterSelected = rate != null;
    emit(SearchCubitRatingSelected(selectedRate));
    fetchSearch();
  }

  void clearRateFilter() {
    if (selectedRate != null) {
      selectedRate = null;
      isRateFilterSelected = false;
      emit(SearchCubitRatingSelected(null));
      fetchSearch();
    }
  }

  bool isRateSelected(double rate) {
    return selectedRate == rate;
  }

  void setPriceRange(double? min, double? max) {
    minPrice = min;
    maxPrice = max;
    isPriceFilterSelected = min != null || max != null;
    emit(SearchCubitPriceRangeSelected(minPrice, maxPrice));
    fetchSearch();
  }

  void clearPricingFilter() {
    if (maxPrice != null && minPrice != null) {
      maxPrice = null;
      minPrice = null;
      isPriceFilterSelected = false;
      emit(SearchCubitPriceRangeSelected(null, null));
      fetchSearch();
    }
  }

  void toggleNearestFilter() {
    isNearestFilterSelected = !isNearestFilterSelected;
    emit(SearchCubitNearestSelected(isNearestFilterSelected));
    fetchSearch();
  }

  void clearNearestFilter() {
    if (isNearestFilterSelected) {
      isNearestFilterSelected = false;
      emit(SearchCubitNearestSelected(false));
      fetchSearch();
    }
  }

  Future<void> fetchSearch() async {
    try {
      emit(SearchCubitLoading());
      final queryParams = {
        "pageSize": 10,
        "pageNo": 1,
        if (query.isNotEmpty) "query": query,
        if (selectedBrand != null) "brandId": selectedBrand,
        if (selectedType != null) "typeId": selectedType,
        if (selectedYear != null) "year": selectedYear,
        if (selectedTransmission != null) "transmission": selectedTransmission,
        if (minPrice != null) "minPrice": minPrice,
        if (maxPrice != null) "maxPrice": maxPrice,
        if (query != "") "searchKey": query,
        if (isNearestFilterSelected == true)
          "byNearest": isNearestFilterSelected,
        if (isNearestFilterSelected == true) "latitude": "30.510187246065026",
        if (isNearestFilterSelected == true) "longitude": "31.352178770683253"
        // TODO : the real location of the user
      };

      final response = await dioConsumer.get(EndPoint.getVehicles,
          queryParameters: queryParams,
          options: Options(headers: {
            'Authorization':
                'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMDc4IiwianRpIjoiMTljOTkwYWMtYzM0NS00MjVhLTkzZjYtZGY4ZWMwNjA3YjRiIiwidXNlcm5hbWUiOiJlc3JhYTEyIiwidWlkIjoiMTA3OCIsInJvbGVzIjpbIlVzZXIiLCJDdXN0b21lciJdLCJleHAiOjE3NDcyOTUwNTUsImlzcyI6IkFnZ2FyQXBpIiwiYXVkIjoiRmx1dHRlciJ9.XIH71CN-FVrFy3ofOwAJ8bM7wT51VV23j5cFpTNtP38',
          }));

      final responseData = response as Map<String, dynamic>;
      final vehicles = ListVehicleModel.fromJson(responseData);

      emit(SearchCubitLoaded(vehicles: vehicles));
    } catch (error) {
      String errorMessage = handleSearchError(error);
      emit(SearchCubitError(message: errorMessage));
    }
  }

  @override
  Future<void> close() {
    textController.removeListener(onTextChanged);
    textController.dispose();
    return super.close();
  }
}
