import 'package:flutter/material.dart';

import '../models/scan_request.dart';
import '../services/api_service.dart';
import 'file_operation.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key});

  @override
  // _ScanScreenState createState() => _ScanScreenState();
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  final TextEditingController _directoryController = TextEditingController();
  final TextEditingController _fileOperationController = TextEditingController();

  FileOperation _operation = FileOperation.copy;
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
            const Padding(
                padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
            ),
            DropdownMenu<FileOperation>(
              initialSelection: FileOperation.copy,
              controller: _fileOperationController,
              requestFocusOnTap: true,
              label: const Text('File Operation'),
              onSelected: (FileOperation? newValue) {
                setState(() {
                  _operation = newValue!;
                });
              },
              dropdownMenuEntries: FileOperation.values.map<DropdownMenuEntry<FileOperation>>((operation) {
                return DropdownMenuEntry<FileOperation>(
                  value: operation,
                  label: operation.label,
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
