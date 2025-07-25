import 'package:aggar/core/cubit/user_cubit/user_info_cubit.dart';
import 'package:aggar/core/cubit/user_cubit/user_info_state.dart';
import 'package:aggar/features/main_screen/admin/presentation/cubit/user_statistics/user_statistics_cubit.dart';
import 'package:aggar/features/main_screen/admin/presentation/cubit/user_statistics/user_statistics_state.dart';
import 'package:aggar/features/vehicle_brand_with_type/presentation/cubit/admin_vehicle_type/admin_vehicle_type_cubit.dart';
import 'package:aggar/features/vehicle_brand_with_type/presentation/cubit/admin_vehicle_type/admin_vehicle_type_state.dart';
import 'package:aggar/features/vehicle_brand_with_type/presentation/cubit/admin_vehilce_brand/admin_vehicle_brand_cubit.dart';
import 'package:aggar/features/vehicle_brand_with_type/presentation/cubit/admin_vehilce_brand/admin_vehicle_brand_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:aggar/core/cubit/refresh%20token/token_refresh_cubit.dart';
import 'package:aggar/core/services/signalr_service.dart';
import 'package:aggar/features/main_screen/admin/presentation/cubit/report_cubit/report_cubit.dart';
import 'package:aggar/features/main_screen/admin/presentation/cubit/report_cubit/report_state.dart';
import 'package:aggar/features/main_screen/admin/presentation/cubit/statistics_cubit/statistics_cubit.dart';
import 'package:aggar/features/main_screen/admin/presentation/cubit/statistics_cubit/statistics_state.dart';
import 'admin_main_state.dart';

class AdminMainCubit extends Cubit<AdminMainState> {
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  late final InternetConnectionChecker _internetChecker;
  final TokenRefreshCubit _tokenRefreshCubit;
  final ReportCubit _reportCubit;
  final UserStatisticsCubit _userStatisticsCubit;
  final StatisticsCubit _statisticsCubit;
  final AdminVehicleTypeCubit _vehicleTypeCubit;
  final AdminVehicleBrandCubit _vehicleBrandCubit;
  final UserInfoCubit _userInfoCubit;
  final SignalRService _signalRService = SignalRService();

  bool _isStatisticsLoaded = false;
  bool _isReportsLoaded = false;
  bool _isStatisticsUsersLoaded = false;
  bool _isVehicleTypesLoaded = false;
  bool _isVehicleBrandsLoaded = false;
  bool _isUserInfoLoaded = false;
  bool _isSignalRConnected = false;
  bool _isInitializing = false;

  AdminMainCubit({
    required TokenRefreshCubit tokenRefreshCubit,
    required ReportCubit reportCubit,
    required UserStatisticsCubit userStatisticsCubit,
    required StatisticsCubit statisticsCubit,
    required AdminVehicleTypeCubit vehicleTypeCubit,
    required AdminVehicleBrandCubit vehicleBrandCubit,
    required UserInfoCubit userInfoCubit,
  }) : _tokenRefreshCubit = tokenRefreshCubit,
       _reportCubit = reportCubit,
       _userStatisticsCubit = userStatisticsCubit,
       _statisticsCubit = statisticsCubit,
       _vehicleTypeCubit = vehicleTypeCubit,
       _vehicleBrandCubit = vehicleBrandCubit,
       _userInfoCubit = userInfoCubit,
       super(AdminMainInitial()) {
    _setupInternetChecker();
    _observeDataStates();
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

      if (state is AdminMainConnected) {
        _updateConnectedState();
      }
    });
  }

  void _observeDataStates() {
    _statisticsCubit.stream.listen((statisticsState) {
      if (state is AdminMainConnected) {
        if (statisticsState is StatisticsLoaded) {
          _isStatisticsLoaded = true;
          _updateConnectedState();
        } else if (statisticsState is StatisticsLoading) {
          _isStatisticsLoaded = false;
          _updateConnectedState();
        } else if (statisticsState is StatisticsError) {
          _handleAuthError(
            'Statistics fetch failxxed: ${statisticsState.message}',
          );
        }
      }
    });

    _reportCubit.stream.listen((reportState) {
      if (state is AdminMainConnected) {
        if (reportState is ReportsLoaded) {
          _isReportsLoaded = true;
          _updateConnectedState();
        } else if (reportState is ReportsLoading) {
          _isReportsLoaded = false;
          _updateConnectedState();
        } else if (reportState is ReportError) {
          _handleAuthError('Reports fetch failed: ${reportState.message}');
        }
      }
    });

    _userStatisticsCubit.stream.listen((userState) {
      if (state is AdminMainConnected) {
        if (userState is UserStatisticsUserTotalsLoaded) {
          _isStatisticsUsersLoaded = true;
          _updateConnectedState();
        } else if (userState is UserStatisticsUserLoading) {
          _isStatisticsUsersLoaded = false;
          _updateConnectedState();
        } else if (userState is UserStatisticsError) {
          _handleAuthError('Users fetch failed: ${userState.message}');
        }
      }
    });

    // Add vehicle type cubit stream listener
    _vehicleTypeCubit.stream.listen((vehicleTypeState) {
      if (state is AdminMainConnected) {
        if (vehicleTypeState is AdminVehicleTypeLoaded) {
          _isVehicleTypesLoaded = true;
          _updateConnectedState();
        } else if (vehicleTypeState is AdminVehicleTypeLoading) {
          _isVehicleTypesLoaded = false;
          _updateConnectedState();
        } else if (vehicleTypeState is AdminVehicleTypeError) {
          _handleAuthError(
            'Vehicle types fetch failed: ${vehicleTypeState.message}',
          );
        }
      }
    });

    // Add vehicle brand cubit stream listener
    _vehicleBrandCubit.stream.listen((vehicleBrandState) {
      if (state is AdminMainConnected) {
        if (vehicleBrandState is AdminVehicleBrandLoaded) {
          _isVehicleBrandsLoaded = true;
          _updateConnectedState();
        } else if (vehicleBrandState is AdminVehicleBrandLoading) {
          _isVehicleBrandsLoaded = false;
          _updateConnectedState();
        } else if (vehicleBrandState is AdminVehicleBrandError) {
          _handleAuthError(
            'Vehicle brands fetch failed: ${vehicleBrandState.message}',
          );
        }
      }
    });

    _userInfoCubit.stream.listen((userInfoState) {
      if (state is AdminMainConnected) {
        if (userInfoState is UserInfoSuccess) {
          _isVehicleBrandsLoaded = true;
          _updateConnectedState();
        } else if (userInfoState is UserInfoLoading) {
          _isVehicleBrandsLoaded = false;
          _updateConnectedState();
        } else if (userInfoState is UserInfoError) {
          _handleAuthError('user fetch failed: ${userInfoState.errorMessage}');
        }
      }
    });
  }

  void _updateConnectedState() {
    if (state is AdminMainConnected) {
      final currentState = state as AdminMainConnected;
      emit(
        AdminMainConnected(
          accessToken: currentState.accessToken,
          isStatisticsLoaded: _isStatisticsLoaded,
          isReportsLoaded: _isReportsLoaded,
          isUserStatisticsLoaded: _isStatisticsUsersLoaded,
          isVehicleTypesLoaded: _isVehicleTypesLoaded,
          isVehicleBrandsLoaded: _isVehicleBrandsLoaded,
          isSignalRConnected: _isSignalRConnected,
          isUserInfoLoaded: _isUserInfoLoaded,
        ),
      );
    }
  }

  Future<void> initializeScreen() async {
    if (_isInitializing) {
      return;
    }
    _isInitializing = true;
    emit(AdminMainLoading());

    try {
      await _checkAndRefreshToken();
    } catch (e) {
      _handleAuthError('Initialization error: ${e.toString()}');
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
      emit(AdminMainDisconnected());
    }
  }

  Future<void> checkInternetConnection() async {
    final hasInternet = await _internetChecker.hasConnection;
    if (hasInternet) {
      _loadAccessToken();
    } else {
      _disconnectSignalR();
      emit(AdminMainDisconnected());
    }
  }

  Future<void> _loadAccessToken() async {
    if (_isInitializing) {
      return;
    }
    _isInitializing = true;

    try {
      final token = await _secureStorage.read(key: 'accessToken');
      final userIdStr = await _secureStorage.read(key: 'userId');
      final userId = userIdStr != null ? int.tryParse(userIdStr) : null;
      if (token != null) {
        _isStatisticsLoaded = false;
        _isReportsLoaded = false;
        _isStatisticsUsersLoaded = false;
        _isVehicleTypesLoaded = false;
        _isVehicleBrandsLoaded = false;
        _isSignalRConnected = false;
        _isUserInfoLoaded = false;
        emit(
          AdminMainConnected(
            accessToken: token,
            isStatisticsLoaded: false,
            isReportsLoaded: false,
            isUserStatisticsLoaded: false,
            isVehicleTypesLoaded: false,
            isVehicleBrandsLoaded: false,
            isSignalRConnected: false,
            isUserInfoLoaded: false,
          ),
        );

        _fetchData(token);
        if (userId != null) {
          _connectToSignalR(userId);
        }
      } else {
        _handleAuthError('Login required. Please sign in again.');
      }
    } catch (e) {
      _handleAuthError('Error retrieving access token: ${e.toString()}');
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
    emit(AdminMainAuthError(message));
  }

  void _fetchData(String accessToken) {
    _statisticsCubit.fetchTotalReports(accessToken);
    _reportCubit.fetchReports(accessToken, null, null, null, null);
    _userStatisticsCubit.fetchUserTotals(accessToken);
    _vehicleTypeCubit.fetchVehicleTypes(accessToken);
    _vehicleBrandCubit.fetchVehicleBrands(accessToken);
    _secureStorage.read(key: 'userId').then((userIdStr) {
      final userId = userIdStr != null ? int.tryParse(userIdStr) : null;
      if (userId != null) {
        _userInfoCubit.fetchUserInfo(userId.toString(), accessToken);
      }
    });
  }

  void handleTokenRefreshSuccess(String accessToken) {
    emit(
      AdminMainConnected(
        accessToken: accessToken,
        isStatisticsLoaded: false,
        isReportsLoaded: false,
        isUserStatisticsLoaded: false,
        isVehicleTypesLoaded: false,
        isVehicleBrandsLoaded: false,
        isSignalRConnected: _isSignalRConnected,
        isUserInfoLoaded: false,
      ),
    );
    _fetchData(accessToken);
    if (!_signalRService.isConnected) {
      _secureStorage.read(key: 'userId').then((userIdStr) {
        final userId = userIdStr != null ? int.tryParse(userIdStr) : null;
        if (userId != null) {
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
    if (state is AdminMainConnected) {
      final accessToken = (state as AdminMainConnected).accessToken;

      _fetchData(accessToken);

      if (!_signalRService.isConnected) {
        _secureStorage.read(key: 'userId').then((userIdStr) {
          final userId = userIdStr != null ? int.tryParse(userIdStr) : null;
          if (userId != null) {
            _connectToSignalR(userId);
          }
        });
      }
    }
  }

  AdminVehicleTypeCubit get vehicleTypeCubit => _vehicleTypeCubit;
  AdminVehicleBrandCubit get vehicleBrandCubit => _vehicleBrandCubit;
}
