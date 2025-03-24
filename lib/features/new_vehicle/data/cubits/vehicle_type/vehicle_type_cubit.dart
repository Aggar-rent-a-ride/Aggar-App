import 'dart:convert';

import 'package:aggar/features/new_vehicle/data/model/vehicle_type_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as dio;
import '../../../../../core/api/end_points.dart';
import 'vehicle_type_state.dart';

class VehicleTypeCubit extends Cubit<VehicleTypeState> {
  VehicleTypeCubit() : super(VehicleTypeInitial());
  final List<String> vehicletypes = [];
  Future<void> fetchVehicleTypes(String accessToken) async {
    try {
      // TODO : edit it with api comusmer but it not work man !!!!
      emit(VehicleTypeLoading());
      final response = await dio.get(
        Uri.parse(EndPoint.vehicleType),
        headers: {
          'Authorization': "Bearer $accessToken",
        },
      );
      print(response.body);
      final Map<String, dynamic> decodedJson = jsonDecode(response.body);
      if (decodedJson['statusCode'] == 200) {
        List<VehicleType> vehicleTypes = (decodedJson['data'] as List)
            .map((item) => VehicleType.fromJson(item))
            .toList();
        for (var vehicle in vehicleTypes) {
          vehicletypes.add(vehicle.name);
        }
      } else {
        emit(VehicleTypeError(message: decodedJson['message']));
      }
      emit(VehicleTypeLoaded());
      print(vehicletypes);
    } catch (error) {
      emit(VehicleTypeError(message: error.toString()));
    }
  }
}
