// ignore_for_file: use_build_context_synchronously

import 'package:aggar/core/cubit/refresh%20token/token_refresh_cubit.dart';
import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/core/widgets/custom_dialog.dart';
import 'package:aggar/features/vehicles_details/presentation/cubit/vehicle_favorite_cubit.dart';
import 'package:aggar/features/vehicles_details/presentation/widgets/custom_description_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class VehicleDetailsMenuIcon extends StatelessWidget {
  const VehicleDetailsMenuIcon({
    super.key,
    required this.isFav,
    required this.vehicleId,
  });

  final bool isFav;
  final int vehicleId;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () async {
        final tokenCubit = context.read<TokenRefreshCubit>();
        final token = await tokenCubit.getAccessToken();
        final RenderBox appBar = context.findRenderObject() as RenderBox;
        final RenderBox overlay =
            Overlay.of(context).context.findRenderObject() as RenderBox;
        final RelativeRect position = RelativeRect.fromRect(
          Rect.fromPoints(
            appBar.localToGlobal(Offset.zero, ancestor: overlay),
            appBar.localToGlobal(appBar.size.bottomRight(Offset.zero),
                ancestor: overlay),
          ),
          Offset.zero & overlay.size,
        );

        showMenu(
          elevation: 1,
          color: context.theme.white100_2,
          context: context,
          position: RelativeRect.fromLTRB(
            position.left,
            position.top + appBar.size.height,
            position.right,
            position.bottom,
          ),
          items: [
            PopupMenuItem(
              value: "create_report",
              child: Row(
                spacing: 8,
                children: [
                  Icon(
                    Icons.flag_outlined,
                    color: context.theme.black100,
                  ),
                  Text(
                    "Create Report",
                    style: AppStyles.medium16(context).copyWith(
                      color: context.theme.black100,
                    ),
                  ),
                ],
              ),
            ),
            PopupMenuItem(
              value: "save_vehicle",
              child: Row(
                spacing: 8,
                children: [
                  Icon(
                    isFav
                        ? Icons.bookmark_remove_outlined
                        : Icons.bookmark_add_outlined,
                    color:
                        isFav ? context.theme.red100_1 : context.theme.black100,
                  ),
                  Text(
                    isFav ? "Unsave Vehicle" : "Save Vehicle",
                    style: AppStyles.medium16(context).copyWith(
                      color: isFav
                          ? context.theme.red100_1
                          : context.theme.black100,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ).then((value) async {
          if (value == "create_report") {
            if (token != null) {
              showDialog(
                context: context,
                builder: (context) => CustomDialog(
                  title: 'Report Vehicle',
                  subtitle: 'Are you sure you want to report this vehicle?',
                  actionTitle: 'Yes',
                  onPressed: () {
                    Navigator.pop(context);
                    showDialog(
                      context: context,
                      builder: (context) => CustomDescriptionDialog(
                        type: "Vehicle",
                        id: vehicleId,
                        token: token,
                      ),
                    );
                  },
                ),
              );
            }
          } else if (value == "save_vehicle") {
            final vehicleFavorite = context.read<VehicleFavoriteCubit>();
            if (token != null) {
              vehicleFavorite.toggleFavorite(vehicleId, isFav, token);
            }
          }
        });
      },
      icon: Icon(
        Icons.more_vert_outlined,
        color: context.theme.black100,
      ),
    );
  }
}
