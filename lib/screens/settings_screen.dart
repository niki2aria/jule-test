import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/theme_service.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Access the ThemeService from the provider
    final themeService = Provider.of<ThemeService>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
      ),
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text("Dark Mode"),
            secondary: const Icon(Icons.dark_mode),
            value: themeService.isDarkMode,
            onChanged: (bool value) {
              // Call the service to toggle the theme
              themeService.toggleTheme(value);
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
