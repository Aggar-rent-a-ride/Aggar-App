import 'dart:convert';
import 'package:aggar/core/api/end_points.dart';
import 'package:aggar/features/vehicles_details/presentation/cubit/vehicle_favorite_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

class VehicleFavoriteCubit extends Cubit<VehicleFavoriteState> {
  VehicleFavoriteCubit() : super(const VehicleFavoriteInitial());

  Future<void> toggleFavorite(
      int vehicleId, bool isFavorite, String token) async {
    emit(XVehicleFavoriteLoading(isFavorite: isFavorite));
    try {
      final response = await http.put(
        Uri.parse(EndPoint.putFavourite),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: jsonEncode({
          'vehicleId': vehicleId,
          'isFavourite': isFavorite,
        }),
      );
      print(response.body);
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        emit(VehicleFavoriteSuccess(
          jsonResponse,
          isFavorite: isFavorite,
        ));
      } else {
        emit(VehicleFavoriteFailure(
          'Failed to update favorite status',
          isFavorite: isFavorite,
        ));
      }
    } catch (e) {
      emit(VehicleFavoriteFailure(
        'Error: $e',
        isFavorite: isFavorite,
      ));
    }
  }
}
