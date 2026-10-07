import 'package:flutter/material.dart';

import 'screens/weather_screen.dart';

void main() {
  runApp(const ClimaRapidoApp());
}

/// Raíz de la aplicación "Clima Rápido".
class ClimaRapidoApp extends StatelessWidget {
  const ClimaRapidoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Clima Rápido',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF4A90E2),
        ),
      ),
      home: const WeatherScreen(),
    );
  }
}
