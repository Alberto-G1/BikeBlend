import 'package:flutter/material.dart';
import 'package:glamazon/reusable_widgets/animations/animations.dart';
import 'package:glamazon/reusable_widgets/loaders/success_message.dart';
import 'package:provider/provider.dart';
import '../config/theme/theme_provider.dart';
import '../utils/colors.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _isAnimated = false;

  @override
  void initState() {
    super.initState();
    // Trigger animation after widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _isAnimated = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppAnimations.slideIn(
              animate: _isAnimated,
              beginOffset: const Offset(0, 0.1),
              child: _buildSectionTitle('Appearance'),
            ),
            const SizedBox(height: 16),
            
            // Theme settings
            AppAnimations.fadeIn(
              animate: _isAnimated,
              child: _buildThemeSelector(themeProvider),
            ),
            
            const SizedBox(height: 24),
            
            // Font settings
            AppAnimations.slideIn(
              animate: _isAnimated,
              beginOffset: const Offset(0, 0.1),
              duration: const Duration(milliseconds: 400),
              child: _buildSectionTitle('Font'),
            ),
            const SizedBox(height: 16),
            
            AppAnimations.fadeIn(
              animate: _isAnimated,
              duration: const Duration(milliseconds: 500),
              child: _buildFontSelector(themeProvider),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Theme.of(context).primaryColor,
      ),
    );
  }

  Widget _buildThemeSelector(ThemeProvider themeProvider) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Theme Mode',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 16),
            
            // Light mode option
            _buildThemeOption(
              title: 'Light',
              icon: Icons.light_mode,
              isSelected: !themeProvider.isDarkMode,
              onTap: () {
                if (themeProvider.isDarkMode) {
                  themeProvider.toggleTheme();
                  SuccessMessage.show(context, 'Light theme applied');
                }
              },
            ),
            
            const SizedBox(height: 12),
            
            // Dark mode option
            _buildThemeOption(
              title: 'Dark',
              icon: Icons.dark_mode,
              isSelected: themeProvider.isDarkMode,
              onTap: () {
                if (!themeProvider.isDarkMode) {
                  themeProvider.toggleTheme();
                  SuccessMessage.show(context, 'Dark theme applied');
                }
              },
            ),
            
            const SizedBox(height: 12),
            
            // System default option
            _buildThemeOption(
              title: 'System Default',
              icon: Icons.settings_suggest,
              isSelected: false,
              onTap: () {
                themeProvider.setSystemTheme(context);
                SuccessMessage.show(context, 'System theme applied');
              },
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
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.sienna.withOpacity(0.1) : null,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? AppColors.sienna : Colors.grey.withOpacity(0.3),
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected ? AppColors.sienna : null,
            ),
            const SizedBox(width: 12),
            Text(
              title,
              style: TextStyle(
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? AppColors.sienna : null,
              ),
            ),
            const Spacer(),
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: AppColors.sienna,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildFontSelector(ThemeProvider themeProvider) {
    // List of available fonts
    final fonts = [
      'Roboto',
      'Poppins',
      'Montserrat',
      'OpenSans',
      'Lato',
    ];

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Font Family',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 16),
            
            ...fonts.map((font) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _buildFontOption(
                fontFamily: font,
                isSelected: themeProvider.fontFamily == font,
                onTap: () {
                  themeProvider.setFont(font);
                  SuccessMessage.show(context, '$font font applied');
                },
              ),
            )),
          ],
        ),
      ),
    );
  }

  Widget _buildFontOption({
    required String fontFamily,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.sienna.withOpacity(0.1) : null,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? AppColors.sienna : Colors.grey.withOpacity(0.3),
          ),
        ),
        child: Row(
          children: [
            Text(
              'Aa',
              style: TextStyle(
                fontFamily: fontFamily,
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isSelected ? AppColors.sienna : null,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              fontFamily,
              style: TextStyle(
                fontFamily: fontFamily,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? AppColors.sienna : null,
              ),
            ),
            const Spacer(),
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: AppColors.sienna,
              ),
          ],
        ),
      ),
    );
  }
}
