import 'package:flutter/material.dart';

import '../models/scan_request.dart';
import '../services/api_service.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key});

  @override
  // _ScanScreenState createState() => _ScanScreenState();
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  final TextEditingController _directoryController = TextEditingController();
  String _operation = 'MOVE';
  bool _imageEnabled = true;
  bool _audioEnabled = false;
  bool _containerEnabled = false;
  bool _archiveEnabled = false;

  void _scanDirectory() {
    final scanRequest = ScanRequest(
      scanDirectory: _directoryController.text,
      operation: _operation,
      imageEnabled: _imageEnabled,
      audioEnabled: _audioEnabled,
      containerEnabled: _containerEnabled,
      archiveEnabled: _archiveEnabled,
    );

    ApiService.scanFiles(scanRequest);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Scan Directory')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _directoryController,
              decoration: const InputDecoration(labelText: 'Directory Path'),
            ),
            DropdownButton<String>(
              value: _operation,
              onChanged: (String? newValue) {
                setState(() {
                  _operation = newValue!;
                });
              },
              items: ['MOVE', 'COPY']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            SwitchListTile(
              title: const Text('Enable Image Scanning'),
              value: _imageEnabled,
              onChanged: (bool value) {
                setState(() {
                  _imageEnabled = value;
                });
              },
            ),
            SwitchListTile(
              title: const Text('Enable Audio Scanning'),
              value: _audioEnabled,
              onChanged: (bool value) {
                setState(() {
                  _audioEnabled = value;
                });
              },
            ),
            SwitchListTile(
              title: const Text('Enable Container Scanning'),
              value: _containerEnabled,
              onChanged: (bool value) {
                setState(() {
                  _containerEnabled = value;
                });
              },
            ),
            SwitchListTile(
              title: const Text('Enable Archive Scanning'),
              value: _archiveEnabled,
              onChanged: (bool value) {
                setState(() {
                  _archiveEnabled = value;
                });
              },
            ),
            ElevatedButton(
              onPressed: _scanDirectory,
              child: const Text('Start Scan'),
            ),
          ],
        ),
      ),
    );
  }
}
