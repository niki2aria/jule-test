import 'package:flutter/material.dart';

class VoiceInputButton extends StatelessWidget {
  const VoiceInputButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.mic),
      onPressed: () {
        // Placeholder for voice recording logic
        print("Voice input button pressed");
      },
    );
  }
}
