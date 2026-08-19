import 'package:flutter/material.dart';

import '../models.dart';
import '../theme.dart';
import '../widgets/brand_widgets.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({
    required this.products,
    required this.onRemove,
    required this.onCheckout,
    super.key,
  });

  final List<BeautyProduct> products;
  final ValueChanged<BeautyProduct> onRemove;
  final ValueChanged<List<BeautyProduct>> onCheckout;

  @override
  Widget build(BuildContext context) {
    final total = products.fold(0, (sum, product) => sum + product.price);
    return Scaffold(
      appBar: AppBar(title: const Text('CART')),
      body: products.isEmpty
          ? const Center(child: Text('장바구니가 비어 있어요.'))
          : ListView(
              padding: const EdgeInsets.fromLTRB(18, 12, 18, 120),
              children: products
                  .map((product) => Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: ListTile(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                              side: const BorderSide(color: AppColors.line)),
                          tileColor: AppColors.surface,
                          leading: ProductBottle(product: product, height: 66),
                          title: Text(product.name,
                              style: const TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.w700)),
                          subtitle: Text(product.formattedPrice),
                          trailing: IconButton(
                              tooltip: '삭제',
                              onPressed: () => onRemove(product),
                              icon: const Icon(Icons.close_rounded)),
                        ),
                      ))
                  .toList(),
            ),
      bottomNavigationBar: products.isEmpty
          ? null
          : SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: FilledButton(
                  onPressed: () => onCheckout(products),
                  child: Text('결제하기 · ${_price(total)}'),
                ),
              ),
            ),
    );
  }
}

class DeliveryStatusScreen extends StatelessWidget {
  const DeliveryStatusScreen({
    required this.order,
    required this.onAdvance,
    required this.onDone,
    super.key,
  });

  final PurchaseOrder order;
  final VoidCallback onAdvance;
  final VoidCallback onDone;

  @override
  Widget build(BuildContext context) {
    const labels = ['결제 완료', '상품 준비', '배송 중', '배송 완료'];
    return Scaffold(
      appBar: AppBar(title: const Text('ORDER STATUS')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('ORDER COMPLETE',
              style: TextStyle(
                  color: AppColors.berry,
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.2)),
          const SizedBox(height: 14),
          const Text('주문이 접수되었어요.',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.w800)),
          const SizedBox(height: 8),
          Text('주문번호 ${order.id}',
              style: const TextStyle(color: AppColors.muted, fontSize: 12)),
          const SizedBox(height: 36),
          ...List.generate(labels.length, (index) {
            final active = index <= order.status.index;
            return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Column(children: [
                Icon(
                    active ? Icons.check_circle_rounded : Icons.circle_outlined,
                    color: active ? AppColors.fuchsia : AppColors.champagne),
                if (index < labels.length - 1)
                  Container(
                      width: 2,
                      height: 42,
                      color: active ? AppColors.fuchsia : AppColors.line),
              ]),
              const SizedBox(width: 14),
              Padding(
                padding: const EdgeInsets.only(top: 2),
                child: Text(labels[index],
                    style: TextStyle(
                        color: active ? AppColors.ink : AppColors.muted,
                        fontSize: 15,
                        fontWeight:
                            active ? FontWeight.w700 : FontWeight.w500)),
              ),
            ]);
          }),
          const Spacer(),
          if (order.status != DeliveryStatus.delivered)
            OutlinedButton.icon(
                onPressed: onAdvance,
                icon: const Icon(Icons.local_shipping_outlined),
                label: const Text('배송 단계 데모 진행')),
          const SizedBox(height: 10),
          FilledButton(onPressed: onDone, child: const Text('MY SKIN에서 주문 조회')),
        ]),
      ),
    );
  }
}

String _price(int value) =>
    '${(value ~/ 1000).toString()},${(value % 1000).toString().padLeft(3, '0')}원';
