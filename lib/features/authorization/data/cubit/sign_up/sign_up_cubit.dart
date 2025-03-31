import 'package:aggar/features/authorization/data/cubit/sign_up/sign_up_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignUpCubit extends Cubit<SignUpState> {
  SignUpCubit() : super(const SignUpState());

  Map<String, dynamic> get userData => state.userData;

  void updateFormData(Map<String, dynamic> data) {
    final updatedUserData = {...state.userData, ...data};
    emit(state.copyWith(userData: updatedUserData));
  }

  void resetError() {
    emit(state.copyWith(error: null));
  }

  void submitSignUp() async {
    emit(state.copyWith(isLoading: true, error: null));
    
    try {
      await Future.delayed(const Duration(seconds: 1));
      
      emit(state.copyWith(
        isLoading: false,
        isSuccess: true,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        error: e.toString(),
      ));
    }
  }

  void resetRegistration() {
    emit(const SignUpState());
  }
}