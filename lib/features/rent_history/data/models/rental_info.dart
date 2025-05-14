enum RentalStatus { Completed, InProgress, NotStarted, Cancelled }

class RentalInfo {
  final String id;
  final RentalStatus status;
  final String clientName;
  final String totalTime;
  final String carNameId;
  final String carModel;
  final String arrivalTime;

  RentalInfo({
    required this.id,
    required this.status,
    required this.clientName,
    required this.totalTime,
    required this.carNameId,
    required this.carModel,
    required this.arrivalTime,
  });
}
