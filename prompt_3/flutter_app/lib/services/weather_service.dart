import 'dart:math' as math;

import '../models/weather.dart';

/// Servicio que devuelve el clima de una ciudad.
///
/// IMPORTANTE: esta versión usa **datos de ejemplo** generados de forma
/// determinista a partir del nombre de la ciudad, para que la app funcione
/// sin conexión ni claves de API.
///
/// Para conectar una API real (p. ej. OpenWeatherMap) solo hay que reemplazar
/// el cuerpo de [fetchByCity] por una petición HTTP con el paquete `http`.
class WeatherService {
  Future<Weather> fetchByCity(String city) async {
    // Simulamos la latencia de una llamada de red.
    await Future<void>.delayed(const Duration(milliseconds: 600));

    final normalized = city.trim();
    if (normalized.isEmpty) {
      throw const WeatherServiceException(
        'Escribe el nombre de una ciudad.',
      );
    }

    // Genera valores "de ejemplo" pero estables para cada ciudad.
    final seed = normalized.toLowerCase().codeUnits.fold<int>(
      0,
      (acc, code) => acc + code,
    );
    final random = math.Random(seed);

    final temperature = 5 + random.nextDouble() * 30; // 5 °C .. 35 °C
    final humidity = 30 + random.nextInt(60); // 30 % .. 89 %
    final windSpeed = random.nextDouble() * 25; // 0 .. 25 km/h

    final conditions = _conditionsFor(random.nextInt(_conditionPool.length));
    final condition = conditions[random.nextInt(conditions.length)];

    return Weather(
      city: _titleCase(normalized),
      temperature: temperature,
      description: condition.$1,
      icon: condition.$2,
      humidity: humidity,
      windSpeed: windSpeed,
    );
  }

  static const List<List<(String, String)>> _conditionPool = [
    [('Despejado', '☀️'), ('Soleado', '🌞')],
    [('Parcialmente nublado', '⛅'), ('Nublado', '☁️')],
    [('Lluvia ligera', '🌦️'), ('Lluvioso', '🌧️')],
    [('Tormenta eléctrica', '⛈️')],
    [('Nevado', '❄️'), ('Ventisca', '🌨️')],
    [('Niebla', '🌫️')],
  ];

  static List<(String, String)> _conditionsFor(int index) =>
      _conditionPool[index % _conditionPool.length];

  /// Convierte "nueva york" -> "Nueva York".
  static String _titleCase(String value) {
    return value
        .split(RegExp(r'\s+'))
        .where((word) => word.isNotEmpty)
        .map(
          (word) =>
              word[0].toUpperCase() + word.substring(1).toLowerCase(),
        )
        .join(' ');
  }
}

/// Excepción controlada del servicio de clima.
class WeatherServiceException implements Exception {
  final String message;
  const WeatherServiceException(this.message);

  @override
  String toString() => message;
}
