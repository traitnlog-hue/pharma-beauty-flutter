import 'package:flutter/material.dart';

import '../catalog.dart';
import '../models.dart';
import '../theme.dart';
import '../widgets/brand_widgets.dart';

/// 매장 안에서 제품을 찾는 흐름을 위한 데모 스캔 화면입니다.
/// 실제 카메라 권한과 OCR은 연결 전이므로, 제품명 입력과 데모 바코드로
/// 동일한 탐색·근거 흐름을 검증할 수 있게 구성합니다.
class ScanScreen extends StatefulWidget {
  const ScanScreen({required this.onOpenProduct, super.key});

  final ValueChanged<BeautyProduct> onOpenProduct;

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  final _controller = TextEditingController();
  bool _isScanning = false;
  String _query = '';

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  List<BeautyProduct> get _results {
    final keyword = _query.trim().toLowerCase();
    if (keyword.isEmpty) return products.take(3).toList();
    return products.where((product) {
      return '${product.brand} ${product.name} ${product.ingredients.join(' ')}'
          .toLowerCase()
          .contains(keyword);
    }).toList();
  }

  void _startDemoScan() {
    setState(() => _isScanning = true);
    Future<void>.delayed(const Duration(milliseconds: 760), () {
      if (!mounted) return;
      setState(() {
        _isScanning = false;
        _query = '세라마이드';
        _controller.text = '세라마이드';
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('데모 바코드를 인식했어요. 제품과 성분 근거를 확인해 보세요.')),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 26, 20, 122),
      children: [
        const _SectionIntro(
          eyebrow: '성분 바로 확인',
          title: '매장에서 바로\n성분을 찾아보세요',
          description: '바코드나 제품명으로 검색하고, 내 피부 기준과 핵심 성분을 함께 확인해요.',
        ),
        const SizedBox(height: 22),
        AspectRatio(
          aspectRatio: 1.28,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 240),
            decoration: BoxDecoration(
              color: AppColors.deep,
              borderRadius: BorderRadius.circular(28),
              border: Border.all(color: AppColors.berry.withValues(alpha: .4)),
            ),
            child: Stack(
              fit: StackFit.expand,
              children: [
                const Positioned.fill(child: _ScanGrid()),
                Center(
                  child: Container(
                    width: 204,
                    height: 136,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: AppColors.lime,
                        width: _isScanning ? 3 : 1.4,
                      ),
                    ),
                    child: _isScanning
                        ? const Align(
                            alignment: Alignment.center,
                            child: LinearProgressIndicator(
                              color: AppColors.lime,
                              backgroundColor: Color(0x44FFFFFF),
                            ),
                          )
                        : const SizedBox.shrink(),
                  ),
                ),
                Positioned(
                  top: 18,
                  left: 18,
                  child: _ScanPill(
                    icon: _isScanning
                        ? Icons.radar_rounded
                        : Icons.qr_code_scanner_rounded,
                    label: _isScanning ? '상품 확인 중' : '바코드 · 제품명',
                  ),
                ),
                Positioned(
                  left: 18,
                  right: 18,
                  bottom: 18,
                  child: FilledButton.icon(
                    onPressed: _isScanning ? null : _startDemoScan,
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.lime,
                      foregroundColor: AppColors.deep,
                    ),
                    icon: const Icon(Icons.center_focus_strong_rounded),
                    label: Text(_isScanning ? '제품을 찾고 있어요' : '데모 스캔 시작'),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 14),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.blush,
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Row(
            children: [
              Icon(
                Icons.info_outline_rounded,
                size: 18,
                color: AppColors.berry,
              ),
              SizedBox(width: 9),
              Expanded(
                child: Text(
                  '프로토타입에서는 카메라를 사용하지 않아요. 제품명 입력으로도 같은 결과를 볼 수 있어요.',
                  style: TextStyle(
                    fontSize: 11,
                    height: 1.45,
                    color: AppColors.berry,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 32),
        TextField(
          controller: _controller,
          onChanged: (value) => setState(() => _query = value),
          decoration: const InputDecoration(
            hintText: '제품명, 브랜드, 성분 검색',
            prefixIcon: Icon(Icons.search_rounded),
          ),
        ),
        const SizedBox(height: 28),
        Row(
          children: [
            const Expanded(
              child: Text(
                '최근 확인한 제품',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
              ),
            ),
            Text(
              '${_results.length}개',
              style: const TextStyle(color: AppColors.muted, fontSize: 11),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ..._results.map(
          (product) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: _ScanResult(
              product: product,
              onTap: () => widget.onOpenProduct(product),
            ),
          ),
        ),
        if (_results.isEmpty)
          const _EmptyResult(
            title: '아직 찾지 못했어요',
            body: '제품명 일부 또는 성분명을 다시 입력해 보세요.',
          ),
      ],
    );
  }
}

class _SectionIntro extends StatelessWidget {
  const _SectionIntro({
    required this.eyebrow,
    required this.title,
    required this.description,
  });
  final String eyebrow;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            eyebrow,
            style: const TextStyle(
              color: AppColors.berry,
              fontSize: 10,
              letterSpacing: 1.3,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: Theme.of(context)
                .textTheme
                .headlineLarge
                ?.copyWith(fontSize: 30, height: 1.12),
          ),
          const SizedBox(height: 10),
          Text(
            description,
            style: const TextStyle(
              color: AppColors.muted,
              fontSize: 13,
              height: 1.55,
            ),
          ),
        ],
      );
}

class _ScanPill extends StatelessWidget {
  const _ScanPill({required this.icon, required this.label});
  final IconData icon;
  final String label;
  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: .12),
          border: Border.all(color: Colors.white.withValues(alpha: .22)),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 15, color: AppColors.lime),
            const SizedBox(width: 6),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.w800,
                letterSpacing: .7,
              ),
            ),
          ],
        ),
      );
}

class _ScanGrid extends StatelessWidget {
  const _ScanGrid();
  @override
  Widget build(BuildContext context) => CustomPaint(painter: _GridPainter());
}

class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: .055)
      ..strokeWidth = 1;
    for (var x = 0.0; x < size.width; x += 28) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (var y = 0.0; y < size.height; y += 28) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _ScanResult extends StatelessWidget {
  const _ScanResult({required this.product, required this.onTap});
  final BeautyProduct product;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Material(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(18),
          child: Container(
            height: 96,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: AppColors.line),
            ),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: SizedBox(
                    width: 72,
                    child: ProductBottle(product: product, height: 76),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.brand,
                        style: const TextStyle(
                          color: AppColors.muted,
                          fontSize: 9,
                          fontWeight: FontWeight.w800,
                          letterSpacing: .7,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        product.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        '내 기준 확인 · ${product.ingredients.take(2).join(' · ')}',
                        style: const TextStyle(
                          color: AppColors.berry,
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                        ),
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

class _EmptyResult extends StatelessWidget {
  const _EmptyResult({required this.title, required this.body});
  final String title;
  final String body;
  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          color: AppColors.surface,
          border: Border.all(color: AppColors.line),
        ),
        child: Column(
          children: [
            const Icon(Icons.manage_search_outlined, color: AppColors.berry),
            const SizedBox(height: 10),
            Text(title, style: const TextStyle(fontWeight: FontWeight.w800)),
            const SizedBox(height: 4),
            Text(
              body,
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.muted, fontSize: 11),
            ),
          ],
        ),
      );
}
