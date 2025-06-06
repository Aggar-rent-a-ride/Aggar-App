import 'package:aggar/core/api/dio_consumer.dart';
import 'package:aggar/core/api/end_points.dart';
import 'package:aggar/features/vehicle_brand_with_type/data/model/list_vehicle_brand_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'admin_vehicle_brand_state.dart';

class AdminVehicleBrandCubit extends Cubit<AdminVehicleBrandState> {
  AdminVehicleBrandCubit() : super(AdminVehicleBrandInitial());
  final DioConsumer dioConsumer = DioConsumer(dio: Dio());

  Future<void> fetchVehicleBrands(String accessToken) async {
    try {
      emit(AdminVehicleBrandLoading());
      final response = await dioConsumer.get(
        EndPoint.vehicleBrand,
        options: Options(
          headers: {
            'Authorization': 'Bearer $accessToken',
          },
        ),
      );
      final vehilceBrandList = ListVehicleBrandModel.fromJson(response);
      emit(AdminVehicleBrandLoaded(listVehicleBrandModel: vehilceBrandList));
    } catch (error) {
      emit(AdminVehicleBrandError(message: error.toString()));
    }
  }
}
