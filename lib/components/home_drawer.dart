import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'drawer_item.dart';

class HomeDrawer extends StatefulWidget {
  const HomeDrawer({super.key});

  @override
  State<HomeDrawer> createState() => _HomeDrawerState();
}

class _HomeDrawerState extends State<HomeDrawer> with TickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Drawer(
        width: MediaQuery.of(context).size.width * 0.78,
        backgroundColor: Theme.of(context).colorScheme.surface,
        child: Column(
          children: [
            const SizedBox(height: 32),
            Lottie.asset(
              "assets/json_assets/1.json",
              controller: _controller,
              onLoaded: (composition) {
                _controller.duration = composition.duration ~/ 7; // 2x faster
                _controller.repeat();
              },
            ),

            const SizedBox(height: 40),
            Divider(indent: 30, endIndent: 30, thickness: 0.5),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0),
              child: DrawerItem(
                icon: Icons.home_rounded,
                label: 'Home',
                onTap: () {
                  Navigator.pop(context);
                  context.go("/");
                },
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0),
              child: DrawerItem(
                icon: Icons.bar_chart_rounded,
                label: 'Analytics',
                onTap: () {
                  Navigator.pop(context);
                  context.go("/analytics");
                },
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0),
              child: DrawerItem(
                icon: Icons.settings_rounded,
                label: 'Settings',
                onTap: () {
                  Navigator.pop(context);
                  context.go("/settings");
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
