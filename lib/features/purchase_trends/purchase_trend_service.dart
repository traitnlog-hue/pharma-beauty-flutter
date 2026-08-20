import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../models.dart';

/// Sends only catalog product IDs after checkout. No profile, payment, or
/// customer-identifying information is used in the aggregate ranking.
class PurchaseTrendService {
  const PurchaseTrendService({this.baseUrl = _defaultBaseUrl});

  static const _defaultBaseUrl = String.fromEnvironment(
    'PURCHASE_TREND_PROXY_URL',
    defaultValue: 'https://pharma-beauty-weather-proxy.trait-n-log.workers.dev',
  );

  final String baseUrl;

  Future<void> recordCompletedPurchase(Iterable<BeautyProduct> products) async {
    final productIds = products.map((product) => product.id).toSet().toList();
    if (productIds.isEmpty || baseUrl.isEmpty) return;
    try {
      await http
          .post(
            Uri.parse('$baseUrl/purchase-events'),
            headers: const {'Content-Type': 'application/json'},
            body: jsonEncode({'productIds': productIds}),
          )
          .timeout(const Duration(seconds: 8));
    } catch (_) {
      // Checkout remains successful if the optional aggregate cannot sync.
    }
  }

  Future<WeeklyPurchaseRanking?> fetchWeeklyRanking() async {
    if (baseUrl.isEmpty) return null;
    try {
      final response = await http
          .get(Uri.parse('$baseUrl/weekly-ingredient-ranking'))
          .timeout(const Duration(seconds: 8));
      if (response.statusCode != 200) return null;
      final payload = jsonDecode(response.body) as Map<String, dynamic>;
      final items = (payload['items'] as List<dynamic>? ?? const [])
          .whereType<Map<String, dynamic>>()
          .map((item) => WeeklyIngredientRank(
                ingredient: item['ingredient']?.toString() ?? '',
                purchaseCount:
                    int.tryParse(item['purchaseCount']?.toString() ?? '') ?? 0,
              ))
          .where((item) => item.ingredient.isNotEmpty)
          .toList(growable: false);
      return WeeklyPurchaseRanking(
        weekStart: payload['weekStart']?.toString() ?? '',
        totalProductPurchases:
            int.tryParse(payload['totalProductPurchases']?.toString() ?? '') ??
                0,
        items: items,
      );
    } catch (_) {
      return null;
    }
  }
}

class WeeklyPurchaseRanking {
  const WeeklyPurchaseRanking({
    required this.weekStart,
    required this.totalProductPurchases,
    required this.items,
  });

  final String weekStart;
  final int totalProductPurchases;
  final List<WeeklyIngredientRank> items;
}

class WeeklyIngredientRank {
  const WeeklyIngredientRank(
      {required this.ingredient, required this.purchaseCount});

  final String ingredient;
  final int purchaseCount;
}
