import 'package:aggar/core/themes/app_light_colors.dart';
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
            boxShadow: [
              BoxShadow(
                offset: const Offset(0, 0),
                blurRadius: 4,
                color: AppLightColors.myBlack25,
              )
            ],
          ),
          child: ClipRRect(
            borderRadius: const BorderRadius.all(
              Radius.circular(30),
            ),
            child: Image(
              image: AssetImage(imageUrl),
              height: 45,
              width: 45,
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
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_vert),
          ),
        )
      ],
    );
  }
}
