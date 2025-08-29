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
