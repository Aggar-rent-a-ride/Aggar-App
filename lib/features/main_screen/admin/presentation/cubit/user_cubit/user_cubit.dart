import 'package:aggar/core/api/dio_consumer.dart';
import 'package:aggar/core/api/end_points.dart';
import 'package:aggar/core/helper/handle_error.dart';
import 'package:aggar/features/main_screen/admin/presentation/cubit/user_cubit/user_state.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserCubit extends Cubit<UserState> {
  UserCubit() : super(UserInitial());
  final DioConsumer dioConsumer = DioConsumer(dio: Dio());

  final List<String> userTypes = [
    "Admin",
    "Renter",
    "Customer",
  ];

  Future<void> fetchUserTotals(String accessToken) async {
    try {
      emit(UserLoading());
      final Map<String, int> totalUsersByRole = {};
      for (String role in userTypes) {
        final response = await dioConsumer.get(
          EndPoint.getTotalUserCount,
          queryParameters: {
            "role": role,
          },
          options: Options(
            headers: {
              'Authorization': 'Bearer $accessToken',
              'Content-Type': 'application/json',
            },
          ),
        );
        totalUsersByRole[role] = response["data"];
      }
      emit(UserTotalsLoaded(totalReportsByType: totalUsersByRole));
    } catch (error) {
      String errorMessage = handleError(error);
      emit(UserError(message: 'Failed to fetch user totals: $errorMessage'));
    }
  }
}
