class MediaFiles {
  final String name;
  final String path;
  final String type;
  final int size;
  final DateTime createdAt;

  MediaFiles({
    required this.name,
    required this.path,
    required this.type,
    required this.size,
    required this.createdAt,
  });

  factory MediaFiles.fromJson(Map<String, dynamic> json) {
    return MediaFiles(
      name: json['name'],
      path: json['path'],
      type: json['type'],
      size: json['size'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'path': path,
      'type': type,
      'size': size,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
