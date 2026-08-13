import 'package:flutter/material.dart';

import '../models.dart';
import '../theme.dart';
import '../widgets/brand_widgets.dart';

class CompareScreen extends StatelessWidget {
  const CompareScreen(
      {required this.products, required this.onRemove, super.key});

  final List<BeautyProduct> products;
  final ValueChanged<BeautyProduct> onRemove;

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) {
      return const _EmptyCompare();
    }

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 36, 24, 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SectionLabel('03', 'SMART COMPARE'),
                const SizedBox(height: 17),
                Text('무엇이 더 좋은지보다,\n누구에게 더 맞는지.',
                    style: Theme.of(context).textTheme.headlineLarge),
                const SizedBox(height: 10),
                const Text('최대 3개 제품의 가격, 성분, 사용감과 적합도를 비교해요.',
                    style: TextStyle(color: AppColors.muted, fontSize: 12)),
              ],
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: products
                  .map((product) => _CompareColumn(
                      product: product, onRemove: () => onRemove(product)))
                  .toList(),
            ),
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 110)),
      ],
    );
  }
}

class _CompareColumn extends StatelessWidget {
  const _CompareColumn({required this.product, required this.onRemove});
  final BeautyProduct product;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(border: Border.all(color: AppColors.line)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(children: [
            ProductBottle(product: product, height: 220),
            Positioned(
                right: 8,
                top: 8,
                child: IconButton.filledTonal(
                    onPressed: onRemove,
                    icon: const Icon(Icons.close, size: 17))),
          ]),
          Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MatchPill(product.match),
                const SizedBox(height: 18),
                Text(product.brand,
                    style: const TextStyle(
                        fontSize: 8,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1)),
                const SizedBox(height: 6),
                Text(product.name,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w800)),
                const SizedBox(height: 20),
                _CompareValue(label: '가격', value: product.formattedPrice),
                _CompareValue(label: '피부 고민', value: product.concern),
                _CompareValue(label: '사용감', value: product.texture),
                _CompareValue(
                    label: '핵심 성분',
                    value: product.ingredients.take(2).join(' · ')),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CompareValue extends StatelessWidget {
  const _CompareValue({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: const BoxDecoration(
            border: Border(top: BorderSide(color: AppColors.line))),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(label,
              style: const TextStyle(color: AppColors.muted, fontSize: 9)),
          const SizedBox(height: 5),
          Text(value,
              style:
                  const TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
        ]),
      );
}

class _EmptyCompare extends StatelessWidget {
  const _EmptyCompare();

  @override
  Widget build(BuildContext context) => Center(
        child: Padding(
          padding: const EdgeInsets.all(40),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Container(
              width: 80,
              height: 80,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.line)),
              child: const Icon(Icons.compare_arrows, color: AppColors.ink),
            ),
            const SizedBox(height: 24),
            Text('비교할 제품을 담아주세요.',
                style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 10),
            const Text('상품 카드의 비교 버튼으로 최대 3개까지 담을 수 있어요.',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.muted, fontSize: 12)),
          ]),
        ),
      );
}
