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

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(slivers: [
      SliverToBoxAdapter(
          child: Container(
        margin: const EdgeInsets.fromLTRB(14, 4, 14, 34),
        padding: const EdgeInsets.fromLTRB(22, 34, 22, 28),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
              colors: [AppColors.pearl, AppColors.paper2, AppColors.blush],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight),
          borderRadius: BorderRadius.circular(32),
          border: Border.all(color: Colors.white, width: .8),
        ),
        child: Center(
            child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1040),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('THE BEAUTY CABINET · CURATED BY DATA',
                style: TextStyle(
                    color: AppColors.berry,
                    fontSize: 10,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.1)),
            const SizedBox(height: 18),
            Text('예쁜 것보다,\n잘 맞는 것이\n나만의 취향.',
                style: Theme.of(context).textTheme.headlineLarge),
            const SizedBox(height: 24),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SegmentedButton<ShopFilterGroup>(
                segments: const [
                  ButtonSegment(
                      value: ShopFilterGroup.concern, label: Text('피부 고민')),
                  ButtonSegment(
                      value: ShopFilterGroup.category, label: Text('카테고리')),
                  ButtonSegment(
                      value: ShopFilterGroup.ingredient, label: Text('성분')),
                  ButtonSegment(
                      value: ShopFilterGroup.brand, label: Text('브랜드')),
                ],
                selected: {group},
                onSelectionChanged: (value) => setState(() {
                  group = value.first;
                  filter = '전체';
                }),
                style: const ButtonStyle(visualDensity: VisualDensity.compact),
              ),
            ),
            const SizedBox(height: 17),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                  children: ['전체', ...options]
                      .map((value) => Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: Material(
                              color: filter == value
                                  ? AppColors.berry
                                  : AppColors.surface,
                              borderRadius: BorderRadius.circular(30),
                              child: InkWell(
                                borderRadius: BorderRadius.circular(30),
                                onTap: () => setState(() => filter = value),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15, vertical: 10),
                                  child: Text(filterLabel(value),
                                      style: TextStyle(
                                          color: filter == value
                                              ? Colors.white
                                              : AppColors.ink,
                                          fontSize: 11,
                                          fontWeight: FontWeight.w800)),
                                ),
                              ),
                            ),
                          ))
                      .toList()),
            ),
            const SizedBox(height: 18),
            Text('${visible.length} PRODUCTS',
                style: const TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.1)),
          ]),
        )),
      )),
      SliverPadding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 130),
        sliver: SliverLayoutBuilder(builder: (context, constraints) {
          final columns = constraints.crossAxisExtent > 900
              ? 3
              : constraints.crossAxisExtent > 560
                  ? 2
                  : 1;
          final imageHeight = columns == 1 ? 320.0 : 230.0;
          return SliverGrid(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: columns,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                mainAxisExtent: columns == 1 ? 520 : 430),
            delegate: SliverChildBuilderDelegate((context, index) {
              final product = visible[index];
              final saved = widget.savedIds.contains(product.id);
              final compared = widget.compareIds.contains(product.id);
              return Container(
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(
                      color: AppColors.roseGold.withValues(alpha: .38)),
                  boxShadow: const [
                    BoxShadow(
                        color: Color(0x183A1425),
                        blurRadius: 22,
                        offset: Offset(0, 10))
                  ],
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
                            child: IconButton.filledTonal(
                                onPressed: () => widget.onSave(product),
                                icon: Icon(
                                    saved
                                        ? Icons.bookmark
                                        : Icons.bookmark_border,
                                    size: 18))),
                      ]),
                      Expanded(
                          child: Padding(
                        padding: const EdgeInsets.all(16),
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
                              const SizedBox(height: 12),
                              Text(product.brand,
                                  style: const TextStyle(
                                      fontSize: 8,
                                      fontWeight: FontWeight.w900,
                                      letterSpacing: .8)),
                              const SizedBox(height: 5),
                              Text(product.name,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w800)),
                              const SizedBox(height: 6),
                              Text(product.ingredients.take(2).join(' · '),
                                  style: const TextStyle(
                                      color: AppColors.muted, fontSize: 10)),
                              const Spacer(),
                              Row(children: [
                                Expanded(
                                    child: TextButton.icon(
                                        onPressed: () =>
                                            widget.onCompare(product),
                                        icon: Icon(
                                            compared
                                                ? Icons.check
                                                : Icons.compare_arrows,
                                            size: 16),
                                        label:
                                            Text(compared ? '비교 담김' : '비교'))),
                                Expanded(
                                    child: FilledButton(
                                        onPressed: () =>
                                            widget.onOpenProduct(product),
                                        child: const Text('상세 보기'))),
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
