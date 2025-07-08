import 'package:aggar/core/api/end_points.dart';
import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/features/booking/data/model/booking_model.dart';
import 'package:flutter/material.dart';

class BookingDetailsVehicleImage extends StatelessWidget {
  const BookingDetailsVehicleImage({
    super.key,
    required this.booking,
  });

  final BookingModel booking;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: MediaQuery.sizeOf(context).height * 0.35,
      decoration: BoxDecoration(
        color: context.theme.white100_4,
        borderRadius: BorderRadius.circular(12),
      ),
      child: booking.vehicleImagePath != null
          ? ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                '${EndPoint.baseUrl}${booking.vehicleImagePath}',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Center(
                    child: Text(
                      booking.vehicleModel,
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
                booking.vehicleModel,
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
