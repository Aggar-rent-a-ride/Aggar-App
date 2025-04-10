import 'package:aggar/core/api/end_points.dart';
import 'package:aggar/features/discount/presentation/cubit/discount_state.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DiscountCubit extends Cubit<DiscountState> {
  late Dio dio;
  DiscountCubit() : super(DiscountInitial()) {
    dio = Dio(BaseOptions(
      headers: {
        'Authorization':
            'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMDYzIiwianRpIjoiZGE3MDBkMTUtNWI1Yy00OWM1LTgzOWQtZmNlYTZjZGYzMzBiIiwidXNlcm5hbWUiOiJlc3JhYXRlc3QxMiIsInVpZCI6IjEwNjMiLCJyb2xlcyI6WyJVc2VyIiwiUmVudGVyIl0sImV4cCI6MTc0NDMyNDM5MSwiaXNzIjoiQWdnYXJBcGkiLCJhdWQiOiJGbHV0dGVyIn0.U-P9W6fP6kNuO_3_SFAlT6AwnpRmcW-2u_J5M9FILsE',
      },
      responseType: ResponseType.json,
    ));
  }

  TextEditingController daysRequired = TextEditingController();
  TextEditingController discountPercentage = TextEditingController();

  Future<void> addDiscount(String id) async {
    emit(DiscountLoading());
    try {
      final data = {
        "vehicleId": id,
        "discounts": [
          {
            "daysRequired": int.tryParse(daysRequired.text) ?? 0,
            "discountPercentage":
                double.tryParse(discountPercentage.text) ?? 0.0,
          }
        ]
      };
      final response = await dio.put(
        EndPoint.vehicleDiscount,
        data: data,
        options: Options(
          contentType: 'application/json',
          validateStatus: (status) {
            return status! < 500;
          },
        ),
      );
      if (response.statusCode == 200) {
        emit(DiscountSuccess(response.data));
      } else {
        emit(DiscountFailure("Error: ${response.statusCode}"));
      }
    } catch (e) {
      emit(DiscountFailure('Error: $e'));
    }
  }
}
