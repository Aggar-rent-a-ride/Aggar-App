import 'dart:convert';

import 'package:aggar/features/new_vehicle/data/cubits/vehicle_brand/vehicle_brand_state.dart';
import 'package:aggar/features/new_vehicle/data/model/vehicle_brand_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as dio;
import '../../../../../core/api/end_points.dart';

class VehicleBrandCubit extends Cubit<VehicleBrandState> {
  VehicleBrandCubit() : super(VehicleBrandInitial());
  final List<String> vehicleBrands = [];
  final List<int> vehicleBrandIds = [];

  Future<void> fetchVehicleBrands(String accessToken) async {
    try {
      // TODO : Edit this with API consumer but it not working, man!!!
      emit(VehicleBrandLoading());
      final response = await dio.get(
        Uri.parse(EndPoint.vehicleBrand),
        headers: {
          'Authorization': "Bearer $accessToken",
        },
      );
      // print(response.body);
      final Map<String, dynamic> decodedJson = jsonDecode(response.body);
      if (decodedJson['statusCode'] == 200) {
        List<VehicleBrand> vehicleBrandsData = (decodedJson['data'] as List)
            .map((item) => VehicleBrand.fromJson(item))
            .toList();
        for (var vehicle in vehicleBrandsData) {
          vehicleBrands.add(vehicle.name);
          vehicleBrandIds.add(vehicle.id);
        }
        emit(VehicleBrandLoaded());
        print(vehicleBrands);
      } else {
        emit(VehicleBrandError(message: decodedJson['message']));
      }
    } catch (error) {
      emit(VehicleBrandError(message: error.toString()));
    }
  }
}
