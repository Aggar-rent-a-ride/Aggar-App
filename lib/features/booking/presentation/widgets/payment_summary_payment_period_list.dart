import 'package:aggar/features/booking/presentation/views/payment_page.dart';
import 'package:aggar/features/booking/presentation/widgets/payment_summary_row.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PaymentSummaryPaymentPeriodList extends StatelessWidget {
  const PaymentSummaryPaymentPeriodList({
    super.key,
    required this.widget,
  });

  final PaymentScreen widget;

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 8,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PaymentSummaryRow(
            label: 'Booking Period',
            value:
                '${DateFormat('MMM dd').format(widget.booking.startDate)} - ${DateFormat('MMM dd, yyyy').format(widget.booking.endDate)}'),
        PaymentSummaryRow(
            label: 'Duration',
            value:
                '${widget.booking.totalDays} day${widget.booking.totalDays > 1 ? 's' : ''}'),
        PaymentSummaryRow(
            label: 'Daily Rate',
            value:
                '\$${(widget.booking.price / widget.booking.totalDays).toStringAsFixed(2)}'),
        if (widget.booking.discount > 0) ...[
          PaymentSummaryRow(
              label: 'Subtotal',
              value: '\$${widget.booking.price.toStringAsFixed(2)}'),
          PaymentSummaryRow(
              label: 'Discount',
              value: '-\$${widget.booking.discount.toStringAsFixed(2)}'),
        ],
      ],
    );
  }
}
