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

      // Create FormData object
      final FormData formData = FormData();

      // Add text fields from userData
      if (userData != null) {
        userData!.forEach((key, value) {
          if (value != null) {
            formData.fields.add(MapEntry(key, value.toString()));
          }
        });
      }

      // Add user type and terms acceptance
      formData.fields.add(MapEntry('userType', state.selectedType));
      formData.fields
          .add(MapEntry('termsAccepted', state.termsAccepted.toString()));

      // Add image file if selected
      if (state.selectedImagePath != null) {
        File imageFile = File(state.selectedImagePath!);
        if (await imageFile.exists()) {
          String fileName = state.selectedImagePath!.split('/').last;
          formData.files.add(MapEntry(
            'profileImage',
            await MultipartFile.fromFile(
              state.selectedImagePath!,
              filename: fileName,
            ),
          ));
          print('Added image: $fileName');
        } else {
          throw Exception('Selected image file does not exist');
        }
      }

      print(
          'Sending registration request with ${formData.fields.length} fields and ${formData.files.length} files');

      // Use your DioConsumer
      final dioConsumer = DioConsumer(dio: dio);
      final response = await dioConsumer.post(
        EndPoint.register,
        data: formData,
        isFromData: false, // We already created FormData directly
      );

      print('Registration successful: $response');
      emit(state.copyWith(isLoading: false, isSuccess: true));
    } on ServerException catch (e) {
      // Handle the specific error model from your server
      print('Server exception: ${e.errModel.errorMessage}');
      emit(state.copyWith(
        isLoading: false,
        errorMessage: e.errModel.errorMessage,
      ));
    } catch (error) {
      // Handle any other exceptions
      print('Registration error: $error');
      emit(state.copyWith(
        isLoading: false,
        errorMessage: 'Registration failed: $error',
      ));
    }
  }
}
