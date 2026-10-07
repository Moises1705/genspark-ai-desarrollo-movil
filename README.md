# Genspark AI Code - Desarrollo móvil

Trabajo grupal: pruebas de **Genspark.ai/code**, un agente de IA que programa sin que el usuario escriba código (no-code). Cada carpeta nace de un prompt distinto, ejecutado de forma independiente.

## Estructura

| Carpeta | Prompt | Tecnología | Resultado |
|---|---|---|---|
| `prompt_1` | Lista de tareas (to-do) desde cero | HTML, CSS, JavaScript | Funcionó, con una corrección |
| `prompt_2` | App "GastosApp" | SwiftUI + SwiftData (Xcode) | Código generado, **no compilado** |
| `prompt_3` | App "Clima Rápido" | Flutter (Dart) | Funcionó en vista previa web |

---

## prompt_1: Lista de tareas web

**Prompt usado:** crear una aplicación web de lista de tareas que permita agregar, marcar como completada y eliminar tareas, con diseño limpio y moderno.

**Resultado:**
- El agente generó `index.html`, `css/style.css`, `js/app.js` y un README.
- Al abrir `index.html` con doble clic (`file://`) falló por un error de CORS.
- Con una segunda instrucción, el agente hizo que la app use `localStorage` cuando no hay base de datos. Después funcionó.

**Cómo probarla:** abrir `index.html` en el navegador.

---

## prompt_2: GastosApp (Xcode + SwiftUI)

**Prompt usado:** crear un proyecto de Xcode con SwiftUI para una app de gastos, con lista, formulario, total y datos guardados con SwiftData.

**Resultado:**
- El agente entregó el proyecto completo: 4 archivos `.swift`, `.xcodeproj`, `project.yml` (XcodeGen) y assets.
- Informó con honestidad que su entorno es Linux y que **no pudo compilar ni ejecutar** el proyecto.
- **No fue compilado por el grupo**, porque nadie tiene un Mac con Xcode.
- Hubo un problema al descargar: el primer ZIP salió mal y hubo que pedir un segundo intento.

**Cómo probarlo:** en un Mac con Xcode 15+ (iOS 17+), abrir `GastosApp.xcodeproj`.

---

## prompt_3: Clima Rápido (Flutter)

**Prompt usado:** crear una app móvil con Flutter donde el usuario escribe una ciudad y ve una tarjeta con temperatura y descripción.

**Resultado:**
- El agente generó el proyecto Flutter completo y una vista previa web que funcionó.
- Los datos del clima son **de ejemplo** (generados de forma determinista), no reales.
- El ZIP se descargó bien a la primera.
- El APK no fue probado en un celular.

**Cómo probarla:**
```bash
cd prompt_3/flutter_app
flutter pub get
flutter run
```

---

## Conclusiones preliminares

- El agente es **honesto sobre sus límites** (en la prueba de SwiftUI avisó que no podía compilar).
- Puede **compilar y previsualizar** web y Flutter, pero **no** apps nativas de Apple.
- Dijo "verificado" en la prueba 1 y aun así falló en el equipo del usuario: probó en su entorno, no en el nuestro.
- Los enlaces de descarga son temporales y hay que bajar los archivos rápido.

> Proyectos generados por Genspark Code como parte de un trabajo grupal. No son código de producción.