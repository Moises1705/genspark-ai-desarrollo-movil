import 'package:flutter/material.dart';

import 'screens/weather_screen.dart';

void main() {
  runApp(const ClimaRapidoApp());
}

/// Raíz de la aplicación "Clima Rápido".
///
/// Es un [StatefulWidget] porque ahora administra el tema (claro/oscuro) y
/// expone un botón en la pantalla principal para alternarlo.
class ClimaRapidoApp extends StatefulWidget {
  const ClimaRapidoApp({super.key});

  @override
  State<ClimaRapidoApp> createState() => _ClimaRapidoAppState();
}

class _ClimaRapidoAppState extends State<ClimaRapidoApp> {
  /// Color de marca de la app, usado como semilla para generar ambos temas.
  static const Color _seedColor = Color(0xFF4A90E2);

  /// Estado actual del tema. Empieza en claro.
  ThemeMode _themeMode = ThemeMode.light;

  /// Alterna entre el modo claro y el modo oscuro.
  void _toggleTheme() {
    setState(() {
      _themeMode =
          _themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Clima Rápido',
      debugShowCheckedModeBanner: false,
      theme: _buildTheme(Brightness.light),
      darkTheme: _buildTheme(Brightness.dark),
      themeMode: _themeMode,
      home: WeatherScreen(
        isDarkMode: _themeMode == ThemeMode.dark,
        onToggleTheme: _toggleTheme,
      ),
    );
  }

  /// Construye un [ThemeData] a partir de la semilla, para el brillo indicado.
  ThemeData _buildTheme(Brightness brightness) {
    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: ColorScheme.fromSeed(
        seedColor: _seedColor,
        brightness: brightness,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: _seedColor,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
    );
  }
}
