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
    // NOTA: antes este test usaba `find.text('Madrid')` y fallaba porque
    // encontraba 2 widgets (el campo de texto Y la tarjeta). Ahora buscamos
    // el texto "Madrid" solo dentro del WeatherCard.
    expect(
      find.descendant(
        of: find.byType(Card),
        matching: find.text('Madrid'),
      ),
      findsOneWidget,
    );
  });

  testWidgets('El botón alterna entre modo claro y modo oscuro',
      (WidgetTester tester) async {
    await tester.pumpWidget(const ClimaRapidoApp());

    // Estado inicial: modo claro -> el botón muestra el ícono "dark_mode".
    expect(find.byIcon(Icons.dark_mode), findsOneWidget);
    expect(find.byIcon(Icons.light_mode), findsNothing);

    // Toca el botón para pasar a modo oscuro.
    await tester.tap(find.byIcon(Icons.dark_mode));
    await tester.pumpAndSettle();

    // Ahora el botón debe ofrecer volver al modo claro.
    expect(find.byIcon(Icons.light_mode), findsOneWidget);
    expect(find.byIcon(Icons.dark_mode), findsNothing);

    // Toca de nuevo para regresar al modo claro.
    await tester.tap(find.byIcon(Icons.light_mode));
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.dark_mode), findsOneWidget);
    expect(find.byIcon(Icons.light_mode), findsNothing);
  });
}
