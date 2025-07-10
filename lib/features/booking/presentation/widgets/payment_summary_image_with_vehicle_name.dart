import 'package:aggar/core/api/end_points.dart';
import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/features/booking/presentation/views/payment_page.dart';
import 'package:flutter/material.dart';

class PaymentSummaryImageWithVehicleName extends StatelessWidget {
  const PaymentSummaryImageWithVehicleName({
    super.key,
    required this.widget,
  });

  final PaymentScreen widget;

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 10,
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: context.theme.black25,
            borderRadius: BorderRadius.circular(8),
          ),
          child: widget.booking.vehicleImagePath != null
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    '${EndPoint.baseUrl}${widget.booking.vehicleImagePath}',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(
                        Icons.directions_car,
                        color: context.theme.black50,
                      );
                    },
                  ),
                )
              : const Icon(
                  Icons.directions_car,
                  color: Colors.grey,
                ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${widget.booking.vehicleBrand ?? ''} ${widget.booking.vehicleModel}',
                style: AppStyles.medium16(context).copyWith(
                  color: context.theme.black100,
                ),
              ),
              Text(
                'Booking ID: ${widget.bookingId}',
                style: AppStyles.regular14(context).copyWith(
                  color: context.theme.black50,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
