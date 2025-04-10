import 'package:equatable/equatable.dart';

abstract class DiscountState extends Equatable {
  final bool showDiscountSection;
  const DiscountState({
    this.showDiscountSection = false,
  });

  @override
  List<Object?> get props => [showDiscountSection];
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
