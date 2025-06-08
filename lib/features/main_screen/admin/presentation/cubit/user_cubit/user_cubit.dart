import 'package:aggar/core/api/dio_consumer.dart';
import 'package:aggar/core/api/end_points.dart';
import 'package:aggar/core/helper/handle_error.dart';
import 'package:aggar/features/main_screen/admin/model/list_user_model.dart';
import 'package:aggar/features/main_screen/admin/model/user_model.dart';
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
  bool isLoadingMore = false;
  int currentPage = 1;
  List<UserModel> allUsers = [];
  String? _lastSearchKey;
  int _totalPages = 0;

  int get totalPages => _totalPages;

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
      _totalPages = users.totalPages ?? 0;
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
      allUsers.clear();
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
        allUsers = users.data;
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
      // ignore: unused_local_variable
      final response = await dioConsumer.delete(
        EndPoint.deleteUser,
        queryParameters: {"userId": userId},
        options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
      );
      if (_lastSearchKey != null && _lastSearchKey!.isNotEmpty) {
        await searchUsers(accessToken, _lastSearchKey!);
      } else {
        _totalPages = 0;
        allUsers.clear();
        emit(UserNoSearch());
      }
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
        allUsers.clear();
        emit(UserNoSearch());
      }
    } catch (error) {
      String errorMessage = handleError(error);
      emit(UserError(message: 'Failed to punish user: $errorMessage'));
    }
  }

  Future<void> getUserWithRole(String accessToken, String role,
      {bool isLoadMore = false}) async {
    if (isLoadMore && currentPage > _totalPages && _totalPages > 0) {
      isLoadingMore = false;
      return;
    }

    try {
      if (!isLoadMore) {
        emit(UserLoading());
        currentPage = 1;
        allUsers.clear();
      } else {
        isLoadingMore = true;
        emit(UsersLoadingMore(
          users: ListUserModel(
            data: allUsers,
            totalPages: _totalPages,
          ),
        ));
      }

      final response = await dioConsumer.get(
        EndPoint.getTotalUser,
        queryParameters: {
          "role": role,
          "pageNo": currentPage,
          "pageSize": 15,
        },
        options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
      );

      final users = ListUserModel.fromJson(response);
      _totalPages = users.totalPages ?? 0;
      if (isLoadMore) {
        allUsers.addAll(users.data);
      } else {
        allUsers = List.from(users.data);
      }

      if (users.data.isNotEmpty || !isLoadMore) {
        currentPage++;
      }

      isLoadingMore = false;
      emit(UserLoaded(
        users: ListUserModel(
          data: allUsers,
          totalPages: _totalPages,
        ),
      ));
    } catch (error) {
      isLoadingMore = false;
      String errorMessage = handleError(error);
      emit(UserError(message: 'Failed to fetch users by role: $errorMessage'));
    }
  }

  Future<void> refreshUsers(String accessToken, String role) async {
    currentPage = 1;
    allUsers.clear();
    await getUserWithRole(accessToken, role);
  }

  void reset() {
    _lastSearchKey = null;
    _totalPages = 0;
    currentPage = 1;
    allUsers.clear();
    searchController.clear();
    emit(UserNoSearch());
  }

  Future<Map<String, dynamic>> getUserById(String accessToken, int id) async {
    try {
      emit(UserLoading());
      final response = await dioConsumer.get(
        "${EndPoint.getUser}$id",
        options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
      );
      emit(UserLoaded(
          users: ListUserModel(data: [UserModel.fromJson(response['data'])])));
      print(response);
      return response;
    } catch (error) {
      String errorMessage = handleError(error);
      emit(UserError(message: 'Failed to fetch user by ID: $errorMessage'));
      rethrow;
    }
  }

  @override
  Future<void> close() {
    _debounceTimer?.cancel();
    searchController.dispose();
    return super.close();
  }
}
