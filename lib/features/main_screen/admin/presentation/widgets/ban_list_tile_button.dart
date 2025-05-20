import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/features/main_screen/admin/model/user_model.dart';
import 'package:aggar/features/main_screen/admin/presentation/cubit/user_cubit/user_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BanListTileButton extends StatelessWidget {
  BanListTileButton({
    super.key,
    required this.user,
  });

  final UserModel user;
  final TextEditingController durationController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.block),
      title: Text(
        "Ban User",
        style: AppStyles.semiBold16(context).copyWith(
          color: context.theme.black100,
        ),
      ),
      onTap: () {
        Navigator.pop(context);
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            backgroundColor: context.theme.white100_2,
            title: Text(
              "Ban User",
              style: AppStyles.semiBold24(context).copyWith(
                color: context.theme.black100,
              ),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Are you sure you want to ban ${user.name}?",
                  style: AppStyles.medium18(context).copyWith(
                    color: context.theme.gray100_2,
                  ),
                ),
                SizedBox(
                  width: 300,
                  child: TextField(
                    controller: durationController,
                    maxLines: 1,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: "Enter ban duration (days)",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.error),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.primary),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text(
                  'Cancel',
                  style: AppStyles.semiBold15(context).copyWith(
                    color: context.theme.blue100_1,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  final duration = int.tryParse(durationController.text) ?? 0;
                  if (duration <= 0) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Please enter a valid duration"),
                        backgroundColor: Colors.red,
                      ),
                    );
                    return;
                  }
                  context.read<UserCubit>().punishUser(
                        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMSIsImp0aSI6IjBjNTA2Yzg5LTIyNDctNDA3Yy1hOTk4LTBhZTA0Njk4YzNkYyIsInVzZXJuYW1lIjoibmFydSIsInVpZCI6IjExIiwicm9sZXMiOlsiQWRtaW4iLCJVc2VyIiwiQ3VzdG9tZXIiXSwiZXhwIjoxNzQ3NzI2MzA2LCJpc3MiOiJBZ2dhckFwaSIsImF1ZCI6IkZsdXR0ZXIifQ.l_s9yQcWtLqcsUuGdT1Tn0I4t5ZNlLBNP3P-IOdfIas",
                        user.id.toString(),
                        "Ban",
                        duration,
                      );
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("User banned successfully"),
                      backgroundColor: Colors.green,
                    ),
                  );
                },
                child: Text(
                  "Ban",
                  style: AppStyles.semiBold15(context).copyWith(
                    color: context.theme.red100_1,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
