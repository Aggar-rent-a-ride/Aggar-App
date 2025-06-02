import 'package:aggar/core/utils/app_constants.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/core/widgets/custom_elevated_button.dart';
import 'package:aggar/features/booking/presentation/widgets/booking_summary_card.dart';
import 'package:aggar/features/booking/presentation/widgets/custom_app_bar.dart';
import 'package:aggar/features/booking/presentation/widgets/date_time_row.dart';
import 'package:aggar/features/booking/presentation/widgets/step_indicator.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class BookVehicleScreen extends StatefulWidget {
  const BookVehicleScreen({super.key});

  @override
  _BookVehicleScreenState createState() => _BookVehicleScreenState();
}

class _BookVehicleScreenState extends State<BookVehicleScreen> {
  String selectedStartDate = "Select date";
  String selectedEndDate = "Select date";
  String selectedPickupTime = "09:00";
  String selectedDropTime = "09:00";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.myWhite100_1,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Header using CustomAppBar
              const CustomAppBar(title: 'Book Vehicle'),

              const Gap(32),

              // Step indicator using StepIndicator
              const StepIndicator(title: 'Select Date & Time'),

              const Gap(40),

              // Start Date and Pickup Time using DateTimeRow
              DateTimeRow(
                dateLabel: 'Start Date:',
                timeLabel: 'Pickup Time:',
                selectedDate: selectedStartDate,
                selectedTime: selectedPickupTime,
                datePlaceholder: "Select date",
                onDateTap: () => selectDate(context, true),
                onTimeTap: () => selectTime(context, true),
                timeIconColor: AppConstants.myBlue100_4,
              ),

              const Gap(24),

              // End Date and Drop Time using DateTimeRow
              DateTimeRow(
                dateLabel: 'End Date:',
                timeLabel: 'Drop Time:',
                selectedDate: selectedEndDate,
                selectedTime: selectedDropTime,
                datePlaceholder: "Select date",
                onDateTap: () => selectDate(context, false),
                onTimeTap: () => selectTime(context, false),
              ),

              const Spacer(),

              const BookingSummaryCard(
                vehicleName: 'Tesla Model S',
                pricePerDay: '\$120/day',
                ownerName: 'Brian Smith',
                ownerRole: 'Owner',
                ownerImageUrl:
                    'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=40&h=40&fit=crop&crop=face',
              ),

              const Gap(24),

              CustomElevatedButton(
                text: 'Send conform to Renter',
                onPressed: sendConfirmToRenter,
              ),

              const Gap(16),
            ],
          ),
        ),
      ),
    );
  }

  void selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppConstants.myBlue100_3,
              onPrimary: AppConstants.myWhite100_1,
              surface: AppConstants.myWhite100_1,
              onSurface: AppConstants.myBlack100_1,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        String formattedDate = "${picked.day}/${picked.month}/${picked.year}";
        if (isStartDate) {
          selectedStartDate = formattedDate;
        } else {
          selectedEndDate = formattedDate;
        }
      });
    }
  }

  void selectTime(BuildContext context, bool isPickupTime) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 9, minute: 0),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppConstants.myBlue100_3,
              onPrimary: AppConstants.myWhite100_1,
              surface: AppConstants.myWhite100_1,
              onSurface: AppConstants.myBlack100_1,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        String formattedTime =
            "${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}";
        if (isPickupTime) {
          selectedPickupTime = formattedTime;
        } else {
          selectedDropTime = formattedTime;
        }
      });
    }
  }

  void sendConfirmToRenter() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Confirmation sent to renter successfully!'),
        backgroundColor: AppConstants.myBlue100_3,
      ),
    );
  }
}
