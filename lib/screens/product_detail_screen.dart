import 'package:flutter/material.dart';

import '../models.dart';
import '../theme.dart';
import '../widgets/brand_widgets.dart';

class ProductDetailScreen extends StatefulWidget {
  const ProductDetailScreen({
    required this.product,
    required this.onCompare,
    required this.initiallySaved,
    required this.onToggleSaved,
    required this.onAddToCart,
    required this.onBuyNow,
    super.key,
  });

  final BeautyProduct product;
  final VoidCallback onCompare;
  final bool initiallySaved;
  final VoidCallback onToggleSaved;
  final VoidCallback onAddToCart;
  final VoidCallback onBuyNow;

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  late bool saved = widget.initiallySaved;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          '상품 상세',
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w800,
            letterSpacing: .7,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              setState(() => saved = !saved);
              widget.onToggleSaved();
            },
            icon: Icon(saved ? Icons.favorite : Icons.favorite_border),
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final wide = constraints.maxWidth >= 760;
                final visual = _ProductGallery(
                  product: widget.product,
                  height: wide ? 540 : 370,
                );
                final info = _ProductInfo(
                  product: widget.product,
                  onCompare: widget.onCompare,
                );
                return wide
                    ? Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(child: visual),
                          Expanded(child: info),
                        ],
                      )
                    : Column(children: [visual, info]);
              },
            ),
          ),
          SliverToBoxAdapter(child: _WhyProduct(product: widget.product)),
          SliverToBoxAdapter(
            child: _IngredientSection(product: widget.product),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Container(
          padding: const EdgeInsets.fromLTRB(16, 9, 16, 9),
          decoration: const BoxDecoration(
            color: AppColors.paper,
            border: Border(top: BorderSide(color: AppColors.line)),
          ),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: widget.onAddToCart,
                  icon: const Icon(Icons.shopping_bag_outlined, size: 18),
                  label: const Text('담기'),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: FilledButton(
                  onPressed: widget.onBuyNow,
                  child: Text('구매하기 · ${widget.product.formattedPrice}'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProductGallery extends StatelessWidget {
  const _ProductGallery({required this.product, required this.height});
  final BeautyProduct product;
  final double height;

  @override
  Widget build(BuildContext context) => Container(
        height: height,
        color: AppColors.champagneBase,
        child: Stack(
          children: [
            Positioned.fill(
              child: ProductBottle(
                product: product,
                height: height,
                alignment: Alignment.center,
              ),
            ),
            Positioned(
              left: 14,
              top: 14,
              child: Column(
                children: List.generate(
                  3,
                  (index) => Container(
                    width: 42,
                    height: 42,
                    margin: const EdgeInsets.only(bottom: 8),
                    decoration: BoxDecoration(
                      color:
                          index == 0 ? AppColors.surface : AppColors.champagne,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: index == 0 ? AppColors.gold : Colors.transparent,
                      ),
                    ),
                    child: index == 0
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(9),
                            child: ProductBottle(product: product, height: 42),
                          )
                        : Icon(
                            index == 1
                                ? Icons.water_drop_outlined
                                : Icons.auto_awesome_outlined,
                            size: 17,
                            color: AppColors.berry,
                          ),
                  ),
                ),
              ),
            ),
            const Positioned(
              bottom: 14,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _GalleryDot(selected: true),
                  _GalleryDot(),
                  _GalleryDot(),
                ],
              ),
            ),
          ],
        ),
      );
}

class _GalleryDot extends StatelessWidget {
  const _GalleryDot({this.selected = false});
  final bool selected;

  @override
  Widget build(BuildContext context) => Container(
        width: selected ? 15 : 5,
        height: 5,
        margin: const EdgeInsets.symmetric(horizontal: 3),
        decoration: BoxDecoration(
          color: selected ? AppColors.gold : AppColors.roseGold,
          borderRadius: BorderRadius.circular(99),
        ),
      );
}

class _ProductInfo extends StatelessWidget {
  const _ProductInfo({required this.product, required this.onCompare});
  final BeautyProduct product;
  final VoidCallback onCompare;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            product.brand,
            style: const TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 7),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  product.name,
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                        fontSize: 26,
                      ),
                ),
              ),
              const SizedBox(width: 14),
              Text(
                product.formattedPrice,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Row(
            children: [
              Icon(Icons.star_rounded, color: AppColors.sunset, size: 16),
              SizedBox(width: 4),
              Text('4.8',
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800)),
              SizedBox(width: 5),
              Text('(1.2K reviews)',
                  style: TextStyle(color: AppColors.muted, fontSize: 10)),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            product.note,
            style: const TextStyle(color: AppColors.muted, height: 1.65),
          ),
          const SizedBox(height: 20),
          Wrap(
            spacing: 7,
            runSpacing: 7,
            children: product.ingredients
                .take(3)
                .map((ingredient) => Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 7),
                      decoration: BoxDecoration(
                        color: AppColors.blush,
                        borderRadius: BorderRadius.circular(99),
                      ),
                      child: Text(
                        ingredient,
                        style: const TextStyle(
                            color: AppColors.berry,
                            fontSize: 10,
                            fontWeight: FontWeight.w800),
                      ),
                    ))
                .toList(),
          ),
          const SizedBox(height: 20),
          OutlinedButton.icon(
            onPressed: () {
              onCompare();
              ScaffoldMessenger.of(context)
                  .showSnackBar(const SnackBar(content: Text('비교함에 추가했어요.')));
            },
            icon: const Icon(Icons.compare_arrows, size: 17),
            label: const Text('다른 제품과 비교하기'),
            style: OutlinedButton.styleFrom(
              shape: const RoundedRectangleBorder(),
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
            ),
          ),
        ],
      ),
    );
  }
}

class _WhyProduct extends StatelessWidget {
  const _WhyProduct({required this.product});
  final BeautyProduct product;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.deep,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 76),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 920),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SectionLabel('01', '추천 기준', light: true),
              const SizedBox(height: 20),
              Text(
                '점수보다,\n선택의 이유를.',
                style: Theme.of(context)
                    .textTheme
                    .displayMedium
                    ?.copyWith(color: Colors.white),
              ),
              const SizedBox(height: 25),
              ...const [
                ('내 피부 기준', '저장한 피부 고민과 핵심 성분을 함께 확인해요.', '보기'),
                ('리뷰 정보', '비슷한 피부 고민의 후기는 상세 탭에서 확인해요.', '보기'),
                ('핵심 성분', '성분 역할과 함께 쓰는 조합을 확인해요.', '보기'),
                ('구매 정보', '가격·용량·배송 조건을 함께 확인해요.', '보기'),
              ].map(
                (reason) => Container(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Color(0x33FFFFFF)),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              reason.$1,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              reason.$2,
                              style: const TextStyle(
                                color: Color(0xFF93A9A2),
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        reason.$3,
                        style: const TextStyle(
                          color: AppColors.lime,
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _IngredientSection extends StatelessWidget {
  const _IngredientSection({required this.product});
  final BeautyProduct product;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 72),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 920),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SectionLabel('02', '전성분 · 핵심 성분'),
              const SizedBox(height: 18),
              Text(
                '성분을 단정하지 않고\n맥락으로 읽어요.',
                style: Theme.of(context).textTheme.displayMedium,
              ),
              const SizedBox(height: 28),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: product.ingredients
                    .map(
                      (value) => Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.mint,
                          border: Border.all(color: AppColors.line),
                        ),
                        child: Text(
                          value,
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
              const SizedBox(height: 24),
              Text(
                '제형 · ${product.texture}',
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  letterSpacing: .8,
                ),
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.butter,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Row(
                  children: [
                    Icon(
                      Icons.update_rounded,
                      size: 18,
                      color: AppColors.berry,
                    ),
                    SizedBox(width: 9),
                    Expanded(
                      child: Text(
                        '성분 정보는 일반적인 배합 목적을 설명합니다. 제품의 전체 처방과 데이터 기준일을 함께 확인해 주세요.',
                        style: TextStyle(
                          color: AppColors.berry,
                          fontSize: 10,
                          height: 1.45,
                        ),
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
  }
}
