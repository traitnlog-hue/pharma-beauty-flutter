import 'package:flutter/material.dart';

import '../catalog.dart';
import '../models.dart';
import '../theme.dart';
import '../widgets/brand_widgets.dart';
import 'routine_builder_screen.dart';
import 'skin_weather_screen.dart';

class MySkinScreen extends StatelessWidget {
  const MySkinScreen({
    required this.skinProfile,
    required this.profileConcern,
    required this.savedIds,
    required this.recentIds,
    required this.onEditProfile,
    required this.onOpenProduct,
    required this.onToggleSave,
    super.key,
  });

  final SkinProfile skinProfile;
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
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.1)),
            const SizedBox(height: 18),
            Text('내 피부의 변화를\n매일 업데이트해요.',
                style: Theme.of(context).textTheme.headlineLarge),
            const SizedBox(height: 28),
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(AppRadii.feature),
                border: Border.all(color: AppColors.line),
              ),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('SKIN PROFILE · UPDATED TODAY',
                              style: TextStyle(
                                  color: AppColors.berry,
                                  fontSize: 8,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 1)),
                          Icon(Icons.check_circle_outline_rounded,
                              color: AppColors.fuchsia, size: 18),
                        ]),
                    const SizedBox(height: 28),
                    Text(
                        skinProfile.isComplete
                            ? skinProfile.profileName
                            : '스킨 차트를 완성해 주세요',
                        style: const TextStyle(
                            color: AppColors.ink,
                            fontSize: 26,
                            fontWeight: FontWeight.w700,
                            letterSpacing: -.8)),
                    const SizedBox(height: 8),
                    Text('PRIMARY CONCERN · $profileConcern',
                        style: const TextStyle(
                            color: AppColors.berry,
                            fontSize: 10,
                            fontWeight: FontWeight.w700)),
                    const SizedBox(height: 20),
                    Wrap(
                        spacing: 7,
                        runSpacing: 7,
                        children: skinProfile.isComplete
                            ? [
                                _ProfileTag(skinProfile.skinType),
                                ...skinProfile.concerns
                                    .map((value) => _ProfileTag(value)),
                                _ProfileTag(skinProfile.sensitivity),
                              ]
                            : const [_ProfileTag('미완성')]),
                    if (skinProfile.isComplete) ...[
                      const SizedBox(height: 16),
                      Text(
                        '추천 성분 · ${skinProfile.recommendedIngredients}',
                        style: const TextStyle(
                            color: AppColors.berry,
                            fontSize: 10,
                            fontWeight: FontWeight.w700),
                      ),
                    ],
                    const SizedBox(height: 24),
                    OutlinedButton.icon(
                      onPressed: onEditProfile,
                      icon: const Icon(Icons.edit_outlined, size: 16),
                      label: const Text('피부 프로필 수정'),
                      style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.berry),
                    ),
                  ]),
            ),
            const SizedBox(height: 12),
            Material(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16),
              clipBehavior: Clip.antiAlias,
              child: InkWell(
                key: const Key('skin-weather-entry'),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => SkinWeatherScreen(
                      profile: skinProfile,
                      onOpenProduct: onOpenProduct,
                    ),
                  ),
                ),
                child: Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.line),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.wb_sunny_outlined,
                          color: AppColors.berry, size: 20),
                      SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('오늘의 환경 케어',
                                style: TextStyle(
                                    color: AppColors.ink,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700)),
                            SizedBox(height: 3),
                            Text('미세먼지 · 자외선 · 습도 기반 추천',
                                style: TextStyle(
                                    color: AppColors.muted, fontSize: 10)),
                          ],
                        ),
                      ),
                      Icon(Icons.arrow_forward_rounded,
                          color: AppColors.berry, size: 18),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 48),
            const Text('01 · MY ROUTINE',
                style: TextStyle(
                    color: AppColors.violet,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.1)),
            const SizedBox(height: 16),
            Text('오늘의 저녁 루틴',
                style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                  color: AppColors.mint,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.line)),
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
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600))),
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
          color: AppColors.blush,
          border: Border.all(color: AppColors.roseGold),
          borderRadius: BorderRadius.circular(10)),
      child: Text(label,
          style: const TextStyle(
              color: AppColors.berry,
              fontSize: 9,
              fontWeight: FontWeight.w700)));
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
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.line)),
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
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.line)),
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
                                  fontSize: 8, fontWeight: FontWeight.w700)),
                          const SizedBox(height: 5),
                          Text(product.name,
                              style: const TextStyle(
                                  fontSize: 13, fontWeight: FontWeight.w700)),
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
