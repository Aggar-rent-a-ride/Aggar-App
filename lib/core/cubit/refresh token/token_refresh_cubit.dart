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

  TokenRefreshCubit({
    required this.apiConsumer,
    required this.secureStorage,
  }) : super(TokenRefreshInitial()) {
    _loadCachedToken();
  }

  Future<void> _loadCachedToken() async {
    _cachedAccessToken = await secureStorage.read(key: 'accessToken');
  }

  Future<String?> getAccessToken() async {
    if (_cachedAccessToken != null && !await isTokenExpired()) {
      return _cachedAccessToken;
    }

    if (await shouldRefreshToken()) {
      try {
        await refreshToken();
        return _cachedAccessToken;
      } catch (e) {
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
        await isTokenExpired();
  }

  Future<bool> isTokenExpired() async {
    try {
      final accessToken = await secureStorage.read(key: 'accessToken');

      if (accessToken == null) return true;

      if (JwtDecoder.isExpired(accessToken)) {
        print('Access token has expired');
        return true;
      }

      // Optional: exact expiration time
      final DateTime expirationDate = JwtDecoder.getExpirationDate(accessToken);
      print('Token expires at: $expirationDate');

      return false;
    } catch (e) {
      print('Error checking token expiration: $e');
      return true;
    }
  }

}
