import 'package:flutter_test/flutter_test.dart';
import 'package:gemma_3n_client/models/message.dart';

void main() {
  group('Message', () {
    test('Message can be created with user sender', () {
      final message = Message(text: 'Hello', sender: MessageSender.user);
      expect(message.text, 'Hello');
      expect(message.sender, MessageSender.user);
    });

    test('Message can be created with model sender', () {
      final message = Message(text: 'Hi there', sender: MessageSender.model);
      expect(message.text, 'Hi there');
      expect(message.sender, MessageSender.model);
    });
  });
}
