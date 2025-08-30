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
      prompt: prompt,
      temperature: 0.7,
      topK: 40,
      topP: 0.9,
      nPredict: 1024,
    );

    if (_llamaProcessor == null) {
      // In a real app, you'd want more robust error handling or state management.
      throw Exception("Model not loaded. Call loadModel() first.");
    }
    return _llamaProcessor!.inference(inferenceParams);
  }

  String _buildPromptFromMessages(List<Map<String, dynamic>> messages) {
    // This is a placeholder for the actual prompt building logic.
    // The format should match the model's expected input format.
    return messages.map((m) => '${m['role']}: ${m['content']}').join('\n');
  }
}
