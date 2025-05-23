import 'package:aggar/core/api/dio_consumer.dart';
import 'package:aggar/core/api/end_points.dart';
import 'package:aggar/core/helper/handle_error.dart';
import 'package:aggar/features/main_screen/admin/presentation/cubit/user_statistics/user_statistics_state.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserStatisticsCubit extends Cubit<UserStatisticsState> {
  UserStatisticsCubit() : super(UserStatisticsInitial());
  final DioConsumer dioConsumer = DioConsumer(dio: Dio());
  final List<String> userTypes = ["Admin", "Renter", "Customer"];
  Future<void> fetchUserTotals(String accessToken) async {
    try {
      emit(UserStatisticsUserLoading()); // Updated state
      final Map<String, int> totalUsersByRole = {};
      for (String role in userTypes) {
        final response = await dioConsumer.get(
          EndPoint.getTotalUserCount,
          queryParameters: {"role": role},
          options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
        );
        print('Response for role $role: $response'); // Debug log
        totalUsersByRole[role] = response["data"] ?? 0; // Fallback to 0 if null
      }
      print('Total Users by Role: $totalUsersByRole'); // Debug log
      emit(UserStatisticsUserTotalsLoaded(
          totalUsersByRole: totalUsersByRole)); // Updated state and property
    } catch (error) {
      String errorMessage = handleError(error);
      print('Error fetching user totals: $errorMessage'); // Debug log
      emit(UserStatisticsError(
          message: 'Failed to fetch user totals: $errorMessage'));
    }
  }
}
