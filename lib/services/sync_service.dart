import 'package:dio/dio.dart';
import './database_service.dart';

// The guide mentions a `sync_data` model, but it is not used in the
// provided service implementation. I will omit it for now to keep the
// code clean and directly reflective of the guide's logic.

class SyncService {
  final Dio _dio = Dio();
  final DatabaseService _databaseService = DatabaseService();

  static const String baseUrl = 'https://your-server.com/api';

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

  Future<bool> checkModelUpdate() async {
    try {
      final response = await _dio.get('$baseUrl/sync/check_model_update');
      return response.data['has_update'] ?? false;
    } catch (e) {
      return false;
    }
  }

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
