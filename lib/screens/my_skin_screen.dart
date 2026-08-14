import 'package:flutter/material.dart';

import '../catalog.dart';
import '../models.dart';
import '../theme.dart';
import '../widgets/brand_widgets.dart';
import 'routine_builder_screen.dart';

class MySkinScreen extends StatelessWidget {
  const MySkinScreen({
    required this.profileConcern,
    required this.savedIds,
    required this.recentIds,
    required this.onEditProfile,
    required this.onOpenProduct,
    required this.onToggleSave,
    super.key,
  });

  final String profileConcern;
  final Set<int> savedIds;
  final List<int> recentIds;
  final VoidCallback onEditProfile;
  final ValueChanged<BeautyProduct> onOpenProduct;
  final ValueChanged<BeautyProduct> onToggleSave;

  @override
  Widget build(BuildContext context) {
    final saved =
        products.where((product) => savedIds.contains(product.id)).toList();
    final recent = recentIds
        .map((id) => products.firstWhere((product) => product.id == id))
        .toList();
    return ListView(
      padding: const EdgeInsets.fromLTRB(24, 38, 24, 110),
      children: [
        Center(
            child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 880),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('MY SKIN · LIVE DASHBOARD',
                style: TextStyle(
                    color: AppColors.violet,
                    fontSize: 10,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.1)),
            const SizedBox(height: 18),
            Text('내 피부의 변화를\n매일 업데이트해요.',
                style: Theme.of(context).textTheme.headlineLarge),
            const SizedBox(height: 28),
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                    colors: [AppColors.deep, AppColors.berry],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight),
                borderRadius: BorderRadius.circular(30),
                boxShadow: const [
                  BoxShadow(
                      color: Color(0x243A1425),
                      blurRadius: 30,
                      offset: Offset(0, 16))
                ],
              ),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('SKIN PROFILE · UPDATED TODAY',
                              style: TextStyle(
                                  color: AppColors.mint,
                                  fontSize: 8,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 1)),
                          Icon(Icons.check_circle,
                              color: AppColors.lime, size: 18),
                        ]),
                    const SizedBox(height: 28),
                    const Text('장벽 보습형',
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'serif',
                            fontSize: 32)),
                    const SizedBox(height: 8),
                    Text('PRIMARY CONCERN · $profileConcern',
                        style: const TextStyle(
                            color: AppColors.ballerina,
                            fontSize: 10,
                            fontWeight: FontWeight.w700)),
                    const SizedBox(height: 20),
                    const Wrap(spacing: 7, runSpacing: 7, children: [
                      _ProfileTag('건성'),
                      _ProfileTag('장벽 관리'),
                      _ProfileTag('무향 선호')
                    ]),
                    const SizedBox(height: 24),
                    OutlinedButton.icon(
                      onPressed: onEditProfile,
                      icon: const Icon(Icons.edit_outlined, size: 16),
                      label: const Text('피부 프로필 수정'),
                      style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white,
                          side: const BorderSide(color: Color(0x66FFFFFF)),
                          shape: const RoundedRectangleBorder()),
                    ),
                  ]),
            ),
            const SizedBox(height: 48),
            const Text('01 · MY ROUTINE',
                style: TextStyle(
                    color: AppColors.violet,
                    fontSize: 10,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.1)),
            const SizedBox(height: 16),
            Text('오늘의 저녁 루틴',
                style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                  color: AppColors.mint,
                  borderRadius: BorderRadius.circular(26)),
              child: Column(children: [
                ...const [
                  ('01', 'TONER', 'BHA 클리어 토너'),
                  ('02', 'SERUM', '세라마이드 배리어 세럼'),
                  ('03', 'CREAM', '바이옴 리커버리 크림')
                ].map((item) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 9),
                      child: Row(children: [
                        Text(item.$1, style: const TextStyle(fontSize: 8)),
                        const SizedBox(width: 16),
                        SizedBox(
                            width: 72,
                            child: Text(item.$2,
                                style: const TextStyle(
                                    fontFamily: 'serif', fontSize: 11))),
                        Expanded(
                            child: Text(item.$3,
                                style: const TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700))),
                        const Icon(Icons.check, size: 16)
                      ]),
                    )),
                const Divider(height: 26),
                Row(children: [
                  const Icon(Icons.verified_outlined, size: 18),
                  const SizedBox(width: 9),
                  const Expanded(
                      child: Text('현재 등록된 성분 조합은 함께 사용하기 좋아요.',
                          style: TextStyle(
                              fontSize: 10, fontWeight: FontWeight.w700))),
                  TextButton(
                      onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const RoutineBuilderScreen())),
                      child: const Text('편집')),
                ]),
              ]),
            ),
            const SizedBox(height: 52),
            _ProductShelf(
                title: '저장한 제품',
                empty: '저장한 제품이 없어요.',
                products: saved,
                onOpen: onOpenProduct,
                onSave: onToggleSave,
                savedIds: savedIds),
            const SizedBox(height: 42),
            _ProductShelf(
                title: '최근 본 제품',
                empty: '아직 확인한 제품이 없어요.',
                products: recent,
                onOpen: onOpenProduct,
                onSave: onToggleSave,
                savedIds: savedIds),
          ]),
        )),
      ],
    );
  }
}

class _ProfileTag extends StatelessWidget {
  const _ProfileTag(this.label);
  final String label;
  @override
  Widget build(BuildContext context) => Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 7),
      decoration: BoxDecoration(
          color: AppColors.fuchsia.withValues(alpha: .26),
          border: Border.all(color: AppColors.roseGold),
          borderRadius: BorderRadius.circular(30)),
      child: Text(label,
          style: const TextStyle(
              color: Colors.white, fontSize: 9, fontWeight: FontWeight.w700)));
}

class _ProductShelf extends StatelessWidget {
  const _ProductShelf(
      {required this.title,
      required this.empty,
      required this.products,
      required this.onOpen,
      required this.onSave,
      required this.savedIds});
  final String title;
  final String empty;
  final List<BeautyProduct> products;
  final ValueChanged<BeautyProduct> onOpen;
  final ValueChanged<BeautyProduct> onSave;
  final Set<int> savedIds;

  @override
  Widget build(BuildContext context) =>
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title, style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(height: 16),
        if (products.isEmpty)
          Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(22)),
              child:
                  Text(empty, style: const TextStyle(color: AppColors.muted)))
        else
          ...products.map((product) => InkWell(
                onTap: () => onOpen(product),
                child: Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(22)),
                  child: Row(children: [
                    SizedBox(
                        width: 78,
                        child: ProductBottle(product: product, height: 78)),
                    const SizedBox(width: 14),
                    Expanded(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                          Text(product.brand,
                              style: const TextStyle(
                                  fontSize: 8, fontWeight: FontWeight.w900)),
                          const SizedBox(height: 5),
                          Text(product.name,
                              style: const TextStyle(
                                  fontSize: 13, fontWeight: FontWeight.w800)),
                          const SizedBox(height: 5),
                          Text(product.ingredients.take(2).join(' · '),
                              style: const TextStyle(
                                  color: AppColors.muted, fontSize: 9))
                        ])),
                    IconButton(
                        onPressed: () => onSave(product),
                        icon: Icon(savedIds.contains(product.id)
                            ? Icons.bookmark
                            : Icons.bookmark_border)),
                  ]),
                ),
              )),
      ]);
}
