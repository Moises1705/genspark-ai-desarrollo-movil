import 'package:flutter/material.dart';

import '../models/weather.dart';
import '../services/weather_service.dart';
import '../theme/app_colors.dart';
import '../widgets/weather_card.dart';
import 'settings_screen.dart';

/// Pantalla principal de "Clima Rápido".
///
/// Permite escribir una ciudad y muestra una tarjeta con el clima de ejemplo.
/// Recibe el estado del tema y callbacks para alternarlo o abrir Configuración.
class WeatherScreen extends StatefulWidget {
  /// Indica si el modo oscuro está activo actualmente.
  final bool isDarkMode;

  /// Se llama cuando el usuario toca el botón para cambiar de tema.
  final VoidCallback onToggleTheme;

  /// Se llama cuando el usuario cambia el modo oscuro desde Configuración.
  final ValueChanged<bool> onDarkModeChanged;

  const WeatherScreen({
    super.key,
    required this.isDarkMode,
    required this.onToggleTheme,
    required this.onDarkModeChanged,
  });

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  final TextEditingController _cityController = TextEditingController();
  final WeatherService _weatherService = WeatherService();

  Weather? _weather;
  bool _isLoading = false;
  String? _error;

  @override
  void dispose() {
    _cityController.dispose();
    super.dispose();
  }

  Future<void> _search() async {
    final city = _cityController.text.trim();
    FocusScope.of(context).unfocus();

    setState(() {
      _isLoading = true;
      _error = null;
      _weather = null;
    });

    try {
      final weather = await _weatherService.fetchByCity(city);
      if (!mounted) return;
      setState(() {
        _weather = weather;
        _isLoading = false;
      });
    } on WeatherServiceException catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.message;
        _isLoading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _error = 'No se pudo obtener el clima. Inténtalo de nuevo.';
        _isLoading = false;
      });
    }
  }

  /// Abre la pantalla de Configuración.
  void _openSettings() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => SettingsScreen(
          isDarkMode: widget.isDarkMode,
          onDarkModeChanged: widget.onDarkModeChanged,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Clima Rápido'),
        // El color de fondo/foreground ahora lo define el AppBarTheme del
        // MaterialApp, así que aquí no lo fijamos para que respete el tema.
        actions: [
          IconButton(
            // Ícono y tooltip dependen del tema actual.
            icon: Icon(
              widget.isDarkMode ? Icons.light_mode : Icons.dark_mode,
            ),
            tooltip: widget.isDarkMode
                ? 'Cambiar a modo claro'
                : 'Cambiar a modo oscuro',
            onPressed: widget.onToggleTheme,
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: 'Configuración',
            onPressed: _openSettings,
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 8),
              _buildSearchField(),
              const SizedBox(height: 24),
              _buildContent(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchField() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _cityController,
            textInputAction: TextInputAction.search,
            onSubmitted: (_) => _search(),
            decoration: InputDecoration(
              hintText: 'Escribe una ciudad...',
              prefixIcon: const Icon(Icons.location_city),
              filled: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        SizedBox(
          height: 56,
          child: FilledButton(
            onPressed: _isLoading ? null : _search,
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.primaryDarkBlue,
              foregroundColor: AppColors.onPrimary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20),
            ),
            child: const Icon(Icons.search),
          ),
        ),
      ],
    );
  }

  Widget _buildContent() {
    if (_isLoading) {
      return const Padding(
        padding: EdgeInsets.only(top: 60),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (_error != null) {
      return Padding(
        padding: const EdgeInsets.only(top: 40),
        child: Column(
          children: [
            const Icon(Icons.error_outline, size: 56, color: Colors.redAccent),
            const SizedBox(height: 12),
            Text(
              _error!,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      );
    }

    if (_weather == null) {
      return const Padding(
        padding: EdgeInsets.only(top: 60),
        child: Column(
          children: [
            Icon(Icons.cloud_outlined, size: 72, color: Colors.blueGrey),
            SizedBox(height: 12),
            Text(
              'Busca una ciudad para ver su clima.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.blueGrey),
            ),
          ],
        ),
      );
    }

    return WeatherCard(weather: _weather!);
  }
}
