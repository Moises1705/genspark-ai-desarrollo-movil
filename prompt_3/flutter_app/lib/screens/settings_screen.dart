import 'package:flutter/material.dart';

/// Pantalla de Configuración de "Clima Rápido".
///
/// Por ahora contiene un interruptor (Switch) para activar/desactivar el modo
/// oscuro. Mantiene una copia local del valor para que el interruptor se mueva
/// al instante, y avisa al padre (que es el dueño real del estado) mediante
/// [onDarkModeChanged] para que aplique y guarde el cambio.
class SettingsScreen extends StatefulWidget {
  /// Indica si el modo oscuro está activo ahora mismo.
  final bool isDarkMode;

  /// Se llama cuando el usuario mueve el interruptor.
  final ValueChanged<bool> onDarkModeChanged;

  const SettingsScreen({
    super.key,
    required this.isDarkMode,
    required this.onDarkModeChanged,
  });

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  /// Copia local del valor, para poder repintar el Switch inmediatamente.
  late bool _darkMode = widget.isDarkMode;

  void _onChanged(bool value) {
    setState(() => _darkMode = value);
    widget.onDarkModeChanged(value);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Configuración'),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // ---- Sección: Apariencia ----
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              child: Text(
                'APARIENCIA',
                style: theme.textTheme.labelSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                  color: theme.colorScheme.primary,
                ),
              ),
            ),
            Card(
              elevation: 0,
              color: theme.colorScheme.surfaceContainerHighest,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: SwitchListTile(
                value: _darkMode,
                onChanged: _onChanged,
                secondary: Icon(
                  _darkMode ? Icons.dark_mode : Icons.light_mode,
                ),
                title: const Text('Modo oscuro'),
                subtitle: Text(
                  _darkMode
                      ? 'Activado · la app se ve con fondo oscuro'
                      : 'Desactivado · la app se ve con fondo claro',
                ),
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                'Tu preferencia se guarda y se recuerda la próxima vez que '
                'abras la app.',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
