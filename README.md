# Remote Collaboration Guide - Gemma 3n Client Project

## Introduction
This guide is for coders who want to collaborate remotely on completing the Gemma 3n Client project.

## Current Project Status

### ✅ Completed:
1. **Full Flutter Project Structure**
2. **Data Models** (Interaction, Personalization, User Settings, Data Sync)
3. **Core Services** (Database, Inference, Tutorial Mode, Personalization, Data Summary)
4. **User Interface** (Chat Page, Personalization Page, Settings Page)
5. **Modern UI** with Animations and Beautiful Design
6. **SQLite Database** with Control Management
7. **Navigation Between Pages**

### ⚠️ Ongoing Work:
- Real Model (Currently Simulated)
- Sync Service

### 🔄 Remaining Work:
- Audio and Video Services
- Performance Optimization
- Cross-Platform Testing

## Work Priorities (in order of importance)

### 1. Implement Real Model (Priority above)

#### Option A: Use llama_cpp_dart
```dart
// in lib/services/inference_service.dart
import 'package:llama_cpp_dart/llama_cpp_dart.dart';

class InferenceService {
  LlamaProcessor? _llamaProcessor;

  Future<void> loadModel() async {
    final modelPath = "assets/gemma-3n-E2B-it-Q8_0.gguf";

    _llamaProcessor = LlamaProcessor(
      modelPath,
      ModelParams(nCtx: 2048),
    );
  }

  Stream<String> generateResponse(List<Map<String, dynamic>> messages) {
    String prompt = _buildPromptFromMessages(messages);

    final inferenceParams = InferenceParams(
      fast: true,
      temp: 0.7,
      topK: 40,
      topP: 0.9,
      nprediction: 1024,
    );
    return _llamaProcessor!.inference(inferenceParams);
  }

  String _buildPromptFromMessages(List<Map<String, dynamic>> messages) {
    // This is a placeholder for the actual prompt building logic.
    return messages.map((m) => '${m['role']}: ${m['content']}').join('\n');
  }
}
```

#### Option B: Use external API
```dart
// in lib/services/inference_service.dart
import 'package:http/http.dart' as http;
import 'dart:convert';

class InferenceService {
  static const String apiUrl = 'https://api.example.com/chat';

  Stream<String> generateResponse(List<Map<String, dynamic>> messages) async* {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'messages': messages,
        'model': 'gemma-3n',
        'stream': true,
      }),
    );

    // Process the stream response
    final lines = response.body.split('\n');
    for (String line in lines) {
      if (line.startsWith('data: ')) {
        final data = jsonDecode(line.substring(6));
        yield data['content'] ?? '';
      }
    }
  }
}
```

### 2. Sync Service (Medium Priority)

#### File: `lib/services/sync_service.dart`
```dart
import 'package:dio/dio.dart';
// These are placeholders for models that need to be created.
// import '../models/sync_data.dart';
// import '../services/database_service.dart';

// Placeholder classes
class SyncData {}
class DatabaseService {
  Future<List<Map<String, dynamic>>> getUnsyncedTrainingData() async => [];
  Future<void> markTrainingDataAsSynced(dynamic id) async {}
}


class SyncService {
  final Dio _dio = Dio();
  final DatabaseService _databaseService = DatabaseService();

  static const String baseUrl = 'https://your-server.com/api';

  // Sync training data
  Future<bool> syncTrainingData() async {
    try {
      final unsyncedData = await _databaseService.getUnsyncedTrainingData();

      for (var data in unsyncedData) {
        final response = await _dio.post(
          '$baseUrl/sync/upload_data',
          data: data['data'],
        );

        if (response.statusCode == 200) {
          await _databaseService.markTrainingDataAsSynced(data['id']);
        }
      }
      return true;
    } catch (e) {
      print('Error syncing: $e');
      return false;
    }
  }

  // Check model update
  Future<bool> checkModelUpdate() async {
    try {
      final response = await _dio.get('$baseUrl/sync/check_model_update');
      return response.data['has_update'] ?? false;
    } catch (e) {
      return false;
    }
  }

  // Download new model
  Future<bool> downloadModel(String modelUrl) async {
    try {
      final response = await _dio.download(
        modelUrl,
        'assets/models/gemma-3n-E2B-it-Q8_0.gguf',
      );
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}
```

### 3. Audio and video services (low priority)

#### File: `lib/services/audio_service.dart`
```dart
import 'package:record/record.dart';
import 'package:audioplayers/audioplayers.dart';

class AudioService {
  final Record _record = Record();
  final AudioPlayer _player = AudioPlayer();

  Future<void> startRecording() async {
    if (await _record.hasPermission()) {
      await _record.start();
    }
  }

  Future<String?> stopRecording() async {
    return await _record.stop();
  }

  Future<void> playAudio(String filePath) async {
    await _player.play(DeviceFileSource(filePath));
  }
}
```

#### File: `lib/services/image_service.dart`
```dart
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ImageService {
  final ImagePicker _picker = ImagePicker();

  Future<File?> pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    return image != null ? File(image.path) : null;
  }

  Future<File?> takePhoto() async {
    final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
    return photo != null ? File(photo.path) : null;
  }
}
```
