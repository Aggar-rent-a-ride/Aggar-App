import 'package:aggar/features/vehicles_details/presentation/views/review_tab_bar/widgets/name_section.dart';
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
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.all(
            Radius.circular(30),
          ),
          child: Image(
            image: AssetImage(imageUrl),
            height: 50,
            width: 50,
          ),
        ),
        const Gap(10),
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
