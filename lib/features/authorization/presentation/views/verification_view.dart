import 'package:aggar/features/authorization/data/cubit/verification/verification_cubit.dart';
import 'package:aggar/features/authorization/presentation/widget/verification_view_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class VerificationView extends StatelessWidget {
  final Map<String, dynamic>? userData;

  const VerificationView({
    super.key,
    this.userData,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => VerificationCubit(userData: userData),
      child: const VerificationViewContent(),
    );
  }
}
