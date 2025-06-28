import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/utils/app_styles.dart' show AppStyles;
import 'package:flutter/material.dart';

class MapLocationShowOnlyAddressSection extends StatelessWidget {
  const MapLocationShowOnlyAddressSection({
    super.key,
    required this.address,
  });

  final String address;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        height: MediaQuery.sizeOf(context).height * 0.2,
        padding: const EdgeInsets.symmetric(
          horizontal: 25,
          vertical: 20,
        ),
        decoration: BoxDecoration(
          color: context.theme.white100_1,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: Offset(0, 0),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.location_on,
                  color: context.theme.blue100_1,
                  size: 24,
                ),
                Text(
                  maxLines: 5,
                  address.split(',').last.trim(),
                  style: AppStyles.bold24(context)
                      .copyWith(color: context.theme.blue100_1),
                ),
              ],
            ),
            Text(
              address,
              style: AppStyles.semiBold16(context).copyWith(
                color: context.theme.black50,
              ),
            )
          ],
        ),
      ),
    );
  }
}
