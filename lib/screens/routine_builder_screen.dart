import 'package:flutter/material.dart';

import '../catalog.dart';
import '../models.dart';
import '../theme.dart';

class RoutineBuilderScreen extends StatefulWidget {
  const RoutineBuilderScreen({super.key});

  @override
  State<RoutineBuilderScreen> createState() => _RoutineBuilderScreenState();
}

class _RoutineBuilderScreenState extends State<RoutineBuilderScreen> {
  bool morning = false;
  final slots = <String, BeautyProduct?>{
    'CLEANSER': null,
    'TONER': products[3],
    'SERUM': products[0],
    'CREAM': products[1],
    'SUNSCREEN': null,
  };

  List<BeautyProduct> get selected =>
      slots.values.whereType<BeautyProduct>().toList();
  RoutineConflict? get conflict => findRoutineConflict(selected);
  bool get morningRetinal =>
      morning && selected.any((product) => product.ingredients.contains('레티날'));

  Future<void> pickProduct(String slot) async {
    final picked = await showModalBottomSheet<BeautyProduct>(
      context: context,
      showDragHandle: true,
      backgroundColor: AppColors.paper,
      builder: (context) => SafeArea(
        child: ListView.separated(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
          itemCount: products.length,
          separatorBuilder: (_, __) => const Divider(),
          itemBuilder: (context, index) {
            final product = products[index];
            return ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(product.name,
                  style: const TextStyle(fontWeight: FontWeight.w700)),
              subtitle: Text(
                  '${product.category} · ${product.ingredients.take(2).join(' · ')}'),
              trailing: const Icon(Icons.add),
              onTap: () => Navigator.pop(context, product),
            );
          },
        ),
      ),
    );
    if (picked != null) setState(() => slots[slot] = picked);
  }

  @override
  Widget build(BuildContext context) {
    final warning = conflict != null || morningRetinal;
    return Scaffold(
      appBar: AppBar(
          title: const Text('MY ROUTINE',
              style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.4))),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 80),
        children: [
          const Text('AI ROUTINE · COMPATIBILITY SCAN',
              style: TextStyle(
                  color: AppColors.violet,
                  fontSize: 10,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.1)),
          const SizedBox(height: 18),
          Text('제품을 담으면\n성분 궁합을 확인해요.',
              style: Theme.of(context).textTheme.headlineLarge),
          const SizedBox(height: 12),
          const Text('사용 순서대로 제품을 등록하면 함께 쓰기 좋은 조합과 주의할 조합을 알려드려요.',
              style: TextStyle(color: AppColors.muted, height: 1.6)),
          const SizedBox(height: 28),
          SegmentedButton<bool>(
            segments: const [
              ButtonSegment(value: true, label: Text('AM ROUTINE')),
              ButtonSegment(value: false, label: Text('PM ROUTINE'))
            ],
            selected: {morning},
            onSelectionChanged: (value) =>
                setState(() => morning = value.first),
            style: const ButtonStyle(visualDensity: VisualDensity.compact),
          ),
          const SizedBox(height: 22),
          ...slots.entries.map((entry) => _RoutineSlot(
                index: slots.keys.toList().indexOf(entry.key) + 1,
                label: entry.key,
                product: entry.value,
                onAdd: () => pickProduct(entry.key),
                onRemove: () => setState(() => slots[entry.key] = null),
              )),
          const SizedBox(height: 22),
          _RoutineStatus(
            warning: warning,
            title: conflict != null
                ? '${conflict!.first} + ${conflict!.second} 조합 주의'
                : morningRetinal
                    ? '레티날은 저녁 루틴을 권장해요'
                    : '현재 루틴은 함께 사용하기 좋아요',
            description: conflict?.reason ??
                (morningRetinal
                    ? '빛에 민감할 수 있어 저녁에 사용하고 낮에는 자외선 차단제를 사용하세요.'
                    : '세라마이드와 판테놀 중심의 장벽·진정 조합입니다.'),
          ),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: () => ScaffoldMessenger.of(context)
                .showSnackBar(const SnackBar(content: Text('내 루틴에 저장했어요.'))),
            icon: const Icon(Icons.bookmark_add_outlined, size: 18),
            label: const Text('이 루틴 저장하기'),
          ),
        ],
      ),
    );
  }
}

class _RoutineSlot extends StatelessWidget {
  const _RoutineSlot(
      {required this.index,
      required this.label,
      required this.product,
      required this.onAdd,
      required this.onRemove});
  final int index;
  final String label;
  final BeautyProduct? product;
  final VoidCallback onAdd;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) => Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
            color: product == null
                ? AppColors.surface
                : AppColors.mint.withValues(alpha: .5),
            borderRadius: BorderRadius.circular(20)),
        child: Row(children: [
          Text('0$index',
              style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w800)),
          const SizedBox(width: 16),
          SizedBox(
              width: 84,
              child: Text(label,
                  style: const TextStyle(fontFamily: 'serif', fontSize: 12))),
          Expanded(
              child: Text(product?.name ?? '제품을 추가해 주세요',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      fontSize: 11,
                      color: product == null ? AppColors.muted : AppColors.ink,
                      fontWeight: product == null
                          ? FontWeight.w400
                          : FontWeight.w700))),
          IconButton(
              onPressed: product == null ? onAdd : onRemove,
              icon: Icon(product == null ? Icons.add : Icons.close, size: 18)),
        ]),
      );
}

class _RoutineStatus extends StatelessWidget {
  const _RoutineStatus(
      {required this.warning, required this.title, required this.description});
  final bool warning;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: warning ? const Color(0xFFFFE3DC) : AppColors.deep,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Icon(
              warning
                  ? Icons.warning_amber_rounded
                  : Icons.check_circle_outline,
              color: warning ? const Color(0xFF9C4A00) : AppColors.lime),
          const SizedBox(width: 14),
          Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                Text(title,
                    style: TextStyle(
                        color: warning ? AppColors.ink : Colors.white,
                        fontWeight: FontWeight.w800)),
                const SizedBox(height: 7),
                Text(description,
                    style: TextStyle(
                        color:
                            warning ? AppColors.muted : const Color(0xFFB9C8C3),
                        fontSize: 11,
                        height: 1.55)),
              ])),
        ]),
      );
}
