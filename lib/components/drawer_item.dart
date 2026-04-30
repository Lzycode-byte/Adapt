import 'package:flutter/material.dart';

class DrawerItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const DrawerItem({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
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
                child: Icon(icon, color: colorScheme.inversePrimary, size: 20),
              ),
              const SizedBox(width: 14),
              // Label
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    color: colorScheme.primary,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.3,
                  ),
                ),
              ),
              // Chevron
              Icon(
                Icons.chevron_right_rounded,
                color: colorScheme.primary,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
