import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/features/booking/data/model/booking_model.dart';
import 'package:aggar/features/booking/presentation/widgets/booking_details_type_and_year_vehicle.dart';
import 'package:aggar/features/booking/presentation/widgets/booking_details_vehicle_image.dart';
import 'package:flutter/material.dart';

class BookingDetailsVehicleInformationSection extends StatelessWidget {
  const BookingDetailsVehicleInformationSection({
    super.key,
    required this.booking,
  });

  final BookingModel booking;

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 10,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Vehicle Information',
          style: AppStyles.semiBold16(context).copyWith(
            color: context.theme.black100,
          ),
        ),
        BookingDetailsVehicleImage(booking: booking),
        Text(
          '${booking.vehicleBrand ?? ''} ${booking.vehicleModel} (${booking.vehicleYear})',
          style: AppStyles.semiBold16(context).copyWith(
            color: context.theme.black100,
          ),
        ),
        BookingDetailsTypeAndYearVehicle(booking: booking),
      ],
    );
  }
}
