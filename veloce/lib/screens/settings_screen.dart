import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class SettingsScreen extends StatefulWidget {
  final bool isDarkMode;
  final Function(bool) onThemeToggle;

  const SettingsScreen({
    super.key,
    required this.isDarkMode,
    required this.onThemeToggle,
  });

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool useSystemTheme = true;

  @override
  void initState() {
    super.initState();
    final brightness = SchedulerBinding.instance.window.platformBrightness;
    useSystemTheme = widget.isDarkMode == (brightness == Brightness.dark);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Settings")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            SwitchListTile(
              title: const Text("Use System Theme"),
              value: useSystemTheme,
              onChanged: (value) {
                setState(() => useSystemTheme = value);
                if (value) {
                  final brightness = SchedulerBinding.instance.window.platformBrightness;
                  widget.onThemeToggle(brightness == Brightness.dark);
                }
              },
            ),
            if (!useSystemTheme)
              SwitchListTile(
                title: const Text("Enable Dark Mode"),
                value: widget.isDarkMode,
                onChanged: widget.onThemeToggle,
              ),
            const Divider(height: 40),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text("Profile"),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.lock),
              title: const Text("Privacy & Security"),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.help_outline),
              title: const Text("Help & Support"),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text("About App"),
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}
