import 'package:flutter/material.dart';

import '../catalog.dart';
import '../models.dart';
import '../theme.dart';
import '../widgets/brand_widgets.dart';

enum ShopFilterGroup { concern, category, ingredient, brand }

class ShopScreen extends StatefulWidget {
  const ShopScreen({
    required this.compareIds,
    required this.savedIds,
    required this.onCompare,
    required this.onSave,
    required this.onOpenProduct,
    super.key,
  });

  final Set<int> compareIds;
  final Set<int> savedIds;
  final ValueChanged<BeautyProduct> onCompare;
  final ValueChanged<BeautyProduct> onSave;
  final ValueChanged<BeautyProduct> onOpenProduct;

  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  ShopFilterGroup group = ShopFilterGroup.concern;
  String filter = '전체';
  bool sortByPrice = false;

  List<String> get options => switch (group) {
        ShopFilterGroup.concern => concerns,
        ShopFilterGroup.category =>
          products.map((item) => item.category).toSet().toList(),
        ShopFilterGroup.ingredient =>
          ingredients.map((item) => item.name).toList(),
        ShopFilterGroup.brand =>
          products.map((item) => item.brand).toSet().toList(),
      };

  List<BeautyProduct> get visible {
    final result = products.where((item) {
      if (filter == '전체') return true;
      return switch (group) {
        ShopFilterGroup.concern => item.concern == filter,
        ShopFilterGroup.category => item.category == filter,
        ShopFilterGroup.ingredient => item.ingredients.contains(filter),
        ShopFilterGroup.brand => item.brand == filter,
      };
    }).toList();
    result.sort(sortByPrice
        ? (first, second) => first.price.compareTo(second.price)
        : (first, second) => second.match.compareTo(first.match));
    return result;
  }

  String filterLabel(String value) {
    if (group != ShopFilterGroup.concern) return value;
    return switch (value) {
      '피부 장벽' => '장벽',
      '민감·진정' => '진정',
      _ => value,
    };
  }

  IconData categoryIcon(String value) => switch (value) {
        '전체' => Icons.auto_awesome_rounded,
        '세럼' => Icons.water_drop_outlined,
        '크림' => Icons.layers_outlined,
        '에센스' => Icons.spa_outlined,
        '토너' => Icons.opacity_outlined,
        '앰플' => Icons.science_outlined,
        _ => Icons.face_retouching_natural_outlined,
      };

  void _selectCategory(String value) {
    setState(() {
      group = ShopFilterGroup.category;
      filter = value;
    });
  }

  void _openFilterSheet() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        var sheetGroup = group;
        var sheetFilter = filter;
        return StatefulBuilder(builder: (context, updateSheet) {
          final sheetOptions = switch (sheetGroup) {
            ShopFilterGroup.concern => concerns,
            ShopFilterGroup.category =>
              products.map((item) => item.category).toSet().toList(),
            ShopFilterGroup.ingredient =>
              ingredients.map((item) => item.name).toList(),
            ShopFilterGroup.brand =>
              products.map((item) => item.brand).toSet().toList(),
          };
          String groupName(ShopFilterGroup value) => switch (value) {
                ShopFilterGroup.concern => '피부 고민',
                ShopFilterGroup.category => '제품 타입',
                ShopFilterGroup.ingredient => '핵심 성분',
                ShopFilterGroup.brand => '브랜드',
              };
          return SafeArea(
            child: Container(
              margin: const EdgeInsets.fromLTRB(12, 0, 12, 12),
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 18),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(26),
                boxShadow: [
                  BoxShadow(
                      color: AppColors.ink.withValues(alpha: .14),
                      blurRadius: 28,
                      offset: const Offset(0, 10)),
                ],
              ),
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                Row(children: [
                  const Expanded(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                        Text('상품 필터',
                            style: TextStyle(
                                fontSize: 19, fontWeight: FontWeight.w800)),
                        SizedBox(height: 3),
                        Text('원하는 기준을 한 번에 선택하세요.',
                            style: TextStyle(
                                color: AppColors.muted, fontSize: 11)),
                      ])),
                  TextButton(
                    onPressed: () => updateSheet(() {
                      sheetGroup = ShopFilterGroup.concern;
                      sheetFilter = '전체';
                    }),
                    child: const Text('초기화',
                        style: TextStyle(
                            fontSize: 11, fontWeight: FontWeight.w800)),
                  ),
                  IconButton(
                      tooltip: '닫기',
                      onPressed: () => Navigator.pop(sheetContext),
                      icon: const Icon(Icons.close_rounded)),
                ]),
                const SizedBox(height: 18),
                const _FilterSheetLabel(index: '01', label: '탐색 기준'),
                const SizedBox(height: 9),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Wrap(
                    spacing: 7,
                    runSpacing: 7,
                    children: ShopFilterGroup.values
                        .map((value) => ChoiceChip(
                              label: Text(groupName(value)),
                              selected: sheetGroup == value,
                              onSelected: (_) => updateSheet(() {
                                sheetGroup = value;
                                sheetFilter = '전체';
                              }),
                            ))
                        .toList(),
                  ),
                ),
                const SizedBox(height: 18),
                _FilterSheetLabel(
                    index: '02', label: '${groupName(sheetGroup)} 선택'),
                const SizedBox(height: 9),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Wrap(
                    spacing: 7,
                    runSpacing: 7,
                    children: ['전체', ...sheetOptions]
                        .map((value) => ChoiceChip(
                              label: Text(sheetGroup == ShopFilterGroup.concern
                                  ? switch (value) {
                                      '피부 장벽' => '장벽',
                                      '민감·진정' => '진정',
                                      _ => value
                                    }
                                  : value),
                              selected: sheetFilter == value,
                              onSelected: (_) =>
                                  updateSheet(() => sheetFilter = value),
                            ))
                        .toList(),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () {
                      setState(() {
                        group = sheetGroup;
                        filter = sheetFilter;
                      });
                      Navigator.pop(sheetContext);
                    },
                    style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14)),
                    child: const Text('선택한 조건으로 보기',
                        style: TextStyle(fontWeight: FontWeight.w800)),
                  ),
                ),
              ]),
            ),
          );
        });
      },
    );
  }

  Widget _shopCategoryRail() => Container(
        color: AppColors.surface,
        child: Column(children: [
          SizedBox(
            height: 124,
            child: Row(children: [
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.only(left: 14, right: 4),
                  child: Row(
                    children: [
                      '전체',
                      ...products.map((item) => item.category).toSet(),
                    ]
                        .map((value) => _ShopCategoryTab(
                              label: value,
                              icon: categoryIcon(value),
                              selected: filter == value &&
                                  (group == ShopFilterGroup.category ||
                                      value == '전체'),
                              onTap: () => _selectCategory(value),
                            ))
                        .toList(),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 14),
                child: Material(
                  color: AppColors.surface,
                  elevation: 5,
                  shadowColor: AppColors.ink.withValues(alpha: .15),
                  shape: const CircleBorder(),
                  child: IconButton(
                    tooltip: '필터',
                    onPressed: _openFilterSheet,
                    icon: const Icon(Icons.tune_rounded, size: 22),
                  ),
                ),
              ),
            ]),
          ),
          Container(height: 1, color: AppColors.line),
        ]),
      );

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(slivers: [
      SliverToBoxAdapter(child: _shopCategoryRail()),
      SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
          child: _ShopCareRibbon(
            onTap: () => setState(() {
              group = ShopFilterGroup.concern;
              filter = '피부 장벽';
            }),
          ),
        ),
      ),
      SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
          child: _CurrentIngredientFeature(
            onTap: () => setState(() {
              group = ShopFilterGroup.ingredient;
              filter = '레티날';
            }),
          ),
        ),
      ),
      SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(18, 20, 18, 12),
          child: Row(children: [
            Text('${visible.length} PRODUCTS',
                style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    letterSpacing: .8)),
            const Spacer(),
            TextButton.icon(
              onPressed: () => setState(() => sortByPrice = !sortByPrice),
              icon: const Icon(Icons.swap_vert_rounded, size: 17),
              label: Text(sortByPrice ? '낮은 가격순' : '추천순',
                  style: const TextStyle(
                      fontSize: 11, fontWeight: FontWeight.w800)),
            ),
            const SizedBox(width: 4),
            FilledButton.tonalIcon(
              onPressed: _openFilterSheet,
              icon: const Icon(Icons.tune_rounded, size: 16),
              label: const Text('필터',
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800)),
              style: FilledButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 9)),
            ),
          ]),
        ),
      ),
      SliverPadding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 130),
        sliver: SliverLayoutBuilder(builder: (context, constraints) {
          final columns = constraints.crossAxisExtent > 900
              ? 3
              : constraints.crossAxisExtent > 560
                  ? 2
                  : 2;
          return SliverGrid(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: columns,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                mainAxisExtent: columns == 3 ? 350 : 286),
            delegate: SliverChildBuilderDelegate((context, index) {
              final product = visible[index];
              return _CompactProductCard(
                product: product,
                saved: widget.savedIds.contains(product.id),
                onOpen: () => widget.onOpenProduct(product),
                onSave: () => widget.onSave(product),
              );
            }, childCount: visible.length),
          );
        }),
      ),
    ]);
  }
}

class _ShopCareRibbon extends StatelessWidget {
  const _ShopCareRibbon({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Material(
        color: AppColors.ballerina.withValues(alpha: .32),
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 13),
            child: Row(children: [
              Icon(Icons.auto_awesome_rounded,
                  color: AppColors.berry, size: 18),
              SizedBox(width: 9),
              Expanded(
                child: Text('피부 장벽을 위한 추천',
                    style: TextStyle(
                        color: AppColors.berry,
                        fontSize: 13,
                        fontWeight: FontWeight.w800)),
              ),
              Icon(Icons.chevron_right_rounded, color: AppColors.berry),
            ]),
          ),
        ),
      );
}

class _FilterSheetLabel extends StatelessWidget {
  const _FilterSheetLabel({required this.index, required this.label});

  final String index;
  final String label;

  @override
  Widget build(BuildContext context) => Row(children: [
        Text(index,
            style: const TextStyle(
                color: AppColors.berry,
                fontSize: 10,
                fontWeight: FontWeight.w900,
                letterSpacing: 1)),
        const SizedBox(width: 7),
        Text(label,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800)),
      ]);
}

class _CurrentIngredientFeature extends StatelessWidget {
  const _CurrentIngredientFeature({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Material(
        borderRadius: BorderRadius.circular(22),
        clipBehavior: Clip.antiAlias,
        color: const Color(0xFFF0EBFF),
        child: InkWell(
          onTap: onTap,
          child: SizedBox(
            height: 184,
            child: Stack(children: [
              Positioned(
                right: -32,
                top: -18,
                child: Opacity(
                  opacity: .94,
                  child: Image.asset(
                      'assets/editorial/ingredient-orb-retinal-v1.png',
                      width: 235,
                      height: 235,
                      fit: BoxFit.contain),
                ),
              ),
              const Positioned(
                left: 18,
                top: 20,
                right: 120,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('CURRENT INGREDIENT',
                          style: TextStyle(
                              color: AppColors.violet,
                              fontSize: 9,
                              fontWeight: FontWeight.w800,
                              letterSpacing: .9)),
                      SizedBox(height: 8),
                      Text('레티날',
                          style: TextStyle(
                              color: AppColors.berry,
                              fontSize: 30,
                              fontWeight: FontWeight.w700,
                              letterSpacing: -1.1)),
                      SizedBox(height: 6),
                      Text('결 케어부터 탄력까지\n저녁 루틴의 집중 성분',
                          style: TextStyle(
                              color: AppColors.muted,
                              fontSize: 11,
                              height: 1.45)),
                    ]),
              ),
              const Positioned(
                  left: 18,
                  bottom: 16,
                  child: CircleAvatar(
                      radius: 18,
                      backgroundColor: AppColors.berry,
                      child: Icon(Icons.arrow_forward_rounded,
                          color: Colors.white, size: 18))),
            ]),
          ),
        ),
      );
}

class _CompactProductCard extends StatelessWidget {
  const _CompactProductCard({
    required this.product,
    required this.saved,
    required this.onOpen,
    required this.onSave,
  });
  final BeautyProduct product;
  final bool saved;
  final VoidCallback onOpen;
  final VoidCallback onSave;

  @override
  Widget build(BuildContext context) => Material(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onOpen,
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Expanded(
              child: Stack(fit: StackFit.expand, children: [
                ProductBottle(product: product, alignment: Alignment.topCenter),
                Positioned(
                  left: 9,
                  bottom: 8,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                    decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: .84),
                        borderRadius: BorderRadius.circular(99)),
                    child: Text(product.ingredients.first.toUpperCase(),
                        style: const TextStyle(
                            color: AppColors.berry,
                            fontSize: 8,
                            fontWeight: FontWeight.w800)),
                  ),
                ),
                Positioned(
                  right: 3,
                  top: 3,
                  child: IconButton(
                      onPressed: onSave,
                      icon: Icon(
                          saved
                              ? Icons.favorite_rounded
                              : Icons.favorite_border_rounded,
                          color: saved ? AppColors.berry : AppColors.ink,
                          size: 19)),
                ),
              ]),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(product.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontSize: 11, fontWeight: FontWeight.w800)),
                    const SizedBox(height: 4),
                    Text(product.formattedPrice,
                        style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                            color: AppColors.berry)),
                  ]),
            ),
          ]),
        ),
      );
}

class _ShopCategoryTab extends StatelessWidget {
  const _ShopCategoryTab({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final tint = selected ? AppColors.berry : AppColors.ink;
    return Semantics(
      button: true,
      selected: selected,
      label: '$label 제품 보기',
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: SizedBox(
          width: 74,
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Container(
              width: 42,
              height: 42,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: selected ? AppColors.berry.withValues(alpha: .09) : null,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: tint, size: 23),
            ),
            const SizedBox(height: 5),
            Text(label,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    color: tint, fontSize: 10, fontWeight: FontWeight.w700)),
            const SizedBox(height: 7),
            AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              width: selected ? 36 : 28,
              height: 3,
              decoration: BoxDecoration(
                color: selected ? AppColors.berry : AppColors.line,
                borderRadius: BorderRadius.circular(99),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
