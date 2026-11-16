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

  testWidgets('adiciona um estudante à lista', (tester) async {
    await tester.pumpWidget(const FightLevelApp());

    await tester.tap(find.text('Insert Student'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextFormField), 'Ana Silva');
    await tester.tap(find.text('Add student'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('See All'));
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.text('Ana Silva'),
      300,
      scrollable: find.byType(Scrollable).last,
    );
    expect(find.text('Ana Silva'), findsOneWidget);
  });

  testWidgets('exige o nome para cadastrar um estudante', (tester) async {
    await tester.pumpWidget(const FightLevelApp());

    await tester.tap(find.text('Insert Student'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Add student'));
    await tester.pumpAndSettle();

    expect(find.text('Name is required.'), findsOneWidget);
    expect(find.byType(AlertDialog), findsOneWidget);
  });

  testWidgets('remove um estudante somente após confirmação', (tester) async {
    await tester.pumpWidget(const FightLevelApp());

    await tester.tap(find.text('Remove Student'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Francisco M.'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Remove'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('See All'));
    await tester.pumpAndSettle();
    expect(find.text('Francisco M.'), findsNothing);
  });

  testWidgets('mantém o estudante quando a remoção é cancelada', (tester) async {
    await tester.pumpWidget(const FightLevelApp());

    await tester.tap(find.text('Remove Student'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Francisco M.'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('See All'));
    await tester.pumpAndSettle();
    expect(find.text('Francisco M.'), findsOneWidget);
  });

  testWidgets('busca estudantes por nome', (tester) async {
    await tester.pumpWidget(const FightLevelApp());

    await tester.tap(find.byTooltip('Search students'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'Larissa');
    await tester.pumpAndSettle();

    expect(find.text('Larissa N.'), findsOneWidget);
    expect(find.text('Francisco M.'), findsNothing);
  });

  testWidgets('mostra dias e horários semanais de treino', (tester) async {
    await tester.pumpWidget(const FightLevelApp());

    await tester.tap(find.text('Workout'));
    await tester.pumpAndSettle();

    expect(find.text('Tuesday'), findsOneWidget);
    expect(find.text('9:00 AM - 10:30 AM\n6:00 PM - 7:30 PM'), findsOneWidget);
    expect(find.text('Saturday'), findsOneWidget);
    expect(find.text('No training'), findsWidgets);
  });
}