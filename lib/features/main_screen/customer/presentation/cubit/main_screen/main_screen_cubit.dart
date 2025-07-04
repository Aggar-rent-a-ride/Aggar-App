import 'package:aggar/core/cubit/user_cubit/user_info_state.dart';
import 'package:aggar/core/services/signalr_service.dart';
import 'package:aggar/features/main_screen/customer/presentation/cubit/vehicles/vehicle_cubit.dart';
import 'package:aggar/features/main_screen/customer/presentation/cubit/vehicles/vehicle_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
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
  bool _signalRInitialized = false;

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
  }

  void _setupInternetChecker() {
    _internetChecker = InternetConnectionChecker.createInstance();
    _internetChecker.onStatusChange.listen(_handleConnectivityChange);
  }

  void _setupSignalRListeners() {
    _signalRService.onConnectionChange.listen((isConnected) {
      _isSignalRConnected = isConnected;
      print('SignalR connection changed: $isConnected');
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

  // Main initialization method called from MainScreen
  Future<void> initializeApp() async {
    if (_isInitializing) {
      print('MainCubit - Already initializing, skipping...');
      return;
    }

    _isInitializing = true;
    print('MainCubit - Starting app initialization...');
    emit(MainLoading());

    try {
      // Check internet connection first
      final hasInternet = await _internetChecker.hasConnection;
      if (!hasInternet) {
        print('MainCubit - No internet connection');
        emit(MainDisconnected());
        return;
      }

      // Check and refresh token if needed
      await _checkAndRefreshToken();

      // Get user credentials
      final credentials = await _getUserCredentials();
      if (credentials == null) {
        _handleAuthError('No valid credentials found');
        return;
      }

      // Initialize SignalR
      await _initializeSignalR(credentials['userId'] as int);

      // Set connected state
      emit(MainConnected(
        accessToken: credentials['accessToken'] as String,
        isVehicleBrandsLoaded: false,
        isVehicleTypesLoaded: false,
        isVehicleLoaded: false,
        isSignalRConnected: _isSignalRConnected,
        isUserLoaded: false,
      ));

      // Fetch all data
      _fetchData(credentials['accessToken'] as String);
    } catch (e) {
      print('MainCubit - Error during initialization: $e');
      _handleAuthError('Initialization error: ${e.toString()}');
    } finally {
      _isInitializing = false;
    }
  }

  Future<Map<String, dynamic>?> _getUserCredentials() async {
    try {
      final accessToken = await _secureStorage.read(key: 'accessToken');
      String? userIdStr = await _secureStorage.read(key: 'userId');

      // If userId is null or empty, try to extract from token
      if (userIdStr == null || userIdStr.isEmpty || userIdStr == '0') {
        print('MainCubit - UserId is null/empty/0, extracting from token...');
        if (accessToken != null) {
          try {
            final Map<String, dynamic> decodedToken =
                JwtDecoder.decode(accessToken);
            final extractedUserId = decodedToken['sub'] ?? decodedToken['uid'];
            if (extractedUserId != null) {
              userIdStr = extractedUserId.toString();
              await _secureStorage.write(key: 'userId', value: userIdStr);
              print('MainCubit - Extracted userId from token: $userIdStr');
            }
          } catch (e) {
            print('MainCubit - Error extracting userId from token: $e');
          }
        }
      }

      final userId = userIdStr != null ? int.tryParse(userIdStr) : null;

      if (accessToken != null && userId != null && userId > 0) {
        return {
          'accessToken': accessToken,
          'userId': userId,
        };
      }

      return null;
    } catch (e) {
      print('MainCubit - Error getting user credentials: $e');
      return null;
    }
  }

  Future<void> _initializeSignalR(int userId) async {
    if (_signalRInitialized) {
      print('MainCubit - SignalR already initialized, checking connection...');
      _isSignalRConnected = _signalRService.isConnected;
      return;
    }

    try {
      print('MainCubit - Initializing SignalR for userId: $userId');
      await _signalRService.initialize(userId: userId);
      _signalRInitialized = true;
      _isSignalRConnected = _signalRService.isConnected;
      print(
          'MainCubit - SignalR initialized successfully. Connected: $_isSignalRConnected');
    } catch (e) {
      print('MainCubit - Error initializing SignalR: $e');
      _isSignalRConnected = false;
    }
  }

  Future<void> _checkAndRefreshToken() async {
    try {
      final needsRefresh = await _tokenRefreshCubit.shouldRefreshToken();
      if (needsRefresh) {
        print('MainCubit - Refreshing token...');
        await _tokenRefreshCubit.refreshToken();
      }
    } catch (e) {
      print('MainCubit - Token refresh error: $e');
      throw Exception('Token refresh failed: ${e.toString()}');
    }
  }

  void _handleConnectivityChange(InternetConnectionStatus status) {
    final hasInternet = status == InternetConnectionStatus.connected;
    print('MainCubit - Connectivity changed: $hasInternet');

    if (hasInternet) {
      if (state is MainDisconnected) {
        initializeApp();
      }
    } else {
      _disconnectSignalR();
      emit(MainDisconnected());
    }
  }

  Future<void> _connectToSignalR(int userId) async {
    if (_signalRInitialized && _signalRService.isConnected) {
      print('MainCubit - SignalR already connected');
      return;
    }

    try {
      await _signalRService.initialize(userId: userId);
      _signalRInitialized = true;
      _isSignalRConnected = _signalRService.isConnected;
      _updateConnectedState();
    } catch (e) {
      print('MainCubit - Error connecting to SignalR: $e');
      _isSignalRConnected = false;
      _updateConnectedState();
    }
  }

  Future<void> _disconnectSignalR() async {
    if (_signalRService.isConnected) {
      await _signalRService.disconnect();
      _isSignalRConnected = false;
      _signalRInitialized = false;
    }
  }

  void _handleAuthError(String message) {
    print('MainCubit - Auth error: $message');
    _disconnectSignalR();
    emit(MainAuthError(message));
  }

  void _fetchData(String accessToken) {
    print('MainCubit - Fetching data...');
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
    print('MainCubit - Token refresh successful');
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
    print('MainCubit - Token refresh failed: $errorMessage');
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

  // Updated method to handle retry from network dialog
  Future<void> checkInternetConnection() async {
    print('MainCubit - Checking internet connection...');

    final hasInternet = await _internetChecker.hasConnection;

    if (hasInternet) {
      print('MainCubit - Internet available, reinitializing app...');
      await initializeApp();
    } else {
      print('MainCubit - No internet connection');
      emit(MainDisconnected());
    }
  }

  // Keep the old methods for backward compatibility but mark them as deprecated
  @deprecated
  Future<void> initializeScreen() async {
    await initializeApp();
  }

  @deprecated
  Future<void> checkConnectionStatus() async {
    // This method is no longer needed as initializeApp handles everything
    print(
        'MainCubit - checkConnectionStatus is deprecated, use initializeApp instead');
  }
}
