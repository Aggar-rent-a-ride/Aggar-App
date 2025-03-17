import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'package:aggar/core/api/dio_consumer.dart';
import 'package:aggar/core/api/end_points.dart';
import 'package:aggar/core/errors/exceptions.dart';
import 'dart:io';
import 'pick_image_state.dart';

class PickImageCubit extends Cubit<PickImageState> {
  final Map<String, dynamic>? userData;

  PickImageCubit({this.userData}) : super(const PickImageState());

  void updateSelectedType(String type) {
    emit(state.copyWith(selectedType: type));
  }

  void updateTermsAccepted(bool accepted) {
    emit(state.copyWith(termsAccepted: accepted));
  }

  void updateSelectedImage(String path) {
    emit(state.copyWith(selectedImagePath: path));
  }

  void resetError() {
    emit(state.copyWith(errorMessage: null));
  }

  Future<void> register() async {
    if (!state.isFormValid) {
      emit(state.copyWith(
        errorMessage: 'Please select an image and accept the terms.',
      ));
      return;
    }

    emit(state.copyWith(isLoading: true, errorMessage: null));

    try {
      final dio = Dio();
      dio.options.baseUrl = EndPoint.baseUrl;
      dio.options.connectTimeout = const Duration(seconds: 60);
      dio.options.receiveTimeout = const Duration(seconds: 60);

      // Create JSON data in the format expected by the server
      final Map<String, dynamic> jsonData = {
        // Add fields from userData if available
        ...(userData ?? {}),

        // Convert UI values to API format
        "aggreedTheTerms": state.termsAccepted,
        "isCustomer":
            state.selectedType == "user", // user → true, renter → false

        // Include these fields if they aren't already in userData
        "location": userData?["location"] ?? {"longitude": 0, "latitude": 0},

        // Include address if not provided
        "address": userData?["address"] ??
            {"country": "", "state": "", "city": "", "street": ""}
      };

      print('Sending JSON data: ${jsonEncode(jsonData)}');

      final response = await dio.post(
        EndPoint.register,
        data: jsonData,
        options: Options(
          contentType: 'application/json',
          headers: {
            'Accept': 'application/json',
          },
        ),
      );

      print('Registration successful: ${response.data}');


      emit(state.copyWith(isLoading: false, isSuccess: true));

      // Note: You might need to handle image upload in a separate API call
      // after successful registration
    } on DioException catch (e) {
      print('Dio exception: ${e.message}');
      print('Response data: ${e.response?.data}');
      emit(state.copyWith(
        isLoading: false,
        errorMessage:
            'Registration failed: ${e.response?.data?.toString() ?? e.message}',
      ));
    } catch (error) {
      print('Registration error: $error');
      emit(state.copyWith(
        isLoading: false,
        errorMessage: 'Registration failed: $error',
      ));
    }
  }
}
