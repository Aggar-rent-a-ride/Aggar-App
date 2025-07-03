import 'package:aggar/core/cubit/refresh%20token/token_refresh_cubit.dart';
import 'package:aggar/core/cubit/user_cubit/user_info_cubit.dart';
import 'package:aggar/core/cubit/user_cubit/user_info_state.dart';
import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/helper/custom_snack_bar.dart';
import 'package:aggar/core/utils/app_assets.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/core/widgets/splet_container.dart';
import 'package:aggar/features/messages/views/messages_status/presentation/widgets/widgets/avatar_chat_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import '../../../../core/cubit/edit_user_info/edit_user_info_cubit.dart';
import '../../../../core/cubit/edit_user_info/edit_user_info_state.dart';

class EditUserPhoto extends StatelessWidget {
  const EditUserPhoto({
    super.key,
  });

  Future<void> _showImageOptions(BuildContext context) async {
    final editCubit = context.read<EditUserInfoCubit>();
    final userCubit = context.read<UserInfoCubit>();
    final tokenCubit = context.read<TokenRefreshCubit>();
    final token = await tokenCubit.getAccessToken();
    await showModalBottomSheet(
      backgroundColor: context.theme.white100_1,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
        ),
      ),
      sheetAnimationStyle: const AnimationStyle(
        duration: Duration(milliseconds: 300),
        curve: Curves.ease,
        reverseDuration: Duration(milliseconds: 300),
        reverseCurve: Curves.ease,
      ),
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.sizeOf(context).height * 0.8,
            minHeight: 200,
          ),
          child: IntrinsicHeight(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Gap(10),
                    const SpletContainer(),
                    const Gap(10),
                    ListTile(
                      leading: Icon(
                        Icons.photo_library,
                        color: context.theme.blue100_1,
                      ),
                      title: Text(
                        'Pick from Gallery',
                        style: AppStyles.medium16(context).copyWith(
                          color: context.theme.blue100_1,
                        ),
                      ),
                      onTap: () async {
                        Navigator.pop(context);
                        final picker = ImagePicker();
                        final pickedFile =
                            await picker.pickImage(source: ImageSource.gallery);
                        if (pickedFile != null) {
                          final File imageFile = File(pickedFile.path);
                          editCubit.updateImage(imageFile);
                        }
                      },
                    ),
                    ListTile(
                      leading: Icon(
                        Icons.delete,
                        color: context.theme.red100_1,
                      ),
                      title: Text(
                        'Remove Image',
                        style: AppStyles.medium16(context).copyWith(
                          color: context.theme.red100_1,
                        ),
                      ),
                      onTap: () async {
                        if (token != null) {
                          Navigator.pop(context);
                          await editCubit.removeProfileImage(token: token);
                        }
                      },
                    ),
                    const Gap(20),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<EditUserInfoCubit, EditUserInfoState>(
      listener: (context, state) {
        if (state is EditUserInfoSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            customSnackBar(
              context,
              "Success",
              "Profile updated successfull",
              SnackBarType.success,
            ),
          );
        } else if (state is EditUserInfoImageRemoved) {
          ScaffoldMessenger.of(context).showSnackBar(
            customSnackBar(
              context,
              "Success",
              "Profile Image Removed Successfully",
              SnackBarType.success,
            ),
          );
        } else if (state is EditUserInfoError) {
          ScaffoldMessenger.of(context).showSnackBar(
            customSnackBar(
              context,
              "Error",
              "Unexpected error occurred",
              SnackBarType.error,
            ),
          );
        }
      },
      child: BlocBuilder<UserInfoCubit, UserInfoState>(
        builder: (context, userState) {
          if (userState is UserInfoLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (userState is UserInfoSuccess) {
            final user = userState.userInfoModel;
            final editCubit = context.read<EditUserInfoCubit>();

            return BlocBuilder<EditUserInfoCubit, EditUserInfoState>(
              builder: (context, editState) {
                Widget imageWidget;
                if (editState is EditUserInfoImageUpdated &&
                    editCubit.selectedImage != null) {
                  imageWidget = CircleAvatar(
                    radius: 75,
                    backgroundImage: FileImage(editCubit.selectedImage!),
                  );
                } else if (editState is EditUserInfoImageRemoved ||
                    editCubit.selectedImage == null &&
                        (user.imageUrl == null || user.imageUrl!.isEmpty)) {
                  imageWidget = Image.asset(
                    AppAssets.assetsImagesDafaultPfp,
                    height: 150,
                    width: 150,
                    fit: BoxFit.cover,
                  );
                } else {
                  imageWidget = AvatarChatView(
                    image: user.imageUrl,
                    size: 150,
                  );
                }
                return Positioned(
                  top: MediaQuery.of(context).size.height * 0.1,
                  left: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: () => _showImageOptions(context),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        CircleAvatar(
                          backgroundColor: context.theme.white100_1,
                          radius: 83,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(90),
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
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          } else {
            return Positioned(
              top: MediaQuery.of(context).size.height * 0.1,
              left: 0,
              right: 0,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  CircleAvatar(
                    backgroundColor: context.theme.white100_1,
                    radius: 83,
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(83),
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
                          child: Image.asset(AppAssets.assetsImagesDafaultPfp),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
