part of 'home_screen.dart';

class _AskPharmacist extends StatelessWidget {
  const _AskPharmacist({required this.onOpen});
  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(14, 18, 14, 0),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1080),
            child: Material(
              color: AppColors.blush,
              borderRadius: BorderRadius.circular(32),
              clipBehavior: Clip.antiAlias,
              child: InkWell(
                onTap: onOpen,
                child: SizedBox(
                  height: 226,
                  child: Row(children: [
                    Expanded(
                      flex: 58,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(24, 22, 8, 22),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Row(children: [
                              CircleAvatar(
                                  radius: 4,
                                  backgroundColor: AppColors.fuchsia),
                              SizedBox(width: 7),
                              Text('PRIVATE BEAUTY CONSULT · ONLINE',
                                  style: TextStyle(
                                      color: AppColors.berry,
                                      fontSize: 9,
                                      fontWeight: FontWeight.w900,
                                      letterSpacing: 1)),
                            ]),
                            const Spacer(),
                            Text('오늘의 피부 고민,\n리아 약사에게 맡겨보세요.',
                                style:
                                    Theme.of(context).textTheme.headlineMedium),
                            const SizedBox(height: 12),
                            const Row(children: [
                              Text('1:1 프라이빗 상담 시작',
                                  style: TextStyle(
                                      color: AppColors.berry,
                                      fontSize: 11,
                                      fontWeight: FontWeight.w900)),
                              SizedBox(width: 5),
                              Icon(Icons.arrow_forward_rounded,
                                  color: AppColors.berry, size: 16),
                            ]),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 42,
                      child: Stack(fit: StackFit.expand, children: [
                        Image.asset(
                          'assets/characters/pharmacist-lia-pink-glam.png',
                          fit: BoxFit.cover,
                          alignment: const Alignment(.05, -.32),
                        ),
                        const DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [AppColors.blush, Colors.transparent],
                              begin: Alignment.centerLeft,
                              end: Alignment.center,
                            ),
                          ),
                        ),
                      ]),
                    ),
                  ]),
                ),
              ),
            ),
          ),
        ),
      );
}

class _Hero extends StatelessWidget {
  const _Hero({required this.onProfile});
  final VoidCallback onProfile;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(14, 4, 14, 0),
        child: LayoutBuilder(builder: (context, constraints) {
          final wide = constraints.maxWidth > 860;
          return Container(
            height: wide ? 560 : 500,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              color: AppColors.oatmeal,
              borderRadius: BorderRadius.circular(34),
              border: Border.all(color: Colors.white.withValues(alpha: .7)),
              boxShadow: const [
                BoxShadow(
                    color: Color(0x24252123),
                    blurRadius: 30,
                    offset: Offset(0, 14))
              ],
            ),
            child: Stack(fit: StackFit.expand, children: [
              Image.asset(
                'assets/editorial/dusty-surreal-hero.png',
                fit: BoxFit.cover,
                alignment: wide ? const Alignment(.45, 0) : Alignment.center,
              ),
              DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: wide ? Alignment.centerLeft : Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: wide
                        ? const [
                            Color(0xD91C1B1C),
                            Color(0x801C1B1C),
                            Colors.transparent,
                            Color(0x401C1B1C)
                          ]
                        : const [
                            Colors.transparent,
                            Color(0x121C1B1C),
                            Color(0x991C1B1C),
                            Color(0xE61C1B1C)
                          ],
                    stops: const [0, .36, .72, 1],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(
                    wide ? 44 : 22, wide ? 38 : 20, wide ? 44 : 22, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(children: [
                      const _GlassLabel(label: 'TODAY · SKIN CHECK'),
                      const Spacer(),
                      Text('08.14',
                          style: TextStyle(
                              color: AppColors.ink.withValues(alpha: .72),
                              fontSize: 10,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1)),
                    ]),
                    const Spacer(),
                    ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: wide ? 470 : 330),
                      child: Text('오늘 피부,\n가볍게 체크해볼까?',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: wide ? 54 : 34,
                              height: 1.08,
                              fontWeight: FontWeight.w800,
                              letterSpacing: wide ? -3 : -1.8)),
                    ),
                    const SizedBox(height: 12),
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 390),
                      child: const Text(
                        '복잡한 질문 없이 3분이면 충분해요.\n내 피부가 원하는 케어부터 확인해보세요.',
                        style: TextStyle(
                            color: Color(0xFFF7EFED),
                            fontSize: 14,
                            height: 1.55,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    const SizedBox(height: 18),
                    FilledButton.icon(
                      style: FilledButton.styleFrom(
                          backgroundColor: AppColors.ink,
                          foregroundColor: Colors.white,
                          minimumSize: const Size(0, 50),
                          side: BorderSide(
                              color: Colors.white.withValues(alpha: .18))),
                      onPressed: onProfile,
                      icon: const Icon(Icons.arrow_forward_rounded, size: 18),
                      label: const Text('3분 피부 체크'),
                    ),
                  ],
                ),
              ),
              Positioned(
                top: wide ? 92 : 78,
                right: 18,
                child: const _SkinSignalCard(),
              ),
            ]),
          );
        }),
      );
}

class _GlassLabel extends StatelessWidget {
  const _GlassLabel({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 9),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: .62),
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: Colors.white.withValues(alpha: .72)),
        ),
        child: Text(label,
            style: const TextStyle(
                color: AppColors.ink,
                fontSize: 9,
                fontWeight: FontWeight.w900,
                letterSpacing: .9)),
      );
}

class _SkinSignalCard extends StatelessWidget {
  const _SkinSignalCard();

  @override
  Widget build(BuildContext context) => Container(
        width: 98,
        padding: const EdgeInsets.fromLTRB(14, 13, 14, 12),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: .66),
          borderRadius: BorderRadius.circular(25),
          border: Border.all(color: Colors.white.withValues(alpha: .78)),
          boxShadow: const [
            BoxShadow(
                color: Color(0x19252123), blurRadius: 18, offset: Offset(0, 8))
          ],
        ),
        child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('42%',
                  style: TextStyle(
                      color: AppColors.ink,
                      fontSize: 25,
                      height: 1,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -1.2)),
              SizedBox(height: 7),
              Text('수분 신호',
                  style: TextStyle(
                      color: AppColors.muted,
                      fontSize: 10,
                      fontWeight: FontWeight.w800)),
            ]),
      );
}

class _SelfCareManifesto extends StatelessWidget {
  const _SelfCareManifesto(
      {required this.onProfile, required this.onDiscover, required this.onAsk});

  final VoidCallback onProfile;
  final VoidCallback onDiscover;
  final VoidCallback onAsk;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 28, 20, 0),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1080),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('바로 시작하기',
                  style: TextStyle(
                      color: AppColors.ink,
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -.8)),
              const SizedBox(height: 5),
              const Text('궁금한 케어를 빠르게 찾아보세요.',
                  style: TextStyle(color: AppColors.muted, fontSize: 13)),
              const SizedBox(height: 16),
              Row(children: [
                Expanded(
                    child: _QuickAction(
                        icon: Icons.face_retouching_natural_rounded,
                        label: '피부 체크',
                        color: AppColors.blush,
                        onTap: onProfile)),
                const SizedBox(width: 8),
                Expanded(
                    child: _QuickAction(
                        icon: Icons.bubble_chart_outlined,
                        label: '성분 트렌드',
                        color: AppColors.paper2,
                        onTap: onDiscover)),
                const SizedBox(width: 8),
                Expanded(
                    child: _QuickAction(
                        icon: Icons.auto_awesome_outlined,
                        label: '루틴 만들기',
                        color: AppColors.oatmeal,
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) =>
                                    const RoutineBuilderScreen())))),
                const SizedBox(width: 8),
                Expanded(
                    child: _QuickAction(
                        key: const Key('pharmacist-home-action'),
                        icon: Icons.chat_bubble_outline_rounded,
                        label: '약사 상담',
                        color: AppColors.surface,
                        onTap: onAsk)),
              ]),
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: AppColors.ink,
                  borderRadius: BorderRadius.circular(22),
                ),
                child: const Row(children: [
                  CircleAvatar(
                      radius: 14,
                      backgroundColor: AppColors.fuchsia,
                      child: Icon(Icons.favorite_outline_rounded,
                          color: Colors.white, size: 15)),
                  SizedBox(width: 11),
                  Expanded(
                    child: Text('오늘은 액티브 성분 하나만, 보습은 충분히.',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            height: 1.4,
                            fontWeight: FontWeight.w700)),
                  ),
                  Icon(Icons.arrow_forward_rounded,
                      color: AppColors.ballerina, size: 17),
                ]),
              ),
            ]),
          ),
        ),
      );
}

class _QuickAction extends StatelessWidget {
  const _QuickAction(
      {required this.icon,
      required this.label,
      required this.color,
      required this.onTap,
      super.key});

  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Material(
        color: color,
        borderRadius: BorderRadius.circular(22),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: SizedBox(
            height: 94,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 13, 8, 11),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 34,
                      height: 34,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: .72),
                          shape: BoxShape.circle),
                      child: Icon(icon, color: AppColors.ink, size: 18),
                    ),
                    const Spacer(),
                    Text(label,
                        maxLines: 2,
                        style: const TextStyle(
                            color: AppColors.ink,
                            fontSize: 11,
                            height: 1.2,
                            fontWeight: FontWeight.w800)),
                  ]),
            ),
          ),
        ),
      );
}

class _DailyBrief extends StatelessWidget {
  const _DailyBrief();
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 46, 20, 0),
        child: Center(
            child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1080),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const _SectionTitle(
                kicker: 'TODAY · SKIN BRIEF',
                title: '오늘의 피부 브리핑',
                subtitle: '프로필과 계절 신호를 바탕으로 우선순위를 정리했어요.'),
            const SizedBox(height: 20),
            LayoutBuilder(builder: (context, constraints) {
              final wide = constraints.maxWidth > 700;
              final cards = [
                const _BriefCard(
                    color: AppColors.mint,
                    icon: Icons.water_drop_rounded,
                    value: '42%',
                    label: '수분 방어력',
                    caption: '보습 레이어 +1 권장'),
                const _BriefCard(
                    color: AppColors.butter,
                    icon: Icons.shield_moon_rounded,
                    value: 'LOW',
                    label: '자극 리스크',
                    caption: '액티브 성분 1개만'),
                const _BriefCard(
                    color: Color(0xFFE1DBFF),
                    icon: Icons.nights_stay_rounded,
                    value: 'PM',
                    label: '집중 루틴',
                    caption: '장벽 회복 · 진정'),
              ];
              return wide
                  ? SizedBox(
                      height: 168,
                      child: Row(children: [
                        for (var i = 0; i < cards.length; i++) ...[
                          Expanded(child: cards[i]),
                          if (i < cards.length - 1) const SizedBox(width: 10)
                        ]
                      ]),
                    )
                  : SizedBox(
                      height: 168,
                      child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: cards.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(width: 10),
                          itemBuilder: (_, index) =>
                              SizedBox(width: 210, child: cards[index])));
            }),
          ]),
        )),
      );
}

class _ConcernPulse extends StatelessWidget {
  const _ConcernPulse({required this.selected, required this.onSelect});
  final String selected;
  final ValueChanged<String> onSelect;
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 68, 20, 0),
        child: Center(
            child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1080),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const _SectionTitle(
                kicker: 'QUICK MATCH',
                title: '어떤 신호가 가장 신경 쓰이나요?',
                subtitle: '고민을 탭하면 매치 결과가 실시간으로 바뀝니다.'),
            const SizedBox(height: 20),
            SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                    children: concerns.map((value) {
                  final active = selected == value;
                  return Padding(
                    padding: const EdgeInsets.only(right: 9),
                    child: ChoiceChip(
                        label: Text(value),
                        selected: active,
                        showCheckmark: false,
                        labelStyle: TextStyle(
                            color: active ? Colors.white : AppColors.ink,
                            fontWeight: FontWeight.w800),
                        onSelected: (_) => onSelect(value)),
                  );
                }).toList())),
          ]),
        )),
      );
}

class _MatchPicks extends StatelessWidget {
  const _MatchPicks(
      {required this.products,
      required this.compareIds,
      required this.onOpen,
      required this.onCompare});
  final List<BeautyProduct> products;
  final Set<int> compareIds;
  final ValueChanged<BeautyProduct> onOpen;
  final ValueChanged<BeautyProduct> onCompare;
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(top: 30),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Center(
                  child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 1080),
                      child: Row(children: [
                        Text('MATCH PICKS',
                            style: Theme.of(context).textTheme.headlineMedium),
                        const Spacer(),
                        Text('${products.length} PICKS',
                            style: const TextStyle(
                                color: AppColors.violet,
                                fontSize: 10,
                                fontWeight: FontWeight.w900))
                      ])))),
          const SizedBox(height: 18),
          SizedBox(
            height: 430,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              scrollDirection: Axis.horizontal,
              itemCount: products.length,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                final product = products[index];
                final selected = compareIds.contains(product.id);
                return SizedBox(
                  width: 270,
                  child: Material(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(28),
                    clipBehavior: Clip.antiAlias,
                    child: InkWell(
                      onTap: () => onOpen(product),
                      child: Column(children: [
                        Stack(children: [
                          ProductBottle(product: product, height: 235),
                          Positioned(
                              left: 14,
                              top: 14,
                              child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 7),
                                  decoration: BoxDecoration(
                                      color: AppColors.lime,
                                      borderRadius: BorderRadius.circular(30)),
                                  child: Text('${product.match}% MATCH',
                                      style: const TextStyle(
                                          fontSize: 9,
                                          fontWeight: FontWeight.w900)))),
                          Positioned(
                              right: 10,
                              top: 10,
                              child: IconButton.filledTonal(
                                  onPressed: () => onCompare(product),
                                  icon: Icon(
                                      selected
                                          ? Icons.check_rounded
                                          : Icons.compare_arrows_rounded,
                                      size: 17))),
                        ]),
                        Expanded(
                            child: Padding(
                                padding: const EdgeInsets.all(18),
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(product.brand,
                                          style: const TextStyle(
                                              color: AppColors.violet,
                                              fontSize: 8,
                                              fontWeight: FontWeight.w900,
                                              letterSpacing: .8)),
                                      const SizedBox(height: 7),
                                      Text(product.name,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                              fontSize: 17,
                                              fontWeight: FontWeight.w900)),
                                      const SizedBox(height: 8),
                                      Text(
                                          product.ingredients
                                              .take(2)
                                              .join(' · '),
                                          style: const TextStyle(
                                              color: AppColors.muted,
                                              fontSize: 10)),
                                      const Spacer(),
                                      Row(children: [
                                        Text(product.formattedPrice,
                                            style: const TextStyle(
                                                fontSize: 13,
                                                fontWeight: FontWeight.w900)),
                                        const Spacer(),
                                        const CircleAvatar(
                                            radius: 16,
                                            backgroundColor: AppColors.ink,
                                            child: Icon(
                                                Icons.arrow_outward_rounded,
                                                color: Colors.white,
                                                size: 16))
                                      ]),
                                    ]))),
                      ]),
                    ),
                  ),
                );
              },
            ),
          ),
        ]),
      );
}

class _IngredientPulse extends StatelessWidget {
  const _IngredientPulse({required this.onOpen});
  final VoidCallback onOpen;
  @override
  Widget build(BuildContext context) => Container(
        margin: const EdgeInsets.fromLTRB(14, 70, 14, 0),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
            gradient: const LinearGradient(
                colors: [AppColors.violet, Color(0xFF4D34D8)]),
            borderRadius: BorderRadius.circular(32)),
        child: Center(
            child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1000),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const _StatusPill(
                icon: Icons.graphic_eq_rounded,
                label: 'INGREDIENT PULSE · +31%'),
            const SizedBox(height: 28),
            Text('이번 주 가장 빠르게 뜨는\n성분은 레티날이에요.',
                style: Theme.of(context)
                    .textTheme
                    .headlineLarge
                    ?.copyWith(color: Colors.white)),
            const SizedBox(height: 13),
            const Text('탄력과 피부 결 관심이 올라가고 있어요. 단, BHA와 같은 날 사용하면 자극 신호를 확인하세요.',
                style: TextStyle(color: Color(0xFFE3DEFF), height: 1.6)),
            const SizedBox(height: 24),
            Row(children: [
              Expanded(
                  child: _PulseMini(
                      value: '89',
                      label: 'TREND SCORE',
                      color: AppColors.lime)),
              const SizedBox(width: 10),
              const Expanded(
                  child: _PulseMini(
                      value: '2',
                      label: 'ROUTINE ALERT',
                      color: AppColors.coral)),
            ]),
            const SizedBox(height: 22),
            FilledButton.icon(
                style: FilledButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: AppColors.ink),
                onPressed: onOpen,
                icon: const Icon(Icons.bubble_chart_rounded, size: 18),
                label: const Text('성분 트렌드 탐색')),
          ]),
        )),
      );
}

class _RoutinePreview extends StatelessWidget {
  const _RoutinePreview({required this.onOpen});
  final VoidCallback onOpen;
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 68, 20, 0),
        child: Center(
            child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1080),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const _SectionTitle(
                kicker: 'SMART ROUTINE',
                title: '오늘 저녁은 3단계면 충분해요.',
                subtitle: '과한 액티브는 줄이고 회복에 집중하는 루틴입니다.'),
            const SizedBox(height: 20),
            ...const [
              ('01', 'BHA 클리어 토너', AppColors.cyan),
              ('02', '세라마이드 배리어 세럼', AppColors.lime),
              ('03', '바이옴 리커버리 크림', AppColors.butter)
            ].map((item) => Container(
                  margin: const EdgeInsets.only(bottom: 9),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(22)),
                  child: Row(children: [
                    Container(
                        width: 42,
                        height: 42,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: item.$3,
                            borderRadius: BorderRadius.circular(14)),
                        child: Text(item.$1,
                            style: const TextStyle(
                                fontSize: 10, fontWeight: FontWeight.w900))),
                    const SizedBox(width: 14),
                    Expanded(
                        child: Text(item.$2,
                            style: const TextStyle(
                                fontSize: 13, fontWeight: FontWeight.w800))),
                    const Icon(Icons.drag_handle_rounded,
                        color: AppColors.muted)
                  ]),
                )),
            const SizedBox(height: 12),
            FilledButton.icon(
                onPressed: onOpen,
                icon: const Icon(Icons.auto_awesome_rounded, size: 18),
                label: const Text('루틴 궁합 스캔')),
          ]),
        )),
      );
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(
      {required this.kicker, required this.title, required this.subtitle});
  final String kicker;
  final String title;
  final String subtitle;
  @override
  Widget build(BuildContext context) =>
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(kicker,
            style: const TextStyle(
                color: AppColors.violet,
                fontSize: 10,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.1)),
        const SizedBox(height: 9),
        Text(title, style: Theme.of(context).textTheme.headlineLarge),
        const SizedBox(height: 8),
        Text(subtitle,
            style: const TextStyle(
                color: AppColors.muted, fontSize: 12, height: 1.5)),
      ]);
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.icon, required this.label});
  final IconData icon;
  final String label;
  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: .1),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: Colors.white.withValues(alpha: .15))),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Icon(icon, color: AppColors.lime, size: 15),
          const SizedBox(width: 7),
          Text(label,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 9,
                  fontWeight: FontWeight.w900,
                  letterSpacing: .8))
        ]),
      );
}

class _BriefCard extends StatelessWidget {
  const _BriefCard(
      {required this.color,
      required this.icon,
      required this.value,
      required this.label,
      required this.caption});
  final Color color;
  final IconData icon;
  final String value;
  final String label;
  final String caption;
  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
            color: color, borderRadius: BorderRadius.circular(24)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Icon(icon, size: 20),
          const Spacer(),
          Text(value,
              style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -1.5)),
          Text(label,
              style:
                  const TextStyle(fontSize: 11, fontWeight: FontWeight.w900)),
          const SizedBox(height: 4),
          Text(caption,
              style: const TextStyle(color: AppColors.muted, fontSize: 9))
        ]),
      );
}

class _PulseMini extends StatelessWidget {
  const _PulseMini(
      {required this.value, required this.label, required this.color});
  final String value;
  final String label;
  final Color color;
  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
            color: color, borderRadius: BorderRadius.circular(20)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(value,
              style:
                  const TextStyle(fontSize: 28, fontWeight: FontWeight.w900)),
          const SizedBox(height: 3),
          Text(label,
              style: const TextStyle(
                  fontSize: 8, fontWeight: FontWeight.w900, letterSpacing: .7))
        ]),
      );
}
