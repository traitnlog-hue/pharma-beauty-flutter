import 'package:flutter/material.dart';

import '../catalog.dart';
import '../features/skin_weather/skin_weather_service.dart';
import '../models.dart';
import '../theme.dart';
import '../widgets/brand_widgets.dart';

class SkinWeatherScreen extends StatelessWidget {
  const SkinWeatherScreen({
    required this.profile,
    required this.onOpenProduct,
    super.key,
  });

  final SkinProfile profile;
  final ValueChanged<BeautyProduct> onOpenProduct;

  @override
  Widget build(BuildContext context) {
    const service = SkinWeatherService();
    final weather = service.loadDemoSnapshot();
    final recommendedIds = service.recommendedProductIds(weather, profile);
    final recommended = products
        .where((product) => recommendedIds.contains(product.id))
        .toList(growable: false);

    return Scaffold(
      appBar: AppBar(
        title: const BrandLogo(compact: true),
        actions: [
          IconButton(
            tooltip: '새로고침',
            onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('현재는 서울 데모 데이터를 사용하고 있어요.')),
            ),
            icon: const Icon(Icons.refresh_rounded),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(18, 12, 18, 40),
        children: [
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 760),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const SectionLabel('LIVE', 'SKIN WEATHER'),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 9, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.paper2,
                          borderRadius: BorderRadius.circular(9),
                        ),
                        child: const Text('SEOUL · DEMO DATA',
                            style: TextStyle(
                                color: AppColors.muted,
                                fontSize: 8,
                                fontWeight: FontWeight.w700,
                                letterSpacing: .7)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text('환경까지 읽는\n오늘의 피부 예보',
                      style: Theme.of(context).textTheme.headlineLarge),
                  const SizedBox(height: 18),
                  _RiskHero(weather: weather),
                  const SizedBox(height: 24),
                  const Text('오늘의 자극 요인',
                      style: TextStyle(
                          color: AppColors.ink,
                          fontSize: 19,
                          fontWeight: FontWeight.w700)),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _FactorCard(
                          icon: Icons.air_rounded,
                          label: 'PM2.5',
                          value: '${weather.pm25}',
                          status: weather.airQuality,
                          color: const Color(0xFFFFE3D8),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _FactorCard(
                          icon: Icons.light_mode_outlined,
                          label: 'UV INDEX',
                          value: '${weather.uvIndex}',
                          status: weather.uvLevel,
                          color: const Color(0xFFFFE9B8),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _FactorCard(
                          icon: Icons.water_drop_outlined,
                          label: 'HUMIDITY',
                          value: '${weather.humidity}%',
                          status: weather.humidityLevel,
                          color: AppColors.blush,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const _RoutineAdvice(),
                  const SizedBox(height: 30),
                  Text(
                    profile.isComplete
                        ? '${profile.profileName} × 오늘 날씨 추천'
                        : '오늘 날씨 기준 추천',
                    style: const TextStyle(
                        color: AppColors.ink,
                        fontSize: 20,
                        fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 6),
                  const Text('미세먼지·자외선·건조 신호를 함께 반영했어요.',
                      style: TextStyle(
                          color: AppColors.muted, fontSize: 12, height: 1.5)),
                  const SizedBox(height: 14),
                  ...recommended.map((product) => _WeatherProductCard(
                        product: product,
                        onTap: () => onOpenProduct(product),
                      )),
                  const SizedBox(height: 14),
                  const Text(
                    '환경 정보와 자가 입력 프로필을 활용한 화장품 큐레이션이며 의료 진단을 대신하지 않습니다.',
                    style: TextStyle(
                        color: AppColors.muted, fontSize: 9, height: 1.5),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RiskHero extends StatelessWidget {
  const _RiskHero({required this.weather});

  final SkinWeatherSnapshot weather;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFDEDFFF), Color(0xFFAFA9F7)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(AppRadii.feature),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.location_on_outlined,
                    color: AppColors.berry, size: 16),
                const SizedBox(width: 5),
                Text('${weather.location} · 현재',
                    style: const TextStyle(
                        color: AppColors.berry,
                        fontSize: 10,
                        fontWeight: FontWeight.w700)),
                const Spacer(),
                Text('${weather.temperature}°',
                    style: const TextStyle(
                        color: AppColors.ink,
                        fontSize: 24,
                        fontWeight: FontWeight.w700)),
              ],
            ),
            const SizedBox(height: 28),
            Text(weather.riskLabel,
                style: const TextStyle(
                    color: AppColors.ink,
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -.8)),
            const SizedBox(height: 8),
            const Text('외출 전 항산화·보습·자외선 차단을 챙기고, 귀가 후에는 순한 세안을 권해요.',
                style: TextStyle(
                    color: AppColors.berry, fontSize: 12, height: 1.55)),
            const SizedBox(height: 20),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: weather.skinRiskScore / 100,
                minHeight: 7,
                color: AppColors.berry,
                backgroundColor: Colors.white.withValues(alpha: .55),
              ),
            ),
            const SizedBox(height: 7),
            Text('SKIN RISK ${weather.skinRiskScore}/100',
                style: const TextStyle(
                    color: AppColors.berry,
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                    letterSpacing: .7)),
          ],
        ),
      );
}

class _FactorCard extends StatelessWidget {
  const _FactorCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.status,
    required this.color,
  });

  final IconData icon;
  final String label;
  final String value;
  final String status;
  final Color color;

  @override
  Widget build(BuildContext context) => Container(
        height: 128,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: AppColors.berry, size: 18),
            const Spacer(),
            Text(value,
                style: const TextStyle(
                    color: AppColors.ink,
                    fontSize: 22,
                    fontWeight: FontWeight.w700)),
            const SizedBox(height: 2),
            Text('$label · $status',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: AppColors.muted, fontSize: 8)),
          ],
        ),
      );
}

class _RoutineAdvice extends StatelessWidget {
  const _RoutineAdvice();

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(17),
        decoration: BoxDecoration(
          color: AppColors.deep,
          borderRadius: BorderRadius.circular(18),
        ),
        child: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('TODAY · ROUTINE NOTE',
                style: TextStyle(
                    color: AppColors.ballerina,
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                    letterSpacing: .8)),
            SizedBox(height: 13),
            _AdviceLine(
                icon: Icons.wb_sunny_outlined,
                title: 'AM',
                body: '항산화 세럼 → 장벽 보습 → SPF 50+'),
            SizedBox(height: 10),
            _AdviceLine(
                icon: Icons.nightlight_outlined,
                title: 'PM',
                body: '순한 이중 세안 → 판테놀·세라마이드 회복'),
          ],
        ),
      );
}

class _AdviceLine extends StatelessWidget {
  const _AdviceLine(
      {required this.icon, required this.title, required this.body});

  final IconData icon;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) => Row(
        children: [
          Icon(icon, color: AppColors.ballerina, size: 17),
          const SizedBox(width: 10),
          SizedBox(
            width: 28,
            child: Text(title,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w700)),
          ),
          Expanded(
            child: Text(body,
                style: const TextStyle(
                    color: Color(0xFFE5E3F6), fontSize: 10, height: 1.4)),
          ),
        ],
      );
}

class _WeatherProductCard extends StatelessWidget {
  const _WeatherProductCard({required this.product, required this.onTap});

  final BeautyProduct product;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 9),
        child: Material(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: onTap,
            child: Container(
              padding: const EdgeInsets.all(11),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.line),
              ),
              child: Row(
                children: [
                  SizedBox(
                      width: 78,
                      child: ProductBottle(product: product, height: 78)),
                  const SizedBox(width: 13),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(product.brand,
                            style: const TextStyle(
                                color: AppColors.berry,
                                fontSize: 8,
                                fontWeight: FontWeight.w700)),
                        const SizedBox(height: 4),
                        Text(product.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                color: AppColors.ink,
                                fontSize: 13,
                                fontWeight: FontWeight.w700)),
                        const SizedBox(height: 5),
                        Text(product.note,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                color: AppColors.muted,
                                fontSize: 9,
                                height: 1.4)),
                      ],
                    ),
                  ),
                  const Icon(Icons.arrow_forward_rounded,
                      color: AppColors.berry, size: 18),
                ],
              ),
            ),
          ),
        ),
      );
}
