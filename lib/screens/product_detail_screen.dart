import 'package:flutter/material.dart';

import '../models.dart';
import '../theme.dart';
import '../widgets/brand_widgets.dart';

class ProductDetailScreen extends StatefulWidget {
  const ProductDetailScreen(
      {required this.product,
      required this.onCompare,
      required this.initiallySaved,
      required this.onToggleSaved,
      super.key});

  final BeautyProduct product;
  final VoidCallback onCompare;
  final bool initiallySaved;
  final VoidCallback onToggleSaved;

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  late bool saved = widget.initiallySaved;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.product.brand,
            style: const TextStyle(
                fontSize: 10, fontWeight: FontWeight.w800, letterSpacing: 1.3)),
        actions: [
          IconButton(
              onPressed: () {
                setState(() => saved = !saved);
                widget.onToggleSaved();
              },
              icon: Icon(saved ? Icons.bookmark : Icons.bookmark_border))
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final wide = constraints.maxWidth >= 760;
                final visual = ProductBottle(
                    product: widget.product, height: wide ? 540 : 410);
                final info = _ProductInfo(
                    product: widget.product, onCompare: widget.onCompare);
                return wide
                    ? Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                            Expanded(child: visual),
                            Expanded(child: info)
                          ])
                    : Column(children: [visual, info]);
              },
            ),
          ),
          SliverToBoxAdapter(child: _WhyProduct(product: widget.product)),
          SliverToBoxAdapter(
              child: _IngredientSection(product: widget.product)),
          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Container(
          padding: const EdgeInsets.fromLTRB(18, 10, 18, 10),
          decoration: const BoxDecoration(
              color: AppColors.paper,
              border: Border(top: BorderSide(color: AppColors.line))),
          child: FilledButton(
            onPressed: () => ScaffoldMessenger.of(context)
                .showSnackBar(const SnackBar(content: Text('장바구니에 담았어요.'))),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('${widget.product.formattedPrice} · 장바구니 담기'),
                  const Icon(Icons.add, size: 18)
                ]),
          ),
        ),
      ),
    );
  }
}

class _ProductInfo extends StatelessWidget {
  const _ProductInfo({required this.product, required this.onCompare});
  final BeautyProduct product;
  final VoidCallback onCompare;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MatchPill(product.match),
          const SizedBox(height: 28),
          Text(product.brand,
              style: const TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.2)),
          const SizedBox(height: 8),
          Text(product.name, style: Theme.of(context).textTheme.headlineLarge),
          const SizedBox(height: 12),
          Text(product.note,
              style: const TextStyle(color: AppColors.muted, height: 1.65)),
          const SizedBox(height: 25),
          Text(product.formattedPrice,
              style:
                  const TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
          const SizedBox(height: 28),
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 18, vertical: 16)),
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
              const SectionLabel('01', 'WHY THIS PRODUCT?', light: true),
              const SizedBox(height: 20),
              Text('좋은 제품보다,\n나에게 맞는 제품.',
                  style: Theme.of(context)
                      .textTheme
                      .displayMedium
                      ?.copyWith(color: Colors.white)),
              const SizedBox(height: 25),
              ...const [
                ('건조 피부에 적합', '보습 지속력이 높은 장벽 지질 배합', 'HIGH'),
                ('피부 장벽 관리 목적', '장벽 구성 성분을 닮은 3:1:1 포뮬러', 'HIGH'),
                ('무향 제품 선호', '향료와 에센셜 오일을 넣지 않은 처방', 'FIT'),
              ].map((reason) => Container(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    decoration: const BoxDecoration(
                        border: Border(
                            bottom: BorderSide(color: Color(0x33FFFFFF)))),
                    child: Row(
                      children: [
                        Expanded(
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                              Text(reason.$1,
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700)),
                              const SizedBox(height: 6),
                              Text(reason.$2,
                                  style: const TextStyle(
                                      color: Color(0xFF93A9A2), fontSize: 11)),
                            ])),
                        Text(reason.$3,
                            style: const TextStyle(
                                color: AppColors.lime,
                                fontSize: 9,
                                fontWeight: FontWeight.w900)),
                      ],
                    ),
                  )),
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
              const SectionLabel('02', 'KEY INGREDIENTS'),
              const SizedBox(height: 18),
              Text('핵심 성분을\n쉬운 언어로.',
                  style: Theme.of(context).textTheme.displayMedium),
              const SizedBox(height: 28),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: product.ingredients
                    .map((value) => Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 10),
                          decoration: BoxDecoration(
                              color: AppColors.mint,
                              border: Border.all(color: AppColors.line)),
                          child: Text(value,
                              style: const TextStyle(
                                  fontSize: 11, fontWeight: FontWeight.w700)),
                        ))
                    .toList(),
              ),
              const SizedBox(height: 24),
              Text('TEXTURE · ${product.texture}',
                  style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      letterSpacing: .8)),
            ],
          ),
        ),
      ),
    );
  }
}
