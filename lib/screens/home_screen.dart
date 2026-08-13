import 'package:flutter/material.dart';

import '../catalog.dart';
import '../models.dart';
import '../theme.dart';
import '../widgets/brand_widgets.dart';
import 'profile_screen.dart';
import 'routine_builder_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    required this.compareIds,
    required this.onToggleCompare,
    required this.onShowCompare,
    required this.onOpenProduct,
    required this.onAskPharmacist,
    required this.onDiscover,
    super.key,
  });

  final Set<int> compareIds;
  final ValueChanged<BeautyProduct> onToggleCompare;
  final VoidCallback onShowCompare;
  final ValueChanged<BeautyProduct> onOpenProduct;
  final VoidCallback onAskPharmacist;
  final VoidCallback onDiscover;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String selectedConcern = concerns.first;

  List<BeautyProduct> get matches {
    final result = [...products];
    result.sort((a, b) {
      if (a.concern == selectedConcern) return -1;
      if (b.concern == selectedConcern) return 1;
      return b.match.compareTo(a.match);
    });
    return result;
  }

  Future<void> openProfile() async {
    final result = await Navigator.push<String>(
        context, MaterialPageRoute(builder: (_) => const SkinProfileScreen()));
    if (result != null) setState(() => selectedConcern = result);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      CustomScrollView(slivers: [
        SliverToBoxAdapter(child: _Hero(onProfile: openProfile)),
        const SliverToBoxAdapter(child: _DailyBrief()),
        SliverToBoxAdapter(
            child: _AskPharmacist(onOpen: widget.onAskPharmacist)),
        SliverToBoxAdapter(
            child: _ConcernPulse(
                selected: selectedConcern,
                onSelect: (value) => setState(() => selectedConcern = value))),
        SliverToBoxAdapter(
            child: _MatchPicks(
                products: matches.take(4).toList(),
                compareIds: widget.compareIds,
                onOpen: widget.onOpenProduct,
                onCompare: widget.onToggleCompare)),
        SliverToBoxAdapter(child: _IngredientPulse(onOpen: widget.onDiscover)),
        SliverToBoxAdapter(
            child: _RoutinePreview(
                onOpen: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const RoutineBuilderScreen())))),
        const SliverToBoxAdapter(child: SizedBox(height: 125)),
      ]),
      if (widget.compareIds.isNotEmpty)
        Positioned(
          left: 20,
          right: 20,
          bottom: 160,
          child: Material(
            color: AppColors.deep,
            borderRadius: BorderRadius.circular(22),
            elevation: 12,
            shadowColor: AppColors.deep.withValues(alpha: .28),
            child: InkWell(
              borderRadius: BorderRadius.circular(22),
              onTap: widget.onShowCompare,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                child: Row(children: [
                  Container(
                      width: 34,
                      height: 34,
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(
                          color: AppColors.lime, shape: BoxShape.circle),
                      child: Text('${widget.compareIds.length}',
                          style: const TextStyle(fontWeight: FontWeight.w900))),
                  const SizedBox(width: 12),
                  const Expanded(
                      child: Text('비교할 제품이 준비됐어요',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w800))),
                  const Icon(Icons.arrow_forward_rounded,
                      color: Colors.white, size: 19),
                ]),
              ),
            ),
          ),
        ),
    ]);
  }
}

class _AskPharmacist extends StatelessWidget {
  const _AskPharmacist({required this.onOpen});
  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(14, 18, 14, 0),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1080),
            child: Material(
              color: AppColors.mint,
              borderRadius: BorderRadius.circular(30),
              clipBehavior: Clip.antiAlias,
              child: InkWell(
                onTap: onOpen,
                child: SizedBox(
                  height: 220,
                  child: Row(children: [
                    Expanded(
                      flex: 6,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(24, 24, 8, 22),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Row(children: [
                              CircleAvatar(
                                  radius: 4,
                                  backgroundColor: Color(0xFF42B883)),
                              SizedBox(width: 7),
                              Text('PHARMACIST · ONLINE',
                                  style: TextStyle(
                                      fontSize: 9,
                                      fontWeight: FontWeight.w900,
                                      letterSpacing: .8)),
                            ]),
                            const Spacer(),
                            Text('성분이 헷갈리면\n리아 약사에게 물어보세요.',
                                style:
                                    Theme.of(context).textTheme.headlineMedium),
                            const SizedBox(height: 12),
                            const Row(children: [
                              Text('1:1 성분 상담 시작',
                                  style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w900)),
                              SizedBox(width: 5),
                              Icon(Icons.arrow_forward_rounded, size: 16),
                            ]),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 4,
                      child: SizedBox.expand(
                        child: Image.asset(
                          'assets/characters/pharmacist-lia.png',
                          fit: BoxFit.cover,
                          alignment: const Alignment(.1, -.1),
                        ),
                      ),
                    ),
                  ]),
                ),
              ),
            ),
          ),
        ),
      );
}

class _Hero extends StatelessWidget {
  const _Hero({required this.onProfile});
  final VoidCallback onProfile;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(14, 4, 14, 0),
        child: LayoutBuilder(builder: (context, constraints) {
          final wide = constraints.maxWidth > 860;
          final copy = Padding(
            padding: EdgeInsets.all(wide ? 42 : 24),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const _StatusPill(
                      icon: Icons.auto_awesome_rounded,
                      label: 'YOUR SKIN · LIVE'),
                  const SizedBox(height: 28),
                  Text('피부가 보내는\n신호부터 읽어요.',
                      style: (wide
                              ? Theme.of(context).textTheme.displayLarge
                              : Theme.of(context).textTheme.displayMedium)
                          ?.copyWith(color: Colors.white)),
                  const SizedBox(height: 18),
                  const Text(
                      '제품을 더 사기 전에, 지금 내 피부가 원하는 성분과\n피해야 할 조합을 먼저 확인하세요.',
                      style: TextStyle(
                          color: Color(0xFFC9D8D4),
                          fontSize: 13,
                          height: 1.6,
                          fontWeight: FontWeight.w600)),
                  const SizedBox(height: 28),
                  FilledButton.icon(
                      style: FilledButton.styleFrom(
                          backgroundColor: AppColors.lime,
                          foregroundColor: AppColors.ink),
                      onPressed: onProfile,
                      icon: const Icon(Icons.face_retouching_natural_rounded,
                          size: 18),
                      label: const Text('3분 피부 스캔 시작')),
                ]),
          );
          final visual = Container(
            constraints: BoxConstraints(minHeight: wide ? 560 : 400),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                  colors: [AppColors.violet, Color(0xFF442BCB), AppColors.cyan],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight),
              borderRadius: wide
                  ? const BorderRadius.horizontal(right: Radius.circular(34))
                  : const BorderRadius.vertical(bottom: Radius.circular(34)),
            ),
            child: Stack(alignment: Alignment.center, children: [
              Positioned(
                  right: -70,
                  top: -80,
                  child: Container(
                      width: 260,
                      height: 260,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withValues(alpha: .13)))),
              Positioned(
                  left: -50,
                  bottom: -60,
                  child: Container(
                      width: 210,
                      height: 210,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.lime.withValues(alpha: .22)))),
              ProductBottle(product: products.first, height: wide ? 440 : 350),
              Positioned(
                  left: 18,
                  top: 18,
                  child: _MetricBubble(
                      value: '94', suffix: '%', label: 'SKIN MATCH')),
              Positioned(
                  right: 18,
                  bottom: 18,
                  child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 11),
                      decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: .9),
                          borderRadius: BorderRadius.circular(18)),
                      child: const Row(children: [
                        Icon(Icons.bolt_rounded,
                            color: AppColors.violet, size: 17),
                        SizedBox(width: 7),
                        Text('장벽 회복 신호 ↑',
                            style: TextStyle(
                                fontSize: 10, fontWeight: FontWeight.w900))
                      ]))),
            ]),
          );
          final darkCopy = Container(color: AppColors.deep, child: copy);
          return ClipRRect(
            borderRadius: BorderRadius.circular(34),
            child: wide
                ? SizedBox(
                    height: 610,
                    child: Row(children: [
                      Expanded(flex: 11, child: darkCopy),
                      Expanded(flex: 9, child: visual)
                    ]))
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [darkCopy, visual]),
          );
        }),
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
      required this.compareIds,
      required this.onOpen,
      required this.onCompare});
  final List<BeautyProduct> products;
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
                        Text('MATCH PICKS',
                            style: Theme.of(context).textTheme.headlineMedium),
                        const Spacer(),
                        Text('${products.length} PICKS',
                            style: const TextStyle(
                                color: AppColors.violet,
                                fontSize: 10,
                                fontWeight: FontWeight.w900))
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
                    borderRadius: BorderRadius.circular(28),
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
                                      borderRadius: BorderRadius.circular(30)),
                                  child: Text('${product.match}% MATCH',
                                      style: const TextStyle(
                                          fontSize: 9,
                                          fontWeight: FontWeight.w900)))),
                          Positioned(
                              right: 10,
                              top: 10,
                              child: IconButton.filledTonal(
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
                                              fontWeight: FontWeight.w900,
                                              letterSpacing: .8)),
                                      const SizedBox(height: 7),
                                      Text(product.name,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                              fontSize: 17,
                                              fontWeight: FontWeight.w900)),
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
                                                fontWeight: FontWeight.w900)),
                                        const Spacer(),
                                        const CircleAvatar(
                                            radius: 16,
                                            backgroundColor: AppColors.ink,
                                            child: Icon(
                                                Icons.arrow_outward_rounded,
                                                color: Colors.white,
                                                size: 16))
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
            borderRadius: BorderRadius.circular(32)),
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
                      borderRadius: BorderRadius.circular(22)),
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
                                fontSize: 10, fontWeight: FontWeight.w900))),
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
                fontWeight: FontWeight.w900,
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
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: Colors.white.withValues(alpha: .15))),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Icon(icon, color: AppColors.lime, size: 15),
          const SizedBox(width: 7),
          Text(label,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 9,
                  fontWeight: FontWeight.w900,
                  letterSpacing: .8))
        ]),
      );
}

class _MetricBubble extends StatelessWidget {
  const _MetricBubble(
      {required this.value, required this.suffix, required this.label});
  final String value;
  final String suffix;
  final String label;
  @override
  Widget build(BuildContext context) => Container(
        width: 92,
        height: 92,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: .9), shape: BoxShape.circle),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          RichText(
              text: TextSpan(
                  style: const TextStyle(color: AppColors.ink),
                  children: [
                TextSpan(
                    text: value,
                    style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w900,
                        letterSpacing: -1.5)),
                TextSpan(
                    text: suffix,
                    style: const TextStyle(
                        fontSize: 10, fontWeight: FontWeight.w900))
              ])),
          const SizedBox(height: 3),
          Text(label,
              style: const TextStyle(fontSize: 7, fontWeight: FontWeight.w900))
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
            color: color, borderRadius: BorderRadius.circular(24)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Icon(icon, size: 20),
          const Spacer(),
          Text(value,
              style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -1.5)),
          Text(label,
              style:
                  const TextStyle(fontSize: 11, fontWeight: FontWeight.w900)),
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
            color: color, borderRadius: BorderRadius.circular(20)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(value,
              style:
                  const TextStyle(fontSize: 28, fontWeight: FontWeight.w900)),
          const SizedBox(height: 3),
          Text(label,
              style: const TextStyle(
                  fontSize: 8, fontWeight: FontWeight.w900, letterSpacing: .7))
        ]),
      );
}
