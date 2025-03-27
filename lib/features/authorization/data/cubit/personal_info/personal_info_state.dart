import 'package:equatable/equatable.dart';

class PersonalInfoState extends Equatable {
  final String name;
  final String username;
  final String dateOfBirth;
  final bool isFormValid;

  const PersonalInfoState({
    this.name = '',
    this.username = '',
    this.dateOfBirth = '',
    this.isFormValid = false,
  });

  PersonalInfoState copyWith({
    String? name,
    String? username,
    String? dateOfBirth,
    bool? isFormValid,
  }) {
    return PersonalInfoState(
      name: name ?? this.name,
      username: username ?? this.username,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      isFormValid: isFormValid ?? this.isFormValid,
    );
  }

  bool validateForm() {
    return name.isNotEmpty && 
           username.isNotEmpty && 
           dateOfBirth.isNotEmpty;
  }

  @override
  List<Object> get props => [name, username, dateOfBirth, isFormValid];
}