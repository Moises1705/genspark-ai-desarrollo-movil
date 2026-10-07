import 'package:flutter/material.dart';

import 'screens/weather_screen.dart';
import 'services/settings_service.dart';
import 'theme/app_colors.dart';

void main() {
  runApp(const ClimaRapidoApp());
}

/// Raíz de la aplicación "Clima Rápido".
///
/// Es un [StatefulWidget] porque administra el tema (claro/oscuro). El modo
/// elegido se guarda en disco con [SettingsService] para que se recuerde al
/// volver a abrir la app.
class ClimaRapidoApp extends StatefulWidget {
  const ClimaRapidoApp({super.key});

  @override
  State<ClimaRapidoApp> createState() => _ClimaRapidoAppState();
}

class _ClimaRapidoAppState extends State<ClimaRapidoApp> {
  final SettingsService _settings = SettingsService();

  /// Estado actual del tema. Empieza en claro hasta leer lo guardado.
  ThemeMode _themeMode = ThemeMode.light;

  /// Indica si ya leímos las preferencias guardadas.
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    _loadSavedTheme();
  }

  /// Lee el modo oscuro guardado y lo aplica. Solo se muestra la pantalla
  /// cuando termina (`_loaded = true`).
  Future<void> _loadSavedTheme() async {
    final savedDark = await _settings.loadDarkMode();
    if (!mounted) return;
    setState(() {
      _themeMode = savedDark ? ThemeMode.dark : ThemeMode.light;
      _loaded = true;
    });
  }

  /// Cambia el tema y guarda la elección en disco.
  Future<void> _setDarkMode(bool enabled) async {
    setState(() {
      _themeMode = enabled ? ThemeMode.dark : ThemeMode.light;
    });
    await _settings.saveDarkMode(enabled);
  }

  /// Alterna entre claro y oscuro (usado por el botón de la barra superior).
  void _toggleTheme() {
    _setDarkMode(_themeMode != ThemeMode.dark);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Clima Rápido',
      debugShowCheckedModeBanner: false,
      theme: _buildTheme(Brightness.light),
      darkTheme: _buildTheme(Brightness.dark),
      themeMode: _themeMode,
      home: _loaded
          ? WeatherScreen(
              isDarkMode: _themeMode == ThemeMode.dark,
              onToggleTheme: _toggleTheme,
              onDarkModeChanged: _setDarkMode,
            )
          : const _SplashScreen(),
    );
  }

  /// Construye un [ThemeData] con el azul oscuro de marca como semilla,
  /// tanto para el tema claro como para el oscuro.
  ThemeData _buildTheme(Brightness brightness) {
    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primaryDarkBlue,
        brightness: brightness,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.primaryDarkBlue,
        foregroundColor: AppColors.onPrimary,
        elevation: 0,
        centerTitle: true,
      ),
    );
  }
}

/// Pantalla de carga mínima mientras se leen las preferencias guardadas.
class _SplashScreen extends StatelessWidget {
  const _SplashScreen();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
