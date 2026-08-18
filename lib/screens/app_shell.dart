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
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1.3))),
                  body: CompareScreen(
                      products: appState.comparedProducts,
                      onRemove: toggleCompare),
                )));
  }

  Future<SkinProfile?> editProfile() async {
    final result = await Navigator.push<SkinProfile>(
        context, MaterialPageRoute(builder: (_) => const SkinProfileScreen()));
    if (result != null) appState.updateSkinProfile(result);
    return result;
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
          skinProfile: appState.skinProfile,
          compareIds: appState.compareIds,
          onToggleCompare: toggleCompare,
          onShowCompare: openCompare,
          onOpenProduct: openProduct,
          onAskPharmacist: openPharmacistChat,
          onEditProfile: editProfile,
          onDiscover: () => setState(() => currentIndex = 2)),
      ShopScreen(
          compareIds: appState.compareIds,
          savedIds: appState.savedIds,
          onCompare: toggleCompare,
          onSave: toggleSaved,
          onOpenProduct: openProduct),
      const DiscoverScreen(),
      MySkinScreen(
          skinProfile: appState.skinProfile,
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
          IconButton(
              onPressed: openSearch,
              icon: const Icon(Icons.search_rounded),
              tooltip: '검색'),
          Stack(children: [
            IconButton(
                onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('장바구니가 비어 있어요.'))),
                tooltip: '장바구니',
                icon: const Icon(Icons.shopping_bag_outlined)),
            const Positioned(
                right: 7,
                top: 8,
                child: CircleAvatar(
                    radius: 7,
                    backgroundColor: AppColors.ink,
                    child: Text('0',
                        style: TextStyle(color: Colors.white, fontSize: 7)))),
          ]),
          IconButton(
              onPressed: () => setState(() => currentIndex = 3),
              tooltip: '마이페이지',
              icon: const Icon(Icons.person_outline_rounded)),
          const SizedBox(width: 6),
        ],
      ),
      body: IndexedStack(index: currentIndex, children: pages),
      floatingActionButton: currentIndex == 0
          ? FloatingActionButton.small(
              key: const Key('pharmacist-chat-fab'),
              heroTag: 'pharmacist-chat-home',
              onPressed: openPharmacistChat,
              tooltip: 'AI 약사 챗봇',
              backgroundColor: AppColors.fuchsia,
              foregroundColor: Colors.white,
              elevation: 2,
              child: const Icon(Icons.chat_bubble_outline_rounded, size: 19),
            )
          : FloatingActionButton.extended(
              key: const Key('pharmacist-chat-fab'),
              heroTag: 'pharmacist-chat',
              onPressed: openPharmacistChat,
              backgroundColor: AppColors.fuchsia,
              foregroundColor: Colors.white,
              elevation: 2,
              icon: const Icon(Icons.chat_bubble_outline_rounded, size: 19),
              label: const Text('AI 약사 챗봇',
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700)),
            ),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.fromLTRB(12, 0, 12, 10),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.line),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: NavigationBar(
              selectedIndex: currentIndex,
              onDestinationSelected: (index) =>
                  setState(() => currentIndex = index),
              height: 64,
              backgroundColor: AppColors.surface,
              surfaceTintColor: Colors.transparent,
              indicatorColor: AppColors.blush,
              indicatorShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
              labelTextStyle:
                  WidgetStateProperty.resolveWith((states) => TextStyle(
                        fontSize: 10,
                        fontWeight: states.contains(WidgetState.selected)
                            ? FontWeight.w700
                            : FontWeight.w600,
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
                    icon: Icon(Icons.grid_view_outlined),
                    selectedIcon: Icon(Icons.grid_view_rounded),
                    label: '쇼핑'),
                NavigationDestination(
                    icon: Icon(Icons.science_outlined),
                    selectedIcon: Icon(Icons.science_rounded),
                    label: '트렌드'),
                NavigationDestination(
                    icon: Icon(Icons.person_outline_rounded),
                    selectedIcon: Icon(Icons.person_rounded),
                    label: '마이스킨'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
