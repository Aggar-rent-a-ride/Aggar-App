import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:flutter/material.dart';

class LoadingVehicleBrandSection extends StatelessWidget {
  const LoadingVehicleBrandSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 10,
      children: [
        Container(
          height: 25,
          width: 140,
          decoration: BoxDecoration(
            color: context.theme.white100_1,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            spacing: 10,
            children: List.generate(
              5,
              (index) => Container(
                height: MediaQuery.of(context).size.height * 0.15,
                width: MediaQuery.of(context).size.height * 0.15,
                decoration: BoxDecoration(
                  color: context.theme.white100_1,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
