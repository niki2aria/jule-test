class UserPreferences {
  String name;
  String preferences;

  UserPreferences({this.name = "", this.preferences = ""});
}

class PersonalizationService {
  // In-memory store for the user's preferences.
  // In a real app, this would be backed by persistent storage.
  UserPreferences _preferences = UserPreferences();

  Future<UserPreferences> getPreferences() async {
    // Simulate a delay, as if loading from disk.
    await Future.delayed(const Duration(milliseconds: 200));
    return _preferences;
  }

  Future<void> savePreferences(UserPreferences newPreferences) async {
    // Simulate a delay, as if saving to disk.
    await Future.delayed(const Duration(milliseconds: 200));
    _preferences = newPreferences;
  }
}
