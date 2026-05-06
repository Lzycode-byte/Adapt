import 'package:flutter/material.dart';

import '../components/scaffold.dart';

class AnalyticsPage extends StatefulWidget {
  const AnalyticsPage({super.key});

  @override
  State<AnalyticsPage> createState() => _AnalyticsPageState();
}

class _AnalyticsPageState extends State<AnalyticsPage> {
  @override
  Widget build(BuildContext context) {
    return MyScaffold(title: "How you adapt", body: Placeholder());
  }
}
