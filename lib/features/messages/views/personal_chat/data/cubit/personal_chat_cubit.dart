import 'package:aggar/core/api/dio_consumer.dart';
import 'package:aggar/core/api/end_points.dart';
import 'package:aggar/features/messages/views/messages_status/data/model/list_message_model.dart';
import 'package:aggar/features/messages/views/personal_chat/data/cubit/personal_chat_state.dart';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class PersonalChatCubit extends Cubit<PersonalChatState> {
  PersonalChatCubit() : super(const PersonalChatInitial());
  final DioConsumer dioConsumer = DioConsumer(dio: Dio());
  bool isSearchActive = false;
  final TextEditingController searchController = TextEditingController();

  void toggleSearchMode() {
    if (state is PersonalChatSearch) {
      isSearchActive = !isSearchActive;
      if (!isSearchActive) {
        searchController.clear();
        emit(const PersonalChatInitial());
      } else {
        emit(PersonalChatSearch());
      }
    } else {
      isSearchActive = true;
      emit(PersonalChatSearch());
    }
  }

  void updateSearchQuery(String query) {
    searchController.text = query;
    searchController.selection = TextSelection.fromPosition(
      TextPosition(offset: searchController.text.length),
    );
    if (state is! PersonalChatSearch) {
      isSearchActive = true;
      emit(PersonalChatSearch());
    }
  }

  Future<void> filtterMessage(String accessToken) async {
    try {
      emit(PersonalChatLoading());
      final response = await dioConsumer.get(
        data: {
          ApiKey.filterMessagesSenderId: 11,
          ApiKey.filterMsgSearchContent: searchController.text,
          //ApiKey.filterMsgSearchType : "",
          ApiKey.filterMsgPageNo: 1,
          ApiKey.filterMsgPageSize: 30,
        },
        EndPoint.filterMessages,
        options: Options(
          headers: {
            'Authorization': 'Bearer $accessToken',
          },
        ),
      );
      print("Response: $response");
      if (response == null) {
        emit(const PersonalChatFailure("No response received from server."));
        return;
      }
      final ListMessageModel messages = ListMessageModel.fromJson(response);
      await Future.delayed(const Duration(seconds: 2));
      emit(PersonalChatSuccess(messages));
    } catch (e) {
      emit(PersonalChatFailure(e.toString()));
    }
  }

  void clearSearch() {
    isSearchActive = false;
    searchController.clear();
    emit(const PersonalChatInitial());
  }

  @override
  Future<void> close() {
    searchController.dispose();
    return super.close();
  }
}
