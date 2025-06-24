import 'package:aggar/core/cubit/user_cubit/user_info_cubit.dart';
import 'package:aggar/core/cubit/user_cubit/user_info_state.dart';
import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/features/messages/views/messages_status/presentation/widgets/widgets/avatar_chat_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserPhoto extends StatelessWidget {
  const UserPhoto({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserInfoCubit, UserInfoState>(builder: (context, state) {
      if (state is UserInfoLoading) {
        return const Center(child: CircularProgressIndicator());
      } else if (state is UserInfoSuccess) {
        final user = state.userInfoModel;
        return Positioned(
          top: MediaQuery.of(context).size.height * 0.1,
          left: 0,
          right: 0,
          child: CircleAvatar(
            backgroundColor: context.theme.white100_1,
            radius: 50,
            child: AvatarChatView(
              image: user.imageUrl,
              size: 90,
            ),
          ),
        );
      } else {
        return const Center(child: Text('Error loading user data'));
      }
    });
  }
}
