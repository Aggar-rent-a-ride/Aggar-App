import 'package:aggar/core/api/end_points.dart';
import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/features/booking/data/model/booking_model.dart';
import 'package:aggar/features/booking/presentation/views/booking_details_view_renter.dart';
import 'package:flutter/material.dart';

class BookingDetailsRenterVehicleImage extends StatelessWidget {
  const BookingDetailsRenterVehicleImage({
    super.key,
    required this.bookingData,
    required this.widget,
  });

  final BookingModel? bookingData;
  final BookingDetailsScreenRenter widget;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: MediaQuery.sizeOf(context).height * 0.35,
      decoration: BoxDecoration(
        color: context.theme.white100_4,
        borderRadius: BorderRadius.circular(12),
      ),
      child: bookingData?.vehicleImagePath != null
          ? ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                '${EndPoint.baseUrl}${bookingData?.vehicleImagePath}',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Center(
                    child: Text(
                      widget.booking.initial,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                  );
                },
              ),
            )
          : Center(
              child: Text(
                widget.booking.name,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
            ),
    );
  }
}
