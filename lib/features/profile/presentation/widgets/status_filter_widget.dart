import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/utils/app_styles.dart';
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
        isExpanded: true,
        decoration: InputDecoration(
          labelText: 'Filter by Status',
          labelStyle: AppStyles.medium14(context).copyWith(
            color: context.theme.black100.withOpacity(0.7),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: context.theme.black100.withOpacity(0.2),
              width: 1,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: context.theme.black100.withOpacity(0.2),
              width: 1,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: context.theme.blue100_1,
              width: 2,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: Colors.red.shade400,
              width: 1,
            ),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: Colors.red.shade400,
              width: 2,
            ),
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          filled: true,
          fillColor: context.theme.white100_1,
          prefixIcon: Icon(
            Icons.filter_list,
            color: context.theme.black100.withOpacity(0.6),
            size: 20,
          ),
        ),
        dropdownColor: context.theme.white100_1,
        borderRadius: BorderRadius.circular(12),
        elevation: 8,
        icon: Icon(
          Icons.keyboard_arrow_down,
          color: context.theme.black100.withOpacity(0.6),
        ),
        style: AppStyles.medium16(context).copyWith(
          color: context.theme.black100,
        ),
        items: [
          DropdownMenuItem<BookingStatus?>(
            value: null,
            child: Text(
              'All Status',
              style: AppStyles.medium16(context).copyWith(
                color: context.theme.black100,
                fontWeight:
                    selectedStatus == null ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
          ),
          ...BookingStatus.values.map((status) => DropdownMenuItem(
                value: status,
                child: Text(
                  status.value,
                  style: AppStyles.medium16(context).copyWith(
                    color: context.theme.black100,
                    fontWeight: selectedStatus == status
                        ? FontWeight.w600
                        : FontWeight.w500,
                  ),
                ),
              )),
        ],
        onChanged: onStatusChanged,
        menuMaxHeight: 300,
      ),
    );
  }
}
