import 'dart:convert';

import 'package:http/http.dart' as http;

/// Checks that the Worker can reach the current Cosmetics Act text published
/// by the 국가법령정보 공동활용 Open API. The app keeps the full legal text at
/// its official source instead of storing a potentially stale local copy.
class CosmeticsLawService {
  const CosmeticsLawService({this.proxyUrl = _defaultProxyUrl});

  static const _defaultProxyUrl = String.fromEnvironment(
    'COSMETICS_LAW_PROXY_URL',
    defaultValue:
        'https://pharma-beauty-weather-proxy.trait-n-log.workers.dev/laws/cosmetics',
  );

  final String proxyUrl;

  Future<CosmeticsLawStatus?> checkCurrentLaw() async {
    if (proxyUrl.isEmpty) return null;
    try {
      final response = await http
          .get(Uri.parse(proxyUrl))
          .timeout(const Duration(seconds: 8));
      if (response.statusCode != 200) return null;
      final payload = jsonDecode(response.body) as Map<String, dynamic>;
      return CosmeticsLawStatus(
        source: payload['source']?.toString() ?? '국가법령정보 공동활용',
        officialUrl: payload['officialUrl']?.toString() ??
            'https://www.law.go.kr/법령/화장품법',
      );
    } catch (_) {
      return null;
    }
  }
}

class CosmeticsLawStatus {
  const CosmeticsLawStatus({required this.source, required this.officialUrl});

  final String source;
  final String officialUrl;
}
