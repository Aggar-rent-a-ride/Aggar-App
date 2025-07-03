import 'package:aggar/features/discount/presentation/cubit/discount_cubit.dart';
import 'package:aggar/features/discount/presentation/cubit/discount_state.dart';
import 'package:aggar/features/discount/presentation/widgets/comprehensive_discount_manager.dart';
import 'package:aggar/features/new_vehicle/data/model/vehicle_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class VehicleDiscountSection extends StatefulWidget {
  final String vehicleId;
  final bool isEditing;
  final VehicleDataModel? vehicleData;

  const VehicleDiscountSection({
    super.key,
    required this.vehicleId,
    this.isEditing = false,
    this.vehicleData,
  });

  @override
  State<VehicleDiscountSection> createState() => _VehicleDiscountSectionState();
}

class _VehicleDiscountSectionState extends State<VehicleDiscountSection> {
  late DiscountCubit _discountCubit;
  bool _hasLoadedDiscounts = false;

  @override
  void initState() {
    super.initState();
    _discountCubit = DiscountCubit(
      tokenRefreshCubit: context.read(),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (widget.isEditing &&
        widget.vehicleData != null &&
        !_hasLoadedDiscounts &&
        mounted) {
      _hasLoadedDiscounts = true;
    }
  }

  @override
  void dispose() {
    _discountCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _discountCubit,
      child: BlocListener<DiscountCubit, DiscountState>(
        listener: (context, state) {
          if (state is DiscountFailure) {
          } else if (state is DiscountSuccess) {}
        },
        child: ComprehensiveDiscountManager(
          vehicleId: widget.vehicleId,
          isEditing: widget.isEditing,
          onDiscountsUpdated: () {},
          discounts: widget.vehicleData?.discounts,
        ),
      ),
    );
  }
}
