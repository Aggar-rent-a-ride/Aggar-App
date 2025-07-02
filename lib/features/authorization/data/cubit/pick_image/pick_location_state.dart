class PickLocationState {
  final String selectedType;
  final String address;
  final String latitude;
  final String longitude;
  final bool termsAccepted;
  final bool isLoading;
  final bool isSuccess;
  final String? errorMessage;

  const PickLocationState({
    this.selectedType = '',
    this.address = '',
    this.latitude = '',
    this.longitude = '',
    this.termsAccepted = false,
    this.isLoading = false,
    this.isSuccess = false,
    this.errorMessage,
  });

  bool get isFormValid {
    final lat = double.tryParse(latitude);
    final lon = double.tryParse(longitude);
    return selectedType.isNotEmpty &&
        lat != null &&
        lon != null &&
        lat >= -90 &&
        lat <= 90 &&
        lon >= -180 &&
        lon <= 180 &&
        termsAccepted;
  }

  PickLocationState copyWith({
    String? selectedType,
    String? address,
    String? latitude,
    String? longitude,
    bool? termsAccepted,
    bool? isLoading,
    bool? isSuccess,
    String? errorMessage,
  }) {
    return PickLocationState(
      selectedType: selectedType ?? this.selectedType,
      address: address ?? this.address,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      termsAccepted: termsAccepted ?? this.termsAccepted,
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      errorMessage: errorMessage,
    );
  }
}
