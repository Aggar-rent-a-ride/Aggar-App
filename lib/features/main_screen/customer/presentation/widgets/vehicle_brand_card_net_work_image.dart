import 'package:aggar/core/api/end_points.dart';
import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:flutter/material.dart';

class VehicleBrandCardNetWorkImage extends StatelessWidget {
  const VehicleBrandCardNetWorkImage(
      {super.key, required this.imgPrv, required this.label, this.onTap});
  final String imgPrv;
  final String label;
  final Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 6),
        width: MediaQuery.of(context).size.width * 0.27,
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
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
          child: Column(
            children: [
              imgPrv == "null"
                  ? const SizedBox(
                      height: 80,
                      width: 80,
                    )
                  : SizedBox(
                      height: 80,
                      width: 80,
                      child: Image.network(
                        "${EndPoint.baseUrl}$imgPrv",
                        errorBuilder: (context, error, stackTrace) {
                          return const SizedBox(
                            height: 80,
                            width: 80,
                          );
                        },
                      ),
                    ),
              Row(
                children: [
                  Text(
                    label,
                    style: AppStyles.bold10(context).copyWith(
                      color: context.theme.black100,
                    ),
                  ),
                  const Spacer(),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
