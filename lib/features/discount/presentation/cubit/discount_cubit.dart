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
        final token = await tokenRefreshCubit.getAccessToken();
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

  Future<void> fetchVehicleDiscounts(String vehicleId) async {
    emit(DiscountLoading(discounts: List.from(discounts)));
    try {
      // First, let's try to get discounts for the specific vehicle
      final response = await dio.get(
        '${EndPoint.vehicleDiscount}?vehicleId=$vehicleId',
        options: Options(
          validateStatus: (status) {
            return status! < 500;
          },
        ),
      );

      print("Fetch discounts response: ${response.data}");
      print("Response status: ${response.statusCode}");

      if (response.statusCode == 200 && response.data != null) {
        // Try different response structures
        List<dynamic> discountsData = [];

        if (response.data is List) {
          discountsData = response.data;
        } else if (response.data['discounts'] != null) {
          discountsData = response.data['discounts'];
        } else if (response.data['data'] != null) {
          discountsData = response.data['data'];
        } else if (response.data['result'] != null) {
          discountsData = response.data['result'];
        }

        discounts.clear();
        for (var discountData in discountsData) {
          if (discountData is Map<String, dynamic>) {
            final daysRequired = discountData['daysRequired'] ??
                discountData['DaysRequired'] ??
                discountData['days_required'] ??
                0;
            final discountPercentage = discountData['discountPercentage'] ??
                discountData['DiscountPercentage'] ??
                discountData['discount_percentage'] ??
                0;

            if (daysRequired > 0 && discountPercentage > 0) {
              discounts.add(DiscountItem(
                daysRequired: daysRequired is int
                    ? daysRequired
                    : int.tryParse(daysRequired.toString()) ?? 0,
                discountPercentage: discountPercentage is int
                    ? discountPercentage
                    : int.tryParse(discountPercentage.toString()) ?? 0,
              ));
            }
          }
        }

        print("Loaded ${discounts.length} discounts");
        emit(DiscountSuccess('Discounts loaded successfully',
            discounts: List.from(discounts)));
      } else if (response.statusCode == 404) {
        // No discounts found for this vehicle
        discounts.clear();
        emit(DiscountSuccess('No discounts found for this vehicle',
            discounts: List.from(discounts)));
      } else {
        emit(DiscountFailure('Failed to load discounts: ${response.statusCode}',
            discounts: List.from(discounts)));
      }
    } catch (e) {
      print("Error fetching discounts: $e");
      emit(DiscountFailure('Error fetching discounts: $e',
          discounts: List.from(discounts)));
    }
  }

  void removeDiscount(int index) {
    if (index >= 0 && index < discounts.length) {
      discounts.removeAt(index);
      emit(
          DiscountSuccess('Discount removed', discounts: List.from(discounts)));
    }
  }

  void clearAllDiscounts() {
    discounts.clear();
    emit(DiscountSuccess('All discounts cleared',
        discounts: List.from(discounts)));
  }

  void clearFormFields() {
    daysRequired.clear();
    discountPercentage.clear();
  }

  void loadDiscountsFromVehicleData(List<dynamic>? discountsData) {
    if (discountsData == null || discountsData.isEmpty) {
      if (discounts.isEmpty) {
        // Don't emit if already empty
        return;
      }
      discounts.clear();
      emit(DiscountSuccess('No discounts found',
          discounts: List.from(discounts)));
      return;
    }

    // Check if we already have the same discounts loaded
    bool hasSameDiscounts = true;
    if (discounts.length != discountsData.length) {
      hasSameDiscounts = false;
    } else {
      for (int i = 0; i < discounts.length; i++) {
        final existing = discounts[i];
        final newData = discountsData[i];
        if (newData is Map<String, dynamic>) {
          final daysRequired = newData['daysRequired'] ??
              newData['DaysRequired'] ??
              newData['days_required'] ??
              0;
          final discountPercentage = newData['discountPercentage'] ??
              newData['DiscountPercentage'] ??
              newData['discount_percentage'] ??
              0;

          if (existing.daysRequired != daysRequired ||
              existing.discountPercentage != discountPercentage) {
            hasSameDiscounts = false;
            break;
          }
        }
      }
    }

    // Don't reload if we already have the same discounts
    if (hasSameDiscounts) {
      print("Discounts already loaded, skipping reload");
      return;
    }

    discounts.clear();
    for (var discountData in discountsData) {
      if (discountData is Map<String, dynamic>) {
        final daysRequired = discountData['daysRequired'] ??
            discountData['DaysRequired'] ??
            discountData['days_required'] ??
            0;
        final discountPercentage = discountData['discountPercentage'] ??
            discountData['DiscountPercentage'] ??
            discountData['discount_percentage'] ??
            0;

        if (daysRequired > 0 && discountPercentage > 0) {
          discounts.add(DiscountItem(
            daysRequired: daysRequired is int
                ? daysRequired
                : int.tryParse(daysRequired.toString()) ?? 0,
            discountPercentage: discountPercentage is int
                ? discountPercentage
                : int.tryParse(discountPercentage.toString()) ?? 0,
          ));
        }
      }
    }

    print("Loaded ${discounts.length} discounts from vehicle data");
    emit(DiscountSuccess('Discounts loaded from vehicle data',
        discounts: List.from(discounts)));
  }
}
