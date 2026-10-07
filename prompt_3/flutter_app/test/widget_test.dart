import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:climarapido/main.dart';

void main() {
  testWidgets('Muestra la pantalla de búsqueda de Clima Rápido',
      (WidgetTester tester) async {
    await tester.pumpWidget(const ClimaRapidoApp());

    // El título de la app y el mensaje inicial deben estar visibles.
    expect(find.text('Clima Rápido'), findsOneWidget);
    expect(find.text('Busca una ciudad para ver su clima.'), findsOneWidget);
    expect(find.byType(TextField), findsOneWidget);
  });

  testWidgets('Busca una ciudad y muestra la tarjeta con el clima',
      (WidgetTester tester) async {
    await tester.pumpWidget(const ClimaRapidoApp());

    await tester.enterText(find.byType(TextField), 'Madrid');
    await tester.tap(find.byIcon(Icons.search));

    // Espera a que termine la "petición" simulada.
    await tester.pumpAndSettle();

    // La tarjeta debe mostrar la ciudad buscada.
    expect(find.text('Madrid'), findsOneWidget);
  });
}
