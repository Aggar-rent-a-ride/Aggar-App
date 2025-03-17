import 'package:equatable/equatable.dart';

class PickImageState extends Equatable {
  final String selectedType;
  final bool termsAccepted;
  final String? selectedImagePath;
  final bool isLoading;
  final String? errorMessage;
  final bool isSuccess;

  const PickImageState({
    this.selectedType = "user",
    this.termsAccepted = false,
    this.selectedImagePath,
    this.isLoading = false,
    this.errorMessage,
    this.isSuccess = false,
  });

  PickImageState copyWith({
    String? selectedType,
    bool? termsAccepted,
    String? selectedImagePath,
    bool? isLoading,
    String? errorMessage,
    bool? isSuccess,
  }) {
    return PickImageState(
      selectedType: selectedType ?? this.selectedType,
      termsAccepted: termsAccepted ?? this.termsAccepted,
      selectedImagePath: selectedImagePath ?? this.selectedImagePath,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      isSuccess: isSuccess ?? this.isSuccess,
    );
  }

  bool get isFormValid => selectedImagePath != null && termsAccepted;

  @override
  List<Object?> get props => [
        selectedType,
        termsAccepted,
        selectedImagePath,
        isLoading,
        errorMessage,
        isSuccess,
      ];
}