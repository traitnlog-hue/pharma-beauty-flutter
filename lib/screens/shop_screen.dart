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

  List<String> get options => switch (group) {
        ShopFilterGroup.concern => concerns,
        ShopFilterGroup.category =>
          products.map((item) => item.category).toSet().toList(),
        ShopFilterGroup.ingredient =>
          ingredients.map((item) => item.name).toList(),
        ShopFilterGroup.brand =>
          products.map((item) => item.brand).toSet().toList(),
      };

  List<BeautyProduct> get visible => products.where((item) {
        if (filter == '전체') return true;
        return switch (group) {
          ShopFilterGroup.concern => item.concern == filter,
          ShopFilterGroup.category => item.category == filter,
          ShopFilterGroup.ingredient => item.ingredients.contains(filter),
          ShopFilterGroup.brand => item.brand == filter,
        };
      }).toList();

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
      builder: (sheetContext) => SafeArea(
        child: Container(
          margin: const EdgeInsets.fromLTRB(14, 0, 14, 14),
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 22),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppRadii.feature),
          ),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Row(children: [
              const Text('상품 필터',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800)),
              const Spacer(),
              IconButton(
                  tooltip: '닫기',
                  onPressed: () => Navigator.pop(sheetContext),
                  icon: const Icon(Icons.close_rounded)),
            ]),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: ShopFilterGroup.values
                  .map((value) => ChoiceChip(
                        label: Text(switch (value) {
                          ShopFilterGroup.concern => '피부 고민',
                          ShopFilterGroup.category => '제품 타입',
                          ShopFilterGroup.ingredient => '성분',
                          ShopFilterGroup.brand => '브랜드',
                        }),
                        selected: group == value,
                        onSelected: (_) => setState(() {
                          group = value;
                          filter = '전체';
                        }),
                      ))
                  .toList(),
            ),
            const SizedBox(height: 14),
            Align(
              alignment: Alignment.centerLeft,
              child: Wrap(
                spacing: 7,
                runSpacing: 7,
                children: ['전체', ...options]
                    .map((value) => ChoiceChip(
                          label: Text(filterLabel(value)),
                          selected: filter == value,
                          onSelected: (_) => setState(() => filter = value),
                        ))
                    .toList(),
              ),
            ),
          ]),
        ),
      ),
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
                              selected: group == ShopFilterGroup.category &&
                                  filter == value,
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
      SliverPadding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 130),
        sliver: SliverLayoutBuilder(builder: (context, constraints) {
          final columns = constraints.crossAxisExtent > 900
              ? 3
              : constraints.crossAxisExtent > 560
                  ? 2
                  : 2;
          final imageHeight = columns == 3 ? 230.0 : 178.0;
          return SliverGrid(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: columns,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                mainAxisExtent: columns == 3 ? 430 : 344),
            delegate: SliverChildBuilderDelegate((context, index) {
              final product = visible[index];
              final saved = widget.savedIds.contains(product.id);
              final compared = widget.compareIds.contains(product.id);
              return Container(
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(AppRadii.card),
                  border: Border.all(color: AppColors.line),
                ),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Stack(children: [
                        InkWell(
                            onTap: () => widget.onOpenProduct(product),
                            child: ProductBottle(
                                product: product,
                                height: imageHeight,
                                alignment: Alignment.topCenter)),
                        Positioned(
                            right: 8,
                            top: 8,
                            child: IconButton(
                                onPressed: () => widget.onSave(product),
                                icon: Icon(
                                    saved
                                        ? Icons.bookmark
                                        : Icons.bookmark_border,
                                    size: 18))),
                      ]),
                      Expanded(
                          child: Padding(
                        padding: const EdgeInsets.fromLTRB(12, 11, 12, 10),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(children: [
                                MatchPill(product.match),
                                const Spacer(),
                                Text(product.category,
                                    style: const TextStyle(
                                        fontSize: 9,
                                        fontWeight: FontWeight.w800))
                              ]),
                              const SizedBox(height: 8),
                              Text(product.brand,
                                  style: const TextStyle(
                                      fontSize: 7,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: .8)),
                              const SizedBox(height: 3),
                              Text(product.name,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700)),
                              const SizedBox(height: 4),
                              Text(product.ingredients.take(2).join(' · '),
                                  style: const TextStyle(
                                      color: AppColors.muted, fontSize: 8)),
                              const Spacer(),
                              Row(children: [
                                IconButton(
                                    visualDensity: VisualDensity.compact,
                                    onPressed: () => widget.onCompare(product),
                                    tooltip: compared ? '비교 해제' : '비교 담기',
                                    icon: Icon(
                                        compared
                                            ? Icons.check_rounded
                                            : Icons.compare_arrows_rounded,
                                        size: 16)),
                                const Spacer(),
                                IconButton(
                                    visualDensity: VisualDensity.compact,
                                    onPressed: () =>
                                        widget.onOpenProduct(product),
                                    tooltip: '상세 보기',
                                    icon: const Icon(
                                        Icons.arrow_outward_rounded,
                                        size: 17)),
                              ]),
                            ]),
                      )),
                    ]),
              );
            }, childCount: visible.length),
          );
        }),
      ),
    ]);
  }
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
