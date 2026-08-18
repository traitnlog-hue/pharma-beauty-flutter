import 'package:flutter/material.dart';

import '../theme.dart';

/// 앱을 처음 열었을 때 브랜드 경험을 전달하는 LEXEM 인트로 화면입니다.
class IntroScreen extends StatelessWidget {
  const IntroScreen({super.key, required this.onStart});

  final VoidCallback onStart;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.paper,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1080),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset(
                    'assets/branding/lexem-wordmark-v2.png',
                    width: 142,
                    height: 35,
                    fit: BoxFit.contain,
                    alignment: Alignment.centerLeft,
                    semanticLabel: 'LEXEM 브랜드 로고',
                  ),
                  const Spacer(),
                  Container(
                    width: double.infinity,
                    constraints: const BoxConstraints(maxHeight: 470),
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      color: AppColors.deep,
                      borderRadius: BorderRadius.circular(AppRadii.hero + 4),
                    ),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Opacity(
                          opacity: .55,
                          child: Image.asset(
                            'assets/editorial/clinical-violet-hero.png',
                            fit: BoxFit.cover,
                            alignment: Alignment.centerRight,
                          ),
                        ),
                        DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: [
                                AppColors.deep,
                                AppColors.deep.withValues(alpha: .82),
                                AppColors.deep.withValues(alpha: .12),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(26),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 7),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: .12),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Text(
                                  '01 · YOUR SKIN, YOUR LANGUAGE',
                                  style: TextStyle(
                                    color: Color(0xFFE2DFFF),
                                    fontSize: 10,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 1,
                                  ),
                                ),
                              ),
                              const Spacer(),
                              const Text(
                                'READ\nYOUR SKIN.',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 38,
                                  height: .98,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: -1.8,
                                ),
                              ),
                              const SizedBox(height: 14),
                              const SizedBox(
                                width: 310,
                                child: Text(
                                  '성분과 피부, 오늘의 환경까지.\n나만의 케어 리듬을 읽어보세요.',
                                  style: TextStyle(
                                    color: Color(0xFFE9E7F2),
                                    fontSize: 15,
                                    height: 1.52,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 22),
                  FilledButton.icon(
                    key: const Key('intro-start-button'),
                    onPressed: onStart,
                    icon: const Icon(Icons.arrow_forward_rounded),
                    label: const Text('LEXEM 시작하기'),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    '피부를 더 잘 읽는 일상, 지금 시작해요.',
                    style: TextStyle(
                      color: AppColors.muted,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
