import 'dart:ui';

import 'package:flutter/material.dart';

import '../models.dart';
import '../state/app_state.dart';
import '../theme.dart';
import '../widgets/brand_widgets.dart';
import '../widgets/product_search_delegate.dart';
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
  late final AppState appState;

  @override
  void initState() {
    super.initState();
    appState = AppState()..addListener(_refresh);
  }

  @override
  void dispose() {
    appState
      ..removeListener(_refresh)
      ..dispose();
    super.dispose();
  }

  void _refresh() => setState(() {});

  void toggleCompare(BeautyProduct product) {
    if (appState.toggleCompare(product)) return;
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('비교는 최대 3개까지 가능해요.')));
  }

  void toggleSaved(BeautyProduct product) => appState.toggleSaved(product);

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
                      products: appState.comparedProducts,
                      onRemove: toggleCompare),
                )));
  }

  Future<void> editProfile() async {
    final result = await Navigator.push<String>(
        context, MaterialPageRoute(builder: (_) => const SkinProfileScreen()));
    if (result != null) appState.updateProfileConcern(result);
  }

  void openProduct(BeautyProduct product) {
    appState.recordViewed(product);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => ProductDetailScreen(
                  product: product,
                  onCompare: () => toggleCompare(product),
                  initiallySaved: appState.savedIds.contains(product.id),
                  onToggleSaved: () => toggleSaved(product),
                )));
  }

  Future<void> openSearch() async {
    final result = await showSearch<BeautyProduct?>(
        context: context, delegate: ProductSearchDelegate());
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
          compareIds: appState.compareIds,
          onToggleCompare: toggleCompare,
          onShowCompare: openCompare,
          onOpenProduct: openProduct,
          onAskPharmacist: openPharmacistChat,
          onDiscover: () => setState(() => currentIndex = 2)),
      ShopScreen(
          compareIds: appState.compareIds,
          savedIds: appState.savedIds,
          onCompare: toggleCompare,
          onSave: toggleSaved,
          onOpenProduct: openProduct),
      const DiscoverScreen(),
      MySkinScreen(
          profileConcern: appState.profileConcern,
          savedIds: appState.savedIds,
          recentIds: appState.recentIds,
          onEditProfile: editProfile,
          onOpenProduct: openProduct,
          onToggleSave: toggleSaved),
    ];

    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        toolbarHeight: 68,
        titleSpacing: 20,
        title: const BrandLogo(),
        actions: [
          IconButton.filledTonal(
              onPressed: openSearch,
              icon: const Icon(Icons.search, size: 22),
              tooltip: '검색'),
          Badge(
            isLabelVisible: appState.compareIds.isNotEmpty,
            label: Text('${appState.compareIds.length}'),
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
      floatingActionButton: currentIndex == 0
          ? null
          : FloatingActionButton.extended(
              key: const Key('pharmacist-chat-fab'),
              heroTag: 'pharmacist-chat',
              onPressed: openPharmacistChat,
              backgroundColor: AppColors.fuchsia,
              foregroundColor: Colors.white,
              elevation: 8,
              icon: const CircleAvatar(
                radius: 16,
                backgroundColor: AppColors.blush,
                backgroundImage:
                    AssetImage('assets/editorial/ai-molecule-violet-3d.png'),
              ),
              label: const Text('AI 약사 챗봇',
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900)),
            ),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.fromLTRB(14, 0, 14, 12),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(26),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.pearl.withValues(alpha: .88),
                borderRadius: BorderRadius.circular(26),
                border: Border.all(color: AppColors.line),
                boxShadow: const [
                  BoxShadow(
                      color: Color(0x20252123),
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
                indicatorColor: AppColors.fuchsia.withValues(alpha: .13),
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
                      label: '홈'),
                  NavigationDestination(
                      icon: Icon(Icons.grid_view_rounded),
                      selectedIcon: Icon(Icons.grid_view_rounded),
                      label: '쇼핑'),
                  NavigationDestination(
                      icon: Icon(Icons.bubble_chart_outlined),
                      selectedIcon: Icon(Icons.bubble_chart_rounded),
                      label: '트렌드'),
                  NavigationDestination(
                      icon: Icon(Icons.face_outlined),
                      selectedIcon: Icon(Icons.face_rounded),
                      label: '마이스킨'),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
