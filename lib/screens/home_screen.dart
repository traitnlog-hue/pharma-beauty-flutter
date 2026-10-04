import 'package:flutter/material.dart';

import '../catalog.dart';
import '../models.dart';
import '../theme.dart';
import '../widgets/brand_widgets.dart';
import 'routine_builder_screen.dart';
import 'skin_weather_screen.dart';

/// HOME은 정보 목록이 아니라 오늘의 선택을 시작하는 Daily Beauty Brief입니다.
class HomeScreen extends StatefulWidget {
  const HomeScreen({
    required this.skinProfile,
    required this.compareIds,
    required this.savedIds,
    required this.onToggleCompare,
    required this.onShowCompare,
    required this.onOpenProduct,
    required this.onAskPharmacist,
    required this.onEditProfile,
    required this.onDiscover,
    super.key,
  });

  final SkinProfile skinProfile;
  final Set<int> compareIds;
  final Set<int> savedIds;
  final ValueChanged<BeautyProduct> onToggleCompare;
  final VoidCallback onShowCompare;
  final ValueChanged<BeautyProduct> onOpenProduct;
  final VoidCallback onAskPharmacist;
  final Future<SkinProfile?> Function() onEditProfile;
  final VoidCallback onDiscover;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _ranking = '구매';

  List<BeautyProduct> get _ranked {
    final values = [...products];
    switch (_ranking) {
      case '관심':
        values.sort((a, b) => b.id.compareTo(a.id));
      case '나이대':
        values.sort((a, b) => b.match.compareTo(a.match));
      default:
        values.sort((a, b) => a.id.compareTo(b.id));
    }
    return values.take(3).toList();
  }

  BeautyProduct get _briefProduct => products.firstWhere(
        (product) => product.concern == widget.skinProfile.primaryConcern,
        orElse: () => products.first,
      );

  @override
  Widget build(BuildContext context) {
    final profile = widget.skinProfile;
    return Stack(
      children: [
        CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: _HomeSearchEntry(onTap: widget.onDiscover),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 18, 20, 0),
                child: _HomeCategoryRail(
                  onOpen: widget.onOpenProduct,
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 22, 20, 0),
                child: _DailyBrief(
                  profile: profile,
                  product: _briefProduct,
                  onOpenProduct: () => widget.onOpenProduct(_briefProduct),
                  onOpenWeather: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => SkinWeatherScreen(
                        profile: profile,
                        onOpenProduct: widget.onOpenProduct,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 30, 20, 0),
                child: _BestsellerShelf(onOpen: widget.onOpenProduct),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 30, 20, 0),
                child: _IngredientMemory(
                  profile: profile,
                  onEdit: widget.onEditProfile,
                  onDiscover: widget.onDiscover,
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 42, 20, 0),
                child: _SectionHeading(
                  kicker: '뷰티 랭킹',
                  title: '지금 많이 찾는 상품',
                  trailing: TextButton.icon(
                    onPressed: widget.onDiscover,
                    icon: const Icon(Icons.arrow_forward_rounded, size: 16),
                    label: const Text('랭킹 전체'),
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 14, 20, 0),
                child: _RankingPanel(
                  selected: _ranking,
                  products: _ranked,
                  onChanged: (value) => setState(() => _ranking = value),
                  onOpenProduct: widget.onOpenProduct,
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 42, 20, 0),
                child: _RoutineAndRemi(
                  profile: profile,
                  onRoutine: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const RoutineBuilderScreen(),
                    ),
                  ),
                  onAsk: widget.onAskPharmacist,
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 42, 20, 126),
                child: _RecentChoices(
                  savedIds: widget.savedIds,
                  compareIds: widget.compareIds,
                  onOpenProduct: widget.onOpenProduct,
                  onToggleCompare: widget.onToggleCompare,
                ),
              ),
            ),
          ],
        ),
        if (widget.compareIds.isNotEmpty)
          Positioned(
            left: 20,
            right: 20,
            bottom: 94,
            child: _CompareTray(
              count: widget.compareIds.length,
              onTap: widget.onShowCompare,
            ),
          ),
      ],
    );
  }
}

class _HomeSearchEntry extends StatelessWidget {
  const _HomeSearchEntry({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '오늘의 뷰티',
            style: TextStyle(
              color: AppColors.berry,
              fontSize: 9,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 7),
          Text(
            '오늘은 무엇을\n찾고 있나요?',
            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  fontSize: 27,
                  letterSpacing: -1.2,
                ),
          ),
          const SizedBox(height: 15),
          Material(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(15),
            child: InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(15),
              child: Container(
                height: 52,
                padding: const EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: AppColors.line),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.search_rounded, size: 20),
                    SizedBox(width: 11),
                    Expanded(
                      child: Text(
                        '제품, 성분, 피부 고민 검색',
                        style: TextStyle(color: AppColors.muted, fontSize: 12),
                      ),
                    ),
                    Icon(Icons.tune_rounded, color: AppColors.berry, size: 20),
                  ],
                ),
              ),
            ),
          ),
        ],
      );
}

class _HomeCategoryRail extends StatelessWidget {
  const _HomeCategoryRail({required this.onOpen});
  final ValueChanged<BeautyProduct> onOpen;

  static const _labels = ['클렌저', '세럼', '크림', '선케어', '마스크'];
  static const _icons = [
    Icons.bubble_chart_outlined,
    Icons.water_drop_outlined,
    Icons.layers_outlined,
    Icons.wb_sunny_outlined,
    Icons.face_retouching_natural_outlined,
  ];

  @override
  Widget build(BuildContext context) => SizedBox(
        height: 92,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: _labels.length,
          separatorBuilder: (_, __) => const SizedBox(width: 13),
          itemBuilder: (context, index) {
            final product = products[index == 3 ? 5 : index % products.length];
            return Semantics(
              button: true,
              label: '${_labels[index]} 제품 보기',
              child: InkWell(
                onTap: () => onOpen(product),
                borderRadius: BorderRadius.circular(99),
                child: SizedBox(
                  width: 57,
                  child: Column(
                    children: [
                      Container(
                        width: 52,
                        height: 52,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: index == 1
                              ? AppColors.blush
                              : AppColors.champagneBase,
                          border: Border.all(
                            color: index == 1
                                ? AppColors.gold
                                : AppColors.champagne,
                          ),
                        ),
                        child: Icon(
                          _icons[index],
                          color: index == 1 ? AppColors.gold : AppColors.ink,
                          size: 23,
                        ),
                      ),
                      const SizedBox(height: 7),
                      Text(
                        _labels[index],
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 9,
                          color: index == 1 ? AppColors.gold : AppColors.muted,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      );
}

class _BestsellerShelf extends StatelessWidget {
  const _BestsellerShelf({required this.onOpen});
  final ValueChanged<BeautyProduct> onOpen;

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                '이번 주 인기 상품',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900),
              ),
              const Spacer(),
              TextButton.icon(
                onPressed: () => onOpen(products.first),
                label: const Text('전체 보기'),
                icon: const Icon(Icons.arrow_forward_rounded, size: 15),
              ),
            ],
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 214,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: 3,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                final product = products[index];
                return SizedBox(
                  width: 154,
                  child: Material(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(16),
                    clipBehavior: Clip.antiAlias,
                    child: InkWell(
                      onTap: () => onOpen(product),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Stack(
                              fit: StackFit.expand,
                              children: [
                                ProductBottle(product: product, height: 128),
                                Positioned(
                                  top: 8,
                                  left: 8,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 7,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColors.champagneBase,
                                      borderRadius: BorderRadius.circular(99),
                                    ),
                                    child: const Text(
                                      '인기',
                                      style: TextStyle(
                                        color: AppColors.berry,
                                        fontSize: 7,
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(10, 9, 10, 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  product.name,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  product.formattedPrice,
                                  style: const TextStyle(
                                    color: AppColors.berry,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      );
}

class _DailyBrief extends StatelessWidget {
  const _DailyBrief({
    required this.profile,
    required this.product,
    required this.onOpenProduct,
    required this.onOpenWeather,
  });
  final SkinProfile profile;
  final BeautyProduct product;
  final VoidCallback onOpenProduct;
  final VoidCallback onOpenWeather;

  @override
  Widget build(BuildContext context) => Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.champagneBase, AppColors.blush],
          ),
          border: Border.all(color: AppColors.roseGold.withValues(alpha: .65)),
          borderRadius: BorderRadius.circular(28),
        ),
        child: Stack(
          children: [
            Positioned(
              right: -42,
              top: -78,
              child: Container(
                width: 250,
                height: 250,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.goldDeep.withValues(alpha: .22),
                ),
              ),
            ),
            Positioned(
              right: -50,
              top: 4,
              child: IgnorePointer(
                child: Image.asset(
                  'assets/editorial/because-gold-gel-orb-v1.png',
                  width: 220,
                  height: 220,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(22, 22, 22, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 7,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: AppColors.surface.withValues(alpha: .76),
                          border: Border.all(
                            color: AppColors.roseGold.withValues(alpha: .7),
                          ),
                        ),
                        child: const Text(
                          '오늘의 뷰티 브리핑',
                          style: TextStyle(
                            color: AppColors.ink,
                            fontSize: 9,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                      const Spacer(),
                      InkWell(
                        onTap: onOpenWeather,
                        borderRadius: BorderRadius.circular(14),
                        child: const Padding(
                          padding: EdgeInsets.all(6),
                          child: Row(
                            children: [
                              Icon(
                                Icons.wb_sunny_outlined,
                                color: AppColors.deep,
                                size: 17,
                              ),
                              SizedBox(width: 5),
                              Text(
                                '15°',
                                style: TextStyle(
                                  color: AppColors.ink,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 28),
                  SizedBox(
                    width: 226,
                    child: Text(
                      profile.isComplete
                          ? '${profile.profileName}의\n오늘 피부 맥락'
                          : '피부 맥락을\n만들어 보세요',
                      style:
                          Theme.of(context).textTheme.headlineLarge?.copyWith(
                                color: AppColors.ink,
                                fontSize: 28,
                                letterSpacing: -1.2,
                              ),
                    ),
                  ),
                  const SizedBox(height: 11),
                  SizedBox(
                    width: 220,
                    child: Text(
                      profile.isComplete
                          ? '낮은 습도와 자외선 지수에 맞춰 보습·보호 중심으로 정리했어요.'
                          : '피부 타입과 관심 성분을 저장하면, 탐색과 비교에서 다시 적용해요.',
                      style: const TextStyle(
                        color: AppColors.deep,
                        fontSize: 12,
                        height: 1.5,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Material(
                    color: AppColors.champagneBase,
                    borderRadius: BorderRadius.circular(16),
                    child: InkWell(
                      onTap: onOpenProduct,
                      borderRadius: BorderRadius.circular(16),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: SizedBox(
                                width: 48,
                                height: 48,
                                child:
                                    ProductBottle(product: product, height: 48),
                              ),
                            ),
                            const SizedBox(width: 11),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    '오늘의 추천',
                                    style: TextStyle(
                                      color: AppColors.berry,
                                      fontSize: 8,
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: .8,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    product.name,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Icon(
                              Icons.arrow_forward_rounded,
                              color: AppColors.berry,
                              size: 18,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
}

class _IngredientMemory extends StatelessWidget {
  const _IngredientMemory({
    required this.profile,
    required this.onEdit,
    required this.onDiscover,
  });
  final SkinProfile profile;
  final Future<SkinProfile?> Function() onEdit;
  final VoidCallback onDiscover;
  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: AppColors.line),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.bookmark_added_outlined,
                  color: AppColors.berry,
                  size: 19,
                ),
                const SizedBox(width: 9),
                const Expanded(
                  child: Text(
                    '나의 성분 기준',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                  ),
                ),
                TextButton(onPressed: onEdit, child: const Text('수정')),
              ],
            ),
            Text(
              profile.isComplete
                  ? '저장한 기준은 제품 탐색과 비교에 자동으로 적용돼요.'
                  : '피부 타입과 피하고 싶은 성분을 저장하면 다음 탐색부터 바로 쓸 수 있어요.',
              style: const TextStyle(
                color: AppColors.muted,
                fontSize: 11,
                height: 1.45,
              ),
            ),
            const SizedBox(height: 13),
            Wrap(
              spacing: 7,
              runSpacing: 7,
              children: [
                _MemoryChip(
                  label: profile.isComplete ? profile.primaryConcern : '기준 만들기',
                  filled: true,
                ),
                ...profile.isComplete
                    ? profile.recommendedIngredients
                        .split(' · ')
                        .map((item) => _MemoryChip(label: item))
                    : const [
                        _MemoryChip(label: '민감 이력'),
                        _MemoryChip(label: '관심 성분'),
                      ],
                _MemoryChip(
                  label: '탐색에 적용',
                  onTap: onDiscover,
                  icon: Icons.arrow_forward_rounded,
                ),
              ],
            ),
          ],
        ),
      );
}

class _MemoryChip extends StatelessWidget {
  const _MemoryChip({
    required this.label,
    this.filled = false,
    this.onTap,
    this.icon,
  });
  final String label;
  final bool filled;
  final VoidCallback? onTap;
  final IconData? icon;
  @override
  Widget build(BuildContext context) => Material(
        color: filled ? AppColors.berry : AppColors.paper2,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: filled ? Colors.white : AppColors.ink,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                if (icon != null) ...[
                  const SizedBox(width: 4),
                  Icon(
                    icon,
                    size: 13,
                    color: filled ? Colors.white : AppColors.berry,
                  ),
                ],
              ],
            ),
          ),
        ),
      );
}

class _SectionHeading extends StatelessWidget {
  const _SectionHeading({
    required this.kicker,
    required this.title,
    this.trailing,
  });
  final String kicker;
  final String title;
  final Widget? trailing;
  @override
  Widget build(BuildContext context) => Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  kicker,
                  style: const TextStyle(
                    color: AppColors.berry,
                    fontSize: 9,
                    letterSpacing: 1.2,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 7),
                Text(
                  title,
                  style: Theme.of(context)
                      .textTheme
                      .headlineMedium
                      ?.copyWith(fontSize: 22),
                ),
              ],
            ),
          ),
          if (trailing != null) trailing!,
        ],
      );
}

class _RankingPanel extends StatelessWidget {
  const _RankingPanel({
    required this.selected,
    required this.products,
    required this.onChanged,
    required this.onOpenProduct,
  });
  final String selected;
  final List<BeautyProduct> products;
  final ValueChanged<String> onChanged;
  final ValueChanged<BeautyProduct> onOpenProduct;
  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 6),
        decoration: BoxDecoration(
          color: AppColors.surface,
          border: Border.all(color: AppColors.line),
          borderRadius: BorderRadius.circular(22),
        ),
        child: Column(
          children: [
            Row(
              children: [
                for (final label in ['구매', '관심', '나이대'])
                  Expanded(
                    child: InkWell(
                      onTap: () => onChanged(label),
                      borderRadius: BorderRadius.circular(12),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: selected == label
                              ? AppColors.blush
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '$label 순위',
                          style: TextStyle(
                            color: selected == label
                                ? AppColors.berry
                                : AppColors.muted,
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const Divider(height: 24),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                  switch (selected) {
                    '구매' => '최근 7일 구매 완료 기준 · 데모 집계',
                    '관심' => '최근 7일 저장 행동 기준 · 데모 집계',
                    _ => '동일 연령대 관심 행동 기준 · 데모 집계',
                  },
                  style: const TextStyle(color: AppColors.muted, fontSize: 10)),
            ),
            const SizedBox(height: 8),
            ...products.asMap().entries.map(
                  (entry) => _RankRow(
                    index: entry.key + 1,
                    product: entry.value,
                    onTap: () => onOpenProduct(entry.value),
                  ),
                ),
            const SizedBox(height: 7),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '업데이트 2026.10.02 · 프로모션 포함 여부는 상세 기준에서 확인',
                style: TextStyle(color: AppColors.muted, fontSize: 9),
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      );
}

class _RankRow extends StatelessWidget {
  const _RankRow({
    required this.index,
    required this.product,
    required this.onTap,
  });
  final int index;
  final BeautyProduct product;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: [
              SizedBox(
                width: 25,
                child: Text(
                  '0$index',
                  style: const TextStyle(
                    color: AppColors.berry,
                    fontSize: 11,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: SizedBox(
                  width: 42,
                  height: 42,
                  child: ProductBottle(product: product, height: 42),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      product.brand,
                      style:
                          const TextStyle(color: AppColors.muted, fontSize: 9),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right_rounded,
                size: 18,
                color: AppColors.muted,
              ),
            ],
          ),
        ),
      );
}

class _RoutineAndRemi extends StatelessWidget {
  const _RoutineAndRemi({
    required this.profile,
    required this.onRoutine,
    required this.onAsk,
  });
  final SkinProfile profile;
  final VoidCallback onRoutine;
  final VoidCallback onAsk;
  @override
  Widget build(BuildContext context) => Column(
        children: [
          const _SectionHeading(kicker: '루틴 가이드', title: '오늘의 사용 순서'),
          const SizedBox(height: 14),
          Row(
            // This row lives in a scrolling viewport, so stretching vertically
            // would request an unbounded height. Each action card owns its height.
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _ActionCard(
                  icon: Icons.nightlight_outlined,
                  title: 'PM 루틴',
                  description: profile.isComplete
                      ? '${profile.recommendedIngredients} 중심'
                      : '기본 루틴 만들기',
                  accent: AppColors.blush,
                  onTap: onRoutine,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _ActionCard(
                  icon: Icons.auto_awesome_outlined,
                  title: '레미에게 묻기',
                  description: '제품·성분·조합 해설',
                  accent: AppColors.butter,
                  onTap: onAsk,
                ),
              ),
            ],
          ),
        ],
      );
}

class _ActionCard extends StatelessWidget {
  const _ActionCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.accent,
    required this.onTap,
  });
  final IconData icon;
  final String title;
  final String description;
  final Color accent;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => Material(
        color: accent,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: SizedBox(
            height: 134,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(icon, color: AppColors.berry, size: 20),
                  const Spacer(),
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: const TextStyle(
                      color: AppColors.muted,
                      fontSize: 10,
                      height: 1.35,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
}

class _RecentChoices extends StatelessWidget {
  const _RecentChoices({
    required this.savedIds,
    required this.compareIds,
    required this.onOpenProduct,
    required this.onToggleCompare,
  });
  final Set<int> savedIds;
  final Set<int> compareIds;
  final ValueChanged<BeautyProduct> onOpenProduct;
  final ValueChanged<BeautyProduct> onToggleCompare;
  @override
  Widget build(BuildContext context) {
    final values =
        products.where((product) => savedIds.contains(product.id)).toList();
    final shown =
        values.isEmpty ? products.take(2).toList() : values.take(2).toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionHeading(kicker: '찜한 상품', title: '다시 보고 싶은 제품'),
        const SizedBox(height: 14),
        ...shown.map(
          (product) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: _ChoiceRow(
              product: product,
              selected: compareIds.contains(product.id),
              onOpen: () => onOpenProduct(product),
              onCompare: () => onToggleCompare(product),
            ),
          ),
        ),
      ],
    );
  }
}

class _ChoiceRow extends StatelessWidget {
  const _ChoiceRow({
    required this.product,
    required this.selected,
    required this.onOpen,
    required this.onCompare,
  });
  final BeautyProduct product;
  final bool selected;
  final VoidCallback onOpen;
  final VoidCallback onCompare;
  @override
  Widget build(BuildContext context) => Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.line),
        ),
        child: Row(
          children: [
            Expanded(
              child: InkWell(
                onTap: onOpen,
                borderRadius: const BorderRadius.horizontal(
                  left: Radius.circular(18),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(11),
                        child: SizedBox(
                          width: 64,
                          height: 64,
                          child: ProductBottle(product: product, height: 64),
                        ),
                      ),
                      const SizedBox(width: 11),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              '${product.ingredients.take(2).join(' · ')} · ${product.formattedPrice}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: AppColors.muted,
                                fontSize: 9,
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
            IconButton(
              onPressed: onCompare,
              tooltip: '비교에 담기',
              icon: Icon(
                selected
                    ? Icons.compare_arrows_rounded
                    : Icons.add_chart_rounded,
                color: AppColors.berry,
              ),
            ),
          ],
        ),
      );
}

class _CompareTray extends StatelessWidget {
  const _CompareTray({required this.count, required this.onTap});
  final int count;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => Material(
        color: AppColors.deep,
        borderRadius: BorderRadius.circular(20),
        elevation: 10,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
            child: Row(
              children: [
                Container(
                  width: 30,
                  height: 30,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    color: AppColors.lime,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    '$count',
                    style: const TextStyle(
                      color: AppColors.deep,
                      fontSize: 11,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                const Expanded(
                  child: Text(
                    '선택한 제품의 차이를 비교해 보세요',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                const Icon(
                  Icons.arrow_forward_rounded,
                  color: AppColors.lime,
                  size: 19,
                ),
              ],
            ),
          ),
        ),
      );
}
