import '../../models.dart';

class SkinWeatherSnapshot {
  const SkinWeatherSnapshot({
    required this.location,
    required this.temperature,
    required this.humidity,
    required this.pm25,
    required this.uvIndex,
  });

  final String location;
  final int temperature;
  final int humidity;
  final int pm25;
  final int uvIndex;

  String get airQuality => switch (pm25) {
        <= 15 => '좋음',
        <= 35 => '보통',
        <= 75 => '나쁨',
        _ => '매우 나쁨',
      };

  String get uvLevel => switch (uvIndex) {
        <= 2 => '낮음',
        <= 5 => '보통',
        <= 7 => '높음',
        _ => '매우 높음',
      };

  String get humidityLevel => humidity < 45 ? '건조' : '적정';

  int get skinRiskScore {
    final dustRisk = pm25 >= 36
        ? 32
        : pm25 >= 16
            ? 18
            : 6;
    final uvRisk = uvIndex >= 8
        ? 36
        : uvIndex >= 6
            ? 28
            : 12;
    final dryRisk = humidity < 40
        ? 28
        : humidity < 50
            ? 18
            : 6;
    return (dustRisk + uvRisk + dryRisk).clamp(0, 100).toInt();
  }

  String get riskLabel => switch (skinRiskScore) {
        >= 75 => '피부 자극 매우 높음',
        >= 55 => '피부 자극 주의',
        >= 35 => '피부 컨디션 보통',
        _ => '피부 컨디션 편안',
      };
}

class SkinWeatherService {
  const SkinWeatherService();

  /// API 연결 전에도 전체 추천 흐름을 검증할 수 있는 서울 기준 데모 스냅샷입니다.
  SkinWeatherSnapshot loadDemoSnapshot() => const SkinWeatherSnapshot(
        location: '서울',
        temperature: 27,
        humidity: 42,
        pm25: 38,
        uvIndex: 7,
      );

  List<int> recommendedProductIds(
      SkinWeatherSnapshot weather, SkinProfile profile) {
    final ids = <int>[];
    if (weather.pm25 >= 36) ids.add(3); // 진정 플루이드
    if (weather.uvIndex >= 6) ids.add(6); // 항산화 앰플
    if (weather.humidity < 45) ids.addAll([1, 2]); // 장벽·보습

    if (profile.isComplete) {
      final profilePick = switch (profile.primaryConcern) {
        '민감·진정' => 3,
        '보습' => 2,
        '트러블' => 4,
        '탄력' => 5,
        _ => 1,
      };
      ids.insert(0, profilePick);
    }
    return ids.toSet().take(3).toList(growable: false);
  }
}
