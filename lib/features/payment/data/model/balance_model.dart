import 'package:aggar/core/api/end_points.dart';

class BalanceModel {
  final num availableBalance;
  final num pendingBalance;
  final num connectReserved;
  final num totalBalance;
  final String currency;

  BalanceModel({
    required this.availableBalance,
    required this.pendingBalance,
    required this.connectReserved,
    required this.totalBalance,
    required this.currency,
  });
  factory BalanceModel.fromJson(Map<String, dynamic> json) {
    return BalanceModel(
        availableBalance:
            (json[ApiKey.paymentAvailableBalance] as num).toDouble(),
        pendingBalance: (json[ApiKey.paymentPendingBalance] as num).toDouble(),
        connectReserved:
            (json[ApiKey.paymentConnectReserved] as num).toDouble(),
        totalBalance: (json[ApiKey.paymentTotalBalance] as num).toDouble(),
        currency: json[ApiKey.paymentCurrency]);
  }
}
