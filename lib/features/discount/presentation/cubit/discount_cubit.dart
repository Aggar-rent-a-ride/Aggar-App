import 'package:aggar/core/api/end_points.dart';
import 'package:aggar/core/cubit/refresh%20token/token_refresh_cubit.dart';
import 'package:aggar/features/discount/presentation/cubit/discount_state.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DiscountCubit extends Cubit<DiscountState> {
  late Dio dio;
  final TokenRefreshCubit tokenRefreshCubit;
  List<DiscountItem> discounts = [];

  DiscountCubit({required this.tokenRefreshCubit}) : super(DiscountInitial()) {
    dio = Dio(BaseOptions(
      responseType: ResponseType.json,
    ));
    _setupDioInterceptors();
  }

  void _setupDioInterceptors() {
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await tokenRefreshCubit.ensureValidToken();
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        } else {
          emit(DiscountFailure('Authentication error: No valid token available',
              discounts: List.from(discounts)));
        }
        return handler.next(options);
      },
      onError: (DioException error, handler) async {
        if (error.response?.statusCode == 401) {
          try {
            await tokenRefreshCubit.refreshToken();
            final token = tokenRefreshCubit.currentAccessToken;
            if (token != null) {
              error.requestOptions.headers['Authorization'] = 'Bearer $token';
              final response = await dio.fetch(error.requestOptions);
              return handler.resolve(response);
            }
          } catch (e) {
            emit(DiscountFailure('Authentication error: $e',
                discounts: List.from(discounts)));
          }
        }
        return handler.next(error);
      },
    ));
  }

  TextEditingController daysRequired = TextEditingController();
  TextEditingController discountPercentage = TextEditingController();

  void addDiscountToList() {
    final num days = int.tryParse(daysRequired.text) ?? 0;
    final num percentage = int.tryParse(discountPercentage.text) ?? 0;
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
  }

  void initializeDiscounts(List<dynamic> initialDiscounts) {
    discounts = initialDiscounts
        .map((item) => DiscountItem(
              daysRequired: item['daysRequired'] ?? 0,
              discountPercentage: item['discountPercentage'] ?? 0,
            ))
        .where((discount) =>
            discount.daysRequired > 0 && discount.discountPercentage > 0)
        .toList();
    emit(DiscountSuccess('Discounts initialized',
        discounts: List.from(discounts)));
  }

  void removeDiscount(int index) {
    if (index >= 0 && index < discounts.length) {
      discounts.removeAt(index);
      emit(
          DiscountSuccess('Discount removed', discounts: List.from(discounts)));
    }
  }
}
