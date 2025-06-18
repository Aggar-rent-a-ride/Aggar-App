import 'package:aggar/core/api/end_points.dart';

class ConnectedAccountModel {
  final String stripeAccountId;
  final String bankAccountId;
  final bool isVerified;

  ConnectedAccountModel({
    required this.stripeAccountId,
    required this.bankAccountId,
    required this.isVerified,
  });

  factory ConnectedAccountModel.fromJson(Map<String, dynamic> json) {
    return ConnectedAccountModel(
      bankAccountId: json[ApiKey.paymentBankAccountId],
      stripeAccountId: json[ApiKey.paymentStripeAccountId],
      isVerified: json[ApiKey.paymentIsVerified],
    );
  }
}
