import 'package:aggar/core/api/end_points.dart';
import 'package:aggar/features/discount/presentation/cubit/discount_state.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DiscountCubit extends Cubit<DiscountState> {
  late Dio dio;
  List<DiscountItem> discounts = [];

  DiscountCubit() : super(DiscountInitial()) {
    dio = Dio(BaseOptions(
      headers: {
        'Authorization':
            'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIyMCIsImp0aSI6IjVkZWExMmYzLTJhZmItNDk1MS1hOGUxLTNiZGQyYTk4ODVmZSIsInVzZXJuYW1lIjoiUmVudGVyIiwidWlkIjoiMjAiLCJyb2xlcyI6WyJVc2VyIiwiUmVudGVyIl0sImV4cCI6MTc0NTU4MjEzMiwiaXNzIjoiQWdnYXJBcGkiLCJhdWQiOiJGbHV0dGVyIn0.VEVBG6MZq0SGQ0p6XX_mjoujjj2zlhJUuCFnKKbCVoc',
      },
      responseType: ResponseType.json,
    ));
  }

  TextEditingController daysRequired = TextEditingController();
  TextEditingController discountPercentage = TextEditingController();

  void addDiscountToList() {
    final int days = int.tryParse(daysRequired.text) ?? 0;
    final int percentage = int.tryParse(discountPercentage.text) ?? 0;

    if (days > 0 && percentage > 0) {
      discounts.add(DiscountItem(
        daysRequired: days,
        discountPercentage: percentage,
      ));

      emit(DiscountSuccess('Discount added to list',
          discounts: List.from(discounts)));
      daysRequired.clear();
      discountPercentage.clear();
    }
  }

  Future<void> addDiscount(String id) async {
    emit(DiscountLoading(discounts: List.from(discounts)));
    try {
      final discountsData = discounts
          .map((discount) => {
                "daysRequired": discount.daysRequired,
                "discountPercentage": discount.discountPercentage,
              })
          .toList();

      final data = {"vehicleId": id, "discounts": discountsData};

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
      print("Response: ${response.data}");
      if (response.statusCode == 200) {
        emit(DiscountSuccess(response.data, discounts: List.from(discounts)));
      } else {
        emit(DiscountFailure("Error: ${response.statusCode}",
            discounts: List.from(discounts)));
      }
    } catch (e) {
      emit(DiscountFailure('Error: $e', discounts: List.from(discounts)));
    }
  }

  void removeDiscount(int index) {
    if (index >= 0 && index < discounts.length) {
      discounts.removeAt(index);
      emit(
          DiscountSuccess('Discount removed', discounts: List.from(discounts)));
    }
  }
}
