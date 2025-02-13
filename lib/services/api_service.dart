import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/media_files.dart';
import '../models/scan_request.dart';

class ApiService {
  static const String baseUrl = 'http://localhost:8080/api/media';

  static Future<String> scanFiles(ScanRequest request) async {
    final url = Uri.parse('$baseUrl/scan');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(request.toJson()),
    );

    if (response.statusCode == 200) {
      print('Scan initiated successfully');
      return response.body;
    } else {
      print('Failed to initiate scan: ${response.body}');
      throw Exception("Failed to start scan");
    }
  }

  static Future<void> abortScan() async {
    final response = await http.post(Uri.parse('$baseUrl/progress/abort'));
    if (response.statusCode != 200) {
      throw Exception('Failed to abort scan');
    }
  }

  // Get the organized files
  static Future<MediaFiles> fetchMediaFiles() async {
    final response = await http.get(
        Uri.parse("$baseUrl/media-files")
    );

    if (response.statusCode == 200) {
      return MediaFiles.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Failed to fetch media files");
    }
  }
}
