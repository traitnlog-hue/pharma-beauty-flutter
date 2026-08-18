part of 'home_screen.dart';

class _Hero extends StatelessWidget {
  const _Hero({required this.profile, required this.onProfile});

  final SkinProfile profile;
  final VoidCallback onProfile;

  @override
  Widget build(BuildContext context) {
    final concern = profile.isComplete ? profile.primaryConcern : '수분 부족';
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 4, 14, 0),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1080),
          child: Container(
            key: const Key('skin-weather-hero'),
            height: 370,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFF1F0FF), Color(0xFFC8C7FF)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(AppRadii.hero),
              border: Border.all(color: AppColors.line),
            ),
            child: Stack(
              fit: StackFit.expand,
              children: [
                const CustomPaint(painter: _SkinWeatherPainter()),
                Padding(
                  padding: const EdgeInsets.fromLTRB(22, 20, 22, 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 11, vertical: 8),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: .72),
                              borderRadius: BorderRadius.circular(11),
                            ),
                            child: const Row(
                              children: [
                                Icon(Icons.wb_sunny_outlined,
                                    size: 15, color: AppColors.berry),
                                SizedBox(width: 7),
                                Text('TODAY · SKIN WEATHER',
                                    style: TextStyle(
                                        color: AppColors.berry,
                                        fontSize: 9,
                                        fontWeight: FontWeight.w700,
                                        letterSpacing: .8)),
                              ],
                            ),
                          ),
                          const Spacer(),
                          const Text('08.18',
                              style: TextStyle(
                                  color: AppColors.berry,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: .8)),
                        ],
                      ),
                      const SizedBox(height: 26),
                      const Text('오늘 피부 날씨',
                          style: TextStyle(
                              color: AppColors.berry,
                              fontSize: 12,
                              fontWeight: FontWeight.w700)),
                      const SizedBox(height: 6),
                      Text('$concern 주의',
                          style: const TextStyle(
                              color: AppColors.ink,
                              fontSize: 34,
                              height: 1.08,
                              fontWeight: FontWeight.w700,
                              letterSpacing: -1.2)),
                      const SizedBox(height: 8),
                      const Text('수분 신호가 낮아요. 오늘은 회복과 보습에 집중하세요.',
                          style: TextStyle(
                              color: AppColors.berry,
                              fontSize: 12,
                              height: 1.45)),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.fromLTRB(14, 13, 10, 13),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: .82),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                              color: Colors.white.withValues(alpha: .9)),
                        ),
                        child: Row(
                          children: [
                            const Expanded(
                                child: _WeatherMetric(
                                    icon: Icons.water_drop_outlined,
                                    label: '수분',
                                    value: '42%')),
                            const _WeatherDivider(),
                            const Expanded(
                                child: _WeatherMetric(
                                    icon: Icons.air_rounded,
                                    label: 'PM2.5',
                                    value: '38 나쁨')),
                            const _WeatherDivider(),
                            const Expanded(
                                child: _WeatherMetric(
                                    icon: Icons.light_mode_outlined,
                                    label: 'UV',
                                    value: '높음')),
                            IconButton(
                              key: const Key('skin-weather-update'),
                              tooltip: '오늘 피부 상태 업데이트',
                              onPressed: onProfile,
                              icon: const Icon(Icons.arrow_forward_rounded,
                                  color: AppColors.berry),
                            ),
                          ],
                        ),
                      ),
                    ],
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

class _WeatherMetric extends StatelessWidget {
  const _WeatherMetric(
      {required this.icon, required this.label, required this.value});

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Icon(icon, size: 13, color: AppColors.berry),
            const SizedBox(width: 4),
            Text(label,
                style: const TextStyle(
                    color: AppColors.muted,
                    fontSize: 9,
                    fontWeight: FontWeight.w600)),
          ]),
          const SizedBox(height: 4),
          Text(value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                  color: AppColors.ink,
                  fontSize: 13,
                  fontWeight: FontWeight.w700)),
        ],
      );
}

class _WeatherDivider extends StatelessWidget {
  const _WeatherDivider();

  @override
  Widget build(BuildContext context) => Container(
        width: 1,
        height: 34,
        margin: const EdgeInsets.symmetric(horizontal: 8),
        color: AppColors.line,
      );
}

class _SkinWeatherPainter extends CustomPainter {
  const _SkinWeatherPainter();

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawCircle(Offset(size.width * .82, size.height * .28),
        size.width * .17, Paint()..color = Colors.white.withValues(alpha: .28));

    final back = Path()
      ..moveTo(0, size.height * .7)
      ..quadraticBezierTo(size.width * .28, size.height * .42, size.width * .56,
          size.height * .66)
      ..quadraticBezierTo(
          size.width * .78, size.height * .48, size.width, size.height * .58)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(back, Paint()..color = const Color(0x267064DB));

    final front = Path()
      ..moveTo(0, size.height * .82)
      ..quadraticBezierTo(size.width * .27, size.height * .61, size.width * .52,
          size.height * .78)
      ..quadraticBezierTo(
          size.width * .76, size.height * .63, size.width, size.height * .72)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(front, Paint()..color = const Color(0x1F493A9A));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _SkinChartCard extends StatelessWidget {
  const _SkinChartCard({required this.profile, required this.onOpen});

  final SkinProfile profile;
  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(14, 12, 14, 0),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1080),
            child: Material(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(18),
              clipBehavior: Clip.antiAlias,
              child: InkWell(
                key: profile.isComplete
                    ? const Key('skin-chart-edit')
                    : const Key('skin-chart-start'),
                onTap: onOpen,
                child: Container(
                  key: const Key('skin-chart-card'),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: AppColors.line),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: AppColors.blush,
                          borderRadius: BorderRadius.circular(13),
                        ),
                        child: const Icon(Icons.assignment_outlined,
                            color: AppColors.berry, size: 21),
                      ),
                      const SizedBox(width: 13),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              profile.isComplete
                                  ? '${profile.profileName} 차트'
                                  : '내 스킨 차트 만들기',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  color: AppColors.ink,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              profile.isComplete
                                  ? '${profile.primaryConcern} · ${profile.recommendedIngredients}'
                                  : '5개 항목 · 약 1분 · 바로 맞춤 추천',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  color: AppColors.muted, fontSize: 11),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        width: 38,
                        height: 38,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: AppColors.fuchsia,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.arrow_forward_rounded,
                            color: Colors.white, size: 18),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );
}

class _SelfCareManifesto extends StatelessWidget {
  const _SelfCareManifesto(
      {required this.onProfile, required this.onDiscover, required this.onAsk});

  final VoidCallback onProfile;
  final VoidCallback onDiscover;
  final VoidCallback onAsk;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 28, 20, 0),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1080),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('바로 시작하기',
                  style: TextStyle(
                      color: AppColors.ink,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -.35)),
              const SizedBox(height: 5),
              const Text('궁금한 케어를 빠르게 찾아보세요.',
                  style: TextStyle(color: AppColors.muted, fontSize: 13)),
              const SizedBox(height: 16),
              Row(children: [
                Expanded(
                    child: _QuickAction(
                        icon: Icons.assignment_ind_outlined,
                        label: '피부 체크',
                        color: AppColors.blush,
                        onTap: onProfile)),
                const SizedBox(width: 8),
                Expanded(
                    child: _QuickAction(
                        icon: Icons.science_outlined,
                        label: '성분 트렌드',
                        color: AppColors.paper2,
                        onTap: onDiscover)),
                const SizedBox(width: 8),
                Expanded(
                    child: _QuickAction(
                        icon: Icons.format_list_numbered_rounded,
                        label: '루틴 만들기',
                        color: AppColors.oatmeal,
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) =>
                                    const RoutineBuilderScreen())))),
                const SizedBox(width: 8),
                Expanded(
                    child: _QuickAction(
                        key: const Key('pharmacist-home-action'),
                        icon: Icons.chat_bubble_outline_rounded,
                        label: '약사 상담',
                        color: AppColors.surface,
                        onTap: onAsk)),
              ]),
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: AppColors.ink,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Row(children: [
                  Icon(Icons.info_outline_rounded,
                      color: AppColors.ballerina, size: 18),
                  SizedBox(width: 11),
                  Expanded(
                    child: Text('오늘은 액티브 성분 하나만, 보습은 충분히.',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            height: 1.4,
                            fontWeight: FontWeight.w700)),
                  ),
                  Icon(Icons.arrow_forward_rounded,
                      color: AppColors.ballerina, size: 17),
                ]),
              ),
            ]),
          ),
        ),
      );
}

class _CoreHooks extends StatelessWidget {
  const _CoreHooks({
    required this.onProfile,
    required this.onRoutine,
    required this.onCompare,
  });

  final VoidCallback onProfile;
  final VoidCallback onRoutine;
  final VoidCallback onCompare;

  @override
  Widget build(BuildContext context) {
    final hooks = [
      (
        key: const Key('core-hook-profile'),
        index: '01',
        icon: Icons.assignment_outlined,
        title: '왜 안 맞았는지\n차트로 확인',
        caption: '자극 이력 · 성분 대조',
        onTap: onProfile,
      ),
      (
        key: const Key('core-hook-synergy'),
        index: '02',
        icon: Icons.warning_amber_rounded,
        title: '함께 쓰기 전\n충돌 신호 확인',
        caption: '레티놀 · AHA 조합 체크',
        onTap: onRoutine,
      ),
      (
        key: const Key('core-hook-compare'),
        index: '03',
        icon: Icons.compare_arrows_rounded,
        title: '후보 3개\n이유까지 비교',
        caption: '내 차트 기준 스마트 비교',
        onTap: onCompare,
      ),
    ];

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 44, 20, 0),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1080),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SectionLabel('01', 'WHY LEXEM'),
              const SizedBox(height: 8),
              Text('내 피부에 필요한 기능만',
                  style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: 6),
              const Text(
                '짧게 확인하고 바로 시작하세요.',
                style: TextStyle(color: AppColors.muted, fontSize: 12),
              ),
              const SizedBox(height: 16),
              LayoutBuilder(builder: (context, constraints) {
                final wide = constraints.maxWidth >= 820;
                final cards = hooks
                    .map((hook) => _HookCard(
                          key: hook.key,
                          index: hook.index,
                          icon: hook.icon,
                          title: hook.title,
                          caption: hook.caption,
                          onTap: hook.onTap,
                        ))
                    .toList();
                if (wide) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for (var i = 0; i < cards.length; i++) ...[
                        Expanded(child: cards[i]),
                        if (i < cards.length - 1) const SizedBox(width: 12),
                      ],
                    ],
                  );
                }
                return SizedBox(
                  height: 158,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    clipBehavior: Clip.none,
                    itemCount: cards.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 10),
                    itemBuilder: (_, index) =>
                        SizedBox(width: 238, child: cards[index]),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}

class _HookCard extends StatelessWidget {
  const _HookCard({
    required this.index,
    required this.icon,
    required this.title,
    required this.caption,
    required this.onTap,
    super.key,
  });

  final String index;
  final IconData icon;
  final String title;
  final String caption;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Material(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadii.card),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.line),
              borderRadius: BorderRadius.circular(AppRadii.card),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 34,
                      height: 34,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: AppColors.blush,
                        borderRadius: BorderRadius.circular(11),
                      ),
                      child: Icon(icon, color: AppColors.berry, size: 18),
                    ),
                    const Spacer(),
                    Text(index,
                        style: const TextStyle(
                            color: AppColors.fuchsia,
                            fontSize: 11,
                            fontWeight: FontWeight.w700)),
                  ],
                ),
                const Spacer(),
                Text(title,
                    style: const TextStyle(
                        color: AppColors.ink,
                        fontSize: 17,
                        height: 1.25,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -.35)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: Text(caption,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              color: AppColors.muted, fontSize: 10)),
                    ),
                    const Icon(Icons.arrow_forward_rounded,
                        color: AppColors.berry, size: 16),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
}

class _BrandStory extends StatelessWidget {
  const _BrandStory();

  static const _serviceLanguage = [
    ('01', 'SKIN PROFILE', '피부의 문맥'),
    ('02', 'INGREDIENT DICTIONARY', '성분의 단어'),
    ('03', 'WHY THIS PRODUCT', '추천의 해석'),
    ('04', 'COMPARE', '선택의 근거'),
    ('05', 'ROUTINE BUILDER', '나만의 문장'),
  ];

  static const _brandLines = [
    'LEXEM / BARRIER',
    'LEXEM / HYDRATION',
    'LEXEM / CALM',
    'LEXEM / INGREDIENT INDEX',
    'LEXEM / SKIN NOTE',
  ];

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(14, 54, 14, 0),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1080),
            child: Container(
              key: const Key('brand-story-section'),
              padding: const EdgeInsets.fromLTRB(22, 22, 22, 26),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(AppRadii.feature),
                border: Border.all(color: AppColors.line),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: AppColors.fuchsia,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'LEXEM / BRAND STORY',
                        style: TextStyle(
                          color: AppColors.berry,
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.4,
                        ),
                      ),
                      const Spacer(),
                      const Text(
                        'READ YOUR SKIN.',
                        style: TextStyle(
                          color: AppColors.ink,
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 26),
                  Container(
                    width: double.infinity,
                    height: 106,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 16),
                    decoration: BoxDecoration(
                      color: AppColors.paper,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Image.asset(
                      'assets/branding/lexem-wordmark.png',
                      fit: BoxFit.contain,
                      filterQuality: FilterQuality.high,
                      semanticLabel: 'LEXEM, READ YOUR SKIN 브랜드 워드마크',
                    ),
                  ),
                  const SizedBox(height: 30),
                  Text(
                    '화장품 성분은\n하나의 언어다.',
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    '각 성분은 단어가 되고, 성분의 조합은 문장이 되며, '
                    '스킨케어 루틴은 피부를 위한 하나의 이야기로 완성됩니다.',
                    style: TextStyle(
                      color: AppColors.ink,
                      fontSize: 14,
                      height: 1.7,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'LEXEM은 어려운 성분 정보를 해석하고, 사용자의 피부에 '
                    '필요한 의미만 남깁니다.',
                    style: TextStyle(
                      color: AppColors.muted,
                      fontSize: 13,
                      height: 1.65,
                    ),
                  ),
                  const SizedBox(height: 32),
                  const Divider(height: 1),
                  const SizedBox(height: 28),
                  const Text(
                    'THE LANGUAGE SYSTEM',
                    style: TextStyle(
                      color: AppColors.berry,
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.4,
                    ),
                  ),
                  const SizedBox(height: 7),
                  const Text(
                    '피부를 읽는 다섯 가지 문법',
                    style: TextStyle(
                      color: AppColors.ink,
                      fontSize: 19,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -.3,
                    ),
                  ),
                  const SizedBox(height: 16),
                  LayoutBuilder(builder: (context, constraints) {
                    final itemWidth = constraints.maxWidth >= 680
                        ? (constraints.maxWidth - 12) / 2
                        : constraints.maxWidth;
                    return Wrap(
                      spacing: 12,
                      runSpacing: 10,
                      children: [
                        for (final item in _serviceLanguage)
                          SizedBox(
                            width: itemWidth,
                            child: Container(
                              padding: const EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                color: AppColors.paper,
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(color: AppColors.line),
                              ),
                              child: Row(
                                children: [
                                  Text(
                                    item.$1,
                                    style: const TextStyle(
                                      color: AppColors.fuchsia,
                                      fontSize: 10,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const SizedBox(width: 13),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          item.$2,
                                          style: const TextStyle(
                                            color: AppColors.ink,
                                            fontSize: 10,
                                            fontWeight: FontWeight.w700,
                                            letterSpacing: .5,
                                          ),
                                        ),
                                        const SizedBox(height: 3),
                                        Text(
                                          item.$3,
                                          style: const TextStyle(
                                            color: AppColors.muted,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Icon(
                                    Icons.arrow_outward_rounded,
                                    size: 16,
                                    color: AppColors.rose,
                                  ),
                                ],
                              ),
                            ),
                          ),
                      ],
                    );
                  }),
                  const SizedBox(height: 30),
                  const Text(
                    'LEXEM LIBRARY',
                    style: TextStyle(
                      color: AppColors.muted,
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.4,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      for (final label in _brandLines)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 9),
                          decoration: BoxDecoration(
                            color: AppColors.blush,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            label,
                            style: const TextStyle(
                              color: AppColors.berry,
                              fontSize: 9,
                              fontWeight: FontWeight.w700,
                              letterSpacing: .35,
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      );
}

class _QuickAction extends StatelessWidget {
  const _QuickAction(
      {required this.icon,
      required this.label,
      required this.color,
      required this.onTap,
      super.key});

  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Material(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Container(
            height: 92,
            padding: const EdgeInsets.fromLTRB(10, 12, 8, 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.line),
            ),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Container(
                width: 32,
                height: 32,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: color, borderRadius: BorderRadius.circular(10)),
                child: Icon(icon, color: AppColors.berry, size: 18),
              ),
              const Spacer(),
              Text(label,
                  maxLines: 2,
                  style: const TextStyle(
                      color: AppColors.ink,
                      fontSize: 11,
                      height: 1.2,
                      fontWeight: FontWeight.w700)),
            ]),
          ),
        ),
      );
}

class _DailyBrief extends StatelessWidget {
  const _DailyBrief();
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 46, 20, 0),
        child: Center(
            child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1080),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const _SectionTitle(
                kicker: 'TODAY · SKIN BRIEF',
                title: '오늘의 피부 브리핑',
                subtitle: '프로필과 계절 신호를 바탕으로 우선순위를 정리했어요.'),
            const SizedBox(height: 20),
            LayoutBuilder(builder: (context, constraints) {
              final wide = constraints.maxWidth > 700;
              final cards = [
                const _BriefCard(
                    color: AppColors.mint,
                    icon: Icons.water_drop_rounded,
                    value: '42%',
                    label: '수분 방어력',
                    caption: '보습 레이어 +1 권장'),
                const _BriefCard(
                    color: AppColors.butter,
                    icon: Icons.shield_moon_rounded,
                    value: 'LOW',
                    label: '자극 리스크',
                    caption: '액티브 성분 1개만'),
                const _BriefCard(
                    color: Color(0xFFE1DBFF),
                    icon: Icons.nights_stay_rounded,
                    value: 'PM',
                    label: '집중 루틴',
                    caption: '장벽 회복 · 진정'),
              ];
              return wide
                  ? SizedBox(
                      height: 168,
                      child: Row(children: [
                        for (var i = 0; i < cards.length; i++) ...[
                          Expanded(child: cards[i]),
                          if (i < cards.length - 1) const SizedBox(width: 10)
                        ]
                      ]),
                    )
                  : SizedBox(
                      height: 168,
                      child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: cards.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(width: 10),
                          itemBuilder: (_, index) =>
                              SizedBox(width: 210, child: cards[index])));
            }),
          ]),
        )),
      );
}

class _ConcernPulse extends StatelessWidget {
  const _ConcernPulse({required this.selected, required this.onSelect});
  final String selected;
  final ValueChanged<String> onSelect;
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 68, 20, 0),
        child: Center(
            child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1080),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const _SectionTitle(
                kicker: 'QUICK MATCH',
                title: '어떤 신호가 가장 신경 쓰이나요?',
                subtitle: '고민을 탭하면 매치 결과가 실시간으로 바뀝니다.'),
            const SizedBox(height: 20),
            SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                    children: concerns.map((value) {
                  final active = selected == value;
                  return Padding(
                    padding: const EdgeInsets.only(right: 9),
                    child: ChoiceChip(
                        label: Text(value),
                        selected: active,
                        showCheckmark: false,
                        labelStyle: TextStyle(
                            color: active ? Colors.white : AppColors.ink,
                            fontWeight: FontWeight.w800),
                        onSelected: (_) => onSelect(value)),
                  );
                }).toList())),
          ]),
        )),
      );
}

class _MatchPicks extends StatelessWidget {
  const _MatchPicks(
      {required this.products,
      required this.profile,
      required this.compareIds,
      required this.onOpen,
      required this.onCompare});
  final List<BeautyProduct> products;
  final SkinProfile profile;
  final Set<int> compareIds;
  final ValueChanged<BeautyProduct> onOpen;
  final ValueChanged<BeautyProduct> onCompare;
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(top: 30),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Center(
                  child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 1080),
                      child: Row(children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  profile.isComplete
                                      ? '${profile.profileName} MATCH'
                                      : 'MATCH PICKS',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineMedium),
                              if (profile.isComplete) ...[
                                const SizedBox(height: 5),
                                Text(
                                  '${profile.primaryConcern} 차트 기준 · ${profile.recommendedIngredients}',
                                  style: const TextStyle(
                                    color: AppColors.muted,
                                    fontSize: 10,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text('${products.length} PICKS',
                            style: const TextStyle(
                                color: AppColors.violet,
                                fontSize: 10,
                                fontWeight: FontWeight.w700))
                      ])))),
          const SizedBox(height: 18),
          SizedBox(
            height: 430,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              scrollDirection: Axis.horizontal,
              itemCount: products.length,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                final product = products[index];
                final selected = compareIds.contains(product.id);
                return SizedBox(
                  width: 270,
                  child: Material(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(20),
                    clipBehavior: Clip.antiAlias,
                    child: InkWell(
                      onTap: () => onOpen(product),
                      child: Column(children: [
                        Stack(children: [
                          ProductBottle(product: product, height: 235),
                          Positioned(
                              left: 14,
                              top: 14,
                              child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 7),
                                  decoration: BoxDecoration(
                                      color: AppColors.lime,
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Text('${product.match}% MATCH',
                                      style: const TextStyle(
                                          fontSize: 9,
                                          fontWeight: FontWeight.w700)))),
                          Positioned(
                              right: 10,
                              top: 10,
                              child: IconButton(
                                  onPressed: () => onCompare(product),
                                  icon: Icon(
                                      selected
                                          ? Icons.check_rounded
                                          : Icons.compare_arrows_rounded,
                                      size: 17))),
                        ]),
                        Expanded(
                            child: Padding(
                                padding: const EdgeInsets.all(18),
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(product.brand,
                                          style: const TextStyle(
                                              color: AppColors.violet,
                                              fontSize: 8,
                                              fontWeight: FontWeight.w700,
                                              letterSpacing: .8)),
                                      const SizedBox(height: 7),
                                      Text(product.name,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                              fontSize: 17,
                                              fontWeight: FontWeight.w700)),
                                      const SizedBox(height: 8),
                                      Text(
                                          product.ingredients
                                              .take(2)
                                              .join(' · '),
                                          style: const TextStyle(
                                              color: AppColors.muted,
                                              fontSize: 10)),
                                      const Spacer(),
                                      Row(children: [
                                        Text(product.formattedPrice,
                                            style: const TextStyle(
                                                fontSize: 13,
                                                fontWeight: FontWeight.w700)),
                                        const Spacer(),
                                        const Icon(Icons.arrow_outward_rounded,
                                            color: AppColors.ink, size: 18)
                                      ]),
                                    ]))),
                      ]),
                    ),
                  ),
                );
              },
            ),
          ),
        ]),
      );
}

class _IngredientPulse extends StatelessWidget {
  const _IngredientPulse({required this.onOpen});
  final VoidCallback onOpen;
  @override
  Widget build(BuildContext context) => Container(
        margin: const EdgeInsets.fromLTRB(14, 70, 14, 0),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
            gradient: const LinearGradient(
                colors: [AppColors.violet, Color(0xFF4D34D8)]),
            borderRadius: BorderRadius.circular(AppRadii.feature)),
        child: Center(
            child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1000),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const _StatusPill(
                icon: Icons.graphic_eq_rounded,
                label: 'INGREDIENT PULSE · +31%'),
            const SizedBox(height: 28),
            Text('이번 주 가장 빠르게 뜨는\n성분은 레티날이에요.',
                style: Theme.of(context)
                    .textTheme
                    .headlineLarge
                    ?.copyWith(color: Colors.white)),
            const SizedBox(height: 13),
            const Text('탄력과 피부 결 관심이 올라가고 있어요. 단, BHA와 같은 날 사용하면 자극 신호를 확인하세요.',
                style: TextStyle(color: Color(0xFFE3DEFF), height: 1.6)),
            const SizedBox(height: 24),
            Row(children: [
              Expanded(
                  child: _PulseMini(
                      value: '89',
                      label: 'TREND SCORE',
                      color: AppColors.lime)),
              const SizedBox(width: 10),
              const Expanded(
                  child: _PulseMini(
                      value: '2',
                      label: 'ROUTINE ALERT',
                      color: AppColors.coral)),
            ]),
            const SizedBox(height: 22),
            FilledButton.icon(
                style: FilledButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: AppColors.ink),
                onPressed: onOpen,
                icon: const Icon(Icons.bubble_chart_rounded, size: 18),
                label: const Text('성분 트렌드 탐색')),
          ]),
        )),
      );
}

class _RoutinePreview extends StatelessWidget {
  const _RoutinePreview({required this.onOpen});
  final VoidCallback onOpen;
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 68, 20, 0),
        child: Center(
            child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1080),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const _SectionTitle(
                kicker: 'SMART ROUTINE',
                title: '오늘 저녁은 3단계면 충분해요.',
                subtitle: '과한 액티브는 줄이고 회복에 집중하는 루틴입니다.'),
            const SizedBox(height: 20),
            ...const [
              ('01', 'BHA 클리어 토너', AppColors.cyan),
              ('02', '세라마이드 배리어 세럼', AppColors.lime),
              ('03', '바이옴 리커버리 크림', AppColors.butter)
            ].map((item) => Container(
                  margin: const EdgeInsets.only(bottom: 9),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.line)),
                  child: Row(children: [
                    Container(
                        width: 42,
                        height: 42,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: item.$3,
                            borderRadius: BorderRadius.circular(14)),
                        child: Text(item.$1,
                            style: const TextStyle(
                                fontSize: 10, fontWeight: FontWeight.w700))),
                    const SizedBox(width: 14),
                    Expanded(
                        child: Text(item.$2,
                            style: const TextStyle(
                                fontSize: 13, fontWeight: FontWeight.w800))),
                    const Icon(Icons.drag_handle_rounded,
                        color: AppColors.muted)
                  ]),
                )),
            const SizedBox(height: 12),
            FilledButton.icon(
                onPressed: onOpen,
                icon: const Icon(Icons.auto_awesome_rounded, size: 18),
                label: const Text('루틴 궁합 스캔')),
          ]),
        )),
      );
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(
      {required this.kicker, required this.title, required this.subtitle});
  final String kicker;
  final String title;
  final String subtitle;
  @override
  Widget build(BuildContext context) =>
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(kicker,
            style: const TextStyle(
                color: AppColors.violet,
                fontSize: 10,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.1)),
        const SizedBox(height: 9),
        Text(title, style: Theme.of(context).textTheme.headlineLarge),
        const SizedBox(height: 8),
        Text(subtitle,
            style: const TextStyle(
                color: AppColors.muted, fontSize: 12, height: 1.5)),
      ]);
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.icon, required this.label});
  final IconData icon;
  final String label;
  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: .1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white.withValues(alpha: .15))),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Icon(icon, color: AppColors.lime, size: 15),
          const SizedBox(width: 7),
          Text(label,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 9,
                  fontWeight: FontWeight.w700,
                  letterSpacing: .8))
        ]),
      );
}

class _BriefCard extends StatelessWidget {
  const _BriefCard(
      {required this.color,
      required this.icon,
      required this.value,
      required this.label,
      required this.caption});
  final Color color;
  final IconData icon;
  final String value;
  final String label;
  final String caption;
  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
            color: color, borderRadius: BorderRadius.circular(16)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Icon(icon, size: 20),
          const Spacer(),
          Text(value,
              style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -1.5)),
          Text(label,
              style:
                  const TextStyle(fontSize: 11, fontWeight: FontWeight.w700)),
          const SizedBox(height: 4),
          Text(caption,
              style: const TextStyle(color: AppColors.muted, fontSize: 9))
        ]),
      );
}

class _PulseMini extends StatelessWidget {
  const _PulseMini(
      {required this.value, required this.label, required this.color});
  final String value;
  final String label;
  final Color color;
  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
            color: color, borderRadius: BorderRadius.circular(14)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(value,
              style:
                  const TextStyle(fontSize: 28, fontWeight: FontWeight.w700)),
          const SizedBox(height: 3),
          Text(label,
              style: const TextStyle(
                  fontSize: 8, fontWeight: FontWeight.w700, letterSpacing: .7))
        ]),
      );
}
