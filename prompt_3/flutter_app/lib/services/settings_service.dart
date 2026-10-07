import 'package:shared_preferences/shared_preferences.dart';

/// Guarda y lee las preferencias del usuario que deben sobrevivir al cierre
/// de la app (por ahora, solo el modo oscuro).
///
/// Usa `shared_preferences`, que funciona tanto en Android como en Web.
class SettingsService {
  /// Clave con la que guardamos el modo oscuro en el almacenamiento local.
  static const String _darkModeKey = 'dark_mode_enabled';

  /// Devuelve `true` si el usuario había activado el modo oscuro.
  /// Si nunca lo eligió, devuelve [defaultValue] (por defecto: `false`).
  Future<bool> loadDarkMode({bool defaultValue = false}) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool(_darkModeKey) ?? defaultValue;
    } catch (_) {
      // Si el almacenamiento falla, no rompemos la app: usamos el valor por
      // defecto.
      return defaultValue;
    }
  }

  /// Guarda la preferencia del modo oscuro.
  Future<void> saveDarkMode(bool enabled) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_darkModeKey, enabled);
    } catch (_) {
      // Ignoramos fallos de escritura para no bloquear la interfaz.
    }
  }
}
