import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/features/booking/data/model/booking_model.dart';
import 'package:aggar/features/booking/presentation/views/booking_details_view_renter.dart';
import 'package:aggar/features/booking/presentation/widgets/booking_details_renter_type_and_year_vehicle.dart';
import 'package:aggar/features/booking/presentation/widgets/booking_details_renter_vehicle_image.dart';
import 'package:flutter/material.dart';

class BookingDetailsRenterVehicleInformationSection extends StatelessWidget {
  const BookingDetailsRenterVehicleInformationSection({
    super.key,
    required this.bookingData,
    required this.widget,
  });

  final BookingModel? bookingData;
  final BookingDetailsScreenRenter widget;

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
        BookingDetailsRenterVehicleImage(
            bookingData: bookingData, widget: widget),
        Text(
          '${bookingData?.vehicleBrand ?? ''} ${bookingData?.vehicleModel} (${bookingData?.vehicleYear})',
          style: AppStyles.semiBold16(context).copyWith(
            color: context.theme.black100,
          ),
        ),
        BookingDetailsRenterTypeAndYearVehicle(bookingData: bookingData),
      ],
    );
  }
}
