part of 'discover_screen.dart';

class _TrendHero extends StatelessWidget {
  const _TrendHero({required this.onSearch});
  final ValueChanged<String> onSearch;

  @override
  Widget build(BuildContext context) => Container(
        margin: const EdgeInsets.fromLTRB(14, 4, 14, 0),
        padding: const EdgeInsets.fromLTRB(22, 32, 22, 26),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(32),
          gradient: const LinearGradient(
              colors: [AppColors.berry, AppColors.fuchsia, Color(0xFFB95A7D)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight),
          border: Border.all(color: AppColors.champagne, width: .8),
          boxShadow: const [
            BoxShadow(
                color: Color(0x33DF0AA4), blurRadius: 36, offset: Offset(0, 16))
          ],
        ),
        child: Center(
            child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1040),
          child: Stack(children: [
            Positioned(
                right: -34,
                top: -44,
                child: Container(
                    width: 190,
                    height: 190,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.ballerina.withValues(alpha: .2)))),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Row(children: [
                _LivePill(label: 'LIVE · WEEK 32'),
                Spacer(),
                Icon(Icons.graphic_eq_rounded, color: AppColors.champagne)
              ]),
              const SizedBox(height: 32),
              Text('THE GLOW\nINGREDIENT EDIT',
                  style: Theme.of(context)
                      .textTheme
                      .displayMedium
                      ?.copyWith(color: Colors.white, letterSpacing: -3)),
              const SizedBox(height: 12),
              const Text('백과사전처럼 쌓아두지 않고, 지금 주목받는 성분과\n나에게 필요한 다음 루틴을 에디트해드려요.',
                  style: TextStyle(
                      color: Color(0xFFF9E5ED),
                      height: 1.55,
                      fontWeight: FontWeight.w600)),
              const SizedBox(height: 26),
              TextField(
                onChanged: onSearch,
                decoration: InputDecoration(
                  hintText: '성분, 효능, 피부 고민 검색',
                  prefixIcon: const Icon(Icons.search_rounded),
                  suffixIcon: const Icon(Icons.tune_rounded),
                  fillColor: Colors.white.withValues(alpha: .94),
                ),
              ),
            ]),
          ]),
        )),
      );
}

class _ModernSectionHeader extends StatelessWidget {
  const _ModernSectionHeader(
      {required this.eyebrow, required this.title, required this.subtitle});
  final String eyebrow;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) =>
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(eyebrow,
            style: const TextStyle(
                color: AppColors.violet,
                fontSize: 10,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.2)),
        const SizedBox(height: 10),
        Text(title, style: Theme.of(context).textTheme.headlineLarge),
        const SizedBox(height: 8),
        Text(subtitle,
            style: const TextStyle(
                color: AppColors.muted, fontSize: 12, height: 1.5)),
      ]);
}

class _TrendCard extends StatelessWidget {
  const _TrendCard(
      {required this.rank,
      required this.ingredient,
      required this.meta,
      required this.onTap});
  final int rank;
  final IngredientInfo ingredient;
  final ({int score, int delta, String signal, Color color}) meta;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => SizedBox(
        width: 250,
        child: Material(
          color: meta.color,
          borderRadius: BorderRadius.circular(28),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(children: [
                      Text('#0$rank',
                          style: const TextStyle(
                              fontSize: 12, fontWeight: FontWeight.w900)),
                      const Spacer(),
                      _DeltaPill(value: meta.delta)
                    ]),
                    const Spacer(),
                    Text(meta.signal,
                        style: const TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1)),
                    const SizedBox(height: 7),
                    Text(ingredient.englishName,
                        style: const TextStyle(
                            fontSize: 26,
                            height: .95,
                            fontWeight: FontWeight.w900,
                            letterSpacing: -1.4)),
                    const SizedBox(height: 5),
                    Text(ingredient.name,
                        style: const TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w800)),
                    const SizedBox(height: 16),
                    _ScoreBar(value: meta.score / 100),
                    const SizedBox(height: 8),
                    Row(children: [
                      Text('PULSE ${meta.score}',
                          style: const TextStyle(
                              fontSize: 9, fontWeight: FontWeight.w900)),
                      const Spacer(),
                      const Icon(Icons.arrow_outward_rounded, size: 18)
                    ]),
                  ]),
            ),
          ),
        ),
      );
}

class _SignalCard extends StatelessWidget {
  const _SignalCard(
      {required this.ingredient, required this.meta, required this.onTap});
  final IngredientInfo ingredient;
  final ({int score, int delta, String signal, Color color}) meta;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Material(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                        color: meta.color, shape: BoxShape.circle)),
                const SizedBox(width: 8),
                Text(meta.signal,
                    style: const TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.w900,
                        letterSpacing: .7)),
                const Spacer(),
                _DeltaPill(value: meta.delta)
              ]),
              const Spacer(),
              Text(ingredient.englishName,
                  style: const TextStyle(
                      fontSize: 24,
                      height: 1,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -1.2)),
              const SizedBox(height: 5),
              Text(ingredient.name,
                  style: const TextStyle(
                      fontSize: 13, fontWeight: FontWeight.w800)),
              const SizedBox(height: 14),
              Text(ingredient.benefits.join(' · '),
                  style: const TextStyle(color: AppColors.muted, fontSize: 10)),
              const SizedBox(height: 15),
              Row(children: [
                Expanded(child: _ScoreBar(value: meta.score / 100)),
                const SizedBox(width: 12),
                Text('${meta.score}',
                    style: const TextStyle(
                        fontSize: 13, fontWeight: FontWeight.w900))
              ]),
            ]),
          ),
        ),
      );
}

class _ScoreBar extends StatelessWidget {
  const _ScoreBar({required this.value});
  final double value;
  @override
  Widget build(BuildContext context) => ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: value),
          duration: const Duration(milliseconds: 700),
          curve: Curves.easeOutCubic,
          builder: (context, progress, _) => LinearProgressIndicator(
              value: progress,
              minHeight: 6,
              color: AppColors.ink,
              backgroundColor: AppColors.ink.withValues(alpha: .12)),
        ),
      );
}

class _DeltaPill extends StatelessWidget {
  const _DeltaPill({required this.value});
  final int value;
  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
        decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: .72),
            borderRadius: BorderRadius.circular(30)),
        child: Text('↗ $value%',
            style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w900)),
      );
}

class _LivePill extends StatelessWidget {
  const _LivePill({required this.label, this.dark = false});
  final String label;
  final bool dark;
  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 7),
        decoration: BoxDecoration(
            color: dark
                ? AppColors.ink.withValues(alpha: .16)
                : Colors.white.withValues(alpha: .14),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: Colors.white.withValues(alpha: .22))),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Container(
              width: 6,
              height: 6,
              decoration: const BoxDecoration(
                  color: AppColors.lime, shape: BoxShape.circle)),
          const SizedBox(width: 7),
          Text(label,
              style: TextStyle(
                  color: dark ? AppColors.ink : Colors.white,
                  fontSize: 9,
                  fontWeight: FontWeight.w900,
                  letterSpacing: .8))
        ]),
      );
}

class _RelationCard extends StatelessWidget {
  const _RelationCard(
      {required this.title,
      required this.subtitle,
      required this.values,
      required this.icon,
      required this.color});
  final String title;
  final String subtitle;
  final List<String> values;
  final IconData icon;
  final Color color;
  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
            color: color, borderRadius: BorderRadius.circular(22)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Container(
                width: 36,
                height: 36,
                decoration: const BoxDecoration(
                    color: AppColors.ink, shape: BoxShape.circle),
                child: Icon(icon, color: Colors.white, size: 18)),
            const SizedBox(width: 12),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(title,
                  style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w900,
                      letterSpacing: .8)),
              Text(subtitle,
                  style: const TextStyle(color: AppColors.muted, fontSize: 10))
            ])
          ]),
          const SizedBox(height: 16),
          Wrap(
              spacing: 7,
              runSpacing: 7,
              children: values
                  .map((value) =>
                      Chip(label: Text(value), side: BorderSide.none))
                  .toList()),
        ]),
      );
}

class _RoutineForecast extends StatelessWidget {
  const _RoutineForecast({required this.onTap});
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => Container(
        margin: const EdgeInsets.symmetric(horizontal: 14),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
            color: AppColors.deep, borderRadius: BorderRadius.circular(32)),
        child: Center(
            child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1000),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const _LivePill(label: 'AI ROUTINE FORECAST'),
            const SizedBox(height: 28),
            Text('내 루틴의 다음\n충돌을 미리 감지해요.',
                style: Theme.of(context)
                    .textTheme
                    .headlineLarge
                    ?.copyWith(color: Colors.white)),
            const SizedBox(height: 12),
            const Text('성분을 담는 순간 조합을 분석하고 아침·저녁 사용 타이밍을 제안합니다.',
                style: TextStyle(color: Color(0xFFB8C9C5), height: 1.6)),
            const SizedBox(height: 24),
            Row(children: [
              Expanded(
                  child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: .08),
                          borderRadius: BorderRadius.circular(20)),
                      child: const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('SAFE PAIRS',
                                style: TextStyle(
                                    color: AppColors.cyan,
                                    fontSize: 9,
                                    fontWeight: FontWeight.w900)),
                            SizedBox(height: 7),
                            Text('03',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 28,
                                    fontWeight: FontWeight.w900))
                          ]))),
              const SizedBox(width: 10),
              Expanded(
                  child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                          color: AppColors.coral.withValues(alpha: .16),
                          borderRadius: BorderRadius.circular(20)),
                      child: const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('CHECK NEEDED',
                                style: TextStyle(
                                    color: AppColors.coral,
                                    fontSize: 9,
                                    fontWeight: FontWeight.w900)),
                            SizedBox(height: 7),
                            Text('01',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 28,
                                    fontWeight: FontWeight.w900))
                          ]))),
            ]),
            const SizedBox(height: 22),
            FilledButton.icon(
                style: FilledButton.styleFrom(
                    backgroundColor: AppColors.lime,
                    foregroundColor: AppColors.ink),
                onPressed: onTap,
                icon: const Icon(Icons.auto_awesome_rounded, size: 18),
                label: const Text('내 루틴 스캔하기')),
          ]),
        )),
      );
}

class _TrendReports extends StatelessWidget {
  const _TrendReports();
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 68, 20, 0),
        child: Center(
            child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1080),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const _ModernSectionHeader(
                eyebrow: '03 · EDITORIAL SIGNAL',
                title: '이번 주 성분 리포트',
                subtitle: '짧게 읽고 바로 루틴에 적용하는 에디터 큐레이션'),
            const SizedBox(height: 22),
            ...const [
              (
                '01',
                '장벽 성분의 세대교체',
                '세라마이드 단독보다 지질 조합과 전달 시스템이 선택 기준이 되고 있어요.',
                AppColors.cyan
              ),
              (
                '02',
                '저자극 레티노이드 루틴',
                '강도 경쟁보다 빈도와 완충 조합을 설계하는 스킨 사이클링이 다시 주목받아요.',
                AppColors.violet
              ),
              (
                '03',
                '멀티 액티브의 피로감',
                '효능을 쌓기보다 루틴을 단순화하고 충돌을 줄이는 스킨 미니멀리즘이 상승 중이에요.',
                AppColors.butter
              ),
            ].map((item) => Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(22)),
                  child: Row(children: [
                    Container(
                        width: 46,
                        height: 46,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: item.$4,
                            borderRadius: BorderRadius.circular(15)),
                        child: Text(item.$1,
                            style:
                                const TextStyle(fontWeight: FontWeight.w900))),
                    const SizedBox(width: 14),
                    Expanded(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                          Text(item.$2,
                              style: const TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.w900)),
                          const SizedBox(height: 5),
                          Text(item.$3,
                              style: const TextStyle(
                                  color: AppColors.muted,
                                  fontSize: 11,
                                  height: 1.5))
                        ])),
                    const Icon(Icons.arrow_forward_rounded, size: 18)
                  ]),
                )),
          ]),
        )),
      );
}
