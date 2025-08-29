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
