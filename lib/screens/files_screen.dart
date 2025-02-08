import 'package:flutter/material.dart';

import '../models/media_files.dart';
import '../services/api_service.dart';

class FilesScreen extends StatefulWidget {
  @override
  _FilesScreenState createState() => _FilesScreenState();
}

class _FilesScreenState extends State<FilesScreen> {
  final ApiService _apiService = ApiService();
  late Future<MediaFiles> _mediaFilesFuture;

  @override
  void initState() {
    super.initState();
    _loadFiles();
  }

  void _loadFiles() {
    setState(() {
      _mediaFilesFuture = _apiService.fetchMediaFiles();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Organized Media Files"),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadFiles,
          ),
        ],
      ),
      body: FutureBuilder<MediaFiles>(
        future: _mediaFilesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.files.isEmpty) {
            return const Center(child: Text("No files found."));
          }

          final filesMap = snapshot.data!.files;
          return ListView(
            children: filesMap.entries.map((entry) {
              return ExpansionTile(
                title: Text(entry.key, style: const TextStyle(fontWeight: FontWeight.bold)),
                children: entry.value.map((file) => ListTile(title: Text(file))).toList(),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
