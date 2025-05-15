import 'package:flutter/material.dart';
import 'package:glamazon/config/theme/theme_provider.dart';
import 'package:glamazon/utils/animations.dart';
import 'package:provider/provider.dart';

class ThemeToggle extends StatelessWidget {
  final bool showLabel;
  final Color? iconColor;
  
  const ThemeToggle({
    super.key, 
    this.showLabel = false,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return GestureDetector(
          onTap: () {
            themeProvider.toggleTheme();
          },
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppAnimations.rotate(
                animate: true,
                child: Icon(
                  themeProvider.isDarkMode 
                      ? Icons.light_mode 
                      : Icons.dark_mode,
                  color: iconColor,
                ),
              ),
              if (showLabel) ...[
                const SizedBox(width: 8),
                Text(
                  themeProvider.isDarkMode ? "Light Mode" : "Dark Mode",
                  style: TextStyle(
                    color: iconColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}
