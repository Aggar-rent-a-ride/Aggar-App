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

  Map<String, dynamic>? get registrationResponse => _registrationResponse;

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

    emit(state.copyWith(isLoading: true, errorMessage: null, isSuccess: false));

    try {
      String addressString = "";
      if (userData != null && userData!.containsKey("address")) {
        final address = userData!["address"];
        if (address is Map) {
          addressString =
              "${address['street'] ?? ''}, ${address['city'] ?? ''}, ${address['state'] ?? ''}, ${address['country'] ?? ''}";
        } else if (address is String) {
          addressString = address;
        }
      }

      final Map<String, dynamic> jsonData = {
        ...(userData ?? {}),
        "aggreedTheTerms": state.termsAccepted,
        "isCustomer": state.selectedType == "user",
        "location": userData?["location"] ?? {"longitude": 0, "latitude": 0},
        "address": addressString.isNotEmpty ? addressString : null,
      };

      print('Sending JSON data: ${jsonEncode(jsonData)}');

      final response = await _apiConsumer.post(
        EndPoint.register,
        data: jsonData,
      );

      print('Received response: $response');

      if (response is Map<String, dynamic>) {
        if (response.containsKey('statusCode')) {
          int? statusCode = response['statusCode'] is int
              ? response['statusCode']
              : int.tryParse(response['statusCode'].toString());

          if (statusCode != null && (statusCode < 200 || statusCode >= 300)) {
            String errorMessage = response['message'] ?? 'Registration failed';
            throw Exception(errorMessage);
          }
        }

        _registrationResponse = response;
        emit(state.copyWith(
            isLoading: false, isSuccess: true, errorMessage: null));
      } else {
        throw Exception('Unexpected response format');
      }
    } on DioException catch (e) {
      print('Dio exception: ${e.message}');
      print('Response data: ${e.response?.data}');

      String errorMessage = 'Registration failed';

      if (e.response?.data is Map<String, dynamic>) {
        final responseData = e.response!.data as Map<String, dynamic>;

        if (responseData.containsKey('message')) {
          errorMessage = responseData['message'];
        } else if (responseData.containsKey('title')) {
          errorMessage = responseData['title'];
        }
      }

      emit(state.copyWith(
        isLoading: false,
        isSuccess: false,
        errorMessage: errorMessage,
      ));
    } catch (error) {
      print('Registration error: $error');
      emit(state.copyWith(
        isLoading: false,
        isSuccess: false,
        errorMessage: error.toString(),
      ));
    }
  }
}
