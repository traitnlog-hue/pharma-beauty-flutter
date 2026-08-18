import 'package:flutter/material.dart';

import '../catalog.dart';
import '../models.dart';
import '../theme.dart';
import '../widgets/brand_widgets.dart';
import 'routine_builder_screen.dart';

part 'home_sections.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    required this.skinProfile,
    required this.compareIds,
    required this.onToggleCompare,
    required this.onShowCompare,
    required this.onOpenProduct,
    required this.onAskPharmacist,
    required this.onEditProfile,
    required this.onDiscover,
    super.key,
  });

  final SkinProfile skinProfile;
  final Set<int> compareIds;
  final ValueChanged<BeautyProduct> onToggleCompare;
  final VoidCallback onShowCompare;
  final ValueChanged<BeautyProduct> onOpenProduct;
  final VoidCallback onAskPharmacist;
  final Future<SkinProfile?> Function() onEditProfile;
  final VoidCallback onDiscover;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late String selectedConcern;

  @override
  void initState() {
    super.initState();
    selectedConcern = widget.skinProfile.primaryConcern;
  }

  @override
  void didUpdateWidget(covariant HomeScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.skinProfile != widget.skinProfile &&
        widget.skinProfile.isComplete) {
      selectedConcern = widget.skinProfile.primaryConcern;
    }
  }

  List<BeautyProduct> get matches {
    final result = [...products];
    result.sort((a, b) {
      if (a.concern == selectedConcern) return -1;
      if (b.concern == selectedConcern) return 1;
      return b.match.compareTo(a.match);
    });
    return result;
  }

  Future<void> openProfile() async {
    final result = await widget.onEditProfile();
    if (result != null && mounted) {
      setState(() => selectedConcern = result.primaryConcern);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      CustomScrollView(slivers: [
        SliverToBoxAdapter(child: _Hero(onOpen: widget.onDiscover)),
        SliverToBoxAdapter(
            child: _SkinChartCard(
                profile: widget.skinProfile, onOpen: openProfile)),
        SliverToBoxAdapter(
            child: _SelfCareManifesto(
                onProfile: openProfile,
                onDiscover: widget.onDiscover,
                onAsk: widget.onAskPharmacist)),
        SliverToBoxAdapter(
            child: _CoreHooks(
                onProfile: openProfile,
                onRoutine: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const RoutineBuilderScreen())),
                onCompare: widget.onShowCompare)),
        const SliverToBoxAdapter(child: _BrandStory()),
        const SliverToBoxAdapter(child: _DailyBrief()),
        SliverToBoxAdapter(
            child: _ConcernPulse(
                selected: selectedConcern,
                onSelect: (value) => setState(() => selectedConcern = value))),
        SliverToBoxAdapter(
            child: _MatchPicks(
                products: matches.take(4).toList(),
                profile: widget.skinProfile,
                compareIds: widget.compareIds,
                onOpen: widget.onOpenProduct,
                onCompare: widget.onToggleCompare)),
        SliverToBoxAdapter(child: _IngredientPulse(onOpen: widget.onDiscover)),
        SliverToBoxAdapter(
            child: _RoutinePreview(
                onOpen: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const RoutineBuilderScreen())))),
        const SliverToBoxAdapter(child: SizedBox(height: 125)),
      ]),
      if (widget.compareIds.isNotEmpty)
        Positioned(
          left: 20,
          right: 20,
          bottom: 160,
          child: Material(
            color: AppColors.berry,
            borderRadius: BorderRadius.circular(22),
            elevation: 12,
            shadowColor: AppColors.deep.withValues(alpha: .28),
            child: InkWell(
              borderRadius: BorderRadius.circular(22),
              onTap: widget.onShowCompare,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                child: Row(children: [
                  Container(
                      width: 34,
                      height: 34,
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(
                          color: AppColors.champagne, shape: BoxShape.circle),
                      child: Text('${widget.compareIds.length}',
                          style: const TextStyle(fontWeight: FontWeight.w700))),
                  const SizedBox(width: 12),
                  const Expanded(
                      child: Text('비교할 제품이 준비됐어요',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w800))),
                  const Icon(Icons.arrow_forward_rounded,
                      color: Colors.white, size: 19),
                ]),
              ),
            ),
          ),
        ),
    ]);
  }
}
