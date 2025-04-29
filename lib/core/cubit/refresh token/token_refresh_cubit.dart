import 'package:aggar/core/api/api_consumer.dart';
import 'package:aggar/core/api/end_points.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'token_refresh_state.dart';

class TokenRefreshCubit extends Cubit<TokenRefreshState> {
  final ApiConsumer apiConsumer;
  final FlutterSecureStorage secureStorage;
  String? _cachedAccessToken;
  
  final int _refreshBufferMinutes;
  TokenRefreshCubit({
    required this.apiConsumer,
    required this.secureStorage,
    int refreshBufferMinutes = 5, // Default to refresh 5 minutes before expiration
  }) : _refreshBufferMinutes = refreshBufferMinutes,
       super(TokenRefreshInitial()) {
    _loadCachedToken();
  }

  Future<void> _loadCachedToken() async {
    _cachedAccessToken = await secureStorage.read(key: 'accessToken');
  }

  Future<String?> getAccessToken() async {
    if (_cachedAccessToken != null && !await isTokenExpired(checkBuffer: true)) {
      return _cachedAccessToken;
    }

    if (await shouldRefreshToken()) {
      try {
        await refreshToken();
        return _cachedAccessToken;
      } catch (e) {
        print('Error refreshing token: $e');
        return null;
      }
    }
    return null;
  }

  String? get currentAccessToken => _cachedAccessToken;

  Future<void> refreshToken() async {
    try {
      emit(TokenRefreshLoading());

      final currentRefreshToken = await secureStorage.read(key: 'refreshToken');

      if (currentRefreshToken == null) {
        throw Exception('No refresh token available');
      }

      final refreshPayload = {
        ApiKey.refreshToken: currentRefreshToken,
      };

      final response = await apiConsumer.post(
        EndPoint.refreshToken,
        data: refreshPayload,
      );

      if (response != null &&
          response['data'] != null &&
          response[ApiKey.status] == 200) {
        final tokenData = response['data'];

        final newAccessToken = tokenData[ApiKey.accessToken];
        final newRefreshToken = tokenData[ApiKey.refreshToken];

        _cachedAccessToken = newAccessToken;

        DateTime? expirationDate;
        if (tokenData[ApiKey.refreshTokenExpiration] != null) {
          expirationDate =
              DateTime.parse(tokenData[ApiKey.refreshTokenExpiration]);
        }

        await _secureStoreTokens(
            accessToken: newAccessToken, refreshToken: newRefreshToken);

        emit(TokenRefreshSuccess(
          accessToken: newAccessToken,
          refreshToken: newRefreshToken,
          expirationDate: expirationDate,
        ));
      } else {
        throw Exception('Invalid token refresh response');
      }
    } catch (error) {
      print('Token Refresh Error: $error');
      _cachedAccessToken = null;
      emit(TokenRefreshFailure(error.toString()));
      rethrow;
    }
  }

  Future<String?> ensureValidToken() async {
    try {
      final accessToken = await secureStorage.read(key: 'accessToken');
      
      if (accessToken == null) {
        return null; 
      }
      
      if (await isTokenExpired(checkBuffer: true)) {
        await refreshToken();
      } else {
        _cachedAccessToken = accessToken;
      }
      
      return _cachedAccessToken;
    } catch (e) {
      print('Error ensuring valid token: $e');
      return null;
    }
  }

  Future<void> _secureStoreTokens(
      {required String accessToken, required String refreshToken}) async {
    try {
      await Future.wait([
        secureStorage.write(key: 'accessToken', value: accessToken),
        secureStorage.write(key: 'refreshToken', value: refreshToken),
        secureStorage.write(
            key: 'tokenStoredAt', value: DateTime.now().toIso8601String())
      ]);
    } catch (e) {
      print('Error storing tokens: $e');
      throw Exception('Failed to store tokens');
    }
  }

  Future<bool> shouldRefreshToken() async {
    final refreshToken = await secureStorage.read(key: 'refreshToken');
    final accessToken = await secureStorage.read(key: 'accessToken');

    return refreshToken == null ||
        accessToken == null ||
        await isTokenExpired(checkBuffer: true);
  }

  /// If [checkBuffer] is true, it will return true if the token will expire within 
  /// the buffer time (default 5 minutes)
  Future<bool> isTokenExpired({bool checkBuffer = false}) async {
    try {
      final accessToken = await secureStorage.read(key: 'accessToken');

      if (accessToken == null) return true;

      if (JwtDecoder.isExpired(accessToken)) {
        print('Access token has expired');
        return true;
      }


      final DateTime expirationDate = JwtDecoder.getExpirationDate(accessToken);
      
      if (checkBuffer) {
        final bufferThreshold = DateTime.now().add(Duration(minutes: _refreshBufferMinutes));
        if (expirationDate.isBefore(bufferThreshold)) {
          print('Token will expire soon (within $_refreshBufferMinutes minutes)');
          return true;
        }
      }

      return false;
    } catch (e) {
      print('Error checking token expiration: $e');
      return true;
    }
  }

  Future<Duration?> getTokenRemainingTime() async {
    try {
      final accessToken = await secureStorage.read(key: 'accessToken');
      
      if (accessToken == null) return null;
      
      final DateTime expirationDate = JwtDecoder.getExpirationDate(accessToken);
      return expirationDate.difference(DateTime.now());
    } catch (e) {
      print('Error getting token remaining time: $e');
      return null;
    }
  }
}