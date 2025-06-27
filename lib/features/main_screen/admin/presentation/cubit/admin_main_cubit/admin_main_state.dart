abstract class AdminMainState {
  const AdminMainState();
}

class AdminMainInitial extends AdminMainState {}

class AdminMainLoading extends AdminMainState {}

class AdminMainConnected extends AdminMainState {
  final String accessToken;
  final bool isStatisticsLoaded;
  final bool isReportsLoaded;
  final bool isUserStatisticsLoaded;
  final bool isVehicleTypesLoaded;
  final bool isVehicleBrandsLoaded;
  final bool isSignalRConnected;
  final bool isUserInfoLoaded;

  const AdminMainConnected({
    required this.accessToken,
    required this.isStatisticsLoaded,
    required this.isReportsLoaded,
    required this.isUserStatisticsLoaded,
    required this.isVehicleTypesLoaded,
    required this.isVehicleBrandsLoaded,
    required this.isSignalRConnected,
    required this.isUserInfoLoaded,
  });

  // Helper method to check if all data is loaded
  bool get isAllDataLoaded =>
      isStatisticsLoaded &&
      isReportsLoaded &&
      isUserStatisticsLoaded &&
      isVehicleTypesLoaded &&
      isVehicleBrandsLoaded;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AdminMainConnected &&
        other.accessToken == accessToken &&
        other.isStatisticsLoaded == isStatisticsLoaded &&
        other.isReportsLoaded == isReportsLoaded &&
        other.isUserStatisticsLoaded == isUserStatisticsLoaded &&
        other.isVehicleTypesLoaded == isVehicleTypesLoaded &&
        other.isVehicleBrandsLoaded == isVehicleBrandsLoaded &&
        other.isSignalRConnected == isSignalRConnected;
  }

  @override
  int get hashCode {
    return accessToken.hashCode ^
        isStatisticsLoaded.hashCode ^
        isReportsLoaded.hashCode ^
        isUserStatisticsLoaded.hashCode ^
        isVehicleTypesLoaded.hashCode ^
        isVehicleBrandsLoaded.hashCode ^
        isSignalRConnected.hashCode;
  }
}

class AdminMainDisconnected extends AdminMainState {}

class AdminMainAuthError extends AdminMainState {
  final String message;

  const AdminMainAuthError(this.message);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AdminMainAuthError && other.message == message;
  }

  @override
  int get hashCode => message.hashCode;
}
