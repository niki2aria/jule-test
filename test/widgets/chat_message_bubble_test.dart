import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gemma_3n_client/models/message.dart';
import 'package:gemma_3n_client/widgets/chat_message_bubble.dart';

void main() {
  testWidgets('ChatMessageBubble shows user message correctly', (WidgetTester tester) async {
    // Create a user message.
    final message = Message(text: 'User message', sender: MessageSender.user);

    // Build our app and trigger a frame.
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: ChatMessageBubble(message: message),
      ),
    ));

    // Verify that the message text is found.
    expect(find.text('User message'), findsOneWidget);

    // You could also test for specific colors or alignment if needed.
  });

  testWidgets('ChatMessageBubble shows model message correctly', (WidgetTester tester) async {
    // Create a model message.
    final message = Message(text: 'Model response', sender: MessageSender.model);

    // Build our app and trigger a frame.
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: ChatMessageBubble(message: message),
      ),
    ));

    // Verify that the message text is found.
    expect(find.text('Model response'), findsOneWidget);
  });
}
