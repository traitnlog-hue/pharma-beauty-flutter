import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../models.dart';

class IngredientDictionaryService {
  const IngredientDictionaryService({this.proxyUrl = _defaultProxyUrl});

  static const _defaultProxyUrl = String.fromEnvironment(
    'INGREDIENT_PROXY_URL',
    defaultValue:
        'https://pharma-beauty-weather-proxy.trait-n-log.workers.dev/ingredients',
  );

  final String proxyUrl;

  Future<List<IngredientInfo>> search(String rawQuery) async {
    final query = rawQuery.trim();
    if (query.isEmpty || proxyUrl.isEmpty) return const [];
    try {
      final uri = Uri.parse(proxyUrl).replace(queryParameters: {'q': query});
      final response = await http.get(uri).timeout(const Duration(seconds: 8));
      if (response.statusCode != 200) return const [];
      final payload = jsonDecode(response.body) as Map<String, dynamic>;
      final items = (payload['items'] as List<dynamic>? ?? const []);
      return items
          .whereType<Map<String, dynamic>>()
          .map(_toIngredient)
          .where((item) => item.name.isNotEmpty || item.englishName.isNotEmpty)
          .toList(growable: false);
    } catch (_) {
      return const [];
    }
  }

  IngredientInfo _toIngredient(Map<String, dynamic> item) {
    String value(String key) => item[key]?.toString().trim() ?? '';
    final standardName = value('standardName');
    final englishName = value('englishName');
    final casNo = value('casNo');
    final origin = value('originAndDefinition');
    final aliases = value('aliases');
    return IngredientInfo(
      name: standardName.isEmpty ? englishName : standardName,
      englishName: englishName.isEmpty ? standardName : englishName,
      category: '식약처 성분 DB',
      summary: origin.isEmpty ? '식품의약품안전처 화장품 원료성분정보에서 제공하는 성분입니다.' : origin,
      benefits: [
        if (casNo.isNotEmpty) 'CAS $casNo',
        '식약처 원료성분정보',
      ],
      goodWith: aliases.isEmpty ? const [] : [aliases],
      cautionWith: const [],
    );
  }
}
