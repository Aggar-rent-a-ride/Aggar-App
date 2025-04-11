import 'package:equatable/equatable.dart';

class DiscountItem {
  final int daysRequired;
  final double discountPercentage;

  DiscountItem({required this.daysRequired, required this.discountPercentage});
}

abstract class DiscountState extends Equatable {
  final bool showDiscountSection;
  final List<DiscountItem> discounts;

  const DiscountState({
    this.showDiscountSection = false,
    this.discounts = const [],
  });

  @override
  List<Object?> get props => [showDiscountSection, discounts];
}

class DiscountInitial extends DiscountState {}

class DiscountLoading extends DiscountState {
  const DiscountLoading({required super.discounts});
}

class DiscountSuccess extends DiscountState {
  final dynamic response;

  const DiscountSuccess(this.response, {required super.discounts});

  @override
  List<Object?> get props => [response, discounts];
}

class DiscountFailure extends DiscountState {
  final String errorMessage;

  const DiscountFailure(this.errorMessage, {required super.discounts});

  @override
  List<Object?> get props => [errorMessage, discounts];
}
