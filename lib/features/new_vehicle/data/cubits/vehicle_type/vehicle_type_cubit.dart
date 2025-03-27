import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as dio;
import '../../../../../core/api/end_points.dart';
import 'vehicle_type_state.dart';

class VehicleTypeCubit extends Cubit<VehicleTypeState> {
  VehicleTypeCubit() : super(VehicleTypeInitial());
  final List<String> vehicleTypes = [];
  final List<int> vehicleTypeIds = [];
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
      final Map<String, dynamic> decodedJson = jsonDecode(response.body);
      if (decodedJson['statusCode'] == 200) {
        vehicleTypes.clear();
        vehicleTypeIds.clear();
        for (var item in decodedJson['data']) {
          vehicleTypes.add(item[ApiKey.vehicleTypeName]);
          vehicleTypeIds.add(item[ApiKey.vehicleTypeId]);
        }
        print(vehicleTypes);
        emit(VehicleTypeLoaded());
      } else {
        emit(VehicleTypeError(message: decodedJson['message']));
      }
      emit(VehicleTypeLoaded());
    } catch (error) {
      emit(VehicleTypeError(message: error.toString()));
    }
  }
}
