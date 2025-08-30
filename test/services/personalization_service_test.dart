import 'package:flutter_test/flutter_test.dart';
import 'package:gemma_3n_client/services/personalization_service.dart';

void main() {
  group('PersonalizationService', () {
    test('getPreferences returns default values initially', () async {
      final service = PersonalizationService();
      final prefs = await service.getPreferences();
      expect(prefs.name, "");
      expect(prefs.preferences, "");
    });

    test('savePreferences updates the in-memory store', () async {
      final service = PersonalizationService();
      final newPrefs = UserPreferences(
        name: "Jules",
        preferences: "Loves Flutter",
      );

      await service.savePreferences(newPrefs);
      final retrievedPrefs = await service.getPreferences();

      expect(retrievedPrefs.name, "Jules");
      expect(retrievedPrefs.preferences, "Loves Flutter");
    });
  });
}
