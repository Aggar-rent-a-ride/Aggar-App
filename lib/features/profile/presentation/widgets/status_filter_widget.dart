import 'package:aggar/features/booking/data/model/booking_model.dart';
import 'package:flutter/material.dart';

class StatusFilterWidget extends StatelessWidget {
  final BookingStatus? selectedStatus;
  final ValueChanged<BookingStatus?> onStatusChanged;

  const StatusFilterWidget({
    super.key,
    required this.selectedStatus,
    required this.onStatusChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: DropdownButtonFormField<BookingStatus?>(
        value: selectedStatus,
        decoration: InputDecoration(
          labelText: 'Filter by Status',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        ),
        items: [
          const DropdownMenuItem<BookingStatus?>(
            value: null,
            child: Text('All Status'),
          ),
          ...BookingStatus.values.map((status) => DropdownMenuItem(
                value: status,
                child: Text(status.value),
              )),
        ],
        onChanged: onStatusChanged,
      ),
    );
  }
}
