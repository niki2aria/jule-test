import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // State will be managed in the next step
  bool _darkModeEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
      ),
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text("Dark Mode"),
            secondary: const Icon(Icons.dark_mode),
            value: _darkModeEnabled,
            onChanged: (bool value) {
              setState(() {
                _darkModeEnabled = value;
              });
              // In a real app, this would also trigger a theme change.
            },
          ),
          const Divider(),
          ListTile(
            title: const Text("About"),
            leading: const Icon(Icons.info_outline),
            onTap: () {
              showAboutDialog(
                context: context,
                applicationName: "Gemma 3n Client",
                applicationVersion: "1.0.0",
                applicationLegalese: "© 2025 Jules AI",
                children: <Widget>[
                  const Padding(
                    padding: EdgeInsets.only(top: 16),
                    child: Text("A Flutter chat client built with the help of an AI assistant."),
                  )
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
