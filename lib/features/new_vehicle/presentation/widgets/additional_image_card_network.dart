import 'package:aggar/core/api/end_points.dart';
import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:flutter/material.dart';

class AdditionalImageCardNetwork extends StatelessWidget {
  const AdditionalImageCardNetwork({
    super.key,
    required this.image,
  });
  final String image;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        boxShadow: [
          BoxShadow(
            color: context.theme.black25,
            offset: const Offset(0, 0),
            blurRadius: 2,
          )
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(5),
        child: Image.network(
          "${EndPoint.baseUrl}$image",
          fit: BoxFit.cover,
          height: MediaQuery.sizeOf(context).height * 0.03 + 50,
          width: MediaQuery.sizeOf(context).height * 0.03 + 50,
          errorBuilder: (context, error, stackTrace) {
            return Row(
              spacing: 15,
              children: List.generate(
                1,
                (index) {
                  return Container(
                    height: MediaQuery.sizeOf(context).height * 0.03 + 50,
                    width: MediaQuery.sizeOf(context).height * 0.03 + 50,
                    decoration: BoxDecoration(
                      color: context.theme.white100_1,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
