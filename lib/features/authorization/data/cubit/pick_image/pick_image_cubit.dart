import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'package:aggar/core/api/dio_consumer.dart';
import 'package:aggar/core/api/end_points.dart';
import 'pick_image_state.dart';

class PickImageCubit extends Cubit<PickImageState> {
  final Map<String, dynamic>? userData;
  late final DioConsumer _apiConsumer;
  Map<String, dynamic>? _registrationResponse;

  PickImageCubit({this.userData}) : super(const PickImageState()) {
    _apiConsumer = DioConsumer(dio: Dio());
  }

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

  // Getter to access registration response
  Map<String, dynamic>? get registrationResponse => _registrationResponse;

  Future<void> register() async {
    if (!state.isFormValid) {
      emit(state.copyWith(
        errorMessage: 'Please select an image and accept the terms.',
      ));
      return;
    }

    emit(state.copyWith(isLoading: true, errorMessage: null));

    try {
      final Map<String, dynamic> jsonData = {
        ...(userData ?? {}),
        "aggreedTheTerms": state.termsAccepted,
        "isCustomer":
            state.selectedType == "user", // user → true, renter → false
        // Include these fields if they aren't already in userData
        "location": userData?["location"] ?? {"longitude": 0, "latitude": 0},
        "address": userData?["address"] ??
            {"country": "", "state": "", "city": "", "street": ""}
      };

      print('Sending JSON data: ${jsonEncode(jsonData)}');

      final response = await _apiConsumer.post(
        EndPoint.register,
        data: jsonData,
      );

      print('Registration successful: $response');

      // Store the response for verification
      _registrationResponse = response;

      emit(state.copyWith(isLoading: false, isSuccess: true));
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
