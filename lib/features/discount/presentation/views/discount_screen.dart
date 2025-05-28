import 'package:aggar/core/cubit/refresh%20token/token_refresh_cubit.dart';
import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/helper/custom_snack_bar.dart';
import 'package:aggar/features/discount/presentation/cubit/discount_cubit.dart';
import 'package:aggar/features/discount/presentation/widgets/discount_list_section.dart';
import 'package:aggar/features/discount/presentation/widgets/yes_no_buttons_row.dart';
import 'package:aggar/features/new_vehicle/presentation/widgets/bottom_navigation_bar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import '../../../../core/utils/app_styles.dart';

class DiscountScreenView extends StatefulWidget {
  final String vehicleId;

  const DiscountScreenView({
    super.key,
    required this.vehicleId,
  });

  @override
  State<DiscountScreenView> createState() => _DiscountScreenViewState();
}

class _DiscountScreenViewState extends State<DiscountScreenView> {
  bool showDiscountSection = false;

  void updateDiscountSectionVisibility(bool show) {
    setState(() {
      showDiscountSection = show;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DiscountCubit(
        tokenRefreshCubit: context.read<TokenRefreshCubit>(),
      ),
      child: Builder(builder: (context) {
        return Scaffold(
          backgroundColor: context.theme.white100_1,
          appBar: AppBar(
            elevation: 2,
            shadowColor: Colors.grey[900],
            surfaceTintColor: Colors.transparent,
            centerTitle: false,
            backgroundColor: context.theme.white100_1,
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back_ios_new_rounded,
                color: context.theme.black100,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            title: Text(
              'Discounts',
              style: AppStyles.semiBold24(context)
                  .copyWith(color: context.theme.black100),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Gap(25),
                  Text(
                    'Add Discount to this vehicle ?',
                    style: AppStyles.bold22(context).copyWith(
                      color: context.theme.blue100_5,
                    ),
                  ),
                  const Gap(20),
                  YesNoButtonsRow(
                    showDiscount: showDiscountSection,
                    onSelectionChanged: updateDiscountSectionVisibility,
                  ),
                  if (showDiscountSection) const DiscountListSection(),
                ],
              ),
            ),
          ),
          bottomNavigationBar: BottomNavigationBarContent(
            title: "Continue",
            onPressed: () {
              if (widget.vehicleId.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  customSnackBar(
                    context,
                    "Error",
                    "Vehicle ID is missing. Cannot add discounts.",
                    SnackBarType.error,
                  ),
                );
                return;
              }
              if (showDiscountSection) {
                context.read<DiscountCubit>().addDiscount(widget.vehicleId);
              } else {
                Navigator.pop(context);
              }
            },
          ),
        );
      }),
    );
  }
}
