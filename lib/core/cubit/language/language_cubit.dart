import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'language_state.dart';

class LanguageCubit extends Cubit<LanguageState> {
  LanguageCubit() : super(LanguageInitial()) {
    _loadSavedLanguage();
  }

  static const String _languageKey = 'language_code';
  static const String _countryCodeKey = 'country_code';

  Future<void> _loadSavedLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    final languageCode = prefs.getString(_languageKey) ?? 'en';
    final countryCode = prefs.getString(_countryCodeKey) ?? 'US';
    emit(LanguageChanged(Locale(languageCode, countryCode)));
  }

  Future<void> changeLanguage(String languageCode, String countryCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_languageKey, languageCode);
    await prefs.setString(_countryCodeKey, countryCode);
    emit(LanguageChanged(Locale(languageCode, countryCode)));
  }

  void changeToEnglish() {
    changeLanguage('en', 'US');
  }

  void changeToArabic() {
    changeLanguage('ar', 'SA');
  }
}
