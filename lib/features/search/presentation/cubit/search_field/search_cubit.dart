import 'package:aggar/core/api/dio_consumer.dart';
import 'package:aggar/core/api/end_points.dart';
import 'package:aggar/core/helper/handle_error.dart';
import 'package:aggar/features/main_screen/customer/data/model/list_vehicle_model.dart';
import 'package:aggar/features/new_vehicle/data/model/location_model.dart';
import 'package:aggar/features/search/presentation/cubit/search_field/search_state.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchCubit extends Cubit<SearchCubitState> {
  final TextEditingController textController = TextEditingController();
  final DioConsumer dioConsumer = DioConsumer(dio: Dio());

  String query = '';
  String? accessToken;
  bool isFilterVisible = true;
  int? selectedBrand;
  int? selectedType;
  String? selectedTransmission;
  String? selectedYear;
  double? minPrice;
  double? maxPrice;
  double? selectedRate;
  String? selectedStatus;
  int? statusCount;
  bool isBrandFilterSelected = false;
  bool isTypeFilterSelected = false;
  bool isTransmissionFilterSelected = false;
  bool isYearFilterSelected = false;
  bool isPriceFilterSelected = false;
  bool isRateFilterSelected = false;
  bool isNearestFilterSelected = false;
  bool isStatusFilterSelected = false;
  int currentPage = 1;
  int totalPages = 1;
  bool isLoadingMore = false;
  LocationModel? currentLocation;
  String? currentAddress;

  SearchCubit({this.accessToken}) : super(SearchCubitInitial()) {
    textController.addListener(onTextChanged);
  }

  void setAccessToken(String token) {
    accessToken = token;
  }

  void setLocation(LocationModel? location, [String? address]) {
    currentLocation = location;
    currentAddress = address;
    if (location != null) {
      print("Current Location: ${location.latitude}, ${location.longitude}");
      print("Address: $address");
    }
    if (isNearestFilterSelected) {
      fetchSearch(pageNo: 1);
    }
    emit(SearchCubitNearestSelected(isNearestFilterSelected));
  }

  void onTextChanged() {
    if (textController.text != query) {
      updateQuery(textController.text);
    }
  }

  void updateQuery(String newQuery) {
    query = newQuery;
    currentPage = 1; // Reset to first page on new query
    if (query.isEmpty) {
      emit(SearchCubitEmpty());
      return;
    }
    fetchSearch(pageNo: 1);
  }

  void clearSearch() {
    textController.clear();
    query = '';
    currentPage = 1;
    totalPages = 1;
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
    selectedRate = null;
    statusCount = null;
    currentPage = 1;
    totalPages = 1;
    isBrandFilterSelected = false;
    isTypeFilterSelected = false;
    isTransmissionFilterSelected = false;
    isYearFilterSelected = false;
    isPriceFilterSelected = false;
    isRateFilterSelected = false;
    isNearestFilterSelected = false;
    isStatusFilterSelected = false;
  }

  void toggleFilterVisibility() {
    isFilterVisible = !isFilterVisible;
    emit(SearchCubitToggleFilter(isFilterVisible));
  }

  void selectBrand(int? brand) {
    selectedBrand = brand;
    isBrandFilterSelected = brand != null;
    currentPage = 1;
    emit(SearchCubitBrandSelected(selectedBrand));
    fetchSearch(pageNo: 1);
  }

  void clearBrandFilter() {
    if (selectedBrand != null) {
      selectedBrand = null;
      isBrandFilterSelected = false;
      currentPage = 1;
      emit(SearchCubitBrandSelected(null));
      fetchSearch(pageNo: 1);
    }
  }

  bool isBrandSelected(int brand) {
    return selectedBrand == brand;
  }

  void selectType(int? type) {
    selectedType = type;
    isTypeFilterSelected = type != null;
    currentPage = 1;
    emit(SearchCubitTypeSelected(selectedType));
    fetchSearch(pageNo: 1);
  }

  void clearTypeFilter() {
    if (selectedType != null) {
      selectedType = null;
      isTypeFilterSelected = false;
      currentPage = 1;
      emit(SearchCubitTypeSelected(null));
      fetchSearch(pageNo: 1);
    }
  }

  bool isTypeSelected(int type) {
    return selectedType == type;
  }

  void selectTransmission(String? transmission) {
    selectedTransmission = transmission;
    isTransmissionFilterSelected = transmission != null;
    currentPage = 1;
    emit(SearchCubitTransmissionSelected(selectedTransmission));
    fetchSearch(pageNo: 1);
  }

  void clearTransmissionFilter() {
    if (selectedTransmission != null) {
      selectedTransmission = null;
      isTransmissionFilterSelected = false;
      currentPage = 1;
      emit(SearchCubitTransmissionSelected(null));
      fetchSearch(pageNo: 1);
    }
  }

  bool isTransmissionSelected(String transmission) {
    return selectedTransmission == transmission;
  }

  void selectYear(String? year) {
    selectedYear = year;
    isYearFilterSelected = year != null;
    currentPage = 1;
    emit(SearchCubitYearSelected(selectedYear));
    fetchSearch(pageNo: 1);
  }

  void clearYearFilter() {
    selectedYear = null;
    isYearFilterSelected = false;
    currentPage = 1;
    emit(SearchCubitYearSelected(null));
    fetchSearch(pageNo: 1);
  }

  bool isYearSelected(String year) {
    return selectedYear == year;
  }

  void selectRate(double? rate) {
    selectedRate = rate;
    isRateFilterSelected = rate != null;
    currentPage = 1;
    emit(SearchCubitRatingSelected(selectedRate));
    fetchSearch(pageNo: 1);
  }

  void clearRateFilter() {
    if (selectedRate != null) {
      selectedRate = null;
      isRateFilterSelected = false;
      currentPage = 1;
      emit(SearchCubitRatingSelected(null));
      fetchSearch(pageNo: 1);
    }
  }

  bool isRateSelected(double rate) {
    return selectedRate == rate;
  }

  void setPriceRange(double? min, double? max) {
    minPrice = min;
    maxPrice = max;
    isPriceFilterSelected = min != null || max != null;
    currentPage = 1;
    emit(SearchCubitPriceRangeSelected(minPrice, maxPrice));
    fetchSearch(pageNo: 1);
  }

  void clearPricingFilter() {
    if (maxPrice != null || minPrice != null) {
      maxPrice = null;
      minPrice = null;
      isPriceFilterSelected = false;
      currentPage = 1;
      emit(SearchCubitPriceRangeSelected(null, null));
      fetchSearch(pageNo: 1);
    }
  }

  void toggleNearestFilter() {
    isNearestFilterSelected = !isNearestFilterSelected;
    currentPage = 1;

    if (!isNearestFilterSelected) {
      currentLocation = null;
    }
    emit(SearchCubitNearestSelected(isNearestFilterSelected));
    fetchSearch(pageNo: 1);
  }

  void clearNearestFilter() {
    if (isNearestFilterSelected) {
      isNearestFilterSelected = false;
      currentLocation = null;
      currentPage = 1;
      emit(SearchCubitNearestSelected(false));
      fetchSearch(pageNo: 1);
    }
  }

  void selectStatus(String? status) {
    selectedBrand = null;
    selectedType = null;
    selectedTransmission = null;
    selectedYear = null;
    minPrice = null;
    maxPrice = null;
    selectedRate = null;
    query = '';
    textController.clear();
    isBrandFilterSelected = false;
    isTypeFilterSelected = false;
    isTransmissionFilterSelected = false;
    isYearFilterSelected = false;
    isPriceFilterSelected = false;
    isRateFilterSelected = false;
    isNearestFilterSelected = false;
    selectedStatus = status;
    isStatusFilterSelected = status != null;
    currentPage = 1;
    totalPages = 1;
    emit(SearchCubitFiltersReset());
    emit(SearchCubitStatusSelected(selectedStatus));

    if (selectedStatus != null) {
      fetchStatusCount();
    } else {
      statusCount = null;
    }

    fetchSearch(pageNo: 1);
  }

  void clearStatusFilter() {
    if (selectedStatus != null) {
      selectedStatus = null;
      isStatusFilterSelected = false;
      statusCount = null;
      currentPage = 1;
      emit(SearchCubitStatusSelected(null));
      fetchSearch(pageNo: 1);
    }
  }

  bool isStatusSelected(String status) {
    return selectedStatus == status;
  }

  Future<void> fetchSearch({required int pageNo}) async {
    if (accessToken == null) {
      emit(
          SearchCubitError(message: 'Access token is missing. Please log in.'));
      return;
    }

    try {
      emit(pageNo == 1
          ? SearchCubitLoading()
          : SearchCubitLoaded(
              vehicles: ListVehicleModel(data: [], totalPages: totalPages),
              statusCount: statusCount,
              canLoadMore: currentPage < totalPages,
              currentPage: currentPage,
              totalPages: totalPages,
            ));

      final queryParams = {
        "pageSize": 10,
        "pageNo": pageNo,
        if (query.isNotEmpty) "query": query,
        if (selectedBrand != null) "brandId": selectedBrand,
        if (selectedType != null) "typeId": selectedType,
        if (selectedYear != null) "year": selectedYear,
        if (selectedTransmission != null) "transmission": selectedTransmission,
        if (minPrice != null) "minPrice": minPrice,
        if (maxPrice != null) "maxPrice": maxPrice,
        if (query.isNotEmpty) "searchKey": query,
        if (selectedStatus != null) "status": selectedStatus,
        if (isNearestFilterSelected) "byNearest": isNearestFilterSelected,
        if (isNearestFilterSelected && currentLocation != null)
          "latitude": currentLocation!.latitude,
        if (isNearestFilterSelected && currentLocation != null)
          "longitude": currentLocation!.longitude,
      };

      final endpoint = selectedStatus != null
          ? EndPoint.getVehiclesByStatus
          : EndPoint.getVehicles;

      final response = await dioConsumer.get(
        endpoint,
        queryParameters: queryParams,
        options: Options(headers: {
          'Authorization': 'Bearer $accessToken',
        }),
      );

      final responseData = response as Map<String, dynamic>;
      final vehicles = ListVehicleModel.fromJson(responseData);

      currentPage = pageNo;
      totalPages = vehicles.totalPages ?? 1;

      emit(SearchCubitLoaded(
        vehicles: vehicles,
        statusCount: statusCount,
        canLoadMore: currentPage < totalPages,
        currentPage: currentPage,
        totalPages: totalPages,
      ));
    } catch (error) {
      String errorMessage = handleError(error);
      emit(SearchCubitError(message: errorMessage));
    }
  }

  Future<void> loadMore() async {
    if (isLoadingMore || currentPage >= totalPages) return;

    isLoadingMore = true;
    try {
      final queryParams = {
        "pageSize": 10,
        "pageNo": currentPage + 1,
        if (query.isNotEmpty) "query": query,
        if (selectedBrand != null) "brandId": selectedBrand,
        if (selectedType != null) "typeId": selectedType,
        if (selectedYear != null) "year": selectedYear,
        if (selectedTransmission != null) "transmission": selectedTransmission,
        if (minPrice != null) "minPrice": minPrice,
        if (maxPrice != null) "maxPrice": maxPrice,
        if (query.isNotEmpty) "searchKey": query,
        if (selectedStatus != null) "status": selectedStatus,
        if (isNearestFilterSelected) "byNearest": isNearestFilterSelected,
        if (isNearestFilterSelected && currentLocation != null)
          "latitude": currentLocation!.latitude,
        if (isNearestFilterSelected && currentLocation != null)
          "longitude": currentLocation!.longitude,
      };

      final endpoint = selectedStatus != null
          ? EndPoint.getVehiclesByStatus
          : EndPoint.getVehicles;

      final response = await dioConsumer.get(
        endpoint,
        queryParameters: queryParams,
        options: Options(headers: {
          'Authorization': 'Bearer $accessToken',
        }),
      );

      final responseData = response as Map<String, dynamic>;
      final newVehicles = ListVehicleModel.fromJson(responseData);

      // Merge new vehicles with existing ones
      final currentVehicles = (state is SearchCubitLoaded)
          ? (state as SearchCubitLoaded).vehicles
          : ListVehicleModel(data: [], totalPages: totalPages);
      final updatedVehicles = ListVehicleModel(
        data: [...currentVehicles.data, ...newVehicles.data],
        totalPages: newVehicles.totalPages,
      );

      currentPage += 1;
      totalPages = newVehicles.totalPages ?? totalPages;

      emit(SearchCubitLoaded(
        vehicles: updatedVehicles,
        statusCount: statusCount,
        canLoadMore: currentPage < totalPages,
        currentPage: currentPage,
        totalPages: totalPages,
      ));
    } catch (error) {
      String errorMessage = handleError(error);
      emit(SearchCubitError(message: errorMessage));
    } finally {
      isLoadingMore = false;
    }
  }

  Future<void> fetchStatusCount() async {
    if (accessToken == null) {
      emit(
          SearchCubitError(message: 'Access token is missing. Please log in.'));
      return;
    }

    try {
      final queryParams = {
        if (selectedStatus != null) "status": selectedStatus,
      };
      final response = await dioConsumer.get(
        EndPoint.statusCount,
        queryParameters: queryParams,
        options: Options(
          headers: {
            'Authorization': 'Bearer $accessToken',
          },
        ),
      );

      final responseData = response as Map<String, dynamic>;
      statusCount = responseData['data'] as int?;
      emit(SearchCubitStatusCount(statusCount));
    } catch (error) {
      String errorMessage = handleError(error);
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
