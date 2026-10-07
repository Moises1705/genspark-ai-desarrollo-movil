import 'package:flutter/material.dart';

/// Paleta central de la app "Clima Rápido".
///
/// Tener los colores en un solo sitio evita repetirlos "a mano" por el código
/// y hace que cambiar el color de marca sea trivial.
class AppColors {
  // Constructor privado: esta clase solo agrupa constantes, no se instancia.
  AppColors._();

  /// Azul oscuro principal (color de marca de la app).
  /// Se usa como semilla del [ColorScheme] y como fondo del [AppBar].
  static const Color primaryDarkBlue = Color(0xFF0D2B57);

  /// Azul oscuro más profundo, para el final del degradado de la tarjeta.
  static const Color primaryDarkBlueDeep = Color(0xFF081C39);

  /// Azul oscuro (algo más claro) usado para el inicio del degradado de la
  /// tarjeta cuando la app está en modo oscuro, para que la tarjeta se vea
  /// sobre el fondo oscuro.
  static const Color primaryDarkBlueBright = Color(0xFF1C4B8A);

  /// Color de texto/íconos que va ENCIMA del azul oscuro (siempre claro).
  static const Color onPrimary = Colors.white;
}
