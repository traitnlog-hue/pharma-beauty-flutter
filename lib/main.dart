import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';
import 'screens/app_shell.dart';
import 'screens/intro_screen.dart';
import 'theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const PharmaBeautyApp());
}

class PharmaBeautyApp extends StatefulWidget {
  const PharmaBeautyApp({super.key, this.showIntro = true});

  final bool showIntro;

  @override
  State<PharmaBeautyApp> createState() => _PharmaBeautyAppState();
}

class _PharmaBeautyAppState extends State<PharmaBeautyApp> {
  late bool _showIntro;
  Timer? _introTimer;

  @override
  void initState() {
    super.initState();
    _showIntro = widget.showIntro;
    if (_showIntro) {
      _introTimer = Timer(const Duration(milliseconds: 800), () {
        if (mounted) setState(() => _showIntro = false);
      });
    }
  }

  @override
  void dispose() {
    _introTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LEXEM — READ YOUR SKIN.',
      debugShowCheckedModeBanner: false,
      theme: buildAppTheme(),
      builder: (context, child) {
        // 앱 전반의 읽기 편한 기본 크기입니다. 개별 UI의 계층은 유지하면서
        // 작은 라벨과 보조 문구까지 동일한 비율로 키웁니다.
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaler: TextScaler.linear(1.12),
          ),
          child: child ?? const SizedBox.shrink(),
        );
      },
      home: AnimatedSwitcher(
        duration: const Duration(milliseconds: 420),
        switchInCurve: Curves.easeOut,
        switchOutCurve: Curves.easeIn,
        child: _showIntro
            ? const IntroScreen(key: ValueKey('intro-screen'))
            : const AppShell(key: ValueKey('app-shell')),
      ),
    );
  }
}
