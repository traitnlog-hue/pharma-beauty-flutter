import 'dart:async';

import 'package:flutter/material.dart';

import '../catalog.dart';
import '../features/ingredient_dictionary/ingredient_dictionary_service.dart';
import '../models.dart';
import '../theme.dart';
import '../widgets/brand_widgets.dart';
import 'routine_builder_screen.dart';

/// 제품·성분·브랜드·리뷰 키워드를 같은 입력에서 해석하는 통합 탐색 화면입니다.
class DiscoverScreen extends StatefulWidget {
  const DiscoverScreen({
    required this.onOpenProduct,
    required this.onAskRemi,
    super.key,
  });

  final ValueChanged<BeautyProduct> onOpenProduct;
  final VoidCallback onAskRemi;

  @override
  State<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen> {
  final _controller = TextEditingController();
  final _dictionary = const IngredientDictionaryService();
  Timer? _debounce;
  String _query = '';
  String _type = '전체';
  bool _loadingOfficial = false;
  List<IngredientInfo> _officialResults = const [];

  @override
  void dispose() {
    _controller.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _search(String value) {
    setState(() {
      _query = value;
      _officialResults = const [];
      _loadingOfficial = value.trim().isNotEmpty;
    });
    _debounce?.cancel();
    if (value.trim().isEmpty) return;
    _debounce = Timer(const Duration(milliseconds: 360), () async {
      final response = await _dictionary.search(value);
      if (!mounted || value != _query) return;
      setState(() {
        _officialResults = response;
        _loadingOfficial = false;
      });
    });
  }

  List<BeautyProduct> get _products {
    final keyword = _query.trim().toLowerCase();
    if (keyword.isEmpty) return products.take(3).toList();
    return products.where((product) {
      return '${product.name} ${product.brand} ${product.ingredients.join(' ')} ${product.concern}'
          .toLowerCase()
          .contains(keyword);
    }).toList();
  }

  List<IngredientInfo> get _ingredients {
    final keyword = _query.trim().toLowerCase();
    final local = ingredients.where((ingredient) {
      return '${ingredient.name} ${ingredient.englishName} ${ingredient.summary} ${ingredient.category}'
          .toLowerCase()
          .contains(keyword);
    });
    final seen = <String>{};
    return [...local, ..._officialResults]
        .where(
          (ingredient) =>
              seen.add('${ingredient.name}|${ingredient.englishName}'),
        )
        .toList();
  }

  void _showIngredient(IngredientInfo ingredient) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: .72,
        maxChildSize: .92,
        expand: false,
        builder: (context, controller) => Container(
          decoration: const BoxDecoration(
            color: AppColors.paper,
            borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
          ),
          child: ListView(
            controller: controller,
            padding: const EdgeInsets.fromLTRB(22, 12, 22, 34),
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.champagne,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 22),
              const _EvidenceLabel(label: '성분 정보'),
              const SizedBox(height: 14),
              Text(
                ingredient.name,
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              const SizedBox(height: 4),
              Text(
                ingredient.englishName,
                style: const TextStyle(
                  color: AppColors.berry,
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  letterSpacing: .6,
                ),
              ),
              const SizedBox(height: 22),
              _EvidenceBlock(
                title: '무엇을 위한 성분인가요?',
                body: ingredient.summary,
                icon: Icons.science_outlined,
              ),
              const SizedBox(height: 10),
              _EvidenceBlock(
                title: '함께 확인할 조합',
                body: ingredient.goodWith.isEmpty
                    ? '제품의 전체 처방과 사용 맥락을 함께 확인해 주세요.'
                    : ingredient.goodWith.join(' · '),
                icon: Icons.hub_outlined,
              ),
              const SizedBox(height: 10),
              _EvidenceBlock(
                title: '주의할 조합',
                body: ingredient.cautionWith.isEmpty
                    ? '고정된 주의 조합이 적어요. 피부 상태와 제품 제형에 따라 달라질 수 있어요.'
                    : ingredient.cautionWith.join(' · '),
                icon: Icons.info_outline_rounded,
              ),
              const SizedBox(height: 20),
              const _DataFreshness(),
              const SizedBox(height: 16),
              OutlinedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const RoutineBuilderScreen(),
                    ),
                  );
                },
                icon: const Icon(Icons.playlist_add_check_rounded),
                label: const Text('내 루틴에서 조합 확인'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final showProducts =
        _type == '전체' || _type == '제품' || _type == '브랜드' || _type == '리뷰';
    final showIngredients = _type == '전체' || _type == '성분';
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 122),
      children: [
        const Text(
          '성분 · 상품 찾기',
          style: TextStyle(
            color: AppColors.berry,
            fontSize: 10,
            letterSpacing: 1.4,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          '제품을 고르기 전,\n성분부터 확인해요.',
          style:
              Theme.of(context).textTheme.headlineLarge?.copyWith(fontSize: 30),
        ),
        const SizedBox(height: 10),
        const Text(
          '제품명·성분명·브랜드를 검색하고 내 피부 기준으로 비교해 보세요.',
          style: TextStyle(color: AppColors.muted, fontSize: 12, height: 1.5),
        ),
        const SizedBox(height: 22),
        TextField(
          controller: _controller,
          onChanged: _search,
          decoration: InputDecoration(
            hintText: '제품, 성분, 브랜드, 리뷰 키워드',
            prefixIcon: const Icon(Icons.search_rounded),
            suffixIcon: _loadingOfficial
                ? const Padding(
                    padding: EdgeInsets.all(14),
                    child: SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  )
                : _query.isEmpty
                    ? null
                    : IconButton(
                        tooltip: '검색어 지우기',
                        onPressed: () {
                          _controller.clear();
                          _search('');
                        },
                        icon: const Icon(Icons.close_rounded),
                      ),
          ),
        ),
        const SizedBox(height: 12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              for (final item in ['전체', '제품', '성분', '브랜드', '리뷰'])
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(item),
                    selected: _type == item,
                    showCheckmark: false,
                    onSelected: (_) => setState(() => _type = item),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 22),
        const _SavedCriteriaStrip(),
        if (showProducts) ...[
          const SizedBox(height: 34),
          _ResultHeading(
            title: _query.isEmpty ? '지금 많이 찾는 상품' : '상품 검색 결과',
            count: _products.length,
            detail: _type == '리뷰'
                ? '리뷰 유형과 구매 정보는 상세에서 확인해요'
                : '내 피부 기준과 함께 비교해 볼 수 있어요',
          ),
          const SizedBox(height: 12),
          if (_products.isEmpty)
            const _EmptyState(
              title: '찾는 상품이 없어요',
              body: '상품명 또는 핵심 성분명으로 다시 검색해 보세요.',
            )
          else
            ..._products.map(
              (product) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: _ProductDecisionCard(
                  product: product,
                  onTap: () => widget.onOpenProduct(product),
                ),
              ),
            ),
        ],
        if (showIngredients) ...[
          const SizedBox(height: 34),
          _ResultHeading(
            title: _query.isEmpty ? '많이 찾는 성분' : '성분 검색 결과',
            count: _ingredients.length,
            detail: _query.isEmpty
                ? '한글명·영문명·INCI 명칭으로 찾아볼 수 있어요'
                : '공식 연동 결과가 있으면 함께 보여드려요',
          ),
          const SizedBox(height: 12),
          if (_ingredients.isEmpty && _query.isNotEmpty)
            const _EmptyState(
              title: '성분 결과가 없어요',
              body: '한글명, 영문명 또는 INCI 명칭을 확인해 보세요.',
            )
          else
            ..._ingredients.take(_query.isEmpty ? 4 : 20).map(
                  (ingredient) => Padding(
                    padding: const EdgeInsets.only(bottom: 9),
                    child: _IngredientRow(
                      ingredient: ingredient,
                      onTap: () => _showIngredient(ingredient),
                    ),
                  ),
                ),
        ],
        const SizedBox(height: 34),
        _RemiContextCard(onTap: widget.onAskRemi),
      ],
    );
  }
}

class _SavedCriteriaStrip extends StatelessWidget {
  const _SavedCriteriaStrip();
  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.blush,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.bookmark_added_outlined,
              size: 18,
              color: AppColors.berry,
            ),
            const SizedBox(width: 9),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '나의 성분 기준 적용 중',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800),
                  ),
                  SizedBox(height: 3),
                  Text(
                    '피부 장벽 · 세라마이드 · 판테놀',
                    style: TextStyle(color: AppColors.berry, fontSize: 10),
                  ),
                ],
              ),
            ),
            const Icon(Icons.tune_rounded, size: 17, color: AppColors.berry),
          ],
        ),
      );
}

class _ResultHeading extends StatelessWidget {
  const _ResultHeading({
    required this.title,
    required this.count,
    required this.detail,
  });
  final String title;
  final int count;
  final String detail;
  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w900),
                ),
              ),
              Text(
                '$count개',
                style: const TextStyle(
                  color: AppColors.berry,
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            detail,
            style: const TextStyle(color: AppColors.muted, fontSize: 10),
          ),
        ],
      );
}

class _ProductDecisionCard extends StatelessWidget {
  const _ProductDecisionCard({required this.product, required this.onTap});
  final BeautyProduct product;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => Material(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Container(
            padding: const EdgeInsets.all(11),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.line),
            ),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(13),
                  child: SizedBox(
                    width: 78,
                    height: 88,
                    child: ProductBottle(product: product, height: 88),
                  ),
                ),
                const SizedBox(width: 13),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const _EvidenceLabel(label: '구매 전 확인'),
                      const SizedBox(height: 7),
                      Text(
                        product.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        product.brand,
                        style: const TextStyle(
                            color: AppColors.muted, fontSize: 9),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        '기준 포함 · ${product.ingredients.take(2).join(' · ')}',
                        style: const TextStyle(
                          color: AppColors.berry,
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        '${product.formattedPrice} · 데이터 기준 확인',
                        style: const TextStyle(
                            color: AppColors.muted, fontSize: 9),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.arrow_forward_rounded,
                  size: 18,
                  color: AppColors.berry,
                ),
              ],
            ),
          ),
        ),
      );
}

class _IngredientRow extends StatelessWidget {
  const _IngredientRow({required this.ingredient, required this.onTap});
  final IngredientInfo ingredient;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => Material(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.line),
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    color: AppColors.blush,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.science_outlined,
                    size: 18,
                    color: AppColors.berry,
                  ),
                ),
                const SizedBox(width: 11),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        ingredient.name,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${ingredient.englishName} · ${ingredient.category}',
                        style: const TextStyle(
                            color: AppColors.muted, fontSize: 9),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right_rounded, color: AppColors.muted),
              ],
            ),
          ),
        ),
      );
}

class _EvidenceLabel extends StatelessWidget {
  const _EvidenceLabel({required this.label});
  final String label;
  @override
  Widget build(BuildContext context) => Text(
        label,
        style: const TextStyle(
          color: AppColors.berry,
          fontSize: 8,
          letterSpacing: .8,
          fontWeight: FontWeight.w900,
        ),
      );
}

class _EvidenceBlock extends StatelessWidget {
  const _EvidenceBlock({
    required this.title,
    required this.body,
    required this.icon,
  });
  final String title;
  final String body;
  final IconData icon;
  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          border: Border.all(color: AppColors.line),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 18, color: AppColors.berry),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    body,
                    style: const TextStyle(
                      color: AppColors.muted,
                      fontSize: 11,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
}

class _DataFreshness extends StatelessWidget {
  const _DataFreshness();
  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.butter,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Row(
          children: [
            Icon(Icons.update_rounded, color: AppColors.berry, size: 18),
            SizedBox(width: 9),
            Expanded(
              child: Text(
                '공식 성분 데이터 연동 결과 · 데이터 기준일은 결과 출처에서 다시 확인해 주세요.',
                style: TextStyle(
                    color: AppColors.berry, fontSize: 10, height: 1.4),
              ),
            ),
          ],
        ),
      );
}

class _RemiContextCard extends StatelessWidget {
  const _RemiContextCard({required this.onTap});
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => Material(
        color: AppColors.deep,
        borderRadius: BorderRadius.circular(22),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(22),
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Row(
              children: [
                const Icon(
                  Icons.auto_awesome_rounded,
                  color: AppColors.lime,
                  size: 22,
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '레미에게 이 결과 물어보기',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        '의료 진단이 아닌 제품·성분 정보 해설을 제공해요.',
                        style:
                            TextStyle(color: Color(0xFFCAE0E2), fontSize: 10),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.arrow_forward_rounded,
                  color: AppColors.lime,
                  size: 18,
                ),
              ],
            ),
          ),
        ),
      );
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.title, required this.body});
  final String title;
  final String body;
  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.line),
        ),
        child: Column(
          children: [
            const Icon(Icons.search_off_rounded, color: AppColors.muted),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 4),
            Text(
              body,
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.muted, fontSize: 10),
            ),
          ],
        ),
      );
}
