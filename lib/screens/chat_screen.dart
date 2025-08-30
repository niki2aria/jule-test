import 'package:flutter/material.dart';
import 'dart:io';

import '../models/message.dart';
import '../services/audio_service.dart';
import '../services/image_service.dart';
import '../services/inference_service.dart';
import '../widgets/media_preview.dart';
import '../widgets/chat_message_bubble.dart'; // Import the new widget

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _textController = TextEditingController();
  final List<Message> _messages = [];
  final ScrollController _scrollController = ScrollController();

  // Services
  final AudioService _audioService = AudioService();
  final ImageService _imageService = ImageService();
  final InferenceService _inferenceService = InferenceService();

  // State
  File? _mediaFile;
  bool _isRecording = false;
  bool _isLoading = false;

  void _handleSendMessage() async {
    final text = _textController.text;
    if (text.isEmpty) return;

    _textController.clear();
    setState(() {
      _messages.add(Message(text: text, sender: MessageSender.user));
      _isLoading = true;
    });
    _scrollToBottom();

    final history = _messages.map((m) => {
      'role': m.sender.toString().split('.').last,
      'content': m.text
    }).toList();

    final stream = _inferenceService.generateResponse(history);
    var fullResponse = "";
    var messageIndex = -1;

    stream.listen((responseChunk) {
      setState(() {
        if (messageIndex == -1) {
          fullResponse += responseChunk;
          _messages.add(Message(text: fullResponse, sender: MessageSender.model));
          messageIndex = _messages.length - 1;
        } else {
          fullResponse += responseChunk;
          _messages[messageIndex] = Message(text: fullResponse, sender: MessageSender.model);
        }
        _scrollToBottom();
      });
    }, onDone: () {
      setState(() {
        _isLoading = false;
      });
    }, onError: (e) {
      setState(() {
        _isLoading = false;
      });
      // Show a SnackBar with the error message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Error: ${e.toString()}"),
            backgroundColor: Colors.red,
          ),
        );
      }
    });
  }

  void _handlePickImage() async {
    final imageFile = await _imageService.pickImage();
    if (imageFile != null) setState(() => _mediaFile = imageFile);
  }

  void _handleTakePhoto() async {
    final photoFile = await _imageService.takePhoto();
    if (photoFile != null) setState(() => _mediaFile = photoFile);
  }

  void _handleToggleRecording() {
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
        _mediaFile = null;
      });
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
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
            child: ListView.builder(
              controller: _scrollController,
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                // Use the new ChatMessageBubble widget
                return ChatMessageBubble(message: _messages[index]);
              },
            ),
          ),
          if (_isLoading) const LinearProgressIndicator(),
          if (_mediaFile != null) MediaPreview(mediaFile: _mediaFile),
          Container(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _textController,
                    decoration: const InputDecoration(
                      hintText: "Type a message...",
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (_) => _handleSendMessage(),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _handleSendMessage,
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(icon: const Icon(Icons.photo_library), onPressed: _handlePickImage),
                IconButton(icon: const Icon(Icons.camera_alt), onPressed: _handleTakePhoto),
                IconButton(
                  icon: Icon(_isRecording ? Icons.stop : Icons.mic),
                  onPressed: _handleToggleRecording,
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
