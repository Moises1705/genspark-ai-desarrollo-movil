import 'package:flutter/material.dart';

import '../models/weather.dart';
import '../theme/app_colors.dart';

/// Tarjeta visual que muestra el clima actual de una ciudad.
class WeatherCard extends StatelessWidget {
  final Weather weather;

  const WeatherCard({super.key, required this.weather});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // En modo oscuro la tarjeta usa un azul algo más claro para que se
    // distinga sobre el fondo oscuro; en modo claro usa el azul oscuro.
    final isDark = theme.brightness == Brightness.dark;
    final gradientColors = isDark
        ? const [AppColors.primaryDarkBlueBright, AppColors.primaryDarkBlueDeep]
        : const [AppColors.primaryDarkBlue, AppColors.primaryDarkBlueDeep];

    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      clipBehavior: Clip.antiAlias,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: gradientColors,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Ciudad
            Text(
              weather.city,
              textAlign: TextAlign.center,
              style: theme.textTheme.headlineSmall?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),

            // Icono + temperatura
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  weather.icon,
                  style: const TextStyle(fontSize: 56),
                ),
                const SizedBox(width: 16),
                Text(
                  weather.formattedTemperature,
                  style: theme.textTheme.displaySmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Descripción
            Text(
              weather.description,
              textAlign: TextAlign.center,
              style: theme.textTheme.titleMedium?.copyWith(
                color: Colors.white.withValues(alpha: 0.95),
              ),
            ),
            const SizedBox(height: 20),

            const Divider(color: Colors.white24),

            // Detalles: humedad y viento
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _DetailItem(
                  icon: Icons.water_drop_outlined,
                  label: 'Humedad',
                  value: '${weather.humidity}%',
                ),
                _DetailItem(
                  icon: Icons.air,
                  label: 'Viento',
                  value: '${weather.windSpeed.toStringAsFixed(0)} km/h',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Pequeño bloque con icono, etiqueta y valor para los detalles del clima.
class _DetailItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _DetailItem({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: Colors.white, size: 26),
        const SizedBox(height: 6),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.85),
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}
