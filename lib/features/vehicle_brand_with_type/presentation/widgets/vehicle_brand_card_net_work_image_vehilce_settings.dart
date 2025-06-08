import 'package:aggar/core/api/end_points.dart';
import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class VehicleBrandCardNetWorkImageVehilceSettings extends StatelessWidget {
  const VehicleBrandCardNetWorkImageVehilceSettings(
      {super.key, required this.imgPrv, required this.label, this.onTap});
  final String imgPrv;
  final String label;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
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
          padding: const EdgeInsets.only(top: 8, right: 8, left: 8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 3,
                child: imgPrv == "null"
                    ? const SizedBox()
                    : Image.network(
                        "${EndPoint.baseUrl}$imgPrv",
                        fit: BoxFit.contain,
                      ),
              ),
              const Gap(5),
              Expanded(
                flex: 1,
                child: Text(
                  label,
                  style: AppStyles.bold10(context).copyWith(
                    color: context.theme.black100,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
