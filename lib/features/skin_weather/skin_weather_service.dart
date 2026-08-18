import 'dart:convert';

import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

import '../../models.dart';

class SkinWeatherSnapshot {
  const SkinWeatherSnapshot({
    required this.location,
    required this.temperature,
    required this.humidity,
    required this.pm25,
    required this.uvIndex,
    required this.airQualityIndex,
    this.isLive = false,
    this.observedAt,
  });

  final String location;
  final int temperature;
  final int humidity;
  final int pm25;
  final int uvIndex;
  final int airQualityIndex;
  final bool isLive;
  final DateTime? observedAt;

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

class SkinWeatherAdvice {
  const SkinWeatherAdvice({
    required this.cautions,
    required this.recommendations,
  });

  final List<String> cautions;
  final List<String> recommendations;
}

class SkinWeatherService {
  const SkinWeatherService({
    this.airQualityProxyUrl = _defaultAirQualityProxyUrl,
  });

  // 인증키는 절대 앱에 넣지 않고 Cloudflare Worker의 비밀값으로만 보관합니다.
  static const _defaultAirQualityProxyUrl = String.fromEnvironment(
    'AIR_QUALITY_PROXY_URL',
    defaultValue:
        'https://pharma-beauty-weather-proxy.trait-n-log.workers.dev/air-quality',
  );

  final String airQualityProxyUrl;

  /// API 연결 전에도 전체 추천 흐름을 검증할 수 있는 서울 기준 데모 스냅샷입니다.
  SkinWeatherSnapshot loadDemoSnapshot() => const SkinWeatherSnapshot(
        location: '서울',
        temperature: 27,
        humidity: 42,
        pm25: 38,
        uvIndex: 7,
        airQualityIndex: 91,
      );

  /// 기상·자외선은 임시 무료 소스를, 미세먼지·AQI는 비밀키를 감춘
  /// AirKorea Worker 프록시를 사용합니다.
  Future<SkinWeatherSnapshot> loadCurrentSnapshot() async {
    final position = await _currentPosition();
    final latitude = position?.latitude ?? 37.5665;
    final longitude = position?.longitude ?? 126.9780;
    final weatherUri = Uri.https('api.open-meteo.com', '/v1/forecast', {
      'latitude': '$latitude',
      'longitude': '$longitude',
      'current': 'temperature_2m,relative_humidity_2m,uv_index',
      'timezone': 'Asia/Seoul',
    });
    try {
      final weatherResponse =
          await http.get(weatherUri).timeout(const Duration(seconds: 8));
      if (weatherResponse.statusCode != 200) {
        return loadDemoSnapshot();
      }
      final weather = jsonDecode(weatherResponse.body) as Map<String, dynamic>;
      final currentWeather = weather['current'] as Map<String, dynamic>;
      final air = await _loadAirKoreaSnapshot();
      return SkinWeatherSnapshot(
        location: position == null ? '서울' : '내 주변',
        temperature: _asInt(currentWeather['temperature_2m']),
        humidity: _asInt(currentWeather['relative_humidity_2m']),
        uvIndex: _asInt(currentWeather['uv_index']),
        pm25: air?.pm25 ?? loadDemoSnapshot().pm25,
        airQualityIndex:
            air?.airQualityIndex ?? loadDemoSnapshot().airQualityIndex,
        isLive: air != null,
        observedAt: DateTime.tryParse(currentWeather['time'] as String? ?? ''),
      );
    } catch (_) {
      return loadDemoSnapshot();
    }
  }

  int _asInt(Object? value) => ((value as num?) ?? 0).round();

  Future<({int pm25, int airQualityIndex})?> _loadAirKoreaSnapshot() async {
    if (airQualityProxyUrl.isEmpty) return null;
    final response = await http
        .get(Uri.parse(airQualityProxyUrl))
        .timeout(const Duration(seconds: 8));
    if (response.statusCode != 200) return null;

    final payload = jsonDecode(response.body) as Map<String, dynamic>;
    return (
      pm25: _asInt(payload['pm25']),
      airQualityIndex: _asInt(payload['airQualityIndex']),
    );
  }

  Future<Position?> _currentPosition() async {
    try {
      if (!await Geolocator.isLocationServiceEnabled()) return null;

      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        return null;
      }

      return Geolocator.getCurrentPosition(
        locationSettings:
            const LocationSettings(accuracy: LocationAccuracy.low),
      ).timeout(const Duration(seconds: 8));
    } catch (_) {
      return null;
    }
  }

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

  /// 환경 지표와 자가 입력 피부 차트를 함께 읽어 홈과 상세 화면에서
  /// 같은 안내를 제공합니다. 실제 날씨 API를 연결할 때도 이 규칙은 그대로
  /// 유지하고 snapshot만 교체하면 됩니다.
  SkinWeatherAdvice adviceFor(
      SkinWeatherSnapshot weather, SkinProfile profile) {
    final cautions = <String>[];
    final recommendations = <String>[];

    if (weather.uvIndex >= 6) {
      cautions.add('자외선이 ${weather.uvLevel} 수준이에요. 낮 외출 시 광노화·색소 자극에 주의하세요.');
      recommendations.add('SPF 50+를 충분히 바르고, 2~3시간마다 덧발라 주세요.');
    }
    if (weather.pm25 >= 36) {
      cautions
          .add('미세먼지가 ${weather.airQuality} 수준이에요. 피부 표면에 먼지가 오래 남지 않게 해주세요.');
      recommendations.add('귀가 후 미온수와 순한 클렌저로 가볍게 세안하세요.');
    }
    if (weather.humidity < 45) {
      cautions.add('습도 ${weather.humidity}%로 피부 수분이 쉽게 빠져나갈 수 있어요.');
      recommendations.add('세라마이드·판테놀 보습제를 얇게 여러 번 레이어링하세요.');
    }

    if (profile.skinType.isNotEmpty) {
      if (profile.sensitivity == '매우 예민함' || profile.skinType.contains('민감')) {
        cautions.add('${profile.skinType} 피부는 오늘 강한 각질 케어와 향이 강한 제품을 쉬어가세요.');
        recommendations.add('새 제품 대신 이미 잘 맞는 진정·장벽 루틴을 유지하세요.');
      } else if (profile.skinType.contains('지성') ||
          profile.primaryConcern == '트러블') {
        recommendations.add('답답하지 않은 워터리 보습과 논코메도제닉 자외선 차단제를 선택하세요.');
      } else if (profile.skinType.contains('건성') ||
          profile.primaryConcern == '보습') {
        recommendations.add('세안 직후 3분 안에 보습제를 발라 수분 증발을 줄이세요.');
      }
    } else {
      recommendations.add('피부 타입을 등록하면 더 개인화된 날씨 루틴을 알려드려요.');
    }

    if (cautions.isEmpty) cautions.add('오늘은 큰 환경 자극이 적어 피부 컨디션이 편안한 편이에요.');
    if (recommendations.isEmpty)
      recommendations.add('기본 보습과 자외선 차단 루틴을 유지하세요.');
    return SkinWeatherAdvice(
      cautions: cautions.take(2).toList(growable: false),
      recommendations: recommendations.take(3).toList(growable: false),
    );
  }
}
