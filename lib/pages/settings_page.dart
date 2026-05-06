import 'package:adapt/components/scaffold.dart';
import 'package:adapt/components/settings_component/toggle_theme.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return const MyScaffold(title: "Settings", body: ToggleTheme());
  }
}
