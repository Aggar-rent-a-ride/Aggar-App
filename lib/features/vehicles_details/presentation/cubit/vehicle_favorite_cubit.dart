import 'package:aggar/core/api/dio_consumer.dart';
import 'package:aggar/core/api/end_points.dart';
import 'package:aggar/features/vehicles_details/presentation/cubit/vehicle_favorite_state.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class VehicleFavoriteCubit extends Cubit<VehicleFavoriteState> {
  final DioConsumer dioConsumer = DioConsumer(dio: Dio());

  VehicleFavoriteCubit({bool initialFavorite = false})
      : super(VehicleFavoriteInitial(isFavorite: initialFavorite));

  Future<void> toggleFavorite(
      int vehicleId, bool isFavorite, String token) async {
    emit(VehicleFavoriteLoading(isFavorite: isFavorite));
    try {
      final response = await dioConsumer.put(
        EndPoint.putFavourite,
        data: {
          'vehicleId': vehicleId,
          'isFavourite': !isFavorite,
        },
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token'
          },
        ),
      );
      emit(VehicleFavoriteSuccess(
        response: response,
        isFavorite: !isFavorite,
      ));
    } catch (e) {
      emit(VehicleFavoriteFailure(
        e.toString(),
        isFavorite: isFavorite,
      ));
    }
  }
}
