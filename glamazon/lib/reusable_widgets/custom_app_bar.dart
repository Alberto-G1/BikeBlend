import 'package:flutter/material.dart';
import 'package:glamazon/config/theme/theme_provider.dart';
import 'package:glamazon/config/theme/theme_toggle.dart';
import 'package:glamazon/utils/colors.dart';
import 'package:provider/provider.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final bool showBackButton;
  final bool showThemeToggle;
  final VoidCallback? onBackPressed;
  final Color? backgroundColor;
  final Color? titleColor;
  final double elevation;
  final Widget? leading;
  final PreferredSizeWidget? bottom;

  const CustomAppBar({
    super.key,
    required this.title,
    this.actions,
    this.showBackButton = true,
    this.showThemeToggle = true,
    this.onBackPressed,
    this.backgroundColor,
    this.titleColor,
    this.elevation = 0,
    this.leading,
    this.bottom,
  });

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    
    return AppBar(
      backgroundColor: backgroundColor ?? 
          (themeProvider.isDarkMode ? Colors.black : AppColors.sienna),
      elevation: elevation,
      centerTitle: true,
      title: Text(
        title,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: titleColor ?? Colors.white,
        ),
      ),
      leading: showBackButton 
          ? (leading ?? IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
              onPressed: onBackPressed ?? () => Navigator.of(context).pop(),
            ))
          : null,
      actions: [
        if (showThemeToggle)
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: ThemeToggle(iconColor: Colors.white),
          ),
        if (actions != null) ...actions!,
      ],
      bottom: bottom,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(bottom == null ? kToolbarHeight : kToolbarHeight + bottom!.preferredSize.height);
}
