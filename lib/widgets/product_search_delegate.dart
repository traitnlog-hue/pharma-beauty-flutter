import 'package:flutter/material.dart';

import '../catalog.dart';
import '../models.dart';

class ProductSearchDelegate extends SearchDelegate<BeautyProduct?> {
  @override
  String get searchFieldLabel => '피부 고민, 성분, 제품 검색';

  @override
  List<Widget>? buildActions(BuildContext context) => [
        if (query.isNotEmpty)
          IconButton(
              onPressed: () => query = '', icon: const Icon(Icons.close)),
      ];

  @override
  Widget? buildLeading(BuildContext context) => IconButton(
        onPressed: () => close(context, null),
        icon: const Icon(Icons.arrow_back),
      );

  @override
  Widget buildResults(BuildContext context) => _results();

  @override
  Widget buildSuggestions(BuildContext context) => _results();

  Widget _results() {
    final normalized = query.toLowerCase();
    final result = products
        .where((item) =>
            item.name.toLowerCase().contains(normalized) ||
            item.brand.toLowerCase().contains(normalized) ||
            item.concern.contains(query) ||
            item.category.contains(query) ||
            item.ingredients.any((value) => value.contains(query)))
        .toList();

    return ListView.separated(
      padding: const EdgeInsets.all(20),
      itemCount: result.length,
      separatorBuilder: (_, __) => const Divider(),
      itemBuilder: (context, index) {
        final product = result[index];
        return ListTile(
          title: Text(product.name),
          subtitle: Text('${product.concern} · ${product.ingredients.first}'),
          trailing: Text('${product.match}%'),
          onTap: () => close(context, product),
        );
      },
    );
  }
}
