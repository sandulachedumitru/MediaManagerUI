import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

import '../models/scan_request.dart';
import '../services/api_service.dart';
import 'files_screen.dart';

class ScanScreen extends StatefulWidget {
  @override
  _ScanScreenState createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  final TextEditingController _directoryController = TextEditingController();
  final ApiService _apiService = ApiService();
  bool _isLoading = false;

  void _pickDirectory() async {
    if (kIsWeb) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Directory selection is not supported on web. Please enter the path manually.")),
      );
      return;
    }

    String? selectedDirectory = await FilePicker.platform.getDirectoryPath();

    if (selectedDirectory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No directory selected!")),
      );
      return;
    }

    setState(() {
      _directoryController.text = selectedDirectory;
    });
  }

  void _startScan() async {
    if (_directoryController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select or enter a directory.")),
      );
      return;
    }

    setState(() => _isLoading = true);
    try {
      String response = await _apiService.startScan(
        ScanRequest(scanDirectory: _directoryController.text),
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response)),
      );

      // navigate to FileScreen after scan
      await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => FilesScreen()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: ${e.toString()}")),
      );
    }
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Scan Media Files")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _directoryController,
              decoration: InputDecoration(
                labelText: "Directory path",
                border: const OutlineInputBorder(),
                suffixIcon: kIsWeb ? null : IconButton(
                  icon: const Icon(Icons.folder_open),
                  onPressed: _pickDirectory,
                ),
              ),
              readOnly: kIsWeb ? false : true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isLoading ? null : _startScan,
              child: _isLoading
                  ? const CircularProgressIndicator()
                  : const Text("Start Scan"),
            ),
          ],
        ),
      ),
    );
  }
}
