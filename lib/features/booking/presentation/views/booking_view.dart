import 'package:aggar/core/utils/app_constants.dart';
import 'package:aggar/core/widgets/custom_elevated_button.dart';
import 'package:aggar/features/booking/presentation/widgets/custom_app_bar.dart';
import 'package:aggar/features/booking/presentation/widgets/date_time_row.dart';
import 'package:aggar/features/booking/presentation/widgets/important_reminder.dart';
import 'package:aggar/features/booking/presentation/widgets/step_indicator.dart';
import 'package:aggar/features/booking/data/cubit/booking_cubit.dart';
import 'package:aggar/features/booking/data/cubit/booking_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

class BookVehicleScreen extends StatefulWidget {
  const BookVehicleScreen({
    super.key,
    required this.vehicleId,
  });

  final int vehicleId;

  @override
  _BookVehicleScreenState createState() => _BookVehicleScreenState();
}

class _BookVehicleScreenState extends State<BookVehicleScreen> {
  String selectedStartDate = "Select date";
  String selectedEndDate = "Select date";
  String selectedPickupTime = "09:00";
  String selectedDropTime = "09:00";

  DateTime? startDateTime;
  DateTime? endDateTime;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.myWhite100_1,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: BlocListener<BookingCubit, BookingState>(
            listener: (context, state) {
              if (state is BookingCreateSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Booking created successfully!'),
                    backgroundColor: Colors.green,
                  ),
                );
                // Navigate back or to success screen
                Navigator.pop(context);
              } else if (state is BookingCreateError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Booking failed: ${state.message}'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
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

                const ReminderContainer(
                  title: 'Important Reminder',
                  message:
                      'Please ensure you have all required documents for vehicle pickup.',
                ),

                const Gap(24),

                BlocBuilder<BookingCubit, BookingState>(
                  builder: (context, state) {
                    final isLoading = state is BookingCreateLoading;

                    return CustomElevatedButton(
                      text: isLoading ? 'Creating Booking...' : 'Book Vehicle',
                      onPressed: isLoading ? null : _createBooking,
                    );
                  },
                ),

                const Gap(16),
              ],
            ),
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
          // Store the DateTime for API call
          startDateTime = _combineDateTime(picked, selectedPickupTime);
        } else {
          selectedEndDate = formattedDate;
          // Store the DateTime for API call
          endDateTime = _combineDateTime(picked, selectedDropTime);
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
          // Update startDateTime if date is already selected
          if (selectedStartDate != "Select date") {
            startDateTime = _combineDateTime(
                _parseDateString(selectedStartDate), formattedTime);
          }
        } else {
          selectedDropTime = formattedTime;
          // Update endDateTime if date is already selected
          if (selectedEndDate != "Select date") {
            endDateTime = _combineDateTime(
                _parseDateString(selectedEndDate), formattedTime);
          }
        }
      });
    }
  }

  DateTime _combineDateTime(DateTime date, String time) {
    final timeParts = time.split(':');
    final hour = int.parse(timeParts[0]);
    final minute = int.parse(timeParts[1]);

    return DateTime(
      date.year,
      date.month,
      date.day,
      hour,
      minute,
    );
  }

  DateTime _parseDateString(String dateString) {
    final parts = dateString.split('/');
    return DateTime(
      int.parse(parts[2]), // year
      int.parse(parts[1]), // month
      int.parse(parts[0]), // day
    );
  }

  void _createBooking() {
    // Validation
    if (selectedStartDate == "Select date") {
      _showErrorSnackBar("Please select a start date");
      return;
    }

    if (selectedEndDate == "Select date") {
      _showErrorSnackBar("Please select an end date");
      return;
    }

    if (startDateTime == null || endDateTime == null) {
      _showErrorSnackBar("Please select valid dates and times");
      return;
    }

    if (startDateTime!.isAfter(endDateTime!)) {
      _showErrorSnackBar("End date must be after start date");
      return;
    }

    // Create booking using cubit
    final vehicleIdInt = widget.vehicleId;
    if (vehicleIdInt == null) {
      _showErrorSnackBar("Invalid vehicle ID");
      return;
    }

    context.read<BookingCubit>().createBooking(
          vehicleId: vehicleIdInt,
          startDate: startDateTime!,
          endDate: endDateTime!,
        );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }
}
