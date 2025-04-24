// main_screen_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:aggar/core/cubit/refresh%20token/token_refresh_cubit.dart';
import 'package:aggar/features/main_screen/presentation/cubit/vehicle_brand/vehicle_brand_cubit.dart';
import 'package:aggar/features/main_screen/presentation/cubit/vehicle_brand/vehicle_brand_state.dart';
import 'package:aggar/features/main_screen/presentation/cubit/vehicle_type/vehicle_type_cubit.dart';
import 'package:aggar/features/main_screen/presentation/cubit/vehicle_type/vehicle_type_state.dart';
import 'package:aggar/features/main_screen/presentation/cubit/main_screen/main_screen_state.dart';

class MainCubit extends Cubit<MainState> {
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  late final InternetConnectionChecker _internetChecker;
  final TokenRefreshCubit _tokenRefreshCubit;
  final VehicleBrandCubit _vehicleBrandCubit;
  final VehicleTypeCubit _vehicleTypeCubit;

  bool _isBrandsLoaded = false;
  bool _isTypesLoaded = false;

  MainCubit({
    required TokenRefreshCubit tokenRefreshCubit,
    required VehicleBrandCubit vehicleBrandCubit,
    required VehicleTypeCubit vehicleTypeCubit,
  })  : _tokenRefreshCubit = tokenRefreshCubit,
        _vehicleBrandCubit = vehicleBrandCubit,
        _vehicleTypeCubit = vehicleTypeCubit,
        super(MainInitial()) {
    _setupInternetChecker();
    _observeVehicleDataStates();
    initializeScreen();
  }

  void _setupInternetChecker() {
    _internetChecker = InternetConnectionChecker.createInstance();
    checkInternetConnection();
    _internetChecker.onStatusChange.listen(_handleConnectivityChange);
  }

  void _observeVehicleDataStates() {
    // Listen to vehicle brand state changes
    _vehicleBrandCubit.stream.listen((brandState) {
      if (state is MainConnected) {
        if (brandState is VehicleBrandLoaded) {
          _isBrandsLoaded = true;
          _updateConnectedState();
        } else if (brandState is VehicleBrandLoading) {
          _isBrandsLoaded = false;
          _updateConnectedState();
        }
      }
    });

    // Listen to vehicle type state changes
    _vehicleTypeCubit.stream.listen((typeState) {
      if (state is MainConnected) {
        if (typeState is VehicleTypeLoaded) {
          _isTypesLoaded = true;
          _updateConnectedState();
        } else if (typeState is VehicleTypeLoading) {
          _isTypesLoaded = false;
          _updateConnectedState();
        }
      }
    });
  }

  void _updateConnectedState() {
    if (state is MainConnected) {
      final currentState = state as MainConnected;
      emit(MainConnected(
        accessToken: currentState.accessToken,
        isVehicleBrandsLoaded: _isBrandsLoaded,
        isVehicleTypesLoaded: _isTypesLoaded,
      ));
    }
  }

  Future<void> initializeScreen() async {
    emit(MainLoading());
    await _checkAndRefreshToken();
  }

  Future<void> _checkAndRefreshToken() async {
    try {
      final needsRefresh = await _tokenRefreshCubit.shouldRefreshToken();

      if (needsRefresh) {
        await _tokenRefreshCubit.refreshToken();
      }

      await _loadAccessToken();
    } catch (e) {
      _handleAuthError('Token refresh error: ${e.toString()}');
    }
  }

  void _handleConnectivityChange(InternetConnectionStatus status) {
    final hasInternet = status == InternetConnectionStatus.connected;

    if (hasInternet) {
      _loadAccessToken();
    } else {
      emit(MainDisconnected());
    }
  }

  Future<void> checkInternetConnection() async {
    final hasInternet = await _internetChecker.hasConnection;

    if (hasInternet) {
      _loadAccessToken();
    } else {
      emit(MainDisconnected());
    }
  }

  Future<void> _loadAccessToken() async {
    try {
      final token = await _secureStorage.read(key: 'accessToken');

      if (token != null) {
        // Reset loading flags
        _isBrandsLoaded = false;
        _isTypesLoaded = false;

        emit(MainConnected(
          accessToken: token,
          isVehicleBrandsLoaded: false,
          isVehicleTypesLoaded: false,
        ));

        _fetchData(token);
      } else {
        _handleAuthError('Login required. Please sign in again.');
      }
    } catch (e) {
      _handleAuthError('Error retrieving access token: ${e.toString()}');
    }
  }

  void _handleAuthError(String message) {
    emit(MainAuthError(message));
  }

  void _fetchData(String accessToken) {
    print("Fetching data with token: ${accessToken.substring(0, 10)}...");
    _vehicleBrandCubit.fetchVehicleBrands(accessToken);
    _vehicleTypeCubit.fetchVehicleTypes(accessToken);
  }

  void handleTokenRefreshSuccess(String accessToken) {
    emit(MainConnected(
      accessToken: accessToken,
      isVehicleBrandsLoaded: false,
      isVehicleTypesLoaded: false,
    ));
    _fetchData(accessToken);
  }

  void handleTokenRefreshFailure(String errorMessage) {
    _handleAuthError('Authentication error: $errorMessage');
  }

  // Manually refresh data
  void refreshData() {
    if (state is MainConnected) {
      final accessToken = (state as MainConnected).accessToken;
      _fetchData(accessToken);
    }
  }
}
