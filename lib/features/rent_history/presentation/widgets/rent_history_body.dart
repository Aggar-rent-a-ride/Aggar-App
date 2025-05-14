import 'package:aggar/features/rent_history/data/models/rental_info.dart';
import 'package:aggar/features/rent_history/presentation/widgets/rent_card.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class RentHistoryBody extends StatelessWidget {
  const RentHistoryBody({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final List<RentalInfo> rentals = [
      RentalInfo(
        id: '#A0513U',
        status: RentalStatus.Completed,
        clientName: 'Adele Smith',
        totalTime: '3 Days, 6 hours',
        carNameId: 'Car name ID:',
        carModel: 'Tesla Model S',
        arrivalTime: '11/8/2024',
      ),
      RentalInfo(
        id: '#BT724V',
        status: RentalStatus.InProgress,
        clientName: 'John Cooper',
        totalTime: '5 Days, 2 hours',
        carNameId: 'Car name ID:',
        carModel: 'BMW M4',
        arrivalTime: '12/8/2024',
      ),
      RentalInfo(
        id: '#CX835W',
        status: RentalStatus.NotStarted,
        clientName: 'Emma Davis',
        totalTime: '2 Days, 8 hours',
        carNameId: 'Car name ID:',
        carModel: 'Porsche 911',
        arrivalTime: '13/8/2024',
      ),
      RentalInfo(
        id: '#CX835W',
        status: RentalStatus.Cancelled,
        clientName: 'Emma Davis',
        totalTime: '2 Days, 8 hours',
        carNameId: 'Car name ID:',
        carModel: 'Porsche 911',
        arrivalTime: '13/8/2024',
      ),
    ];
    return SafeArea(
      child: Container(
        margin: const EdgeInsets.all(20),
        child: Expanded(
          child: ListView.separated(
            itemCount: rentals.length,
            separatorBuilder: (context, index) => const Gap(15),
            itemBuilder: (context, index) {
              final rental = rentals[index];
              return RentalCard(rental: rental);
            },
          ),
        ),
      ),
    );
  }
}
