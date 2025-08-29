import 'package:flutter/material.dart';
import 'dart:io';

class MediaPreview extends StatelessWidget {
  final File? mediaFile;

  const MediaPreview({super.key, this.mediaFile});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: mediaFile == null
          ? const Text("No media selected")
          : Text("Preview for: ${mediaFile!.path}"), // Simple text preview
    );
  }
}
