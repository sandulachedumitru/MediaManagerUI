import '../screens/file_operation.dart';

class ScanRequest {
  final String scanDirectory;
  final FileOperation operation;
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
      'operation': operation.label,
      'imageEnabled': imageEnabled,
      'audioEnabled': audioEnabled,
      'containerEnabled': containerEnabled,
      'archiveEnabled': archiveEnabled,
    };
  }

  factory ScanRequest.fromJson(Map<String, dynamic> json) {
    return ScanRequest(
      scanDirectory: json['scanDirectory'],
      operation: FileOperation.values.firstWhere((e) => e.label == json['operation']),
      imageEnabled: json['imageEnabled'],
      audioEnabled: json['audioEnabled'],
      containerEnabled: json['containerEnabled'],
      archiveEnabled: json['archiveEnabled'],
    );
  }
}
