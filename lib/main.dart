import 'package:flutter/material.dart';

import 'screens/app_shell.dart';
import 'theme.dart';

void main() {
  runApp(const PharmaBeautyApp());
}

class PharmaBeautyApp extends StatelessWidget {
  const PharmaBeautyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PHARMA BEAUTY',
      debugShowCheckedModeBanner: false,
      theme: buildAppTheme(),
      home: const AppShell(),
    );
  }
}
