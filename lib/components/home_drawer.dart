import 'package:flutter/material.dart';
import 'package:gif_view/gif_view.dart';
import 'package:provider/provider.dart';

import '../theme/theme_provider.dart';

class HomeDrawer extends StatelessWidget {
  const HomeDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.surface,
      child: Column(
        children: [
          GifView.asset("assets/image_assets/mahoraga3.gif"),
          Switch(
            value: Provider.of<ThemeProvider>(context).isDarkMode,
            onChanged: (value) => Provider.of<ThemeProvider>(
              context,
              listen: false,
            ).toggleTheme(),
          ),
        ],
      ),
    );
  }
}
