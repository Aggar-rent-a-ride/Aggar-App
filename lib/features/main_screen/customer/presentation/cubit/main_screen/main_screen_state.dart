// main_screen_state.dart
abstract class MainState {}

class MainInitial extends MainState {}

class MainLoading extends MainState {}

class MainConnected extends MainState {
  final String accessToken;
  final bool isVehicleBrandsLoaded;
  final bool isVehicleTypesLoaded;
  final bool isVehicleLoaded;
  final bool isSignalRConnected;
  final bool isUserLoaded;

  MainConnected({
    required this.accessToken,
    required this.isVehicleBrandsLoaded,
    required this.isVehicleTypesLoaded,
    required this.isVehicleLoaded,
    this.isSignalRConnected = false,
    required this.isUserLoaded,
  });
}

class MainDisconnected extends MainState {}

class MainAuthError extends MainState {
  final String message;

  MainAuthError(this.message);
}
