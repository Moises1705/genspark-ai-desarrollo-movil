/// Modelo de datos que representa el clima de una ciudad.
///
/// Todos los campos son `final` para que la instancia sea inmutable.
class Weather {
  final String city;
  final double temperature; // grados Celsius
  final String description; // texto legible (p. ej. "Parcialmente nublado")
  final String icon; // emoji representativo
  final int humidity; // % de humedad
  final double windSpeed; // km/h

  const Weather({
    required this.city,
    required this.temperature,
    required this.description,
    required this.icon,
    required this.humidity,
    required this.windSpeed,
  });

  /// Devuelve una temperatura formateada, p. ej. "22.5 °C".
  String get formattedTemperature =>
      '${temperature.toStringAsFixed(1)} °C';
}
