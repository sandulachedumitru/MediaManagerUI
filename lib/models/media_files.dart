class MediaFiles {
  final Map<String, List<String>> files;

  MediaFiles({required this.files});

  factory MediaFiles.fromJson(Map<String, dynamic> json) {
    return MediaFiles(
      files: json.map((key, value) =>
          MapEntry(key, List<String>.from(value as List))),
    );
  }
}
