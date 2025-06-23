import 'package:aggar/core/cubit/user_cubit/user_info_state.dart';
import 'package:aggar/core/services/signalr_service.dart';
import 'package:aggar/features/main_screen/customer/presentation/cubit/vehicles/vehicle_cubit.dart';
import 'package:aggar/features/main_screen/customer/presentation/cubit/vehicles/vehicle_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:aggar/core/cubit/refresh%20token/token_refresh_cubit.dart';
import 'package:aggar/features/main_screen/customer/presentation/cubit/vehicle_brand/vehicle_brand_cubit.dart';
import 'package:aggar/features/main_screen/customer/presentation/cubit/vehicle_brand/vehicle_brand_state.dart';
import 'package:aggar/features/main_screen/customer/presentation/cubit/vehicle_type/vehicle_type_cubit.dart';
import 'package:aggar/features/main_screen/customer/presentation/cubit/vehicle_type/vehicle_type_state.dart';
import 'package:aggar/features/main_screen/customer/presentation/cubit/main_screen/main_screen_state.dart';
import '../../../../../../core/cubit/user_cubit/user_info_cubit.dart';

class MainCubit extends Cubit<MainState> {
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  late final InternetConnectionChecker _internetChecker;
  final TokenRefreshCubit _tokenRefreshCubit;
  final VehicleBrandCubit _vehicleBrandCubit;
  final VehicleTypeCubit _vehicleTypeCubit;
  final VehicleCubit _vehicleCubit;
  final UserInfoCubit _userInfoCubit;
  final SignalRService _signalRService = SignalRService();

  bool _isBrandsLoaded = false;
  bool _isTypesLoaded = false;
  bool _isVehicleLoaded = false;
  bool _isSignalRConnected = false;
  bool _isInitializing = false;
  bool _isUserLoaded = false;

  MainCubit({
    required TokenRefreshCubit tokenRefreshCubit,
    required VehicleBrandCubit vehicleBrandCubit,
    required VehicleTypeCubit vehicleTypeCubit,
    required VehicleCubit vehicleCubit,
    required UserInfoCubit userInfoCubit,
  })  : _tokenRefreshCubit = tokenRefreshCubit,
        _vehicleBrandCubit = vehicleBrandCubit,
        _vehicleTypeCubit = vehicleTypeCubit,
        _vehicleCubit = vehicleCubit,
        _userInfoCubit = userInfoCubit,
        super(MainInitial()) {
    _setupInternetChecker();
    _observeVehicleDataStates();
    _setupSignalRListeners();
    initializeScreen();
  }

  void _setupInternetChecker() {
    _internetChecker = InternetConnectionChecker.createInstance();
    checkInternetConnection();
    _internetChecker.onStatusChange.listen(_handleConnectivityChange);
  }

  void _setupSignalRListeners() {
    _signalRService.onConnectionChange.listen((isConnected) {
      _isSignalRConnected = isConnected;
      if (state is MainConnected) {
        _updateConnectedState();
      }
    });
  }

  void _observeVehicleDataStates() {
    _vehicleBrandCubit.stream.listen((brandState) {
      if (state is MainConnected) {
        if (brandState is VehicleLoadedBrand) {
          _isBrandsLoaded = true;
          _updateConnectedState();
        } else if (brandState is VehicleBrandLoading) {
          _isBrandsLoaded = false;
          _updateConnectedState();
        }
      }
    });

    _vehicleTypeCubit.stream.listen((typeState) {
      if (state is MainConnected) {
        if (typeState is VehicleLoadedType) {
          _isTypesLoaded = true;
          _updateConnectedState();
        } else if (typeState is VehicleTypeLoading) {
          _isTypesLoaded = false;
          _updateConnectedState();
        }
      }
    });

    _vehicleCubit.stream.listen((vehicleState) {
      if (state is MainConnected) {
        if (vehicleState is VehicleLoaded) {
          _isVehicleLoaded = true;
          _updateConnectedState();
        } else if (vehicleState is VehicleLoading) {
          _isVehicleLoaded = false;
          _updateConnectedState();
        }
      }
    });

    _userInfoCubit.stream.listen((userState) {
      if (state is MainConnected) {
        if (userState is UserInfoSuccess) {
          _isUserLoaded = true;
          _updateConnectedState();
        } else if (userState is UserInfoLoading) {
          _isUserLoaded = false;
          _updateConnectedState();
        } else if (userState is UserInfoError) {
          _handleAuthError(
              'Failed to load user info: ${userState.errorMessage}');
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
        isVehicleLoaded: _isVehicleLoaded,
        isSignalRConnected: _isSignalRConnected,
        isUserLoaded: _isUserLoaded,
      ));
    }
  }

  Future<void> initializeScreen() async {
    if (_isInitializing) return;
    _isInitializing = true;
    emit(MainLoading());

    try {
      await _checkAndRefreshToken();
    } finally {
      _isInitializing = false;
    }
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
      _disconnectSignalR();
      emit(MainDisconnected());
    }
  }

  Future<void> checkInternetConnection() async {
    final hasInternet = await _internetChecker.hasConnection;

    if (hasInternet) {
      _loadAccessToken();
    } else {
      _disconnectSignalR();
      emit(MainDisconnected());
    }
  }

  Future<void> _loadAccessToken() async {
    if (_isInitializing) return;
    _isInitializing = true;

    try {
      final token = await _secureStorage.read(key: 'accessToken');
      final userIdStr = await _secureStorage.read(key: 'userId');
      final userId = userIdStr != null ? int.tryParse(userIdStr) : null;

      if (token != null && userId != null && userId > 0) {
        _isBrandsLoaded = false;
        _isTypesLoaded = false;
        _isVehicleLoaded = false;
        _isSignalRConnected = false;
        _isUserLoaded = false;

        emit(MainConnected(
          accessToken: token,
          isVehicleBrandsLoaded: false,
          isVehicleTypesLoaded: false,
          isSignalRConnected: false,
          isVehicleLoaded: false,
          isUserLoaded: false,
        ));

        _fetchData(token);
        _connectToSignalR(userId);
      } else {
        _handleAuthError(
            'Invalid token or userId. Token: ${token != null}, UserId: $userId');
      }
    } catch (e) {
      _handleAuthError(
          'Error retrieving access token or userId: ${e.toString()}');
    } finally {
      _isInitializing = false;
    }
  }

  Future<void> _connectToSignalR(int userId) async {
    try {
      if (!_signalRService.isConnected) {
        await _signalRService.initialize(userId: userId);
        _isSignalRConnected = _signalRService.isConnected;
        _updateConnectedState();
      }
    } catch (e) {
      _isSignalRConnected = false;
      _updateConnectedState();
    }
  }

  Future<void> _disconnectSignalR() async {
    if (_signalRService.isConnected) {
      await _signalRService.disconnect();
      _isSignalRConnected = false;
    }
  }

  void _handleAuthError(String message) {
    _disconnectSignalR();
    emit(MainAuthError(message));
  }

  void _fetchData(String accessToken) {
    _vehicleBrandCubit.fetchVehicleBrands(accessToken);
    _vehicleTypeCubit.fetchVehicleTypes(accessToken);
    _vehicleCubit.fetchPopularVehicles(accessToken);

    _secureStorage.read(key: 'userId').then((userIdStr) {
      final userId = userIdStr != null ? int.tryParse(userIdStr) : null;
      if (userId != null && userId > 0) {
        _userInfoCubit.fetchUserInfo(
          userId.toString(),
          accessToken,
        );
      } else {
        _handleAuthError('Invalid or missing userId. Please log in again.');
      }
    }).catchError((e) {
      _handleAuthError('Error reading userId: ${e.toString()}');
    });
  }

  void handleTokenRefreshSuccess(String accessToken) {
    emit(MainConnected(
      accessToken: accessToken,
      isVehicleBrandsLoaded: false,
      isVehicleTypesLoaded: false,
      isVehicleLoaded: false,
      isSignalRConnected: _isSignalRConnected,
      isUserLoaded: false,
    ));
    _fetchData(accessToken);

    if (!_signalRService.isConnected) {
      _secureStorage.read(key: 'userId').then((userIdStr) {
        final userId = userIdStr != null ? int.tryParse(userIdStr) : null;
        if (userId != null && userId > 0) {
          _connectToSignalR(userId);
        }
      });
    }
  }

  void handleTokenRefreshFailure(String errorMessage) {
    _disconnectSignalR();
    _handleAuthError('Authentication error: $errorMessage');
  }

  void refreshData() {
    if (state is MainConnected) {
      final accessToken = (state as MainConnected).accessToken;
      _fetchData(accessToken);

      if (!_signalRService.isConnected) {
        _secureStorage.read(key: 'userId').then((userIdStr) {
          final userId = userIdStr != null ? int.tryParse(userIdStr) : null;
          if (userId != null && userId > 0) {
            _connectToSignalR(userId);
          }
        });
      }
    }
  }
}
