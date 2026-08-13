import 'package:flutter/material.dart';

import '../catalog.dart';
import '../theme.dart';
import '../widgets/brand_widgets.dart';

class SkinProfileScreen extends StatefulWidget {
  const SkinProfileScreen({super.key});

  @override
  State<SkinProfileScreen> createState() => _SkinProfileScreenState();
}

class _SkinProfileScreenState extends State<SkinProfileScreen> {
  int step = 0;
  final answers = <String>[];

  static const questions = [
    ('평소 피부 상태는 어떤가요?', ['쉽게 건조하고 당겨요', '유분이 쉽게 올라와요', '부위별로 달라요', '자극에 민감해요']),
    ('가장 개선하고 싶은 고민은요?', ['피부 장벽', '보습', '민감·진정', '트러블']),
    ('선호하는 사용감이 있나요?', ['가볍고 산뜻하게', '촉촉하고 편안하게', '쫀쫀하고 영양감 있게', '사용감은 상관없어요']),
  ];

  void select(String answer) {
    answers.add(answer);
    setState(() => step += 1);
  }

  @override
  Widget build(BuildContext context) {
    final done = step >= questions.length;
    return Scaffold(
      appBar: AppBar(
        title: const BrandLogo(),
        leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.pop(context)),
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 680),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 12, 24, 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    child: LinearProgressIndicator(
                      value: (step + 1) / 4,
                      minHeight: 2,
                      color: AppColors.ink,
                      backgroundColor: AppColors.line,
                    ),
                  ),
                  const SizedBox(height: 36),
                  Text('MY SKIN PROFILE · 0${step + 1}/04',
                      style: const TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.3)),
                  const SizedBox(height: 24),
                  if (!done) ...[
                    Text(questions[step].$1,
                        style: Theme.of(context).textTheme.headlineLarge),
                    const SizedBox(height: 10),
                    const Text('가장 가까운 답 하나를 선택해 주세요.',
                        style: TextStyle(color: AppColors.muted, fontSize: 12)),
                    const SizedBox(height: 35),
                    Expanded(
                      child: ListView.separated(
                        itemCount: questions[step].$2.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 9),
                        itemBuilder: (context, index) {
                          final option = questions[step].$2[index];
                          return InkWell(
                            onTap: () => select(option),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 18, vertical: 19),
                              decoration: BoxDecoration(
                                  border: Border.all(color: AppColors.line)),
                              child: Row(
                                children: [
                                  Text('0${index + 1}',
                                      style: const TextStyle(fontSize: 9)),
                                  const SizedBox(width: 24),
                                  Expanded(
                                      child: Text(option,
                                          style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600))),
                                  const Icon(Icons.arrow_forward, size: 17),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ] else
                    Expanded(
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 108,
                              height: 108,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                      color: AppColors.ink, width: 8)),
                              child: const Text('94%',
                                  style: TextStyle(
                                      fontSize: 28,
                                      fontWeight: FontWeight.w800)),
                            ),
                            const SizedBox(height: 30),
                            Text('당신은 ‘장벽 보습형’이에요.',
                                textAlign: TextAlign.center,
                                style:
                                    Theme.of(context).textTheme.headlineLarge),
                            const SizedBox(height: 15),
                            const Text('건조와 민감 반응을 줄이는 순한 세라마이드 루틴이 잘 맞아요.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: AppColors.muted, height: 1.6)),
                            const SizedBox(height: 22),
                            const Wrap(spacing: 8, runSpacing: 8, children: [
                              _ResultTag('건성'),
                              _ResultTag('장벽 관리'),
                              _ResultTag('무향 선호'),
                            ]),
                            const SizedBox(height: 38),
                            SizedBox(
                              width: 250,
                              child: FilledButton(
                                onPressed: () =>
                                    Navigator.pop(context, concerns.first),
                                child: const Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('맞춤 제품 확인하기'),
                                      Icon(Icons.north_east, size: 17)
                                    ]),
                              ),
                            ),
                          ],
                        ),
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

class _ResultTag extends StatelessWidget {
  const _ResultTag(this.label);
  final String label;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 8),
        color: AppColors.mint,
        child: Text(label,
            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700)),
      );
}
