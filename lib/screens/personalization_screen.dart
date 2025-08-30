import 'package:flutter/material.dart';
import '../services/personalization_service.dart';

class PersonalizationScreen extends StatefulWidget {
  const PersonalizationScreen({super.key});

  @override
  State<PersonalizationScreen> createState() => _PersonalizationScreenState();
}

class _PersonalizationScreenState extends State<PersonalizationScreen> {
  final _nameController = TextEditingController();
  final _preferencesController = TextEditingController();
  final _personalizationService = PersonalizationService();

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    setState(() {
      _isLoading = true;
    });
    final prefs = await _personalizationService.getPreferences();
    _nameController.text = prefs.name;
    _preferencesController.text = prefs.preferences;
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _savePreferences() async {
    final newPrefs = UserPreferences(
      name: _nameController.text,
      preferences: _preferencesController.text,
    );
    await _personalizationService.savePreferences(newPrefs);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Preferences saved!"),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _preferencesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Personalization"),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView(
                children: [
                  Text(
                    "User Profile",
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: "Your Name",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "Model Preferences",
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _preferencesController,
                    decoration: const InputDecoration(
                      labelText: "Tell the model about your preferences...",
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 5,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: _savePreferences,
                    child: const Text("Save Preferences"),
                  ),
                ],
              ),
            ),
    );
  }
}
