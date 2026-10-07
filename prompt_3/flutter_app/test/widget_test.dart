import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:climarapido/main.dart';

void main() {
  // Empezamos cada test con el almacenamiento local vacío para que no haya
  // estado guardado de una ejecución a otra.
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('Muestra la pantalla de búsqueda de Clima Rápido',
      (WidgetTester tester) async {
    await tester.pumpWidget(const ClimaRapidoApp());
    await tester.pumpAndSettle(); // espera a que carguen las preferencias

    // El título de la app y el mensaje inicial deben estar visibles.
    expect(find.text('Clima Rápido'), findsOneWidget);
    expect(find.text('Busca una ciudad para ver su clima.'), findsOneWidget);
    expect(find.byType(TextField), findsOneWidget);
  });

  testWidgets('Busca una ciudad y muestra la tarjeta con el clima',
      (WidgetTester tester) async {
    await tester.pumpWidget(const ClimaRapidoApp());
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), 'Madrid');
    await tester.tap(find.byIcon(Icons.search));

    // Espera a que termine la "petición" simulada.
    await tester.pumpAndSettle();

    // La tarjeta debe mostrar la ciudad buscada.
    // NOTA: usamos `find.descendant` porque `find.text('Madrid')` encontraría
    // 2 widgets (el campo de texto Y la tarjeta).
    expect(
      find.descendant(
        of: find.byType(Card),
        matching: find.text('Madrid'),
      ),
      findsOneWidget,
    );
  });

  testWidgets('El botón de la barra alterna entre modo claro y oscuro',
      (WidgetTester tester) async {
    await tester.pumpWidget(const ClimaRapidoApp());
    await tester.pumpAndSettle();

    // Estado inicial: modo claro -> el botón muestra el ícono "dark_mode".
    expect(find.byIcon(Icons.dark_mode), findsOneWidget);

    await tester.tap(find.byIcon(Icons.dark_mode));
    await tester.pumpAndSettle();

    // Ahora debe ofrecer volver al modo claro.
    expect(find.byIcon(Icons.light_mode), findsOneWidget);
  });

  testWidgets('Se puede abrir Configuración y usar el interruptor',
      (WidgetTester tester) async {
    await tester.pumpWidget(const ClimaRapidoApp());
    await tester.pumpAndSettle();

    // Abrimos la pantalla de Configuración.
    await tester.tap(find.byIcon(Icons.settings));
    await tester.pumpAndSettle();

    expect(find.text('Configuración'), findsOneWidget);
    expect(find.byType(SwitchListTile), findsOneWidget);

    // El interruptor empieza apagado (modo claro).
    SwitchListTile switchTile =
        tester.widget(find.byType(SwitchListTile));
    expect(switchTile.value, isFalse);

    // Lo activamos.
    await tester.tap(find.byType(SwitchListTile));
    await tester.pumpAndSettle();

    switchTile = tester.widget(find.byType(SwitchListTile));
    expect(switchTile.value, isTrue);
  });

  testWidgets('Recuerda el modo oscuro guardado al iniciar',
      (WidgetTester tester) async {
    // Simulamos que el usuario ya había activado el modo oscuro antes.
    SharedPreferences.setMockInitialValues({'dark_mode_enabled': true});

    await tester.pumpWidget(const ClimaRapidoApp());
    await tester.pumpAndSettle();

    // Si arrancó en oscuro, el botón de la barra muestra "light_mode".
    expect(find.byIcon(Icons.light_mode), findsOneWidget);
    expect(find.byIcon(Icons.dark_mode), findsNothing);
  });

  testWidgets('Guardar el modo oscuro lo persiste en el almacenamiento',
      (WidgetTester tester) async {
    await tester.pumpWidget(const ClimaRapidoApp());
    await tester.pumpAndSettle();

    // Activamos el modo oscuro desde el botón de la barra superior.
    await tester.tap(find.byIcon(Icons.dark_mode));
    await tester.pumpAndSettle();

    // Comprobamos que quedó guardado en SharedPreferences.
    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getBool('dark_mode_enabled'), isTrue);
  });
}
