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

  testWidgets('auto-dismisses the LEXEM intro before home', (tester) async {
    await tester.pumpWidget(const PharmaBeautyApp());

    expect(find.text('YOUR SKIN, YOUR LANGUAGE'), findsOneWidget);
    await tester.pump(const Duration(milliseconds: 800));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('ingredient-trend-hero')), findsOneWidget);
  });

  testWidgets('shows the LEXEM home experience', (tester) async {
    await tester.pumpWidget(const PharmaBeautyApp(showIntro: false));

    expect(find.byKey(const Key('lexem-brand-logo')), findsOneWidget);
    expect(find.byKey(const Key('ingredient-trend-hero')), findsOneWidget);
    expect(find.textContaining('이번 주, 레티날이'), findsOneWidget);
    expect(find.byKey(const Key('skin-weather-hero')), findsOneWidget);
    expect(find.textContaining('회원님의 피부 기상 리포트'), findsOneWidget);
    await tester.tap(find.byKey(const Key('ingredient-trend-tab-1')));
    await tester.pumpAndSettle();
    expect(find.textContaining('세라마이드를'), findsOneWidget);
  });

  testWidgets('opens weather-based skin recommendations', (tester) async {
    await tester.pumpWidget(const PharmaBeautyApp(showIntro: false));

    await tester.tap(find.text('MY SKIN'));
    await tester.pumpAndSettle();
    final weatherEntry = find.byKey(const Key('skin-weather-entry'));
    tester.widget<InkWell>(weatherEntry).onTap!.call();
    await tester.pumpAndSettle();

    expect(find.text('오늘의 자극 요인'), findsOneWidget);
    expect(find.textContaining('PM2.5'), findsWidgets);
    expect(find.textContaining('오늘 날씨 기준 추천'), findsOneWidget);
  });

  testWidgets('shows the LEXEM brand story and service language',
      (tester) async {
    await tester.pumpWidget(const PharmaBeautyApp(showIntro: false));

    await tester.scrollUntilVisible(
      find.byKey(const Key('brand-story-section')),
      420,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();

    expect(find.text('화장품 성분은\n하나의 언어다.'), findsOneWidget);
    expect(find.text('INGREDIENT DICTIONARY'), findsOneWidget);
    expect(find.text('나만의 문장'), findsOneWidget);
  });

  testWidgets('completes the five-step skin chart from home', (tester) async {
    await tester.pumpWidget(const PharmaBeautyApp(showIntro: false));

    await tester.scrollUntilVisible(
      find.byKey(const Key('skin-chart-start')),
      420,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('skin-chart-start')));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('skin-chart-option-0-0')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('skin-chart-option-1-0')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('skin-chart-concern-next')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('skin-chart-option-2-0')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('skin-chart-option-3-0')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('skin-chart-option-4-0')));
    await tester.pumpAndSettle();

    expect(find.text('장벽 회복형'), findsOneWidget);
    expect(find.textContaining('세라마이드 · 판테놀'), findsOneWidget);

    await tester.drag(find.byType(ListView).last, const Offset(0, -320));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('skin-chart-complete')));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('skin-chart-edit')), findsOneWidget);
    expect(find.textContaining('장벽 회복형'), findsOneWidget);
  });

  testWidgets('opens the ingredient discovery experience', (tester) async {
    await tester.pumpWidget(const PharmaBeautyApp(showIntro: false));

    await tester.tap(find.text('TREND'));
    await tester.pumpAndSettle();

    expect(find.text('지금 뜨는 성분'), findsOneWidget);
    expect(find.textContaining('INGREDIENT'), findsWidgets);
  });

  testWidgets('asks Lia pharmacist about retinal', (tester) async {
    await tester.pumpWidget(const PharmaBeautyApp(showIntro: false));

    await tester.tap(find.text('SHOP'));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('pharmacist-chat-fab')));
    await tester.pumpAndSettle();

    expect(find.text('리아 AI 약사'), findsOneWidget);
    expect(find.textContaining('의료 진단·처방을 대신하지 않아요'), findsOneWidget);

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
