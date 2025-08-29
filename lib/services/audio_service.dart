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
