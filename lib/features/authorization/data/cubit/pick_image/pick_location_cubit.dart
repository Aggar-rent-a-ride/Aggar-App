import 'dart:convert';
import 'package:aggar/features/authorization/data/cubit/pick_image/pick_location_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'package:aggar/core/api/dio_consumer.dart';
import 'package:aggar/core/api/end_points.dart';

enum ErrorFieldType {
  username,
  email,
  password,
  location,
  general,
}

class PickLocationCubit extends Cubit<PickLocationState> {
  Map<String, dynamic>? userData;
  late final DioConsumer _apiConsumer;
  Map<String, dynamic>? _registrationResponse;
  PageController? controller;
  final TextEditingController addressController = TextEditingController();

  PickLocationCubit({this.userData, this.controller})
      : super(const PickLocationState()) {
    _apiConsumer = DioConsumer(dio: Dio());
    _restoreStateFromUserData();
  }

  Map<String, dynamic>? get registrationResponse => _registrationResponse;

  void setPageController(PageController pageController) {
    controller = pageController;
  }

  void updateUserData(Map<String, dynamic>? newUserData) {
    userData = newUserData;
    _restoreStateFromUserData();
  }

  void _restoreStateFromUserData() {
    if (userData != null) {
      if (userData!.containsKey('selectedType')) {
        updateSelectedType(userData!['selectedType']);
      }
      if (userData!.containsKey('address')) {
        updateAddress(userData!['address']);
      }
      if (userData!.containsKey('location')) {
        final location = userData!['location'];
        updateLatitude(location['latitude'].toString());
        updateLongitude(location['longitude'].toString());
      }
      if (userData!.containsKey('termsAccepted')) {
        updateTermsAccepted(userData!['termsAccepted']);
      }
    }
  }

  void _saveStateToUserData() {
    userData ??= {};
    userData!['selectedType'] = state.selectedType;
    userData!['address'] = state.address;
    userData!['location'] = {
      'latitude': double.tryParse(state.latitude) ?? 0.0,
      'longitude': double.tryParse(state.longitude) ?? 0.0,
    };
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

  void updateAddress(String address) {
    addressController.text = address;
    emit(state.copyWith(address: address));
    _saveStateToUserData();
  }

  void updateLatitude(String latitude) {
    emit(state.copyWith(latitude: latitude));
    _saveStateToUserData();
  }

  void updateLongitude(String longitude) {
    emit(state.copyWith(longitude: longitude));
    _saveStateToUserData();
  }

  void resetError() {
    emit(state.copyWith(errorMessage: null));
  }

  void previousPage(BuildContext context) {
    if (controller != null) {
      controller!.previousPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
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
      case ErrorFieldType.location:
        controller!.animateToPage(
          2,
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
    } else if (errorMessage.contains('location') ||
        errorMessage.contains('address')) {
      return ErrorFieldType.location;
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
    navigateToPageForError(context, errorType);
  }

  Future<void> register(BuildContext context) async {
    if (!state.isFormValid) {
      emit(state.copyWith(
        errorMessage:
            'Please enter valid location details and accept the terms.',
      ));
      return;
    }

    _saveStateToUserData();

    emit(state.copyWith(isLoading: true, errorMessage: null, isSuccess: false));

    try {
      final jsonData = {
        'name': userData?['name'] ?? '',
        'dateOfBirth': userData?['dateOfBirth'] ?? '',
        'username': userData?['username'] ?? '',
        'email': userData?['email'] ?? '',
        'password': userData?['password'] ?? '',
        'confirmPassword': userData?['confirmPassword'] ?? '',
        'aggreedTheTerms': state.termsAccepted,
        'isCustomer': state.selectedType == 'user',
        'location': {
          'longitude': double.tryParse(state.longitude) ?? 0.0,
          'latitude': double.tryParse(state.latitude) ?? 0.0,
        },
        'address': state.address.isNotEmpty ? state.address : null,
      };
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
      String errorMessage = 'Registration failed';

      if (e.response?.data is Map<String, dynamic>) {
        final responseData = e.response!.data as Map<String, dynamic>;
        if (responseData.containsKey('message')) {
          errorMessage = responseData['message'];
        } else if (responseData.containsKey('title')) {
          errorMessage = responseData['title'];
        }
      } else if (e.response?.data is String) {
        try {
          final responseJson = jsonDecode(e.response!.data as String);
          if (responseJson is Map<String, dynamic> &&
              responseJson.containsKey('message')) {
            errorMessage = responseJson['message'];
          }
        } catch (_) {
          errorMessage = e.response!.data as String;
        }
      }

      handleErrorAndNavigate(context, errorMessage);
    } catch (error) {
      String errorMessage = error.toString();
      if (errorMessage.startsWith('Exception: ')) {
        errorMessage = errorMessage.substring('Exception: '.length);
      }
      handleErrorAndNavigate(context, errorMessage);
    }
  }

  @override
  Future<void> close() {
    addressController.dispose();
    return super.close();
  }
}
