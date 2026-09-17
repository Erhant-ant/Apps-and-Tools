import 'package:flutter/material.dart';

import 'core/theme/app_theme.dart';
import 'presentation/screens/dashboard/dashboard_screen.dart';

void main() {
  runApp(const SupportDeskApp());
}

class SupportDeskApp extends StatelessWidget {
  const SupportDeskApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SupportDesk',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: DashboardScreen(),
    );
  }
}
