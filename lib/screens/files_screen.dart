import 'package:flutter/material.dart';

import '../models/media_files.dart';
import '../services/api_service.dart';

class FilesScreen extends StatefulWidget {
  const FilesScreen({super.key});

  @override
  // _FilesScreenState createState() => _FilesScreenState();
  State<FilesScreen> createState() => _FilesScreenState();
}

class _FilesScreenState extends State<FilesScreen> {
  late Future<List<MediaFiles>> _mediaFiles;

  @override
  void initState() {
    super.initState();
    _mediaFiles = ApiService.fetchMediaFiles();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Media Files')),
      body: FutureBuilder<List<MediaFiles>>(
        future: _mediaFiles,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error loading media files'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No media files found'));
          }

          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final file = snapshot.data![index];
              return ListTile(
                title: Text(file.name),
                subtitle: Text(file.path),
                trailing: const Icon(Icons.insert_drive_file),
              );
            },
          );
        },
      ),
    );
  }
}
