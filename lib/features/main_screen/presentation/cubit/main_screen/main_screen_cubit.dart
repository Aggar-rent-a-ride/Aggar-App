import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'main_screen_state.dart';

class MainScreenCubit extends Cubit<MainScreenState> {
  final FlutterSecureStorage secureStorage;

  MainScreenCubit({required this.secureStorage}) : super(MainScreenInitial());

  Future<void> loadAccessToken() async {
    try {
      emit(MainScreenLoading());

      final token = await secureStorage.read(key: 'accessToken');

      if (token != null && token.isNotEmpty) {
        emit(MainScreenAuthenticated(accessToken: token));
      } else {
        emit(MainScreenUnauthenticated());
      }
    } catch (e) {
      emit(MainScreenError(
          message: 'Error retrieving access token: ${e.toString()}'));
    }
  }
}
