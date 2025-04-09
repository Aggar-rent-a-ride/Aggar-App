import 'dart:convert';
import 'package:aggar/features/discount/presentation/cubit/discount_state.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DiscountCubit extends Cubit<DiscountState> {
  DiscountCubit() : super(DiscountInitial());

  Future<void> updateVehicleDiscounts() async {
    emit(DiscountLoading());

    try {
      Dio dio = Dio();
      final response = await dio.put(
        "https://aggarapi.runasp.net/api/vehicle/vehicle-discounts",
        data: jsonEncode(
          {
            "vehicleId": 1,
            "discounts": [
              {
                "daysRequired": 0,
                "discountPercentage": 0,
              },
              {
                "daysRequired": 0,
                "discountPercentage": 0,
              },
            ],
          },
        ),
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
        ),
      );

      emit(DiscountSuccess(response));
    } catch (e) {
      emit(DiscountFailure('Error: $e'));
    }
  }
}
