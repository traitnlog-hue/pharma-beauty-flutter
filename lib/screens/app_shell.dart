import 'dart:ui';

import 'package:flutter/material.dart';

import '../catalog.dart';
import '../models.dart';
import '../theme.dart';
import '../widgets/brand_widgets.dart';
import 'compare_screen.dart';
import 'discover_screen.dart';
import 'home_screen.dart';
import 'my_skin_screen.dart';
import 'pharmacist_chat_screen.dart';
import 'product_detail_screen.dart';
import 'profile_screen.dart';
import 'shop_screen.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int currentIndex = 0;
  String profileConcern = concerns.first;
  final compareIds = <int>{};
  final savedIds = <int>{1, 3};
  final recentIds = <int>[2];

  List<BeautyProduct> get comparedProducts =>
      products.where((product) => compareIds.contains(product.id)).toList();

  void toggleCompare(BeautyProduct product) {
    setState(() {
      if (compareIds.contains(product.id)) {
        compareIds.remove(product.id);
      } else if (compareIds.length < 3) {
        compareIds.add(product.id);
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('비교는 최대 3개까지 가능해요.')));
      }
    });
  }

  void toggleSaved(BeautyProduct product) {
    setState(() {
      if (!savedIds.add(product.id)) savedIds.remove(product.id);
    });
  }

  void openCompare() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => Scaffold(
                  appBar: AppBar(
                      title: const Text('SMART COMPARE',
                          style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1.3))),
                  body: CompareScreen(
                      products: comparedProducts, onRemove: toggleCompare),
                )));
  }

  Future<void> editProfile() async {
    final result = await Navigator.push<String>(
        context, MaterialPageRoute(builder: (_) => const SkinProfileScreen()));
    if (result != null) setState(() => profileConcern = result);
  }

  void openProduct(BeautyProduct product) {
    setState(() {
      recentIds.remove(product.id);
      recentIds.insert(0, product.id);
      if (recentIds.length > 5) recentIds.removeLast();
    });
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => ProductDetailScreen(
                  product: product,
                  onCompare: () => toggleCompare(product),
                  initiallySaved: savedIds.contains(product.id),
                  onToggleSaved: () => toggleSaved(product),
                )));
  }

  Future<void> openSearch() async {
    final result = await showSearch<BeautyProduct?>(
        context: context, delegate: _ProductSearch());
    if (result != null && mounted) openProduct(result);
  }

  void openPharmacistChat() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const PharmacistChatScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      HomeScreen(
          compareIds: compareIds,
          onToggleCompare: toggleCompare,
          onShowCompare: openCompare,
          onOpenProduct: openProduct,
          onAskPharmacist: openPharmacistChat,
          onDiscover: () => setState(() => currentIndex = 2)),
      ShopScreen(
          compareIds: compareIds,
          savedIds: savedIds,
          onCompare: toggleCompare,
          onSave: toggleSaved,
          onOpenProduct: openProduct),
      const DiscoverScreen(),
      MySkinScreen(
          profileConcern: profileConcern,
          savedIds: savedIds,
          recentIds: recentIds,
          onEditProfile: editProfile,
          onOpenProduct: openProduct,
          onToggleSave: toggleSaved),
    ];

    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        toolbarHeight: 72,
        titleSpacing: 20,
        title: const BrandLogo(),
        actions: [
          IconButton.filledTonal(
              onPressed: openSearch,
              icon: const Icon(Icons.search, size: 22),
              tooltip: '검색'),
          Badge(
            isLabelVisible: compareIds.isNotEmpty,
            label: Text('${compareIds.length}'),
            child: IconButton.filledTonal(
                onPressed: openCompare,
                icon: const Icon(Icons.compare_arrows, size: 21),
                tooltip: '제품 비교'),
          ),
          Stack(children: [
            IconButton.filledTonal(
                onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('장바구니가 비어 있어요.'))),
                icon: const Icon(Icons.shopping_bag_outlined, size: 21)),
            const Positioned(
                right: 7,
                top: 8,
                child: CircleAvatar(
                    radius: 7,
                    backgroundColor: AppColors.ink,
                    child: Text('0',
                        style: TextStyle(color: Colors.white, fontSize: 7)))),
          ]),
          const SizedBox(width: 6),
        ],
      ),
      body: IndexedStack(index: currentIndex, children: pages),
      floatingActionButton: FloatingActionButton.extended(
        key: const Key('pharmacist-chat-fab'),
        heroTag: 'pharmacist-chat',
        onPressed: openPharmacistChat,
        backgroundColor: AppColors.deep,
        foregroundColor: Colors.white,
        elevation: 8,
        icon: const CircleAvatar(
          radius: 16,
          backgroundImage: AssetImage('assets/characters/pharmacist-lia.png'),
        ),
        label: const Text('리아 약사',
            style: TextStyle(fontSize: 11, fontWeight: FontWeight.w900)),
      ),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.fromLTRB(14, 0, 14, 12),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(26),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: .82),
                borderRadius: BorderRadius.circular(26),
                border: Border.all(color: Colors.white.withValues(alpha: .75)),
                boxShadow: const [
                  BoxShadow(
                      color: Color(0x1F10201D),
                      blurRadius: 28,
                      offset: Offset(0, 10))
                ],
              ),
              child: NavigationBar(
                selectedIndex: currentIndex,
                onDestinationSelected: (index) =>
                    setState(() => currentIndex = index),
                height: 66,
                backgroundColor: Colors.transparent,
                surfaceTintColor: Colors.transparent,
                indicatorColor: AppColors.lime,
                indicatorShape: const StadiumBorder(),
                labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
                labelTextStyle:
                    WidgetStateProperty.resolveWith((states) => TextStyle(
                          fontSize: 9,
                          fontWeight: states.contains(WidgetState.selected)
                              ? FontWeight.w900
                              : FontWeight.w700,
                          color: states.contains(WidgetState.selected)
                              ? AppColors.ink
                              : AppColors.muted,
                        )),
                destinations: const [
                  NavigationDestination(
                      icon: Icon(Icons.home_outlined),
                      selectedIcon: Icon(Icons.home_rounded),
                      label: 'HOME'),
                  NavigationDestination(
                      icon: Icon(Icons.grid_view_rounded),
                      selectedIcon: Icon(Icons.grid_view_rounded),
                      label: 'SHOP'),
                  NavigationDestination(
                      icon: Icon(Icons.bubble_chart_outlined),
                      selectedIcon: Icon(Icons.bubble_chart_rounded),
                      label: 'TRENDS'),
                  NavigationDestination(
                      icon: Icon(Icons.face_outlined),
                      selectedIcon: Icon(Icons.face_rounded),
                      label: 'MY SKIN'),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ProductSearch extends SearchDelegate<BeautyProduct?> {
  @override
  String get searchFieldLabel => '피부 고민, 성분, 제품 검색';

  @override
  List<Widget>? buildActions(BuildContext context) => [
        if (query.isNotEmpty)
          IconButton(onPressed: () => query = '', icon: const Icon(Icons.close))
      ];
  @override
  Widget? buildLeading(BuildContext context) => IconButton(
      onPressed: () => close(context, null),
      icon: const Icon(Icons.arrow_back));
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
            onTap: () => close(context, product));
      },
    );
  }
}
