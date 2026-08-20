import 'dart:async';
import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../models.dart';
import '../state/app_state.dart';
import '../theme.dart';
import '../widgets/brand_widgets.dart';
import '../widgets/product_search_delegate.dart';
import 'compare_screen.dart';
import 'commerce_screen.dart';
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
  StreamSubscription<User?>? _authSubscription;

  @override
  void initState() {
    super.initState();
    appState = AppState()..addListener(_refresh);
    if (Firebase.apps.isNotEmpty) {
      _authSubscription = FirebaseAuth.instance.authStateChanges().listen(
        (user) {
          if (user == null) {
            appState.signOut();
          } else {
            appState.signIn(
              email: user.email ?? '',
              name: user.displayName ?? user.email?.split('@').first ?? '회원',
            );
          }
        },
      );
      if (kIsWeb) unawaited(_completeGoogleRedirect());
    }
  }

  /// 리디렉션으로 Google 인증을 마친 뒤 Firebase가 전달한 결과를 소비합니다.
  /// 이 호출 뒤 authStateChanges가 로그인한 사용자를 AppState에 반영합니다.
  Future<void> _completeGoogleRedirect() async {
    try {
      await FirebaseAuth.instance.getRedirectResult();
    } on FirebaseAuthException catch (error) {
      if (mounted) _showAuthError(error);
    }
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
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
                  onAddToCart: () {
                    appState.addToCart(product);
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('장바구니에 담았어요.')));
                  },
                  onBuyNow: () => _openCheckout([product]),
                )));
  }

  void _openCart() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => CartScreen(
                  products: appState.cartProducts,
                  onRemove: appState.removeFromCart,
                  onCheckout: _openCheckout,
                )));
  }

  void _openCheckout(List<BeautyProduct> items) {
    if (items.isEmpty) return;
    final order = appState.checkout(items);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (routeContext) => DeliveryStatusScreen(
                  order: order,
                  onAdvance: () => appState.advanceDelivery(order.id),
                  onDone: () {
                    Navigator.pop(routeContext);
                    setState(() => currentIndex = 3);
                  },
                )));
  }

  void _openOrder(PurchaseOrder order) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (routeContext) => DeliveryStatusScreen(
                  order: order,
                  onAdvance: () => appState.advanceDelivery(order.id),
                  onDone: () => Navigator.pop(routeContext),
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

  Future<void> showAuth() async {
    if (appState.isSignedIn) {
      final signOut = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('로그아웃할까요?'),
          content: Text('${appState.userEmail} 계정에서 로그아웃합니다.'),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('취소')),
            FilledButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('로그아웃')),
          ],
        ),
      );
      if (signOut == true) {
        try {
          await FirebaseAuth.instance.signOut();
          appState.signOut();
        } on FirebaseAuthException catch (error) {
          if (mounted) _showAuthError(error);
        }
      }
      return;
    }

    final name = TextEditingController();
    final email = TextEditingController();
    final password = TextEditingController();
    var isSignUp = false;
    final result = await showDialog<(String, String, String, bool)?>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) {
          InputDecoration fieldDecoration({
            required String hint,
            required IconData icon,
          }) =>
              InputDecoration(
                hintText: hint,
                hintStyle: const TextStyle(
                  color: Color(0xFF9A98A8),
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
                prefixIcon: Icon(icon, color: AppColors.fuchsia, size: 18),
                filled: true,
                fillColor: const Color(0xFFF8F7FC),
                contentPadding: const EdgeInsets.symmetric(vertical: 14),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(color: Color(0xFFEBE9F4)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide:
                      const BorderSide(color: AppColors.fuchsia, width: 1.4),
                ),
              );

          return Dialog(
            backgroundColor: Colors.transparent,
            elevation: 0,
            insetPadding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 28),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFFFFEFF),
                  borderRadius: BorderRadius.circular(28),
                  border:
                      Border.all(color: Colors.white.withValues(alpha: .85)),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x331E1740),
                      blurRadius: 40,
                      offset: Offset(0, 18),
                    ),
                  ],
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(24, 20, 24, 22),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 38,
                            height: 38,
                            alignment: Alignment.center,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                colors: [Color(0xFF8D82ED), AppColors.fuchsia],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                            ),
                            child: const Icon(Icons.auto_awesome_rounded,
                                color: Colors.white, size: 18),
                          ),
                          const Spacer(),
                          IconButton(
                            tooltip: '닫기',
                            onPressed: () => Navigator.pop(dialogContext),
                            icon: const Icon(Icons.close_rounded, size: 20),
                            color: AppColors.muted,
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(isSignUp ? '피부 루틴을 시작해요' : '다시 만난 반가워요',
                          style: const TextStyle(
                            color: AppColors.ink,
                            fontSize: 23,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -.8,
                          )),
                      const SizedBox(height: 6),
                      Text(
                        isSignUp
                            ? '내 피부와 오늘 날씨에 맞는 케어를 찾아드릴게요.'
                            : '나만의 피부 리포트와 저장한 루틴을 이어서 확인하세요.',
                        style: const TextStyle(
                          color: AppColors.muted,
                          fontSize: 12,
                          height: 1.45,
                        ),
                      ),
                      if (kIsWeb) ...[
                        const SizedBox(height: 20),
                        SizedBox(
                          height: 48,
                          child: OutlinedButton.icon(
                            onPressed: () async {
                              try {
                                await FirebaseAuth.instance
                                    .signInWithRedirect(GoogleAuthProvider());
                              } on FirebaseAuthException catch (error) {
                                if (dialogContext.mounted)
                                  _showAuthError(error);
                              }
                            },
                            icon: Container(
                              width: 20,
                              height: 20,
                              alignment: Alignment.center,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                              child: const Text('G',
                                  style: TextStyle(
                                      color: Color(0xFF4285F4),
                                      fontSize: 13,
                                      fontWeight: FontWeight.w900)),
                            ),
                            label: const Text('Google로 계속하기'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AppColors.ink,
                              side: const BorderSide(color: Color(0xFFE4E1ED)),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14)),
                              textStyle: const TextStyle(
                                  fontSize: 13, fontWeight: FontWeight.w700),
                            ),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          child: Row(children: [
                            Expanded(child: Divider(color: Color(0xFFEAE8F0))),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              child: Text('또는 이메일로',
                                  style: TextStyle(
                                      color: AppColors.muted,
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600)),
                            ),
                            Expanded(child: Divider(color: Color(0xFFEAE8F0))),
                          ]),
                        ),
                      ] else
                        const SizedBox(height: 18),
                      if (isSignUp) ...[
                        TextField(
                          controller: name,
                          textCapitalization: TextCapitalization.words,
                          decoration: fieldDecoration(
                              hint: '이름 또는 닉네임',
                              icon: Icons.person_outline_rounded),
                        ),
                        const SizedBox(height: 10),
                      ],
                      TextField(
                        controller: email,
                        keyboardType: TextInputType.emailAddress,
                        decoration: fieldDecoration(
                            hint: '이메일 주소', icon: Icons.mail_outline_rounded),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: password,
                        obscureText: true,
                        decoration: fieldDecoration(
                            hint: '비밀번호', icon: Icons.lock_outline_rounded),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(dialogContext);
                              _showAccountRecoveryDialog();
                            },
                            style: TextButton.styleFrom(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 4),
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            child: const Text('아이디 찾기',
                                style: TextStyle(
                                    color: AppColors.muted,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700)),
                          ),
                          const Text(' · ',
                              style: TextStyle(
                                  color: AppColors.muted, fontSize: 10)),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(dialogContext);
                              _showAccountRecoveryDialog(
                                  startWithPassword: true);
                            },
                            style: TextButton.styleFrom(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 4),
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            child: const Text('비밀번호 찾기',
                                style: TextStyle(
                                    color: AppColors.fuchsia,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w800)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),
                      SizedBox(
                        height: 48,
                        child: FilledButton(
                          onPressed: () => Navigator.pop(
                            dialogContext,
                            (
                              email.text.trim(),
                              name.text.trim(),
                              password.text,
                              isSignUp
                            ),
                          ),
                          style: FilledButton.styleFrom(
                            backgroundColor: AppColors.fuchsia,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14)),
                          ),
                          child: Text(isSignUp ? '계정 만들기' : '로그인하기',
                              style: const TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.w800)),
                        ),
                      ),
                      const SizedBox(height: 14),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(isSignUp ? '이미 계정이 있나요?' : 'LEXEM이 처음인가요?',
                              style: const TextStyle(
                                  color: AppColors.muted, fontSize: 11)),
                          TextButton(
                            onPressed: () => setDialogState(() {
                              isSignUp = !isSignUp;
                            }),
                            style: TextButton.styleFrom(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 6),
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            child: Text(isSignUp ? '로그인' : '이메일 가입',
                                style: const TextStyle(
                                    color: AppColors.fuchsia,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w800)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
    if (result != null && result.$1.contains('@') && result.$3.isNotEmpty) {
      try {
        final credential = result.$4
            ? await FirebaseAuth.instance.createUserWithEmailAndPassword(
                email: result.$1,
                password: result.$3,
              )
            : await FirebaseAuth.instance.signInWithEmailAndPassword(
                email: result.$1,
                password: result.$3,
              );
        final user = credential.user;
        if (result.$4 && user != null && result.$2.trim().isNotEmpty) {
          await user.updateDisplayName(result.$2.trim());
        }
        if (user != null) {
          appState.signIn(
            email: user.email ?? result.$1,
            name: user.displayName ?? result.$2,
          );
        }
      } on FirebaseAuthException catch (error) {
        if (mounted) _showAuthError(error);
      }
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('이메일과 비밀번호를 입력해 주세요.')),
      );
    }
    name.dispose();
    email.dispose();
    password.dispose();
  }

  Future<void> _showAccountRecoveryDialog(
      {bool startWithPassword = false}) async {
    final email = TextEditingController();
    var isPasswordReset = startWithPassword;

    await showDialog<void>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) => Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          insetPadding: const EdgeInsets.symmetric(horizontal: 20),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 390),
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: const Color(0xFFFFFEFF),
                borderRadius: BorderRadius.circular(24),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x331E1740),
                    blurRadius: 34,
                    offset: Offset(0, 16),
                  ),
                ],
              ),
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                Container(
                  width: 42,
                  height: 42,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    color: Color(0xFFF0EDFF),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.mark_email_read_outlined,
                      color: AppColors.fuchsia, size: 21),
                ),
                const SizedBox(height: 14),
                Text(isPasswordReset ? '비밀번호를 재설정할까요?' : '아이디를 잊으셨나요?',
                    style: const TextStyle(
                        color: AppColors.ink,
                        fontSize: 18,
                        fontWeight: FontWeight.w800)),
                const SizedBox(height: 8),
                Text(
                  isPasswordReset
                      ? '가입한 이메일로 비밀번호 재설정 링크를 보내드려요.'
                      : 'LEXEM에서는 가입에 사용한 이메일 주소가 아이디예요.',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      color: AppColors.muted, fontSize: 11, height: 1.45),
                ),
                const SizedBox(height: 18),
                TextField(
                  controller: email,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    hintText: '가입한 이메일 주소',
                    prefixIcon: const Icon(Icons.mail_outline_rounded,
                        color: AppColors.fuchsia, size: 18),
                    filled: true,
                    fillColor: const Color(0xFFF8F7FC),
                    contentPadding: const EdgeInsets.symmetric(vertical: 14),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                if (!isPasswordReset) ...[
                  const SizedBox(height: 9),
                  const Text('이메일로 로그인하거나 비밀번호 재설정을 이용해 주세요.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: AppColors.muted, fontSize: 10)),
                ],
                const SizedBox(height: 18),
                SizedBox(
                  width: double.infinity,
                  height: 46,
                  child: FilledButton(
                    onPressed: () async {
                      final address = email.text.trim();
                      if (!address.contains('@')) {
                        ScaffoldMessenger.of(this.context).showSnackBar(
                          const SnackBar(content: Text('가입한 이메일 주소를 입력해 주세요.')),
                        );
                        return;
                      }
                      if (!isPasswordReset) {
                        setDialogState(() => isPasswordReset = true);
                        return;
                      }
                      try {
                        await FirebaseAuth.instance
                            .sendPasswordResetEmail(email: address);
                        if (dialogContext.mounted) Navigator.pop(dialogContext);
                        if (mounted) {
                          ScaffoldMessenger.of(this.context).showSnackBar(
                            const SnackBar(
                                content:
                                    Text('등록된 이메일이라면 비밀번호 재설정 링크가 발송됩니다.')),
                          );
                        }
                      } on FirebaseAuthException catch (error) {
                        if (mounted) _showAuthError(error);
                      }
                    },
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.fuchsia,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                    ),
                    child: Text(isPasswordReset ? '재설정 링크 보내기' : '비밀번호 재설정하기',
                        style: const TextStyle(fontWeight: FontWeight.w800)),
                  ),
                ),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: const Text('로그인으로 돌아가기',
                      style: TextStyle(color: AppColors.muted, fontSize: 11)),
                ),
              ]),
            ),
          ),
        ),
      ),
    );
    email.dispose();
  }

  void _showAuthError(FirebaseAuthException error) {
    const messages = {
      'invalid-email': '이메일 주소 형식을 확인해 주세요.',
      'invalid-credential': '이메일 또는 비밀번호가 올바르지 않습니다.',
      'wrong-password': '비밀번호가 올바르지 않습니다.',
      'email-already-in-use': '이미 가입된 이메일입니다. 로그인해 주세요.',
      'weak-password': '비밀번호는 6자 이상으로 설정해 주세요.',
      'popup-closed-by-user': 'Google 로그인이 취소되었습니다.',
      'account-exists-with-different-credential': '다른 로그인 방식으로 가입된 이메일입니다.',
    };
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text(messages[error.code] ?? '로그인에 실패했습니다. 다시 시도해 주세요.')),
    );
  }

  PreferredSizeWidget _buildShopAppBar() => AppBar(
        toolbarHeight: 84,
        backgroundColor: AppColors.surface,
        centerTitle: true,
        leadingWidth: 118,
        leading: Row(children: [
          IconButton(
              tooltip: '메뉴',
              onPressed: () => ScaffoldMessenger.of(context)
                  .showSnackBar(const SnackBar(content: Text('메뉴는 준비 중이에요.'))),
              icon: const Icon(Icons.menu_rounded, size: 27)),
          IconButton(
              tooltip: '검색',
              onPressed: openSearch,
              icon: const Icon(Icons.search_rounded, size: 25)),
        ]),
        title: const Text('SHOP',
            style: TextStyle(
                color: AppColors.berry,
                fontSize: 20,
                fontWeight: FontWeight.w700,
                letterSpacing: 3.2)),
        actions: [
          IconButton(
              tooltip: '저장한 제품',
              onPressed: () => setState(() => currentIndex = 3),
              icon: const Icon(Icons.favorite_border_rounded, size: 25)),
          IconButton(
              onPressed: _openCart,
              tooltip: '장바구니',
              icon: const Icon(Icons.shopping_bag_outlined, size: 24)),
          const SizedBox(width: 8),
        ],
      );

  @override
  Widget build(BuildContext context) {
    final pages = [
      HomeScreen(
          skinProfile: appState.skinProfile,
          compareIds: appState.compareIds,
          savedIds: appState.savedIds,
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
          onToggleSave: toggleSaved,
          orders: appState.orders,
          onOpenOrder: _openOrder),
    ];

    return Scaffold(
      extendBody: true,
      appBar: currentIndex == 1
          ? _buildShopAppBar()
          : AppBar(
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
                      onPressed: () => ScaffoldMessenger.of(context)
                          .showSnackBar(
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
                              style: TextStyle(
                                  color: Colors.white, fontSize: 7)))),
                ]),
                IconButton(
                    key: const Key('auth-button'),
                    onPressed: showAuth,
                    tooltip: appState.isSignedIn ? '로그아웃' : '로그인',
                    icon: appState.isSignedIn
                        ? CircleAvatar(
                            radius: 13,
                            backgroundColor: AppColors.fuchsia,
                            child: Text(
                                appState.userName.substring(0, 1).toUpperCase(),
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w800)),
                          )
                        : const Icon(Icons.login_rounded)),
                const SizedBox(width: 6),
              ],
            ),
      body: IndexedStack(index: currentIndex, children: pages),
      floatingActionButton: _PharmacistChatFab(onPressed: openPharmacistChat),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.fromLTRB(12, 0, 12, 12),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(26),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.surface.withValues(alpha: .72),
                borderRadius: BorderRadius.circular(26),
                border: Border.all(color: Colors.white.withValues(alpha: .78)),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x1A17171B),
                    blurRadius: 24,
                    offset: Offset(0, 10),
                  ),
                ],
              ),
              child: NavigationBar(
                selectedIndex: currentIndex,
                onDestinationSelected: (index) =>
                    setState(() => currentIndex = index),
                height: 68,
                backgroundColor: Colors.transparent,
                surfaceTintColor: Colors.transparent,
                indicatorColor: AppColors.blush.withValues(alpha: .78),
                indicatorShape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
                labelTextStyle:
                    WidgetStateProperty.resolveWith((states) => TextStyle(
                          fontSize: 10,
                          fontWeight: states.contains(WidgetState.selected)
                              ? FontWeight.w700
                              : FontWeight.w600,
                          color: states.contains(WidgetState.selected)
                              ? AppColors.fuchsia
                              : AppColors.muted,
                        )),
                destinations: const [
                  NavigationDestination(
                      icon: Icon(Icons.home_outlined),
                      selectedIcon: Icon(Icons.home_rounded),
                      label: 'HOME'),
                  NavigationDestination(
                      icon: Icon(Icons.grid_view_outlined),
                      selectedIcon: Icon(Icons.grid_view_rounded),
                      label: 'SHOP'),
                  NavigationDestination(
                      icon: Icon(Icons.science_outlined),
                      selectedIcon: Icon(Icons.science_rounded),
                      label: 'TREND'),
                  NavigationDestination(
                      icon: Icon(Icons.person_outline_rounded),
                      selectedIcon: Icon(Icons.person_rounded),
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

class _PharmacistChatFab extends StatelessWidget {
  const _PharmacistChatFab({required this.onPressed});
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => Semantics(
        button: true,
        label: 'AI 약사 챗봇 열기',
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
              child: Container(
                height: 44,
                padding: const EdgeInsets.symmetric(horizontal: 17),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: .68),
                  borderRadius: BorderRadius.circular(18),
                  border:
                      Border.all(color: Colors.white.withValues(alpha: .88)),
                  boxShadow: const [
                    BoxShadow(
                        color: Color(0x1A17171B),
                        blurRadius: 16,
                        offset: Offset(0, 7))
                  ],
                ),
                child: const Text('AI Pharmacist',
                    style:
                        TextStyle(fontSize: 11, fontWeight: FontWeight.w700)),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Material(
            color: Colors.transparent,
            shape: const CircleBorder(),
            child: InkWell(
              key: const Key('pharmacist-chat-fab'),
              onTap: onPressed,
              customBorder: const CircleBorder(),
              child: Ink(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: .80),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 1.4),
                  boxShadow: const [
                    BoxShadow(
                        color: Color(0x2417171B),
                        blurRadius: 18,
                        offset: Offset(0, 8))
                  ],
                ),
                child: Stack(clipBehavior: Clip.none, children: [
                  const Center(
                      child: Icon(Icons.chat_bubble_outline_rounded,
                          size: 28, color: AppColors.ink)),
                  Positioned(
                    right: -2,
                    top: -2,
                    child: Container(
                      width: 24,
                      height: 24,
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(
                          color: AppColors.fuchsia, shape: BoxShape.circle),
                      child: const Icon(Icons.auto_awesome_rounded,
                          size: 13, color: Colors.white),
                    ),
                  ),
                ]),
              ),
            ),
          ),
        ]),
      );
}
