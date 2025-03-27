import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'sign_up_state.dart';

class SignUpCubit extends Cubit<SignUpState> {
  SignUpCubit() : super(SignUpInitial());

  // Store collected user data
  Map<String, dynamic> userData = {};

  // Update form data
  void updateFormData(Map<String, String> data) {
    userData.addAll(data);
    emit(SignUpDataUpdated(userData));
  }

  // Move to next page
  void nextPage(PageController pageController) {
    pageController.nextPage(
      duration: const Duration(milliseconds: 300), 
      curve: Curves.easeInOut
    );
  }

  // Move to previous page
  void previousPage(PageController pageController) {
    pageController.previousPage(
      duration: const Duration(milliseconds: 300), 
      curve: Curves.easeInOut
    );
  }

  // Final submission method (you can add validation and submission logic)
  void submitSignUp() {
    // Implement your sign-up submission logic here
    emit(SignUpSubmitting());
    // Simulate submission
    Future.delayed(const Duration(seconds: 2), () {
      if (userData.isNotEmpty) {
        emit(SignUpSuccess(userData));
      } else {
        emit(SignUpFailure('Incomplete user data'));
      }
    });
  }
}