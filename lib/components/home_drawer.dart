import 'package:flutter/material.dart';
import 'package:gif_view/gif_view.dart';
import 'package:provider/provider.dart';

import '../theme/theme_provider.dart';
import 'drawer_item.dart';

class HomeDrawer extends StatelessWidget {
  const HomeDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Drawer(
        width: MediaQuery.of(context).size.width * 0.78,
        backgroundColor: Theme.of(context).colorScheme.surface,
        child: Column(
          children: [
            const SizedBox(height: 32),
            GifView.asset("assets/image_assets/mahoraga3.gif"),
            const SizedBox(height: 40),
            Divider(indent: 30, endIndent: 30, thickness: 0.5),
            Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0),
              child: DrawerItem(
                icon: Icons.home_rounded,
                label: 'Home',
                onTap: () => Navigator.pop(context),
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0),
              child: DrawerItem(
                icon: Icons.bar_chart_rounded,
                label: 'Analytics',
                onTap: () => Navigator.pop(context),
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0),
              child: DrawerItem(
                icon: Icons.settings_rounded,
                label: 'Settings',
                onTap: () => Navigator.pop(context),
              ),
            ),
            Switch(
              value: Provider.of<ThemeProvider>(context).isDarkMode,
              onChanged: (value) => Provider.of<ThemeProvider>(
                context,
                listen: false,
              ).toggleTheme(),
            ),
          ],
        ),
      ),
    );
  }
}
