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

  @override
  void initState() {
    super.initState();
    _showIntro = widget.showIntro;
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
        duration: const Duration(milliseconds: 360),
        child: _showIntro
            ? IntroScreen(
                key: const ValueKey('intro-screen'),
                onStart: () => setState(() => _showIntro = false),
              )
            : const AppShell(key: ValueKey('app-shell')),
      ),
    );
  }
}
