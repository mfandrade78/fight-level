import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fight_level/main.dart';

void main() {
  testWidgets('navega para a lista e filtra alunos com mídia', (tester) async {
    await tester.pumpWidget(const FightLevelApp());

    expect(find.text('Students Fight Level'), findsOneWidget);
    await tester.tap(find.text('See All'));
    await tester.pumpAndSettle();

    expect(find.text('Students Level'), findsOneWidget);
    expect(find.text('Francisco M.'), findsOneWidget);
    expect(find.text('Larissa N.'), findsOneWidget);

    await tester.tap(find.text('Media'));
    await tester.pumpAndSettle();

    expect(find.text('Francisco M.'), findsOneWidget);
    expect(find.text('Hellen O.'), findsOneWidget);
    expect(find.text('Larissa N.'), findsNothing);
  });
}