import 'package:aggar/core/api/dio_consumer.dart';
import 'package:aggar/core/api/end_points.dart';
import 'package:aggar/features/payment/data/model/balance_model.dart';
import 'package:aggar/features/payment/data/model/connected_account_model.dart';
import 'package:aggar/features/payment/data/model/renter_payout_detials_model.dart';
import 'package:aggar/features/payment/presentation/cubit/payment_state.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PaymentCubit extends Cubit<PaymentState> {
  PaymentCubit() : super(PaymentInitial());
  final DioConsumer dioConsumer = DioConsumer(dio: Dio());
  Future<void> getPlatformBalance(String accesstoken) async {
    emit(PaymentLoading());
    try {
      final response = await dioConsumer.get(
        EndPoint.getPlatformBalance,
        options: Options(
          headers: {
            'Authorization': 'Bearer $accesstoken',
          },
        ),
      );
      final balanceModel = BalanceModel.fromJson(response["data"]);
      print(balanceModel);
      emit(PaymentPlatformBalanceSuccess(balanceModel: balanceModel));
    } catch (e) {
      emit(PaymentError(message: e.toString()));
    }
  }

  Future<void> createConnectedAccount(String accessToken, String phone,
      String bankAccountNumber, String bankAccountRoutingNumber) async {
    emit(PaymentLoading());
    try {
      final response = await dioConsumer.post(
        EndPoint.connectedAccount,
        options: Options(
          headers: {
            'Authorization': 'Bearer $accessToken',
          },
        ),
        data: FormData.fromMap({
          'phone': phone,
          'bankAccountNumber': bankAccountNumber,
          'bankAccountRoutingNumber': bankAccountRoutingNumber,
        }),
      );
      final connectedAccountModel =
          ConnectedAccountModel.fromJson(response["data"]);
      print(connectedAccountModel);
      emit(PaymentConnectedAccountSuccess(
          connectedAccountModel: connectedAccountModel));
    } catch (e) {
      emit(PaymentError(message: e.toString()));
    }
  }

  Future<void> getRenterPayoutDetails(String accessToken) async {
    emit(PaymentLoading());
    try {
      final response = await dioConsumer.get(
        EndPoint.renterpayoutDetails,
        options: Options(
          headers: {
            'Authorization': 'Bearer $accessToken',
          },
        ),
      );
      final renterPayoutDetialsModel =
          RenterPayoutDetialsModel.fromJson(response["data"]);
      print(renterPayoutDetialsModel);
      emit(PaymentRenterPayoutDetialsSuccess(
        renterPayoutDetialsModel: renterPayoutDetialsModel,
      ));
    } catch (e) {
      emit(PaymentError(message: e.toString()));
    }
  }
}
