import 'package:flutter/material.dart';
import 'package:veloce/theme/app_theme.dart';
import 'package:veloce/theme/theme_manager.dart';
import 'package:veloce/widgets/animated_widgets.dart';

class SettingsScreen extends StatefulWidget {
  final ThemeManager themeManager;
  
  const SettingsScreen({
    super.key,
    required this.themeManager,
  });

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late String _selectedFont;
  
  @override
  void initState() {
    super.initState();
    _selectedFont = widget.themeManager.fontFamily;
  }
  
  @override
  Widget build(BuildContext context) {
    final isDark = widget.themeManager.isDarkMode;
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.colorScheme.primary,
        title: const Text('Settings'),
        elevation: 0,
      ),
      // Wrap the body in a SingleChildScrollView to fix scrolling
      body: SingleChildScrollView(
        // Add padding at the bottom to prevent overflow
        padding: const EdgeInsets.only(bottom: 24),
        physics: const BouncingScrollPhysics(),
        child: StaggeredList(
          children: [
            _buildSection(
              title: 'Appearance',
              children: [
                _buildThemeToggle(isDark),
                const SizedBox(height: 20),
                _buildFontSelector(),
              ],
            ),
            const SizedBox(height: 30),
            _buildSection(
              title: 'Notifications',
              children: [
                _buildSwitchTile(
                  title: 'Push Notifications',
                  subtitle: 'Receive alerts about your rides',
                  value: true,
                  onChanged: (value) {
                    // Show a snackbar to confirm the action
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Push notifications ${value ? 'enabled' : 'disabled'}'),
                        duration: const Duration(seconds: 1),
                      ),
                    );
                  },
                ),
                _buildSwitchTile(
                  title: 'Email Notifications',
                  subtitle: 'Receive updates via email',
                  value: false,
                  onChanged: (value) {
                    // Show a snackbar to confirm the action
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Email notifications ${value ? 'enabled' : 'disabled'}'),
                        duration: const Duration(seconds: 1),
                      ),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 30),
            _buildSection(
              title: 'Privacy',
              children: [
                _buildSwitchTile(
                  title: 'Location Tracking',
                  subtitle: 'Allow app to track your location during rides',
                  value: true,
                  onChanged: (value) {
                    // Show a snackbar to confirm the action
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Location tracking ${value ? 'enabled' : 'disabled'}'),
                        duration: const Duration(seconds: 1),
                      ),
                    );
                  },
                ),
                _buildSwitchTile(
                  title: 'Analytics',
                  subtitle: 'Help us improve by sending anonymous usage data',
                  value: true,
                  onChanged: (value) {
                    // Show a snackbar to confirm the action
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Analytics ${value ? 'enabled' : 'disabled'}'),
                        duration: const Duration(seconds: 1),
                      ),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 30),
            _buildSection(
              title: 'About',
              children: [
                _buildListTile(
                  title: 'Version',
                  subtitle: '1.0.0',
                  leading: const Icon(Icons.info_outline),
                ),
                _buildListTile(
                  title: 'Terms of Service',
                  leading: const Icon(Icons.description_outlined),
                  onTap: () {
                    // Show a snackbar to confirm the action
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Opening Terms of Service...'),
                        duration: Duration(seconds: 1),
                      ),
                    );
                  },
                ),
                _buildListTile(
                  title: 'Privacy Policy',
                  leading: const Icon(Icons.privacy_tip_outlined),
                  onTap: () {
                    // Show a snackbar to confirm the action
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Opening Privacy Policy...'),
                        duration: Duration(seconds: 1),
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({required String title, required List<Widget> children}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
        const SizedBox(height: 10),
        ...children,
      ],
    );
  }

  Widget _buildThemeToggle(bool isDark) {
    return AnimatedCard(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Theme Mode',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildThemeOption(
                  title: 'Light',
                  icon: Icons.light_mode,
                  isSelected: !isDark && widget.themeManager.themeMode != ThemeMode.system,
                  onTap: () {
                    widget.themeManager.setThemeMode('light');
                    // Show a snackbar to confirm the theme change
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Light theme applied'),
                        duration: Duration(seconds: 1),
                      ),
                    );
                  },
                ),
                _buildThemeOption(
                  title: 'Dark',
                  icon: Icons.dark_mode,
                  isSelected: isDark && widget.themeManager.themeMode != ThemeMode.system,
                  onTap: () {
                    widget.themeManager.setThemeMode('dark');
                    // Show a snackbar to confirm the theme change
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Dark theme applied'),
                        duration: Duration(seconds: 1),
                      ),
                    );
                  },
                ),
                _buildThemeOption(
                  title: 'System',
                  icon: Icons.settings_suggest,
                  isSelected: widget.themeManager.themeMode == ThemeMode.system,
                  onTap: () {
                    widget.themeManager.setThemeMode('system');
                    // Show a snackbar to confirm the theme change
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('System theme applied'),
                        duration: Duration(seconds: 1),
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildThemeOption({
    required String title,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  )
                ]
              : null,
          border: isSelected 
              ? null 
              : Border.all(
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.1),
                ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: isSelected
                  ? Colors.white
                  : Theme.of(context).colorScheme.onSurface,
              size: 28,
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                color: isSelected
                    ? Colors.white
                    : Theme.of(context).colorScheme.onSurface,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFontSelector() {
    return AnimatedCard(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Font Style',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            // Make the font selection more visible with a grid layout
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 1.5,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: AppTheme.availableFonts.length,
              itemBuilder: (context, index) {
                final font = AppTheme.availableFonts[index];
                final isSelected = _selectedFont == font;
                return GestureDetector(
                  onTap: () {
                    setState(() => _selectedFont = font);
                    widget.themeManager.setFontFamily(font);
                    // Show a snackbar to confirm the font change
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Font changed to $font'),
                        duration: const Duration(seconds: 1),
                      ),
                    );
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context).colorScheme.onSurface.withOpacity(0.2),
                        width: isSelected ? 2 : 1,
                      ),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              )
                            ]
                          : null,
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Aa',
                            style: TextStyle(
                              fontFamily: font,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: isSelected
                                  ? Colors.white
                                  : Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            font,
                            style: TextStyle(
                              fontFamily: font,
                              fontSize: 12,
                              color: isSelected
                                  ? Colors.white.withOpacity(0.9)
                                  : Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                            ),
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
            // Make the preview more prominent
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Font Preview: $_selectedFont',
                    style: TextStyle(
                      fontFamily: _selectedFont,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'The quick brown fox jumps over the lazy dog.',
                    style: TextStyle(
                      fontFamily: _selectedFont,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'ABCDEFGHIJKLMNOPQRSTUVWXYZ',
                    style: TextStyle(
                      fontFamily: _selectedFont,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'abcdefghijklmnopqrstuvwxyz 0123456789',
                    style: TextStyle(
                      fontFamily: _selectedFont,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSwitchTile({
    required String title,
    String? subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return AnimatedCard(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: SwitchListTile(
          title: Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontFamily: _selectedFont,
                ),
          ),
          subtitle: subtitle != null 
              ? Text(
                  subtitle,
                  style: TextStyle(
                    fontFamily: _selectedFont,
                  ),
                ) 
              : null,
          value: value,
          onChanged: onChanged,
          activeColor: Theme.of(context).colorScheme.primary,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }

  Widget _buildListTile({
    required String title,
    String? subtitle,
    Widget? leading,
    VoidCallback? onTap,
  }) {
    return AnimatedCard(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ListTile(
          title: Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontFamily: _selectedFont,
                ),
          ),
          subtitle: subtitle != null 
              ? Text(
                  subtitle,
                  style: TextStyle(
                    fontFamily: _selectedFont,
                  ),
                ) 
              : null,
          leading: leading,
          trailing: onTap != null 
              ? Icon(
                  Icons.chevron_right,
                  color: Theme.of(context).colorScheme.primary,
                ) 
              : null,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }
}
