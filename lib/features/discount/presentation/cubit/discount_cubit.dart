import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'discount_state.dart';

class DiscountCubit extends Cubit<DiscountState> {
  DiscountCubit() : super(const DiscountState());

  void toggleDiscountVisibility(bool showDiscount) {
    emit(state.copyWith(
      showDiscountList: showDiscount,
      isYesSelected: showDiscount,
      isNoSelected: !showDiscount,
    ));
  }

  void updateDays(String days) {
    emit(state.copyWith(days: days));
  }

  void updatePercentage(String percentage) {
    emit(state.copyWith(percentage: percentage));
  }

  void addDiscount() {
    // Implement discount addition logic here
    // For now, just print the values
    print('Adding discount: ${state.days} days, ${state.percentage}%');
  }

  void continueProcess() {
    // Implement navigation or next step logic
    print('Continue button pressed');
  }
}
