import 'package:flutter/material.dart';

import '../catalog.dart';
import '../models.dart';
import '../theme.dart';
import 'routine_builder_screen.dart';

class DiscoverScreen extends StatefulWidget {
  const DiscoverScreen({super.key});

  @override
  State<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen> {
  String query = '';
  String category = 'ALL';

  static const trend =
      <String, ({int score, int delta, String signal, Color color})>{
    '세라마이드': (
      score: 96,
      delta: 18,
      signal: 'BARRIER BOOM',
      color: AppColors.cyan
    ),
    '판테놀': (
      score: 91,
      delta: 24,
      signal: 'SOOTHING CORE',
      color: AppColors.lime
    ),
    '레티날': (
      score: 89,
      delta: 31,
      signal: 'NIGHT ACTIVE',
      color: AppColors.violet
    ),
    '비타민 C': (
      score: 84,
      delta: 12,
      signal: 'GLOW RESET',
      color: AppColors.butter
    ),
    'BHA': (score: 78, delta: 9, signal: 'PORE CYCLE', color: AppColors.coral),
    '나이아신아마이드': (
      score: 86,
      delta: 15,
      signal: 'MULTI TASKER',
      color: Color(0xFFA8B7FF)
    ),
  };

  List<String> get categories =>
      ['ALL', ...ingredients.map((item) => item.category).toSet()];

  List<IngredientInfo> get filtered => ingredients.where((item) {
        final normalized = query.toLowerCase();
        final matchesQuery = item.name.contains(query) ||
            item.englishName.toLowerCase().contains(normalized) ||
            item.benefits.any((value) => value.contains(query));
        return matchesQuery && (category == 'ALL' || item.category == category);
      }).toList();

  void showIngredient(IngredientInfo ingredient) {
    final meta = trend[ingredient.name]!;
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: .8,
        maxChildSize: .94,
        builder: (context, controller) => Container(
          decoration: const BoxDecoration(
              color: AppColors.paper,
              borderRadius: BorderRadius.vertical(top: Radius.circular(32))),
          child: ListView(
            controller: controller,
            padding: const EdgeInsets.fromLTRB(22, 12, 22, 44),
            children: [
              Center(
                  child: Container(
                      width: 42,
                      height: 5,
                      decoration: BoxDecoration(
                          color: AppColors.ink.withValues(alpha: .25),
                          borderRadius: BorderRadius.circular(10)))),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: meta.color,
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: [
                    BoxShadow(
                        color: meta.color.withValues(alpha: .35),
                        blurRadius: 34,
                        offset: const Offset(0, 16))
                  ],
                ),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(children: [
                        _LivePill(label: meta.signal, dark: true),
                        const Spacer(),
                        Text('${meta.score}',
                            style: const TextStyle(
                                fontSize: 42,
                                fontWeight: FontWeight.w900,
                                letterSpacing: -2)),
                        const Text('/100',
                            style: TextStyle(
                                fontSize: 10, fontWeight: FontWeight.w800)),
                      ]),
                      const SizedBox(height: 38),
                      Text(ingredient.englishName,
                          style: const TextStyle(
                              fontSize: 36,
                              height: .95,
                              fontWeight: FontWeight.w900,
                              letterSpacing: -2)),
                      const SizedBox(height: 7),
                      Text(ingredient.name,
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w800)),
                    ]),
              ),
              const SizedBox(height: 26),
              Text(ingredient.summary,
                  style: const TextStyle(
                      fontSize: 15, height: 1.65, fontWeight: FontWeight.w600)),
              const SizedBox(height: 24),
              Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: ingredient.benefits
                      .map((value) => Chip(label: Text(value)))
                      .toList()),
              const SizedBox(height: 30),
              _RelationCard(
                title: 'POWER PAIR',
                subtitle: '함께 쓰면 시너지가 좋아요',
                values: ingredient.goodWith,
                icon: Icons.add_rounded,
                color: AppColors.mint,
              ),
              const SizedBox(height: 12),
              _RelationCard(
                title: 'ROUTINE ALERT',
                subtitle: '같은 루틴에서는 체크하세요',
                values: ingredient.cautionWith.isEmpty
                    ? const ['현재 알려진 주요 충돌 조합이 적어요']
                    : ingredient.cautionWith,
                icon: Icons.bolt_rounded,
                color: const Color(0xFFFFE3DC),
              ),
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const RoutineBuilderScreen()));
                },
                icon: const Icon(Icons.auto_awesome_rounded, size: 18),
                label: const Text('내 루틴에 넣어 궁합 확인'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(slivers: [
      SliverToBoxAdapter(
          child:
              _TrendHero(onSearch: (value) => setState(() => query = value))),
      SliverToBoxAdapter(
          child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 54, 20, 20),
        child: Center(
            child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1080),
          child: const _ModernSectionHeader(
              eyebrow: '01 · LIVE SIGNAL',
              title: '지금 뜨는 성분',
              subtitle: '검색량·저장·루틴 등록 데이터를 조합한 이번 주 트렌드'),
        )),
      )),
      SliverToBoxAdapter(
          child: SizedBox(
        height: 278,
        child: ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          scrollDirection: Axis.horizontal,
          itemCount: 3,
          separatorBuilder: (_, __) => const SizedBox(width: 12),
          itemBuilder: (context, index) {
            final ingredient = ingredients[index];
            return _TrendCard(
                rank: index + 1,
                ingredient: ingredient,
                meta: trend[ingredient.name]!,
                onTap: () => showIngredient(ingredient));
          },
        ),
      )),
      SliverToBoxAdapter(
          child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 64, 20, 18),
        child: Center(
            child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1080),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const _ModernSectionHeader(
                eyebrow: '02 · INGREDIENT RADAR',
                title: '내 피부를 위한 성분 신호',
                subtitle: '효능, 상승세, 궁합까지 한 번에 탐색하세요.'),
            const SizedBox(height: 22),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                  children: categories.map((value) {
                final selected = category == value;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(value),
                    showCheckmark: false,
                    selected: selected,
                    labelStyle: TextStyle(
                        color: selected ? Colors.white : AppColors.ink,
                        fontWeight: FontWeight.w800),
                    onSelected: (_) => setState(() => category = value),
                  ),
                );
              }).toList()),
            ),
          ]),
        )),
      )),
      SliverPadding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 72),
        sliver: SliverLayoutBuilder(builder: (context, constraints) {
          final columns = constraints.crossAxisExtent > 900
              ? 3
              : constraints.crossAxisExtent > 560
                  ? 2
                  : 1;
          return SliverGrid(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: columns,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                mainAxisExtent: 218),
            delegate: SliverChildBuilderDelegate((context, index) {
              final ingredient = filtered[index];
              final meta = trend[ingredient.name]!;
              return _SignalCard(
                  ingredient: ingredient,
                  meta: meta,
                  onTap: () => showIngredient(ingredient));
            }, childCount: filtered.length),
          );
        }),
      ),
      SliverToBoxAdapter(
          child: _RoutineForecast(
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const RoutineBuilderScreen())))),
      const SliverToBoxAdapter(child: _TrendReports()),
      const SliverToBoxAdapter(child: SizedBox(height: 120)),
    ]);
  }
}

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
              colors: [Color(0xFF7657FF), Color(0xFF5137D9), Color(0xFF0E3934)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight),
          boxShadow: const [
            BoxShadow(
                color: Color(0x337657FF), blurRadius: 36, offset: Offset(0, 16))
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
                        color: AppColors.cyan.withValues(alpha: .18)))),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Row(children: [
                _LivePill(label: 'LIVE · WEEK 32'),
                Spacer(),
                Icon(Icons.graphic_eq_rounded, color: AppColors.lime)
              ]),
              const SizedBox(height: 32),
              Text('INGREDIENT\nPULSE',
                  style: Theme.of(context)
                      .textTheme
                      .displayMedium
                      ?.copyWith(color: Colors.white, letterSpacing: -3)),
              const SizedBox(height: 12),
              const Text('성분 백과보다 빠르게. 지금 반응하는 성분과\n내 루틴의 다음 신호를 발견하세요.',
                  style: TextStyle(
                      color: Color(0xFFDDE9E6),
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
