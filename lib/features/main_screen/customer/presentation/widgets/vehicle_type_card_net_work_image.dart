import 'package:aggar/core/api/end_points.dart';
import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';

class VehicleTypeCardNetWorkImage extends StatelessWidget {
  const VehicleTypeCardNetWorkImage(
      {super.key, required this.iconPrv, required this.label, this.onTap});
  final String iconPrv;
  final String label;
  final Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 6),
        decoration: BoxDecoration(
          color: context.theme.white100_2,
          borderRadius: BorderRadius.circular(8),
          boxShadow: const [
            BoxShadow(
              blurRadius: 4,
              color: Colors.black12,
              offset: Offset(0, 0),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              iconPrv == "null"
                  ? const SizedBox(
                      height: 35,
                      width: 35,
                    )
                  : SizedBox(
                      height: 35,
                      width: 35,
                      child: SvgPicture.network(
                        color: context.theme.black50,
                        "${EndPoint.baseUrl}/$iconPrv",
                      ),
                    ),
              const Gap(10),
              Text(
                label,
                style: AppStyles.medium12(context)
                    .copyWith(color: context.theme.black100),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
