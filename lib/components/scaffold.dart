import 'package:flutter/material.dart';

import 'home_drawer.dart';

class MyScaffold extends StatelessWidget {
  final Widget? body;
  final Widget? floatingActionButton;
  final String title;
  final List<Widget>? actions;

  const MyScaffold({
    super.key,
    required this.body,
    required this.title,
    this.floatingActionButton,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: Text(title),
        elevation: 0,
        backgroundColor: Colors.transparent,
        actions: actions,
      ),

      drawer: const HomeDrawer(),
      // body: SafeArea(child: Calendar()),
      body: body,
      floatingActionButton: floatingActionButton,
    );
  }
}
