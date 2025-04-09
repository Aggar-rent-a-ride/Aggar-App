import 'package:equatable/equatable.dart';

abstract class DiscountState extends Equatable {
  const DiscountState();

  @override
  List<Object?> get props => [];
}

class DiscountInitial extends DiscountState {}

class DiscountLoading extends DiscountState {}

class DiscountSuccess extends DiscountState {
  final dynamic response;

  const DiscountSuccess(this.response);

  @override
  List<Object?> get props => [response];
}

class DiscountFailure extends DiscountState {
  final String errorMessage;

  const DiscountFailure(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}
