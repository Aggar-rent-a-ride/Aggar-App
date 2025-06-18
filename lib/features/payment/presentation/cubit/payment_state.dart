import 'package:aggar/features/payment/data/model/balance_model.dart';
import 'package:aggar/features/payment/data/model/connected_account_model.dart';
import 'package:aggar/features/payment/data/model/renter_payout_detials_model.dart';
import 'package:equatable/equatable.dart';

abstract class PaymentState extends Equatable {
  const PaymentState();

  @override
  List<Object?> get props => [];
}

class PaymentLoading extends PaymentState {}

class PaymentInitial extends PaymentState {}

class PaymentPlatformBalanceSuccess extends PaymentState {
  final BalanceModel balanceModel;

  const PaymentPlatformBalanceSuccess({required this.balanceModel});
}

class PaymentConnectedAccountSuccess extends PaymentState {
  final ConnectedAccountModel connectedAccountModel;

  const PaymentConnectedAccountSuccess({required this.connectedAccountModel});
}

class PaymentRenterPayoutDetialsSuccess extends PaymentState {
  final RenterPayoutDetialsModel renterPayoutDetialsModel;

  const PaymentRenterPayoutDetialsSuccess(
      {required this.renterPayoutDetialsModel});
}

class PaymentError extends PaymentState {
  final String message;

  const PaymentError({required this.message});

  @override
  List<Object?> get props => [message];
}
