part of 'sign_up_cubit.dart';

abstract class SignUpState extends Equatable {
  const SignUpState();
  
  @override
  List<Object> get props => [];
}

class SignUpInitial extends SignUpState {}

class SignUpDataUpdated extends SignUpState {
  final Map<String, dynamic> userData;
  
  const SignUpDataUpdated(this.userData);
  
  @override
  List<Object> get props => [userData];
}

class SignUpSubmitting extends SignUpState {}

class SignUpSuccess extends SignUpState {
  final Map<String, dynamic> userData;
  
  const SignUpSuccess(this.userData);
  
  @override
  List<Object> get props => [userData];
}

class SignUpFailure extends SignUpState {
  final String error;
  
  const SignUpFailure(this.error);
  
  @override
  List<Object> get props => [error];
}