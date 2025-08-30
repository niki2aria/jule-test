import 'package:flutter/material.dart';
import 'dart:io';

import '../services/audio_service.dart';
import '../services/image_service.dart';
import '../widgets/media_preview.dart';
import '../widgets/voice_input_button.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final AudioService _audioService = AudioService();
  final ImageService _imageService = ImageService();

  File? _mediaFile;
  bool _isRecording = false;

  void _handlePickImage() async {
    final imageFile = await _imageService.pickImage();
    if (imageFile != null) {
      setState(() {
        _mediaFile = imageFile;
      });
    }
  }

  void _handleTakePhoto() async {
    final photoFile = await _imageService.takePhoto();
    if (photoFile != null) {
      setState(() {
        _mediaFile = photoFile;
      });
    }
  }

  void _handleToggleRecording() {
    // This is a simplified toggle. A real app would need more robust state management.
    if (_isRecording) {
      _audioService.stopRecording().then((audioPath) {
        if (audioPath != null) {
          setState(() {
            _mediaFile = File(audioPath);
            _isRecording = false;
          });
        }
      });
    } else {
      _audioService.startRecording();
      setState(() {
        _isRecording = true;
        _mediaFile = null; // Clear previous media
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Gemma 3n Client"),
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: MediaPreview(mediaFile: _mediaFile),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  icon: const Icon(Icons.photo_library),
                  onPressed: _handlePickImage,
                  tooltip: "Pick Image",
                ),
                IconButton(
                  icon: const Icon(Icons.camera_alt),
                  onPressed: _handleTakePhoto,
                  tooltip: "Take Photo",
                ),
                // Using a dedicated button for recording toggle for clarity
                IconButton(
                  icon: Icon(_isRecording ? Icons.stop : Icons.mic),
                  onPressed: _handleToggleRecording,
                  tooltip: _isRecording ? "Stop Recording" : "Start Recording",
                  color: _isRecording ? Colors.red : null,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
