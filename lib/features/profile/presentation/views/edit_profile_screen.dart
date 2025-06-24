import 'package:aggar/core/cubit/edit_user_info/edit_user_info_cubit.dart';
import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/core/widgets/custom_dialog.dart';
import 'package:aggar/features/profile/presentation/widgets/edit_user_info_list_field.dart';
import 'package:aggar/features/profile/presentation/widgets/edit_user_photo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key, required this.userId});
  final String userId;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<EditUserInfoCubit>();
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (didPop) return;
        await _showDiscardDialog(context);
      },
      child: Scaffold(
        backgroundColor: context.theme.white100_1,
        body: Form(
          key: context.read<EditUserInfoCubit>().formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height * 0.2,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 4,
                            offset: Offset(0, 0),
                          ),
                        ],
                        color: context.theme.blue100_1,
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(25),
                          bottomRight: Radius.circular(25),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Gap(35),
                          Row(
                            children: [
                              IconButton(
                                onPressed: () => _showDiscardDialog(context),
                                icon: Icon(
                                  Icons.arrow_back_ios_new_rounded,
                                  color: context.theme.white100_1,
                                ),
                              ),
                              Gap(MediaQuery.sizeOf(context).width * 0.26),
                              Text(
                                "Edit Profile",
                                style: AppStyles.bold20(context).copyWith(
                                  color: context.theme.white100_1,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    const EditUserPhoto(),
                  ],
                ),
                const Gap(85),
                EditUserInfoListField(cubit: cubit),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _showDiscardDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      builder: (context) => CustomDialog(
        title: "Cancel Changes",
        actionTitle: "Discard",
        subtitle: "Are you sure you want to discard the changes?",
        onPressed: () {
          Navigator.pop(context);
          Navigator.pop(context);
        },
      ),
    );
  }
}
