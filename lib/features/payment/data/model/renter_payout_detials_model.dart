import 'package:aggar/core/api/end_points.dart';

class RenterPayoutDetialsModel {
  final String last4;
  final String routingNumber;
  final num currentAmount;
  final num upcomingAmount;
  final num totalBalance;
  final String currency;

  RenterPayoutDetialsModel({
    required this.last4,
    required this.routingNumber,
    required this.currentAmount,
    required this.upcomingAmount,
    required this.totalBalance,
    required this.currency,
  });
  factory RenterPayoutDetialsModel.fromJson(Map<String, dynamic> json) {
    return RenterPayoutDetialsModel(
      last4: json[ApiKey.paymentLast4],
      routingNumber: json[ApiKey.paymentRoutingNumber],
      currentAmount: (json[ApiKey.paymentCurrentAmount] as num).toDouble(),
      upcomingAmount: (json[ApiKey.paymentUpcomingAmount] as num).toDouble(),
      totalBalance: (json[ApiKey.paymentTotalBalance] as num).toDouble(),
      currency: json[ApiKey.paymentCurrency],
    );
  }
}
