import 'package:adapt/theme/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ToggleTheme extends StatefulWidget {
  const ToggleTheme({super.key});

  @override
  State<ToggleTheme> createState() => _ToggleThemeState();
}

class _ToggleThemeState extends State<ToggleTheme> {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: () =>
            Provider.of<ThemeProvider>(context, listen: false).toggleTheme(),
        borderRadius: BorderRadius.circular(14),
        splashColor: colorScheme.primary.withOpacity(0.15),
        highlightColor: colorScheme.primary.withOpacity(0.08),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            color: colorScheme.secondary.withOpacity(0.5),
            border: Border.all(
              color: colorScheme.primary.withOpacity(0.3),
              width: 0.8,
            ),
          ),
          child: Row(
            children: [
              // Icon container
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: colorScheme.secondary,
                  borderRadius: BorderRadius.circular(9),
                ),
                child: Icon(
                  isDarkMode
                      ? Icons.dark_mode_outlined
                      : Icons.light_mode_outlined,
                  color: colorScheme.inversePrimary,
                  size: 20,
                ),
              ),
              const SizedBox(width: 14),
              // Label
              Expanded(
                child: Text(
                  isDarkMode ? "Join Light Side" : "Join Dark Side",
                  style: TextStyle(
                    color: colorScheme.primary,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.3,
                  ),
                ),
              ),
              // Chevron
              Switch(
                value: isDarkMode,
                onChanged: (value) => Provider.of<ThemeProvider>(
                  context,
                  listen: false,
                ).toggleTheme(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
