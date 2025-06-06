import 'package:flutter/material.dart';

IconData getFileIcon(String filePath) {
  final extension = filePath.split('.').last.toLowerCase();
  switch (extension) {
    case 'pdf':
      return Icons.picture_as_pdf;
    case 'jpg':
    case 'jpeg':
    case 'png':
      return Icons.image;
    case 'doc':
    case 'docx':
      return Icons.description;
    default:
      return Icons.insert_drive_file;
  }
}
