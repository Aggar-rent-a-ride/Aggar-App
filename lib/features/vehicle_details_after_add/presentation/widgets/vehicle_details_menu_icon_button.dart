import 'package:aggar/core/cubit/refresh%20token/token_refresh_cubit.dart';
import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/helper/custom_snack_bar.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/core/widgets/custom_dialog.dart';
import 'package:aggar/features/edit_vehicle/presentation/cubit/edit_vehicle_cubit.dart';
import 'package:aggar/features/edit_vehicle/presentation/cubit/edit_vehicle_state.dart';
import 'package:aggar/features/edit_vehicle/presentation/views/edit_vehicle_view.dart';
import 'package:aggar/features/profile/presentation/customer/presentation/cubit/profile/profile_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

class VehicleDetailsMenuIconButton extends StatelessWidget {
  const VehicleDetailsMenuIconButton({
    super.key,
    required this.vehicleId,
  });
  final String vehicleId;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<EditVehicleCubit, EditVehicleState>(
      listener: (context, state) async {
        if (state is EditVehicleDeleted) {
          // Refresh the vehicle list in ProfileCubit
          final tokenRefreshCubit = context.read<TokenRefreshCubit>();
          final token = await tokenRefreshCubit.getAccessToken();
          if (token != null) {
            context.read<ProfileCubit>().fetchRenterVehicles(token);
          }
          // Show success message and navigate back
          ScaffoldMessenger.of(context).showSnackBar(
            customSnackBar(
              context,
              "Success",
              "Vehicle deleted successfully",
              SnackBarType.success,
            ),
          );
          Navigator.pop(context);
        } else if (state is EditVehicleFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            customSnackBar(
              context,
              "Error",
              "Failed to delete vehicle: ${state.errorMessage}",
              SnackBarType.error,
            ),
          );
        }
      },
      builder: (context, state) {
        final isLoading = state is EditVehicleLoading;
        return IconButton(
          onPressed: isLoading
              ? null
              : () {
                  final RenderBox button =
                      context.findRenderObject() as RenderBox;
                  final RenderBox overlay = Overlay.of(context)
                      .context
                      .findRenderObject() as RenderBox;
                  final RelativeRect position = RelativeRect.fromRect(
                    Rect.fromPoints(
                      button.localToGlobal(Offset.zero, ancestor: overlay),
                      button.localToGlobal(button.size.bottomRight(Offset.zero),
                          ancestor: overlay),
                    ),
                    Offset.zero & overlay.size,
                  );

                  showMenu(
                    elevation: 1,
                    color: context.theme.white100_2,
                    context: context,
                    position: position,
                    items: [
                      PopupMenuItem(
                        value: "edit",
                        child: Row(
                          children: [
                            Icon(
                              Icons.edit_note_outlined,
                              color: context.theme.black100,
                            ),
                            const Gap(5),
                            Text(
                              "Edit",
                              style: AppStyles.medium16(context).copyWith(
                                color: context.theme.black100,
                              ),
                            ),
                            const SizedBox(width: 60),
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        value: "delete",
                        child: Row(
                          children: [
                            Icon(
                              Icons.delete,
                              color: context.theme.red100_1,
                            ),
                            const Gap(5),
                            Text(
                              "Delete",
                              style: AppStyles.medium16(context).copyWith(
                                color: context.theme.red100_1,
                              ),
                            ),
                            const SizedBox(width: 60),
                          ],
                        ),
                      ),
                    ],
                  ).then((value) async {
                    if (value == "delete") {
                      final tokenRefreshCubit =
                          context.read<TokenRefreshCubit>();
                      final token = await tokenRefreshCubit.getAccessToken();

                      if (token != null) {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return CustomDialog(
                              actionTitle: "Delete",
                              title: "Delete vehicle",
                              subtitle:
                                  "Are you sure you want to delete this vehicle ?",
                              onPressed: () async {
                                Navigator.pop(context);
                                await context
                                    .read<EditVehicleCubit>()
                                    .deleteVehicle(
                                      vehicleId,
                                      token,
                                    );
                              },
                            );
                          },
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          customSnackBar(
                            context,
                            "Error",
                            "Authentication failed. Please login again.",
                            SnackBarType.error,
                          ),
                        );
                      }
                    } else if (value == "edit") {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              EditVehicleView(vehicleId: vehicleId),
                        ),
                      );
                    }
                  });
                },
          icon: Icon(
            Icons.more_vert_outlined,
            color: context.theme.black100,
          ),
        );
      },
    );
  }
}
