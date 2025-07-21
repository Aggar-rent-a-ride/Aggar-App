import 'package:aggar/core/cubit/user_cubit/user_info_cubit.dart';
import 'package:aggar/core/cubit/user_cubit/user_info_state.dart';
import 'package:aggar/features/profile/presentation/widgets/location_content_widget.dart';
import 'package:aggar/features/profile/presentation/widgets/location_error_widget.dart';
import 'package:aggar/features/profile/presentation/widgets/location_loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LocationTabWidget extends StatelessWidget {
  const LocationTabWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserInfoCubit, UserInfoState>(
      builder: (context, state) {
        if (state is UserInfoSuccess) {
          return LocationContentWidget(state: state);
        } else if (state is UserInfoLoading) {
          return const LocationLoadingWidget();
        } else {
          return const LocationErrorWidget();
        }
      },
    );
  }
}
