import 'package:flutter_test/flutter_test.dart';
import 'package:pharma_beauty/main.dart';
import 'package:pharma_beauty/catalog.dart';
import 'package:pharma_beauty/screens/routine_builder_screen.dart';
import 'package:pharma_beauty/theme.dart';
import 'package:flutter/material.dart';

void main() {
  test('detects a BHA and retinal routine conflict', () {
    final conflict = findRoutineConflict([products[3], products[4]]);

    expect(conflict, isNotNull);
    expect(conflict!.first, '레티날');
    expect(conflict.second, 'BHA');
  });

  testWidgets('shows the PHARMA BEAUTY home experience', (tester) async {
    await tester.pumpWidget(const PharmaBeautyApp());

    expect(find.text('PHARMA\nBEAUTY'), findsOneWidget);
    expect(find.textContaining('피부가 보내는'), findsOneWidget);
  });

  testWidgets('opens the ingredient discovery experience', (tester) async {
    await tester.pumpWidget(const PharmaBeautyApp());

    await tester.tap(find.text('TRENDS'));
    await tester.pumpAndSettle();

    expect(find.text('지금 뜨는 성분'), findsOneWidget);
    expect(find.textContaining('INGREDIENT'), findsWidgets);
  });

  testWidgets('asks Lia pharmacist about retinal', (tester) async {
    await tester.pumpWidget(const PharmaBeautyApp());

    await tester.tap(find.byKey(const Key('pharmacist-chat-fab')));
    await tester.pumpAndSettle();

    expect(find.text('리아 약사'), findsOneWidget);
    expect(find.textContaining('의료 진단·처방을 대신하지 않아요'), findsOneWidget);

    await tester.tap(find.text('레티날 사용법'));
    await tester.pumpAndSettle();

    expect(find.textContaining('저녁에 주 2회부터'), findsOneWidget);
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
