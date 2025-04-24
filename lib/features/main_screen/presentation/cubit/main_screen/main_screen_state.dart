// main_screen_state.dart
abstract class MainState {}

class MainInitial extends MainState {}

class MainLoading extends MainState {}

class MainConnected extends MainState {
  final String accessToken;
  final bool isVehicleBrandsLoaded;
  final bool isVehicleTypesLoaded;

  MainConnected({
    required this.accessToken,
    this.isVehicleBrandsLoaded = false,
    this.isVehicleTypesLoaded = false,
  });
}

class MainDisconnected extends MainState {}

class MainAuthError extends MainState {
  final String message;

  MainAuthError(this.message);
}
