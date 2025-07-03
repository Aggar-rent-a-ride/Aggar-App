import 'package:aggar/core/cubit/user_review_cubit/user_review_cubit.dart';
import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/features/main_screen/admin/model/user_model.dart';
import 'package:aggar/features/messages/views/messages_status/data/model/message_model.dart';
import 'package:aggar/features/messages/views/messages_status/presentation/cubit/message_cubit/message_cubit.dart';
import 'package:aggar/features/messages/views/personal_chat/data/cubit/personal_chat/personal_chat_cubit.dart';
import 'package:aggar/features/messages/views/personal_chat/data/cubit/personal_chat/personal_chat_state.dart';
import 'package:aggar/features/messages/views/personal_chat/data/cubit/real%20time%20chat/real_time_chat_cubit.dart';
import 'package:aggar/features/messages/views/personal_chat/data/cubit/real%20time%20chat/real_time_chat_state.dart';
import 'package:aggar/features/messages/views/personal_chat/presentation/widgets/image_and_name_person_message.dart';
import 'package:aggar/features/messages/views/personal_chat/presentation/widgets/menu_icon_button.dart';
import 'package:aggar/features/messages/views/personal_chat/presentation/widgets/personal_chat_body.dart';
import 'package:aggar/features/messages/views/personal_chat/presentation/widgets/search_for_msg_by_content_or_date.dart';
import 'package:aggar/core/api/dio_consumer.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/cubit/refresh token/token_refresh_cubit.dart';
import '../../../../../../core/cubit/user_cubit/user_info_cubit.dart';
import '../../../../../profile/presentation/views/show_profile_screen.dart';
import '../../../../../vehicle_details_after_add/presentation/cubit/review_count/review_count_cubit.dart';

class PersonalChatView extends StatefulWidget {
  const PersonalChatView({
    super.key,
    required this.messageList,
    this.onMessagesUpdated,
    required this.receiverId,
    required this.receiverName,
    this.reciverImg,
  });

  final List<MessageModel> messageList;
  final int receiverId;
  final VoidCallback? onMessagesUpdated;
  final String receiverName;
  final String? reciverImg;

  @override
  State<PersonalChatView> createState() => _PersonalChatViewState();
}

class _PersonalChatViewState extends State<PersonalChatView> {
  late final PersonalChatCubit personalChatCubit;
  late final RealTimeChatCubit realTimeChatCubit;
  late final MessageCubit messageCubit;
  int senderId = 0;

  @override
  void initState() {
    super.initState();
    messageCubit = MessageCubit(dioConsumer: DioConsumer(dio: Dio()));
    personalChatCubit = PersonalChatCubit();
    realTimeChatCubit = RealTimeChatCubit(messageCubit);

    personalChatCubit.setMessages(widget.messageList);
    personalChatCubit.setReceiverId(widget.receiverId);

    realTimeChatCubit.setMessages(widget.messageList);
    realTimeChatCubit.setReceiverId(widget.receiverId);

    _initializeUser();
    _setupMessageListeners();
  }

  Future<void> _initializeUser() async {
    await realTimeChatCubit.initializeSenderId();
    setState(() {
      senderId = realTimeChatCubit.senderId;
    });
  }

  void _setupMessageListeners() {
    // Listen for new messages
    realTimeChatCubit.stream.listen((state) {
      if (state is MessageAddedState ||
          state is MessageSentSuccessfully ||
          state is FileUploadComplete) {
        widget.onMessagesUpdated?.call();
      }
    });
  }

  @override
  void dispose() {
    widget.onMessagesUpdated?.call();
    personalChatCubit.close();
    realTimeChatCubit.close();
    messageCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: personalChatCubit),
        BlocProvider.value(value: realTimeChatCubit),
        BlocProvider.value(value: messageCubit),
      ],
      child: BlocBuilder<PersonalChatCubit, PersonalChatState>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              toolbarHeight: 70,
              iconTheme: IconThemeData(
                color: context.theme.white100_2,
              ),
              elevation: 1,
              shadowColor: Colors.grey[900],
              centerTitle: false,
              surfaceTintColor: Colors.transparent,
              backgroundColor: context.theme.blue100_1,
              title: personalChatCubit.isSearchActive
                  ? SearchForMsgByContentOrDate(cubit: personalChatCubit)
                  : GestureDetector(
                      onTap: () async {
                        final tokenCubit = context.read<TokenRefreshCubit>();
                        final token = await tokenCubit.getAccessToken();
                        if (token != null) {
                          context.read<UserInfoCubit>().fetchUserInfo(
                              widget.receiverId.toString(), token);
                          context.read<UserReviewCubit>().getUserReviews(
                              widget.receiverId.toString(), token);
                          context.read<ReviewCountCubit>().getUserReviewsNumber(
                              widget.receiverId.toString(), token);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ShowProfileScreen(
                                user: UserModel(
                                  username: "",
                                  id: widget.receiverId,
                                  name: widget.receiverName,
                                  imagePath: widget.reciverImg,
                                ),
                              ),
                            ),
                          );
                        }
                      },
                      child: ImageAndNamePersonMessage(
                        name: widget.receiverName,
                        image: widget.reciverImg,
                      ),
                    ),
              leading: personalChatCubit.isSearchActive
                  ? IconButton(
                      icon: Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: context.theme.white100_2,
                      ),
                      onPressed: () {
                        personalChatCubit.clearSearch();
                      },
                    )
                  : IconButton(
                      icon: Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: context.theme.white100_2,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
              actions: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: personalChatCubit.isSearchActive
                      ? IconButton(
                          onPressed: () async {
                            personalChatCubit.selectDate(context);
                          },
                          icon: Icon(
                            color: context.theme.white100_2,
                            Icons.date_range_outlined,
                          ),
                        )
                      : MenuIconButton(
                          cubit: personalChatCubit,
                          userId: widget.receiverId,
                        ),
                ),
              ],
            ),
            backgroundColor: context.theme.white100_1,
            body: PersonalChatBody(
              reciverId: widget.receiverId.toString(),
              currentUserId: senderId,
              reciverName: widget.receiverName,
            ),
          );
        },
      ),
    );
  }
}
