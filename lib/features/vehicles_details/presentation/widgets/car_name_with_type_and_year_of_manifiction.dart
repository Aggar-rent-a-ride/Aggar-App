import 'package:aggar/core/themes/app_colors.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/features/vehicles_details/presentation/widgets/transmission_type_container.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class CarNameWithTypeAndYearOfManifiction extends StatelessWidget {
  const CarNameWithTypeAndYearOfManifiction({
    super.key,
    required this.carName,
    required this.manifactionYear,
    required this.transmissionType,
  });
  final String carName;
  final int manifactionYear;
  final int transmissionType;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                carName,
                style: AppStyles.semiBold26(context).copyWith(
                  color: AppLightColors.myBlack100,
                ),
              ),
            ),
            const Gap(15),
            transmissionType == 0
                ? const SizedBox()
                : (transmissionType == 1
                    ? const TransmissionTypeContainer(
                        transmissionType: "Automatic")
                    : const TransmissionTypeContainer(
                        transmissionType: "Manual",
                      )),
          ],
        ),
        Text(
          "This car was made in $manifactionYear",
          style: AppStyles.medium16(context).copyWith(
            color: AppLightColors.myBlack50,
          ),
        )
      ],
    );
  }
}
