part of 'home_screen.dart';

class _Hero extends StatefulWidget {
  const _Hero({required this.onOpen});

  final VoidCallback onOpen;

  @override
  State<_Hero> createState() => _HeroState();
}

class _HeroState extends State<_Hero> {
  final controller = PageController();
  Timer? timer;
  int selected = 0;
  static const slides = [
    ('이번 주, 레티날이\n빠르게 뜨고 있어요.', '탄력·피부결 검색량 상승 · 함께 쓰는 성분까지 확인'),
    ('장벽 케어의 중심,\n세라마이드를 읽어요.', '건조한 날씨에 찾는 보습 성분 · 판테놀 궁합 확인'),
    ('비타민C, 아침 루틴에\n다시 주목해요.', '칙칙함 케어 검색량 상승 · 자외선 차단과 함께'),
  ];

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(const Duration(seconds: 5), (_) {
      if (!mounted) return;
      controller.animateToPage((selected + 1) % slides.length,
          duration: const Duration(milliseconds: 520),
          curve: Curves.easeOutCubic);
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    controller.dispose();
    super.dispose();
  }

  void select(int index) => controller.animateToPage(index,
      duration: const Duration(milliseconds: 360), curve: Curves.easeOutCubic);

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(14, 4, 14, 0),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1080),
            child: Column(
              children: [
                Material(
                  color: AppColors.deep,
                  borderRadius: BorderRadius.circular(AppRadii.hero),
                  clipBehavior: Clip.antiAlias,
                  child: InkWell(
                    key: const Key('ingredient-trend-hero'),
                    onTap: widget.onOpen,
                    child: SizedBox(
                      height: 226,
                      child: PageView.builder(
                        controller: controller,
                        itemCount: slides.length,
                        onPageChanged: (index) =>
                            setState(() => selected = index),
                        itemBuilder: (context, index) =>
                            Stack(fit: StackFit.expand, children: [
                          Image.asset(
                            'assets/editorial/ingredient-trend-hero-editorial-v1.png',
                            fit: BoxFit.cover,
                            alignment: const Alignment(.55, 0),
                          ),
                          const DecoratedBox(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Color(0xFF111115),
                                  Color(0xE6111115),
                                  Color(0x40493A9A),
                                ],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ),
                            ),
                          ),
                          const DecoratedBox(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.transparent,
                                  Color(0xD9111115),
                                ],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 7),
                                      decoration: BoxDecoration(
                                        color:
                                            Colors.white.withValues(alpha: .12),
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                            color: Colors.white
                                                .withValues(alpha: .18)),
                                      ),
                                      child: const Text(
                                        'LIVE · INGREDIENT TREND',
                                        style: TextStyle(
                                          color: AppColors.ballerina,
                                          fontSize: 9,
                                          fontWeight: FontWeight.w700,
                                          letterSpacing: .8,
                                        ),
                                      ),
                                    ),
                                    const Spacer(),
                                    Text(
                                      '0${index + 1} / 03',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 9,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                                const Spacer(),
                                Text(
                                  slides[index].$1,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 22,
                                    height: 1.12,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: -.9,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  slides[index].$2,
                                  style: TextStyle(
                                    color: Color(0xFFE8E6F7),
                                    fontSize: 11,
                                    height: 1.45,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: Container(
                                    padding: const EdgeInsets.only(left: 12),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withValues(alpha: .1),
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(
                                        color:
                                            Colors.white.withValues(alpha: .2),
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Text(
                                          '지금 뜨는 성분 보기',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 11,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Container(
                                          width: 30,
                                          height: 30,
                                          alignment: Alignment.center,
                                          decoration: const BoxDecoration(
                                            color: Colors.white,
                                            shape: BoxShape.circle,
                                          ),
                                          child: const Icon(
                                            Icons.north_east_rounded,
                                            color: AppColors.deep,
                                            size: 17,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ]),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 2),
                PageIndicator(
                  count: slides.length,
                  selectedIndex: selected,
                  onSelected: select,
                  keyPrefix: 'ingredient-trend-tab',
                ),
              ],
            ),
          ),
        ),
      );
}

class _TrendShortcuts extends StatelessWidget {
  const _TrendShortcuts({required this.onOpen});

  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context) {
    const items = [
      (Icons.shield_outlined, '세라마이드', Color(0xFFEFEDFF)),
      (Icons.spa_outlined, '판테놀', Color(0xFFF0F1F4)),
      (Icons.auto_awesome_outlined, '레티날', Color(0xFFFFE9D6)),
      (Icons.light_mode_outlined, '비타민C', Color(0xFFFFF0C9)),
      (Icons.water_drop_outlined, 'BHA', Color(0xFFE6F0F5)),
    ];
    return Row(
      children: [
        for (var i = 0; i < items.length; i++) ...[
          Expanded(
            child: InkWell(
              key: Key('trend-shortcut-$i'),
              borderRadius: BorderRadius.circular(14),
              onTap: onOpen,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Column(
                  children: [
                    Container(
                      width: 42,
                      height: 42,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: items[i].$3,
                        shape: BoxShape.circle,
                      ),
                      child:
                          Icon(items[i].$1, color: AppColors.berry, size: 19),
                    ),
                    const SizedBox(height: 7),
                    Text(
                      items[i].$2,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppColors.ink,
                        fontSize: 9,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (i < items.length - 1) const SizedBox(width: 3),
        ],
      ],
    );
  }
}

class _HomeSkinWeather extends StatefulWidget {
  const _HomeSkinWeather({required this.profile, required this.onOpen});

  final SkinProfile profile;
  final VoidCallback onOpen;

  @override
  State<_HomeSkinWeather> createState() => _HomeSkinWeatherState();
}

class _HomeSkinWeatherState extends State<_HomeSkinWeather> {
  static const _refreshInterval = Duration(minutes: 15);
  final _service = const SkinWeatherService();
  late Future<SkinWeatherSnapshot> _weatherFuture;
  Timer? _refreshTimer;

  @override
  void initState() {
    super.initState();
    _weatherFuture = _service.loadCurrentSnapshot();
    _refreshTimer = Timer.periodic(_refreshInterval, (_) => _refresh());
  }

  void _refresh() {
    if (mounted)
      setState(() => _weatherFuture = _service.loadCurrentSnapshot());
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<SkinWeatherSnapshot>(
      future: _weatherFuture,
      builder: (context, snapshot) {
        final weather = snapshot.data ?? _service.loadDemoSnapshot();
        final advice = _service.adviceFor(weather, widget.profile);
        final skinType = widget.profile.skinType.isEmpty
            ? '피부 타입 미등록'
            : widget.profile.skinType;
        final userName = widget.profile.displayName.isEmpty
            ? '회원'
            : widget.profile.displayName;

        return Padding(
          padding: const EdgeInsets.fromLTRB(14, 28, 14, 0),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1080),
              child: InkWell(
                key: const Key('skin-weather-hero'),
                onTap: widget.onOpen,
                borderRadius: BorderRadius.circular(AppRadii.hero),
                child: Ink(
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(AppRadii.hero),
                    border: Border.all(color: const Color(0xFFDFDDFA)),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.fuchsia.withValues(alpha: .09),
                        blurRadius: 24,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _WeatherSkyHero(
                            weather: weather,
                            skinType: skinType,
                            userName: userName),
                        const SizedBox(height: 12),
                        _WeatherMetricGrid(
                            weather: weather, skinType: skinType),
                        const SizedBox(height: 12),
                        _WeatherAdvice(
                          weather: weather,
                          advice: advice,
                          skinType: skinType,
                          userName: userName,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _WeatherSkyHero extends StatelessWidget {
  const _WeatherSkyHero(
      {required this.weather, required this.skinType, required this.userName});

  final SkinWeatherSnapshot weather;
  final String skinType;
  final String userName;

  @override
  Widget build(BuildContext context) => Container(
        height: 220,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(21),
          gradient: const LinearGradient(
            colors: [Color(0xFF9089E8), Color(0xFFD3C7F4), Color(0xFFFFD9CC)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            const Positioned(
              right: -44,
              top: -42,
              child: _SkyOrb(size: 180, color: Color(0x55FFF7E8)),
            ),
            const Positioned(
              right: 44,
              bottom: -70,
              child: _SkyOrb(size: 190, color: Color(0x3A594AC7)),
            ),
            Positioned(
              left: -20,
              bottom: -86,
              child: Transform.rotate(
                angle: -.13,
                child: Container(
                  width: 310,
                  height: 160,
                  decoration: const BoxDecoration(
                    color: Color(0x446051B5),
                    borderRadius: BorderRadius.all(Radius.elliptical(220, 100)),
                  ),
                ),
              ),
            ),
            // 텍스트와 겹치지 않도록 오른쪽에만 배치한 투명 날씨 일러스트입니다.
            const Positioned(
              right: 6,
              bottom: -18,
              child: _FloatingWeatherIllustration(),
            ),
            Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 9, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: .22),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.location_on_outlined,
                                color: Colors.white, size: 13),
                            SizedBox(width: 4),
                            Text(
                                weather.isLive
                                    ? 'SEOUL · LIVE DATA'
                                    : 'SEOUL · 업데이트 중',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 8,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: .7)),
                          ],
                        ),
                      ),
                      const Spacer(),
                      const Icon(Icons.wb_sunny_rounded,
                          color: Color(0xFFFFF7D2), size: 25),
                    ],
                  ),
                  const Spacer(),
                  Text('${weather.temperature}°',
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 56,
                          height: .9,
                          fontWeight: FontWeight.w500,
                          letterSpacing: -3)),
                  const SizedBox(height: 7),
                  Text('$userName님의 피부 기상 리포트',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.w800)),
                  const SizedBox(height: 4),
                  Text(
                      '$skinType 피부 · UV ${weather.uvIndex} · PM2.5 ${weather.pm25}',
                      style: const TextStyle(
                          color: Color(0xFFF8F5FF),
                          fontSize: 11,
                          fontWeight: FontWeight.w600)),
                ],
              ),
            ),
          ],
        ),
      );
}

class _SkyOrb extends StatelessWidget {
  const _SkyOrb({required this.size, required this.color});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) => Container(
        width: size,
        height: size,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      );
}

class _FloatingWeatherIllustration extends StatefulWidget {
  const _FloatingWeatherIllustration();

  @override
  State<_FloatingWeatherIllustration> createState() =>
      _FloatingWeatherIllustrationState();
}

class _FloatingWeatherIllustrationState
    extends State<_FloatingWeatherIllustration> {
  Timer? _floatTimer;
  bool _isRaised = false;

  @override
  void initState() {
    super.initState();
    _floatTimer = Timer.periodic(const Duration(milliseconds: 2200), (_) {
      if (mounted) setState(() => _isRaised = !_isRaised);
    });
  }

  @override
  void dispose() {
    _floatTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => IgnorePointer(
        child: AnimatedSlide(
          offset: Offset(0, _isRaised ? -.026 : .026),
          duration: const Duration(milliseconds: 1100),
          curve: Curves.easeInOut,
          child: const Image(
            image: AssetImage('assets/editorial/skin-weather-hero-cute-v1.png'),
            width: 350,
            fit: BoxFit.contain,
          ),
        ),
      );
}

class _WeatherMetricGrid extends StatelessWidget {
  const _WeatherMetricGrid({required this.weather, required this.skinType});

  final SkinWeatherSnapshot weather;
  final String skinType;

  @override
  Widget build(BuildContext context) {
    final items = [
      (
        Icons.wb_sunny_outlined,
        '자외선',
        'UV ${weather.uvIndex}',
        weather.uvLevel
      ),
      (Icons.grain_rounded, '미세먼지', '${weather.pm25}㎍/㎥', weather.airQuality),
      (
        Icons.air_rounded,
        '공기질',
        'AQI ${weather.airQualityIndex}',
        weather.airQuality
      ),
      (
        Icons.face_retouching_natural_outlined,
        '피부 주의',
        'RISK ${weather.skinRiskScore}',
        skinType == '피부 타입 미등록' ? '프로필 미등록' : '$skinType 반영',
      ),
    ];
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F8FF),
        borderRadius: BorderRadius.circular(18),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final columns = constraints.maxWidth >= 700 ? 4 : 2;
          // 전역 가독성 스케일(112%)에서도 정보가 잘리지 않는 카드 높이입니다.
          const cardHeight = 98.0;
          const gap = 5.0;
          final rows = (items.length / columns).ceil();

          // GridView의 shrinkWrap 높이 계산에 의존하지 않아 카드 아래에
          // 불필요한 빈 공간이 남지 않도록 행 수를 명확하게 고정합니다.
          return SizedBox(
            height: rows * cardHeight + (rows - 1) * gap,
            child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              itemCount: items.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: columns,
                mainAxisSpacing: gap,
                crossAxisSpacing: gap,
                mainAxisExtent: cardHeight,
              ),
              itemBuilder: (context, index) {
                final item = items[index];
                return Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(13),
                    border: Border.all(color: const Color(0xFFE7E5F4)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(item.$1, color: AppColors.fuchsia, size: 16),
                      const SizedBox(height: 7),
                      Text(item.$2,
                          style: const TextStyle(
                              color: AppColors.muted,
                              fontSize: 9,
                              fontWeight: FontWeight.w700)),
                      const SizedBox(height: 1),
                      Text(item.$3,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              color: AppColors.ink,
                              fontSize: 13,
                              fontWeight: FontWeight.w800)),
                      Text(item.$4,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              color: AppColors.fuchsia,
                              fontSize: 8,
                              fontWeight: FontWeight.w700)),
                    ],
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class _WeatherAdvice extends StatelessWidget {
  const _WeatherAdvice(
      {required this.weather,
      required this.advice,
      required this.skinType,
      required this.userName});

  final SkinWeatherSnapshot weather;
  final SkinWeatherAdvice advice;
  final String skinType;
  final String userName;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.deep,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.auto_awesome_rounded,
                    color: AppColors.ballerina, size: 16),
                const SizedBox(width: 7),
                Expanded(
                  child: Text('$userName님의 $skinType 피부 × 오늘 날씨',
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w800)),
                ),
                Text('RISK ${weather.skinRiskScore}',
                    style: const TextStyle(
                        color: AppColors.ballerina,
                        fontSize: 8,
                        fontWeight: FontWeight.w800)),
              ],
            ),
            const SizedBox(height: 13),
            _AdviceBullet(
                icon: Icons.warning_amber_rounded,
                label: '주의',
                body: advice.cautions.first),
            const SizedBox(height: 9),
            _AdviceBullet(
                icon: Icons.favorite_outline_rounded,
                label: '추천',
                body: advice.recommendations.first),
            const SizedBox(height: 12),
            const Text('탭하여 전체 날씨 리포트와 맞춤 제품을 확인하세요.',
                style: TextStyle(color: Color(0xFFC9C7DD), fontSize: 9)),
          ],
        ),
      );
}

class _AdviceBullet extends StatelessWidget {
  const _AdviceBullet(
      {required this.icon, required this.label, required this.body});

  final IconData icon;
  final String label;
  final String body;

  @override
  Widget build(BuildContext context) => Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.ballerina, size: 16),
          const SizedBox(width: 8),
          SizedBox(
              width: 28,
              child: Text(label,
                  style: const TextStyle(
                      color: AppColors.ballerina,
                      fontSize: 9,
                      fontWeight: FontWeight.w800))),
          Expanded(
              child: Text(body,
                  style: const TextStyle(
                      color: Color(0xFFF0EFF9), fontSize: 10, height: 1.45))),
        ],
      );
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
                const SizedBox(height: 18),
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

  void _openLanguageNote(BuildContext context, (String, String, String) item) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.fromLTRB(24, 14, 24, 38),
        decoration: const BoxDecoration(
          color: AppColors.paper,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Container(
            width: 38,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.champagne,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(height: 26),
          Align(
            alignment: Alignment.centerLeft,
            child: Text('${item.$1} · ${item.$2}',
                style: const TextStyle(
                    color: AppColors.fuchsia,
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.1)),
          ),
          const SizedBox(height: 10),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(item.$3,
                style: Theme.of(context).textTheme.headlineMedium),
          ),
          const SizedBox(height: 12),
          const Text(
            'LEXEM은 이 정보를 피부 상태와 성분 조합, 루틴의 맥락 안에서 읽기 쉽게 정리합니다.',
            style: TextStyle(color: AppColors.muted, fontSize: 15, height: 1.6),
          ),
        ]),
      ),
    );
  }

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
                    'LEXEM CARE GUIDE',
                    style: TextStyle(
                      color: AppColors.berry,
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.4,
                    ),
                  ),
                  const SizedBox(height: 7),
                  const Text(
                    '피부 케어, 이렇게 도와드려요',
                    style: TextStyle(
                      color: AppColors.ink,
                      fontSize: 19,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -.3,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    '피부 상태부터 성분과 루틴까지, 필요한 것만 간단히 정리해요.',
                    style: TextStyle(color: AppColors.muted, fontSize: 12),
                  ),
                  const SizedBox(height: 16),
                  LayoutBuilder(builder: (context, constraints) {
                    const items = [
                      (
                        Icons.face_retouching_natural_outlined,
                        '피부 확인',
                        '내 피부 상태'
                      ),
                      (Icons.science_outlined, '성분 해석', '어려운 성분을 쉽게'),
                      (Icons.auto_awesome_outlined, '루틴 제안', '오늘의 케어 순서'),
                    ];
                    final itemWidth = constraints.maxWidth >= 680
                        ? (constraints.maxWidth - 16) / 3
                        : (constraints.maxWidth - 8) / 2;
                    return Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        for (final item in items)
                          SizedBox(
                            width: itemWidth,
                            child: Container(
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: AppColors.paper,
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(color: AppColors.line),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Icon(item.$1,
                                      size: 19, color: AppColors.fuchsia),
                                  const SizedBox(height: 12),
                                  Text(item.$2,
                                      style: const TextStyle(
                                          color: AppColors.ink,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w800)),
                                  const SizedBox(height: 3),
                                  Text(item.$3,
                                      style: const TextStyle(
                                          color: AppColors.muted,
                                          fontSize: 10,
                                          fontWeight: FontWeight.w600)),
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

class _DailyBrief extends StatefulWidget {
  const _DailyBrief();

  @override
  State<_DailyBrief> createState() => _DailyBriefState();
}

class _DailyBriefState extends State<_DailyBrief> {
  final PageController _controller = PageController(viewportFraction: .84);
  Timer? _timer;
  int _page = 0;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (!mounted || !_controller.hasClients) return;
      final next = (_page + 1) % 3;
      _controller.animateToPage(next,
          duration: const Duration(milliseconds: 440),
          curve: Curves.easeOutCubic);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const cards = [
      _BriefCard(
          color: AppColors.mint,
          icon: Icons.water_drop_rounded,
          value: '42%',
          label: '수분 방어력',
          caption: '보습 레이어 +1 권장'),
      _BriefCard(
          color: AppColors.butter,
          icon: Icons.shield_moon_rounded,
          value: 'LOW',
          label: '자극 리스크',
          caption: '액티브 성분 1개만'),
      _BriefCard(
          color: Color(0xFFE1DBFF),
          icon: Icons.nights_stay_rounded,
          value: 'PM',
          label: '집중 루틴',
          caption: '장벽 회복 · 진정'),
    ];
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 46, 20, 0),
      child: Center(
          child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1080),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const _SectionTitle(
              kicker: 'TODAY · SKIN BRIEF',
              title: '오늘의 피부 브리핑',
              subtitle: '프로필과 계절 신호를 바탕으로 우선순위를 정리했어요.'),
          const SizedBox(height: 20),
          LayoutBuilder(builder: (context, constraints) {
            final wide = constraints.maxWidth > 700;
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
                    height: 184,
                    child: Column(children: [
                      Expanded(
                        child: PageView.builder(
                          controller: _controller,
                          itemCount: cards.length,
                          padEnds: false,
                          onPageChanged: (value) =>
                              setState(() => _page = value),
                          itemBuilder: (_, index) => Padding(
                            padding: EdgeInsets.only(
                                right: index == cards.length - 1 ? 0 : 10),
                            child: cards[index],
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      PageIndicator(
                        count: cards.length,
                        selectedIndex: _page,
                        onSelected: (index) => _controller.animateToPage(
                          index,
                          duration: const Duration(milliseconds: 360),
                          curve: Curves.easeOutCubic,
                        ),
                      ),
                    ]));
          }),
        ]),
      )),
    );
  }
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
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(2),
              color: AppColors.paper,
              child: Wrap(
                spacing: 9,
                runSpacing: 9,
                children: concerns.map((value) {
                  final active = selected == value;
                  return ChoiceChip(
                      label: Text(value),
                      labelPadding: const EdgeInsets.symmetric(horizontal: 10),
                      selected: active,
                      showCheckmark: false,
                      labelStyle: TextStyle(
                          color: active ? Colors.white : AppColors.ink,
                          fontWeight: FontWeight.w800),
                      onSelected: (_) => onSelect(value));
                }).toList(),
              ),
            ),
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
