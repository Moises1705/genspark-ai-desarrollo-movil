# GastosApp (SwiftUI + SwiftData)

App de iPhone para llevar el control de gastos personales, escrita en **SwiftUI** y con persistencia de datos mediante **SwiftData**.

## Funcionalidades
- **Pantalla principal** con la lista de gastos (nombre, monto y fecha).
- **Total de gastos** mostrado en una tarjeta destacada en la parte superior.
- **Botón "+"** que abre un formulario para **agregar un gasto nuevo**.
- **Persistencia con SwiftData**: los datos se guardan en disco y sobreviven al reinicio de la app.
- Extras: categorías con iconos, borrado con deslizar o `EditButton`, estado vacío y moneda en EUR.

## Requisitos
- **macOS** con **Xcode 15** o superior (SwiftData requiere Xcode 15+).
- **iOS 17.0** o superior (SwiftData solo está disponible desde iOS 17).
- Un simulador de iPhone o un dispositivo iOS 17+.

## Estructura de carpetas
```
GastosApp/
├── GastosApp.xcodeproj/                 # Proyecto de Xcode
│   ├── project.pbxproj
│   ├── project.xcworkspace/
│   │   └── contents.xcworkspacedata
│   │   └── xcshareddata/IDEWorkspaceChecks.plist
│   └── xcshareddata/xcschemes/
│       └── GastosApp.xcscheme           # Scheme compartido
├── GastosApp/                           # Código fuente
│   ├── GastosAppApp.swift               # Punto de entrada + ModelContainer
│   ├── Models/
│   │   └── Gasto.swift                  # @Model Gasto + enum CategoriaGasto
│   ├── Views/
│   │   ├── ListaGastosView.swift        # Pantalla principal (lista + total + botón)
│   │   └── NuevoGastoView.swift         # Formulario para agregar gasto
│   ├── Assets.xcassets/                 # Iconos y colores
│   │   ├── AppIcon.appiconset/
│   │   └── AccentColor.colorset/
│   └── Preview Content/                 # Assets solo para Preview
│       └── Preview Assets.xcassets/
├── project.yml                          # Spec para regenerar con XcodeGen (opcional)
├── .gitignore
└── README.md
```

## Cómo abrirlo en Xcode
1. Copia la carpeta `GastosApp` a tu Mac.
2. **Doble clic** en `GastosApp.xcodeproj` (o `File ▸ Open…` en Xcode y selecciónalo).
3. Arriba, en la barra de esquemas, elige el esquema **GastosApp** y un **simulador de iPhone** (p. ej. "iPhone 15").
4. Si aparece un aviso de firma (`Signing`), ve a **Signing & Capabilities** y elige tu **Team** (con tu Apple ID), o deja *Automatically manage signing* activado.
5. Pulsa **▶︎ (Run)** o `⌘R` para compilar y ejecutar.

### Regenerar el proyecto (alternativa recomendada)
Si el `project.pbxproj` te diera algún problema, usa **XcodeGen** (más robusto porque genera el proyecto desde `project.yml`):

```bash
brew install xcodegen
cd GastosApp
xcodegen generate
open GastosApp.xcodeproj
```

## Limitaciones de este entorno (importante)
El entorno donde se ha generado este proyecto es **Linux sobre un sandbox de desarrollo**, y **NO** es macOS. En concreto:

- ❌ **No hay Xcode ni `xcodebuild`** → no se puede compilar ni archivar la app aquí.
- ❌ **No hay compilador de Swift** → no se pueden ejecutar test ni build de Swift.
- ❌ **No hay simulador de iOS** → no se puede ver la app en marcha.
- ❌ **No hay SwiftData en runtime** → su API solo existe en el sistema Apple (iOS 17+/macOS 14+).

✅ **Lo que sí se ha entregado y verificado aquí:**
- Toda la estructura de carpetas y **todos los archivos `.swift`**.
- El **`project.pbxproj`** y el **scheme** con **llaves y paréntesis balanceados** y plists/JSON validados sintácticamente.
- Un `project.yml` para regenerar el proyecto con XcodeGen.

⚠️ **No compilado**: el código está escrito siguiendo las APIs correctas de SwiftUI/SwiftData, pero **no ha podido compilarse ni probarse** en este entorno. Al abrirlo en un Mac con Xcode 15+ debería compilar sin cambios; si Xcode detectara cualquier detalle, será trivial de ajustar en el IDE.

## Notas de diseño
- El `ModelContainer` se crea una vez en `GastosAppApp.swift` y se inyecta con `.modelContainer(...)`.
- Las vistas usan `@Query` para leer datos de forma reactiva y `@Environment(\.modelContext)` para insertar/borrar.
- El monto acepta coma o punto decimal (se normaliza a punto antes de convertir).
