import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:photos_manager_ui/services/progress_service.dart';

import '../models/scan_request.dart';
import '../services/api_service.dart';
import '../models/file_operation.dart';
import 'files_screen.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key});

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  final TextEditingController _directoryController = TextEditingController();
  final TextEditingController _fileOperationController = TextEditingController();
  final ProgressService _progressService = ProgressService();

  bool _isLoading = false;
  bool _isScanning = false;
  int _progress = 0;

  FileOperation _operation = FileOperation.copy;
  bool _imageEnabled = true;
  bool _audioEnabled = false;
  bool _containerEnabled = false;
  bool _archiveEnabled = false;

  void _scanDirectory() async {
    if (_directoryController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select or enter a directory.")),
      );
      return;
    }

    setState(() {
      _isLoading = true;
      _isScanning = true;
      _progress = 0;
    });

    try {
      final scanRequest = ScanRequest(
        scanDirectory: _directoryController.text,
        operation: _operation,
        imageEnabled: _imageEnabled,
        audioEnabled: _audioEnabled,
        containerEnabled: _containerEnabled,
        archiveEnabled: _archiveEnabled,
      );

      _progressService.startListening();

      String response = await ApiService.scanFiles(scanRequest);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response)),
      );

      // navigate to FileScreen after scan
      await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const FilesScreen()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: ${e.toString()}")),
      );
    }

    setState(() {
      _isLoading = false;
      _isScanning = false;
      _progress = 0;
    });
  }

  void _abortScan() async {
    try {
      await ApiService.abortScan();
      _progressService.stopListening();
      setState(() {
        _isLoading = false;
        _isScanning = false;
        _progress = 0;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Scan aborted!")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to abort scan')));
    }
  }

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

  @override
  void initState() {
    super.initState();
    _progressService.startListening();
  }

  @override
  void dispose() {
    _progressService.dispose();
    super.dispose();
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

            // Linear Progress Indicator
            StreamBuilder<int>(
              stream: _progressService.progressStream,
              initialData: 0,
              builder: (context, snapshot) {
                _progress = snapshot.data ?? 0;
                return Column(
                  children: [
                    Text("Progress: $_progress%"),
                    const SizedBox(height: 10),
                    LinearProgressIndicator(value: _progress / 100),
                  ],
                );
              },
            ),

            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isLoading ? null : _scanDirectory,
              child: _isLoading ? const CircularProgressIndicator() : const Text('Start Scan'),
            ),

            // the button is visible only during the scan
            if (_isScanning)
              ElevatedButton(
                onPressed: _abortScan,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: const Text("Abort", style: TextStyle(color: Colors.white)),
              ),
            StreamBuilder(
                stream: _progressService.progressStream,
                initialData: 0,
                builder: (context, snapshot) {
                  _progress = snapshot.data ?? 0;
                  return Column(children: [
                    Text("Progress: $_progress%"),
                    LinearProgressIndicator(value: _progress / 100,)
                  ]);
                }
            ),
          ],
        ),
      ),
    );
  }
}
