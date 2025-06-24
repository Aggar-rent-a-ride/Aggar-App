import 'package:aggar/core/cubit/user_cubit/user_info_cubit.dart';
import 'package:aggar/core/cubit/user_cubit/user_info_state.dart';
import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/utils/app_assets.dart';
import 'package:aggar/features/messages/views/messages_status/presentation/widgets/widgets/avatar_chat_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import '../../../../core/cubit/edit_user_info/edit_user_info_cubit.dart';
import '../../../../core/cubit/edit_user_info/edit_user_info_state.dart';

class EditUserPhoto extends StatelessWidget {
  const EditUserPhoto({
    super.key,
  });

  Future<void> _pickImage(BuildContext context) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final File imageFile = File(pickedFile.path);
      context.read<EditUserInfoCubit>().updateImage(imageFile);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserInfoCubit, UserInfoState>(
      builder: (context, userState) {
        if (userState is UserInfoLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (userState is UserInfoSuccess) {
          final user = userState.userInfoModel;

          return BlocBuilder<EditUserInfoCubit, EditUserInfoState>(
            builder: (context, editState) {
              Widget imageWidget;
              if (editState is EditUserInfoImageUpdated) {
                imageWidget = CircleAvatar(
                  radius: 75,
                  backgroundImage: FileImage(editState.image),
                );
              } else if (user.imageUrl != null && user.imageUrl!.isNotEmpty) {
                imageWidget = AvatarChatView(
                  image: user.imageUrl,
                  size: 150,
                );
              } else {
                imageWidget = Image.asset(
                  AppAssets.assetsImagesDafaultPfp,
                  height: 150,
                  width: 150,
                  fit: BoxFit.cover,
                );
              }
              return Positioned(
                top: MediaQuery.of(context).size.height * 0.1,
                left: 0,
                right: 0,
                child: GestureDetector(
                  onTap: () => _pickImage(context),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      CircleAvatar(
                        backgroundColor: context.theme.white100_1,
                        radius: 83,
                        child: Container(
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 4,
                                offset: Offset(0, 0),
                              ),
                            ],
                          ),
                          child: imageWidget,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        } else {
          return const Center(child: Text('Error loading user data'));
        }
      },
    );
  }
}
