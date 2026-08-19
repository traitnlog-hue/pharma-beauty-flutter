import 'package:flutter/material.dart';

import '../theme.dart';

/// 0.8초 동안 브랜드만 보여주는 미니멀 오프닝 화면입니다.
class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _logoFade;
  late final Animation<Offset> _logoSlide;
  late final Animation<double> _taglineFade;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 560),
    )..forward();
    _logoFade =
        CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic);
    _logoSlide = Tween<Offset>(
      begin: const Offset(0, .16),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
    _taglineFade = CurvedAnimation(
      parent: _controller,
      curve: const Interval(.42, 1, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.paper,
      body: Center(
        child: FadeTransition(
          opacity: _logoFade,
          child: SlideTransition(
            position: _logoSlide,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const _IntroWordmark(),
                const SizedBox(height: 14),
                FadeTransition(
                  opacity: _taglineFade,
                  child: const Text(
                    'YOUR SKIN, YOUR LANGUAGE',
                    style: TextStyle(
                      color: AppColors.berry,
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _IntroWordmark extends StatelessWidget {
  const _IntroWordmark();

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'LEXEM',
      child: SizedBox(
        width: 216,
        height: 52,
        child: Image.asset(
          'assets/branding/lexem-wordmark-v2.png',
          fit: BoxFit.contain,
          filterQuality: FilterQuality.high,
        ),
      ),
    );
  }
}
