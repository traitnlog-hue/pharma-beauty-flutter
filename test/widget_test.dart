import 'package:flutter_test/flutter_test.dart';
import 'package:pharma_beauty/main.dart';
import 'package:pharma_beauty/catalog.dart';
import 'package:pharma_beauty/features/pharmacist_chat/pharmacist_chat_service.dart';
import 'package:pharma_beauty/features/skin_weather/skin_weather_service.dart';
import 'package:pharma_beauty/models.dart';
import 'package:pharma_beauty/screens/routine_builder_screen.dart';
import 'package:pharma_beauty/state/app_state.dart';
import 'package:pharma_beauty/theme.dart';
import 'package:flutter/material.dart';

void main() {
  test('detects a BHA and retinal routine conflict', () {
    final conflict = findRoutineConflict([products[3], products[4]]);

    expect(conflict, isNotNull);
    expect(conflict!.first, '레티날');
    expect(conflict.second, 'BHA');
  });

  test('app state enforces the three-product comparison limit', () {
    final state = AppState();

    expect(state.toggleCompare(products[0]), isTrue);
    expect(state.toggleCompare(products[1]), isTrue);
    expect(state.toggleCompare(products[2]), isTrue);
    expect(state.toggleCompare(products[3]), isFalse);
    expect(state.compareIds, hasLength(3));

    state.dispose();
  });

  test('app state signs in and signs out a local session', () {
    final state = AppState();

    state.signIn(email: 'jimin@example.com', name: '지민');
    expect(state.isSignedIn, isTrue);
    expect(state.userName, '지민');

    state.signOut();
    expect(state.isSignedIn, isFalse);
    state.dispose();
  });

  test('skin chart updates the primary curation concern', () {
    final state = AppState();
    const profile = SkinProfile(
      skinType: '민감성',
      concerns: ['민감·진정', '보습'],
      sensitivity: '매우 예민함',
      triggerHistory: '향료·에센셜 오일',
      duration: '반복적으로 발생',
    );

    state.updateSkinProfile(profile);

    expect(state.skinProfile.isComplete, isTrue);
    expect(state.profileConcern, '민감·진정');
    expect(state.skinProfile.recommendedIngredients, contains('판테놀'));

    state.dispose();
  });

  test('pharmacist service keeps high-risk guidance explicit', () {
    const service = PharmacistChatService();

    expect(service.answerFor('임신 중 레티놀을 써도 될까요?'), contains('담당 의료진이나 약사'));
    expect(service.answerFor('레티날 사용법'), contains('주 2회'));
  });

  test('skin weather converts environment signals into recommendations', () {
    const service = SkinWeatherService();
    final weather = service.loadDemoSnapshot();

    expect(weather.airQuality, '나쁨');
    expect(weather.uvLevel, '높음');
    expect(weather.skinRiskScore, greaterThanOrEqualTo(55));
    expect(service.recommendedProductIds(weather, const SkinProfile.empty()),
        containsAll([1, 3, 6]));
    final advice = service.adviceFor(
      weather,
      const SkinProfile(
        skinType: '민감성',
        concerns: ['민감·진정'],
        sensitivity: '매우 예민함',
        triggerHistory: '',
        duration: '',
      ),
    );
    expect(advice.cautions.join(), contains('자외선'));
    expect(advice.recommendations.join(), contains('SPF 50+'));
  });

  testWidgets('auto-dismisses the BE:CAUSE intro before home', (tester) async {
    await tester.pumpWidget(const PharmaBeautyApp());

    expect(find.text('내 피부를 위한 뷰티 선택'), findsOneWidget);
    await tester.pump(const Duration(milliseconds: 800));
    await tester.pumpAndSettle();

    expect(find.text('오늘의 뷰티 브리핑'), findsOneWidget);
  });

  testWidgets('shows the BE:CAUSE daily decision home', (tester) async {
    await tester.pumpWidget(const PharmaBeautyApp(showIntro: false));

    expect(find.byKey(const Key('because-brand-logo')), findsOneWidget);
    expect(find.text('오늘의 뷰티 브리핑'), findsOneWidget);
    expect(find.textContaining('피부 맥락을'), findsOneWidget);
  });

  testWidgets('opens the contextual skin weather recommendation',
      (tester) async {
    await tester.pumpWidget(const PharmaBeautyApp(showIntro: false));

    await tester.tap(find.text('마이'));
    await tester.pumpAndSettle();
    final weatherEntry = find.byKey(const Key('skin-weather-entry'));
    tester.widget<InkWell>(weatherEntry).onTap!.call();
    await tester.pumpAndSettle();

    expect(find.text('오늘의 자극 요인'), findsOneWidget);
    expect(find.textContaining('PM2.5'), findsWidgets);
    expect(find.textContaining('오늘 날씨 기준 추천'), findsOneWidget);
  });

  testWidgets('opens criteria editing from the MY screen', (tester) async {
    await tester.pumpWidget(const PharmaBeautyApp(showIntro: false));

    await tester.tap(find.text('마이'));
    await tester.pumpAndSettle();
    expect(find.textContaining('마이 뷰티'), findsOneWidget);
    expect(find.textContaining('내 피부 기준'), findsOneWidget);
  });

  testWidgets('opens the unified discover experience', (tester) async {
    await tester.pumpWidget(const PharmaBeautyApp(showIntro: false));

    await tester.tap(find.text('찾기'));
    await tester.pumpAndSettle();

    expect(find.text('성분 · 상품 찾기'), findsWidgets);
    expect(find.text('제품, 성분, 브랜드, 리뷰 키워드'), findsOneWidget);
  });

  testWidgets('asks contextual Remi about retinal', (tester) async {
    await tester.pumpWidget(const PharmaBeautyApp(showIntro: false));

    await tester.scrollUntilVisible(
      find.text('레미에게 묻기'),
      380,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('레미에게 묻기'));
    await tester.pumpAndSettle();

    expect(find.text('레미 · 성분 정보 해설'), findsOneWidget);
    expect(find.textContaining('의료 진단·처방은 제공하지 않아요'), findsOneWidget);

    await tester.tap(find.text('레티날 사용법'));
    await tester.pumpAndSettle();

    expect(find.textContaining('저녁에 주 2회부터'), findsOneWidget);
  });

  test('ingredient chatbot explains a common pairing', () {
    const service = PharmacistChatService();

    expect(
      service.answerFor('비타민 C와 나이아신아마이드 궁합'),
      contains('함께 사용할 수 있어요'),
    );
    expect(service.answerFor('아침 사용 순서'), contains('자외선 차단제'));
  });

  testWidgets('shows the routine compatibility checker', (tester) async {
    await tester.pumpWidget(MaterialApp(
        theme: buildAppTheme(), home: const RoutineBuilderScreen()));

    expect(find.textContaining('성분 궁합을 확인해요'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.textContaining('현재 루틴은 함께 사용하기 좋아요'),
      400,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.textContaining('현재 루틴은 함께 사용하기 좋아요'), findsOneWidget);
  });
}
