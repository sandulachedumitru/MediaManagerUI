import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:photos_manager_ui/models/media_files.dart';
import 'package:photos_manager_ui/models/scan_request.dart';


class ApiService {
  final String baseUrl;

  ApiService({this.baseUrl = "http://127.0.0.1:8080/api/photos"});

  // Init the scan of the directory
  Future<String> startScan(ScanRequest request) async {
    final response = await http.post(
      Uri.parse("$baseUrl/scan"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(request.toJson()),
    );

    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception("Failed to start scan");
    }
  }

  // Get the organized files
  Future<MediaFiles> fetchMediaFiles() async {
    final response = await http.get(
      Uri.parse("$baseUrl/files")
    );

    if (response.statusCode == 200) {
      return MediaFiles.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Failed to fetch media files");
    }
  }
}