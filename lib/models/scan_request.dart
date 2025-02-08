class ScanRequest {
  final String scanDirectory;

  ScanRequest({required this.scanDirectory});

  Map<String, dynamic> toJson() {
    return { "scanDirectory": scanDirectory };
  }
}