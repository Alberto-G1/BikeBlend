import 'package:flutter/material.dart';
import 'package:glamazon/config/theme/theme_provider.dart';
import 'package:glamazon/utils/colors.dart';
import 'package:provider/provider.dart';

class ThemeToggle extends StatelessWidget {
  final bool showLabel;
  final double size;
  final Color? iconColor;
  
  const ThemeToggle({
    Key? key,
    this.showLabel = false,
    this.size = 24.0,
    this.iconColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    return GestureDetector(
      onTap: () {
        themeProvider.toggleTheme();
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (Widget child, Animation<double> animation) {
              return RotationTransition(
                turns: animation,
                child: ScaleTransition(
                  scale: animation,
                  child: child,
                ),
              );
            },
            child: Icon(
              isDarkMode ? Icons.dark_mode : Icons.light_mode,
              key: ValueKey<bool>(isDarkMode),
              color: isDarkMode ? Colors.amber : AppColors.sienna,
              size: size,
            ),
          ),
          if (showLabel) ...[
            const SizedBox(width: 8),
            Text(
              isDarkMode ? 'Dark Mode' : 'Light Mode',
              style: TextStyle(
                fontSize: 14,
                color: isDarkMode ? Colors.white70 : Colors.black87,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
