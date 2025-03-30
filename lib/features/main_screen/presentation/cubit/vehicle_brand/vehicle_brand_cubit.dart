import 'dart:convert';

import 'package:aggar/features/main_screen/presentation/cubit/vehicle_brand/vehicle_brand_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as dio;
import '../../../../../core/api/end_points.dart';

class VehicleBrandCubit extends Cubit<VehicleBrandState> {
  VehicleBrandCubit() : super(VehicleBrandInitial());
  final List<String> vehicleBrands = [];
  final List<int> vehicleBrandIds = [];
  final List<String> vehicleBrandLogoPaths = [];
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
        print(vehicleBrands);
        print(vehicleBrandLogoPaths);
        emit(VehicleBrandLoaded());
      } else {
        emit(VehicleBrandError(message: decodedJson['message']));
      }
    } catch (error) {
      emit(VehicleBrandError(message: error.toString()));
    }
  }
}
