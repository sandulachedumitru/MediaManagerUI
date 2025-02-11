import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/media_files.dart';
import '../models/scan_request.dart';

class ApiService {
  static const String baseUrl = 'http://localhost:8080/api';

  static Future<void> scanFiles(ScanRequest request) async {
    final url = Uri.parse('$baseUrl/scan');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(request.toJson()),
    );

    if (response.statusCode == 200) {
      print('Scan initiated successfully');
    } else {
      print('Failed to initiate scan: ${response.body}');
    }
  }

  static Future<List<MediaFiles>> fetchMediaFiles() async {
    final url = Uri.parse('$baseUrl/media-files');
    final response = await http.get(
      url,
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((json) => MediaFiles.fromJson(json)).toList();
    } else {
      print('Failed to fetch media files: ${response.body}');
      return [];
    }
  }
}
