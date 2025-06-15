import 'dart:convert';
import 'package:aggar/core/api/dio_consumer.dart';
import 'package:aggar/features/main_screen/customer/presentation/cubit/vehicle_brand/vehicle_brand_state.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as dio;
import '../../../../../../core/api/end_points.dart';
import '../../../data/model/list_vehicle_model.dart';
import '../../../data/model/vehicle_model.dart';

class VehicleBrandCubit extends Cubit<VehicleBrandState> {
  VehicleBrandCubit() : super(VehicleBrandInitial());
  final DioConsumer dioConsumer = DioConsumer(dio: Dio());
  final List<String> vehicleBrands = [];
  final List<int> vehicleBrandIds = [];
  final List<String> vehicleBrandLogoPaths = [];
  bool isLoadingMoreAll = false;
  int currentPageAll = 1;
  int totalPagesAll = 1;
  List<VehicleModel> _allVehicles = [];
  List<VehicleModel> get allVehicles => List.unmodifiable(_allVehicles);

  void resetAllVehicles() {
    _allVehicles.clear();
    currentPageAll = 1;
    totalPagesAll = 1;
    isLoadingMoreAll = false;
  }

  void loadMoreVehicles(String accessToken, int brand) async {
    if (isLoadingMoreAll || currentPageAll >= totalPagesAll) return;
    fetchVehicleBrand(accessToken, brand, isLoadMore: true);
  }

  Future<void> fetchVehicleBrands(String accessToken) async {
    try {
      emit(VehicleBrandLoading());
      final response = await dio.get(
        Uri.parse(EndPoint.vehicleBrand),
        headers: {
          'Authorization': "Bearer $accessToken",
        },
      );
      final Map<String, dynamic> decodedJson = jsonDecode(response.body);
      if (decodedJson['statusCode'] == 200) {
        vehicleBrands.clear();
        vehicleBrandIds.clear();
        vehicleBrandLogoPaths.clear();
        for (var item in decodedJson['data']) {
          vehicleBrands.add(item[ApiKey.vehicleBrandName]);
          vehicleBrandIds.add(item[ApiKey.vehicleBrandId]);
          if (item[ApiKey.vehicleBrandLogo] != null) {
            vehicleBrandLogoPaths.add(item[ApiKey.vehicleBrandLogo]);
          } else {
            vehicleBrandLogoPaths.add("null");
          }
        }
        emit(VehicleLoadedBrand());
      }
    } catch (error) {
      emit(VehicleBrandError(message: error.toString()));
    }
  }

  Future<void> fetchVehicleBrand(String accessToken, int brand,
      {bool isLoadMore = false, int? page}) async {
    final targetPage = page ?? (isLoadMore ? currentPageAll + 1 : 1);
    if (isLoadMore && isLoadingMoreAll) return;
    if (isLoadMore && targetPage > totalPagesAll) return;

    try {
      if (!isLoadMore) {
        emit(VehicleBrandLoading());
        resetAllVehicles();
      } else {
        isLoadingMoreAll = true;
        emit(VehicleBrandLoadingMore(
          vehicles:
              ListVehicleModel(data: _allVehicles, totalPages: totalPagesAll),
        ));
      }

      final response = await dioConsumer.get(
        EndPoint.getVehicles,
        queryParameters: {
          "brandId": brand,
          "pageNo": targetPage,
          "pageSize": 10
        },
        options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
      );

      final vehicles = ListVehicleModel.fromJson(response);

      if (isLoadMore) {
        _allVehicles.addAll(vehicles.data);
      } else {
        _allVehicles = List.from(vehicles.data);
      }

      if (_allVehicles.length > 50) {
        _allVehicles.removeRange(0, _allVehicles.length - 50);
      }

      currentPageAll = targetPage;
      totalPagesAll = vehicles.totalPages ?? 1;

      emit(VehicleLoadedBrand(
        vehicles: ListVehicleModel(
          data: _allVehicles,
          totalPages: totalPagesAll,
        ),
      ));
      return;
    } finally {
      if (isLoadMore) {
        isLoadingMoreAll = false;
      }
    }
  }
}
