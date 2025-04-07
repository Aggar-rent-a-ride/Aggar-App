part of 'discount_cubit.dart';

class DiscountState extends Equatable {
  final bool showDiscountList;
  final bool isYesSelected;
  final bool isNoSelected;
  final String days;
  final String percentage;

  const DiscountState({
    this.showDiscountList = false,
    this.isYesSelected = false,
    this.isNoSelected = false,
    this.days = '',
    this.percentage = '',
  });

  DiscountState copyWith({
    bool? showDiscountList,
    bool? isYesSelected,
    bool? isNoSelected,
    String? days,
    String? percentage,
  }) {
    return DiscountState(
      showDiscountList: showDiscountList ?? this.showDiscountList,
      isYesSelected: isYesSelected ?? this.isYesSelected,
      isNoSelected: isNoSelected ?? this.isNoSelected,
      days: days ?? this.days,
      percentage: percentage ?? this.percentage,
    );
  }

  @override
  List<Object?> get props =>
      [showDiscountList, isYesSelected, isNoSelected, days, percentage];
}
