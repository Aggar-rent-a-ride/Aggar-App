import 'package:aggar/core/cubit/theme/theme_cubit.dart';
import 'package:flutter/material.dart';

extension ThemeCubitExtension on BuildContext {
  ThemeCubit get themeCubit => ThemeCubit.of(this);
}
