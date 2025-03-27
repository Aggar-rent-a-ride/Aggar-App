import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'personal_info_state.dart';

class PersonalInfoCubit extends Cubit<PersonalInfoState> {
  PersonalInfoCubit() : super(const PersonalInfoState());

  void updateName(String name) {
    final newState = state.copyWith(
      name: name,
      isFormValid: _checkFormValidity(name: name),
    );
    emit(newState);
  }

  void updateUsername(String username) {
    final newState = state.copyWith(
      username: username,
      isFormValid: _checkFormValidity(username: username),
    );
    emit(newState);
  }

  void updateDateOfBirth(DateTime? selectedDate) {
    if (selectedDate != null) {
      final formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate);
      final newState = state.copyWith(
        dateOfBirth: formattedDate,
        isFormValid: _checkFormValidity(dateOfBirth: formattedDate),
      );
      emit(newState);
    }
  }

  bool _checkFormValidity({
    String? name,
    String? username,
    String? dateOfBirth,
  }) {
    final currentName = name ?? state.name;
    final currentUsername = username ?? state.username;
    final currentDateOfBirth = dateOfBirth ?? state.dateOfBirth;

    return currentName.isNotEmpty &&
           currentUsername.isNotEmpty &&
           currentDateOfBirth.isNotEmpty;
  }
}