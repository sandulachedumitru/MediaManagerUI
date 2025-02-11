class ScanRequest {
  final String scanDirectory;
  final String operation;
  final bool imageEnabled;
  final bool audioEnabled;
  final bool containerEnabled;
  final bool archiveEnabled;

  ScanRequest({
    required this.scanDirectory,
    required this.operation,
    required this.imageEnabled,
    required this.audioEnabled,
    required this.containerEnabled,
    required this.archiveEnabled,
  });

  Map<String, dynamic> toJson() {
    return {
      'scanDirectory': scanDirectory,
      'operation': operation,
      'imageEnabled': imageEnabled,
      'audioEnabled': audioEnabled,
      'containerEnabled': containerEnabled,
      'archiveEnabled': archiveEnabled,
    };
  }

  factory ScanRequest.fromJson(Map<String, dynamic> json) {
    return ScanRequest(
      scanDirectory: json['scanDirectory'],
      operation: json['operation'],
      imageEnabled: json['imageEnabled'],
      audioEnabled: json['audioEnabled'],
      containerEnabled: json['containerEnabled'],
      archiveEnabled: json['archiveEnabled'],
    );
  }
}
