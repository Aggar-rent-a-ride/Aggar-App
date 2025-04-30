import 'package:aggar/core/api/end_points.dart';
import 'package:aggar/core/utils/app_assets.dart';
import 'package:aggar/core/widgets/name_section.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class NameAndRateSection extends StatelessWidget {
  const NameAndRateSection({
    super.key,
    required this.imageUrl,
    required this.name,
    required this.rate,
    required this.date,
  });
  final String imageUrl;
  final String name;
  final double rate;
  final String date;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
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
                  AppAssets.assetsImagesDafaultPfp,
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
      ],
    );
  }
}
