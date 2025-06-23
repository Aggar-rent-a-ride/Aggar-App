import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/features/main_screen/admin/presentation/views/no_internet_all_report_screen.dart';
import 'package:aggar/features/main_screen/customer/presentation/cubit/main_screen/main_screen_cubit.dart';
import 'package:aggar/features/main_screen/customer/presentation/cubit/main_screen/main_screen_state.dart';
import 'package:aggar/features/main_screen/customer/presentation/widgets/all_vehicle_list.dart';
import 'package:aggar/features/search/presentation/views/search_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AllVehicleScreen extends StatelessWidget {
  const AllVehicleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MainCubit, MainState>(
      builder: (context, state) {
        if (state is MainConnected) {
          return Scaffold(
            backgroundColor: context.theme.white100_1,
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: context.theme.blue100_8,
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20),
                      ),
                    ),
                    padding: const EdgeInsets.only(
                        left: 12, right: 12, top: 55, bottom: 8),
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: Icon(
                            Icons.arrow_back_ios_new_rounded,
                            color: context.theme.white100_1,
                            size: 20,
                          ),
                        ),
                        Text(
                          "All Vehicles",
                          style: AppStyles.bold20(context).copyWith(
                            color: context.theme.white100_1,
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const SearchScreen(),
                              ),
                            );
                          },
                          icon: Icon(
                            Icons.search,
                            color: context.theme.white100_1,
                            size: 20,
                          ),
                        ),
                      ],
                    ),
                  ),
                  AllVehicleList(
                    accessToken: state.accessToken,
                  ),
                ],
              ),
            ),
          );
        } else if (state is MainDisconnected) {
          return const NoInternetAllReportScreen();
        } else if (state is MainAuthError) {
          return Scaffold(
            backgroundColor: context.theme.white100_1,
            body: Center(
              child: Text(
                state.message,
                style: AppStyles.semiBold18(context).copyWith(
                  color: context.theme.black100,
                ),
              ),
            ),
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
