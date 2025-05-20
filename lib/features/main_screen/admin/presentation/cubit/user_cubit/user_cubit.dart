import 'package:aggar/core/api/dio_consumer.dart';
import 'package:aggar/core/api/end_points.dart';
import 'package:aggar/core/helper/handle_error.dart';
import 'package:aggar/features/main_screen/admin/model/list_user_model.dart';
import 'package:aggar/features/main_screen/admin/presentation/cubit/user_cubit/user_state.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:async';

class UserCubit extends Cubit<UserState> {
  UserCubit() : super(UserNoSearch());
  final DioConsumer dioConsumer = DioConsumer(dio: Dio());
  TextEditingController searchController = TextEditingController();
  Timer? _debounceTimer;

  final List<String> userTypes = ["Admin", "Renter", "Customer"];
  String? _lastSearchKey;
  int _totalPages = 0;

  int get totalPages => _totalPages;

  Future<void> fetchUserTotals(String accessToken) async {
    try {
      emit(UserLoading());
      final Map<String, int> totalUsersByRole = {};
      for (String role in userTypes) {
        final response = await dioConsumer.get(
          EndPoint.getTotalUserCount,
          queryParameters: {"role": role},
          options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
        );
        totalUsersByRole[role] = response["data"];
      }
      emit(UserTotalsLoaded(totalReportsByType: totalUsersByRole));
    } catch (error) {
      String errorMessage = handleError(error);
      emit(UserError(message: 'Failed to fetch user totals: $errorMessage'));
    }
  }

  Future<void> getTotalPages(String accessToken, String searchKey) async {
    if (searchKey.trim().isEmpty) {
      _totalPages = 0;
      return;
    }

    try {
      final response = await dioConsumer.get(
        EndPoint.getSearchUsers,
        queryParameters: {
          "searchKey": searchKey,
          "pageNo": 1,
          "pageSize": 1,
        },
        options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
      );
      final users = ListUserModel.fromJson(response);
      final totalUsers = users.totalPages;
      _totalPages = totalUsers ?? 0;
    } catch (error) {
      String errorMessage = handleError(error);
      emit(UserError(message: 'Failed to fetch total pages: $errorMessage'));
    }
  }

  Future<void> searchUsers(String accessToken, String searchKey) async {
    _debounceTimer?.cancel();
    if (searchKey.trim().isEmpty) {
      _lastSearchKey = null;
      _totalPages = 0;
      emit(UserNoSearch());
      return;
    }

    _debounceTimer = Timer(const Duration(milliseconds: 300), () async {
      try {
        emit(UserLoading());
        _lastSearchKey = searchKey;
        await getTotalPages(accessToken, searchKey);

        final response = await dioConsumer.get(
          EndPoint.getSearchUsers,
          queryParameters: {
            "searchKey": searchKey,
            "pageNo": 1,
            "pageSize": 8,
          },
          options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
        );
        final users = ListUserModel.fromJson(response);
        emit(UserLoaded(users: users));
      } catch (error) {
        String errorMessage = handleError(error);
        emit(UserError(message: 'Failed to search users: $errorMessage'));
      }
    });
  }

  Future<void> deleteUser(String accessToken, int userId) async {
    try {
      emit(UserLoading());
      final response = await dioConsumer.delete(
        EndPoint.deleteUser,
        queryParameters: {"userId": userId},
        options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
      );
      if (_lastSearchKey != null && _lastSearchKey!.isNotEmpty) {
        await searchUsers(accessToken, _lastSearchKey!);
      } else {
        _totalPages = 0;
        emit(UserNoSearch());
      }
      print(response);
    } catch (error) {
      String errorMessage = handleError(error);
      emit(UserError(message: 'Failed to delete user: $errorMessage'));
    }
  }

  Future<void> punishUser(
      String accessToken, String userId, String type, int? banDuration) async {
    try {
      emit(UserLoading());
      await dioConsumer.put(
        EndPoint.punishUser,
        data: {
          "userId": userId,
          "type": type,
          "banDurationInDays": banDuration,
        },
        options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
      );

      if (_lastSearchKey != null && _lastSearchKey!.isNotEmpty) {
        await searchUsers(accessToken, _lastSearchKey!);
      } else {
        _totalPages = 0;
        emit(UserNoSearch());
      }
    } catch (error) {
      String errorMessage = handleError(error);
      emit(UserError(message: 'Failed to punish user: $errorMessage'));
    }
  }

  Future<void> getUserWithRole(String accessToken, String role) async {
    try {
      emit(UserLoading());
      _lastSearchKey = null;
      _totalPages = 0;
      final totalResponse = await dioConsumer.get(
        EndPoint.getSearchUsers,
        queryParameters: {
          "role": role,
          "pageNo": 1,
          "pageSize": 1,
        },
        options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
      );
      final totalUsersModel = ListUserModel.fromJson(totalResponse);
      final totalUsers = totalUsersModel.totalPages;
      _totalPages = totalUsers ?? 0;

      final response = await dioConsumer.get(
        EndPoint.getSearchUsers,
        queryParameters: {
          "role": role,
          "pageNo": 1,
          "pageSize": 10,
        },
        options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
      );
      final users = ListUserModel.fromJson(response);
      emit(UserLoaded(users: users));
    } catch (error) {
      String errorMessage = handleError(error);
      emit(UserError(message: 'Failed to fetch users by role: $errorMessage'));
    }
  }

  @override
  Future<void> close() {
    _debounceTimer?.cancel();
    searchController.dispose();
    return super.close();
  }
}
