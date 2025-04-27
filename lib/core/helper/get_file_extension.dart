String getFileExtension(String fileType, String originalPath) {
  if (originalPath.contains('.')) {
    final String originalExtension = originalPath.split('.').last.toLowerCase();
    final validExtensions = [
      '.pdf',
      '.doc',
      '.docx',
      '.xls',
      '.xlsx',
      '.ppt',
      '.pptx',
      '.txt',
    ];

    if (validExtensions.contains('.$originalExtension')) {
      return '.$originalExtension';
    }
  }
  switch (fileType) {
    case 'pdf':
      return '.pdf';
    case 'word':
      return '.docx';
    case 'excel':
      return '.xlsx';
    case 'powerpoint':
      return '.pptx';
    case 'text':
      return '.txt';
    default:
      return '.bin';
  }
}
