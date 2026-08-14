import 'package:flutter/material.dart';

import '../catalog.dart';
import '../models.dart';
import '../theme.dart';
import 'routine_builder_screen.dart';

part 'discover_sections.dart';

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
                color: AppColors.blush,
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
