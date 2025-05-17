String getFileName(String path) {
  final uri = Uri.parse(path);
  return uri.pathSegments.last;
}
