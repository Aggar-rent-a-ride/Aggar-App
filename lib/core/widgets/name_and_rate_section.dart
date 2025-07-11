import 'package:aggar/core/api/end_points.dart';
import 'package:aggar/core/cubit/refresh%20token/token_refresh_cubit.dart';
import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/utils/app_assets.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/core/widgets/custom_dialog.dart' show CustomDialog;
import 'package:aggar/core/widgets/name_section.dart';
import 'package:aggar/features/vehicles_details/presentation/widgets/custom_description_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

class NameAndRateSection extends StatelessWidget {
  const NameAndRateSection({
    super.key,
    required this.imageUrl,
    required this.name,
    this.rate,
    required this.date,
    required this.reviewId,
    required this.typeOfReport,
  });
  final String imageUrl;
  final String name;
  final double? rate;
  final String date;
  final int reviewId;
  final String typeOfReport;

  @override
  Widget build(BuildContext context) {
    final GlobalKey iconButtonKey = GlobalKey();

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            color: context.theme.grey100_1,
            boxShadow: const [
              BoxShadow(
                offset: Offset(0, 0),
                blurRadius: 4,
                color: Colors.black12,
              )
            ],
          ),
          child: ClipRRect(
            borderRadius: const BorderRadius.all(
              Radius.circular(30),
            ),
            child: Image.network(
              "${EndPoint.baseUrl}$imageUrl",
              height: 45,
              width: 45,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Image.asset(
                  color: context.theme.black50,
                  AppAssets.assetsImagesDefaultPfp0,
                  height: 45,
                  width: 45,
                  fit: BoxFit.cover,
                );
              },
            ),
          ),
        ),
        const Gap(15),
        NameSection(
          date: date,
          name: name,
          rating: rate,
        ),
        const Spacer(),
        IconButton(
          key: iconButtonKey,
          onPressed: () async {
            final tokenCubit = context.read<TokenRefreshCubit>();
            final token = await tokenCubit.getAccessToken();
            final RenderBox button = context.findRenderObject() as RenderBox;
            final RenderBox overlay =
                Overlay.of(context).context.findRenderObject() as RenderBox;
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
                  value: "create_report",
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.flag_outlined,
                        color: context.theme.black100,
                      ),
                      const Gap(8),
                      Text(
                        "Create Report",
                        style: AppStyles.medium16(context).copyWith(
                          color: context.theme.black100,
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
                      title: 'Report $typeOfReport',
                      subtitle:
                          'Are you sure you want to report this $typeOfReport?',
                      actionTitle: 'Yes',
                      onPressed: () {
                        Navigator.pop(context);
                        showDialog(
                          context: context,
                          builder: (context) => CustomDescriptionDialog(
                            type: typeOfReport,
                            id: reviewId,
                            token: token,
                          ),
                        );
                      },
                    ),
                  );
                }
              }
            });
          },
          icon: Icon(
            Icons.more_vert_outlined,
            color: context.theme.black100,
          ),
        ),
      ],
    );
  }
}
