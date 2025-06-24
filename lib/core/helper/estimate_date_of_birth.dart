import 'package:intl/intl.dart';

String estimateDateOfBirth(int age) {
  final now = DateTime.now();
  final estimatedBirthYear = now.year - age;
  final estimatedBirthDate = DateTime(estimatedBirthYear, 1, 1);
  final dateFormat = DateFormat('yyyy-MM-dd');
  return dateFormat.format(estimatedBirthDate);
}
