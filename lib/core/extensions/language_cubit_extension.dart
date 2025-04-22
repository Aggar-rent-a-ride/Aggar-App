import 'package:aggar/core/cubit/language/language_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

extension LanguageCubitExtension on BuildContext {
  LanguageCubit get languageCubit => read<LanguageCubit>();
}
