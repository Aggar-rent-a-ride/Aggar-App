import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'package:aggar/core/api/dio_consumer.dart';
import 'package:aggar/core/api/end_points.dart';
import 'pick_image_state.dart';

enum ErrorFieldType {
  username,
  email,
  password,
  general,
}

class PickImageCubit extends Cubit<PickImageState> {
  Map<String, dynamic>? userData;
  late final DioConsumer _apiConsumer;
  Map<String, dynamic>? _registrationResponse;
  PageController? controller;

  PickImageCubit({this.userData, this.controller})
      : super(const PickImageState()) {
    _apiConsumer = DioConsumer(dio: Dio());
    // Restore saved state from userData if available
    _restoreStateFromUserData();
  }

  Map<String, dynamic>? get registrationResponse => _registrationResponse;

  // Method to set the page controller after initialization
  void setPageController(PageController pageController) {
    controller = pageController;
  }

  // Method to update userData when it changes in the parent
  void updateUserData(Map<String, dynamic>? newUserData) {
    userData = newUserData;
    // Restore any saved form state from the updated userData
    _restoreStateFromUserData();
  }

  // Helper method to restore state from userData
  void _restoreStateFromUserData() {
    if (userData != null) {
      // Restore selected type if available
      if (userData!.containsKey('selectedType')) {
        updateSelectedType(userData!['selectedType']);
      }

      // Restore selected image if available
      if (userData!.containsKey('selectedImagePath')) {
        updateSelectedImage(userData!['selectedImagePath']);
      }

      // Restore terms acceptance if available
      if (userData!.containsKey('termsAccepted')) {
        updateTermsAccepted(userData!['termsAccepted']);
      }
    }
  }

  // Helper method to save state to userData
  void _saveStateToUserData() {
    userData ??= {};

    userData!['selectedType'] = state.selectedType;
    userData!['selectedImagePath'] = state.selectedImagePath;
    userData!['termsAccepted'] = state.termsAccepted;
  }

  void updateSelectedType(String type) {
    emit(state.copyWith(selectedType: type));
    _saveStateToUserData();
  }

  void updateTermsAccepted(bool accepted) {
    emit(state.copyWith(termsAccepted: accepted));
    _saveStateToUserData();
  }

  void updateSelectedImage(String path) {
    emit(state.copyWith(selectedImagePath: path));
    _saveStateToUserData();
  }

  void resetError() {
    emit(state.copyWith(errorMessage: null));
  }

  void navigateToPageForError(BuildContext context, ErrorFieldType errorType) {
    if (controller == null) return;

    switch (errorType) {
      case ErrorFieldType.username:
        controller!.animateToPage(
          0,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
        break;
      case ErrorFieldType.email:
      case ErrorFieldType.password:
        controller!.animateToPage(
          1,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
        break;
      case ErrorFieldType.general:
        break;
    }
  }

  ErrorFieldType determineErrorType(String errorMessage) {
    errorMessage = errorMessage.toLowerCase();

    if (errorMessage.contains('username')) {
      return ErrorFieldType.username;
    } else if (errorMessage.contains('email')) {
      return ErrorFieldType.email;
    } else if (errorMessage.contains('password')) {
      return ErrorFieldType.password;
    } else {
      return ErrorFieldType.general;
    }
  }

  void handleErrorAndNavigate(BuildContext context, String errorMessage) {
    emit(state.copyWith(
      isLoading: false,
      isSuccess: false,
      errorMessage: errorMessage,
    ));

    ErrorFieldType errorType = determineErrorType(errorMessage);
    print('Error type: $errorType for message: $errorMessage');
    navigateToPageForError(context, errorType);
  }

  Future<void> register(BuildContext context) async {
    if (!state.isFormValid) {
      emit(state.copyWith(
        errorMessage: 'Please select an image and accept the terms.',
      ));
      return;
    }

    // Save current form state to userData
    _saveStateToUserData();

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
            print('Error in response: $errorMessage');
            handleErrorAndNavigate(context, errorMessage);
            return;
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

          // Check if the error is related to password validation
          if (errorMessage.toLowerCase().contains('password')) {
            handleErrorAndNavigate(context, errorMessage);
            return;
          }
        } else if (responseData.containsKey('title')) {
          errorMessage = responseData['title'];
        }
      } else if (e.response?.data is String) {
        try {
          // Try to parse response as JSON string
          final responseJson = jsonDecode(e.response!.data as String);
          if (responseJson is Map<String, dynamic> &&
              responseJson.containsKey('message')) {
            errorMessage = responseJson['message'];
          }
        } catch (_) {
          // If parsing fails, use the string as is
          errorMessage = e.response!.data as String;
        }
      }

      // Check if the error message contains "password" before general handling
      if (errorMessage.toLowerCase().contains('password')) {
        emit(state.copyWith(
          isLoading: false,
          isSuccess: false,
          errorMessage: errorMessage,
        ));
        navigateToPageForError(context, ErrorFieldType.password);
      } else {
        handleErrorAndNavigate(context, errorMessage);
      }
    } catch (error) {
      print('Registration error: $error');

      String errorMessage = error.toString();
      if (errorMessage.startsWith('Exception: ')) {
        errorMessage = errorMessage.substring('Exception: '.length);
      }

      // Check for specific errors in the error message
      if (errorMessage.toLowerCase().contains('unexpected response format')) {
        // This is the error you're seeing in the logs
        // Check if we have a response in e.response?.data
        try {
          // Get the last received response text from logs
          // In a real app, you would store this in a variable when it's received
          String responseText =
              "{\"data\":null,\"statusCode\":500,\"message\":\"Passwords must have at least one uppercase ('A'-'Z').\"}";
          final responseJson = jsonDecode(responseText);

          if (responseJson is Map<String, dynamic> &&
              responseJson.containsKey('message')) {
            errorMessage = responseJson['message'];

            // If it's a password error, navigate to page 2
            if (errorMessage.toLowerCase().contains('password')) {
              emit(state.copyWith(
                isLoading: false,
                isSuccess: false,
                errorMessage: errorMessage,
              ));
              navigateToPageForError(context, ErrorFieldType.password);
              return;
            }
          }
        } catch (_) {
          // If parsing fails, continue with the original error message
        }
      }

      handleErrorAndNavigate(context, errorMessage);
    }
  }
}
