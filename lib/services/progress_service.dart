import 'dart:async';
import 'package:photos_manager_ui/services/api_service.dart';
import 'package:sse_dart_client/sse_dart_client.dart';

class ProgressService {
  final StreamController<int> _progressStreamController = StreamController<int>.broadcast();
  Stream<int> get progressStream => _progressStreamController.stream;

  final String progressSubscribeURL = '${ApiService.baseUrl}/progress/subscribe';
  SSEClient? _client;

  void startListening() {
    _client = SSEClient(
        url: progressSubscribeURL,
    );

    _client!.stream.listen((event) {
      print('Progress Received: $event');
      final progress = int.tryParse(event) ?? 0;
      _progressStreamController.add(progress);
    }, onError: (error) {
      print('Error receiving progress updates: $error');
    });
  }

  void stopListening() {
    _client?.close();
    _client = null;
  }

  void dispose() {
    stopListening();
    _progressStreamController.close();
  }
}
