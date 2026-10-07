# Mi Lista de Tareas

Aplicación web estática (HTML + CSS + JavaScript) para gestionar una lista de
tareas personales. Permite **agregar**, **marcar como completada** y **eliminar**
tareas, con un diseño limpio y moderno, totalmente responsive.

## ✨ Funcionalidades implementadas

- **Agregar tareas** mediante un formulario con validación (no permite vacíos, máx. 200 caracteres).
- **Marcar / desmarcar tareas** como completadas (checkbox o clic sobre el texto).
- **Eliminar tareas** individualmente.
- **Filtros**: ver Todas / Pendientes / Completadas.
- **Contador** de tareas pendientes y completadas en tiempo real.
- **Limpiar completadas**: elimina de una sola vez todas las tareas completadas.
- **Persistencia real** de datos mediante la RESTful Table API (tabla `tareas`).
- **Actualización optimista** en la UI con reversión automática si falla la petición.
- Diseño moderno, con tipografía Inter, iconos Font Awesome y adaptación a móviles.

## 📁 Archivos del proyecto

| Archivo | Propósito |
|---|---|
| `index.html` | Estructura semántica de la app (header, formulario, filtros, lista, footer). |
| `css/style.css` | Estilos, variables de color, animaciones y media queries responsive. |
| `js/app.js` | Lógica CRUD: cargar, crear, actualizar, eliminar y renderizar tareas. |
| `.tables/schema.json` | Definición del esquema de la tabla `tareas`. |

## 🚀 Cómo ejecutarla

1. **Publicar (recomendado)**: ve a la pestaña **Publish** y publica el proyecto con un clic. Una
   vez publicado, la aplicación usa la RESTful Table API y guarda tareas reales en la tabla `tareas`.
2. **Vista previa**: en el editor se ve la interfaz; como la Table API no responde en la vista previa,
   la app cae automáticamente al modo local (localStorage).
3. **Localmente (doble clic en `index.html`)**: funciona igual gracias al **modo local**. No abras
   el archivo con `file://` esperando usar la Table API: el navegador bloquea esas peticiones por
   CORS y las rutas relativas no resuelven sin servidor.

### 🔀 Detección automática de entorno

`js/app.js` decide la persistencia según el protocolo:

| Entorno | Protocolo | Persistencia |
|---|---|---|
| Sitio publicado / servidor | `http(s)://` | RESTful Table API (nube) |
| Archivo local | `file://` | `localStorage` del navegador |

Si la Table API falla por cualquier motivo, la app usa silenciosamente `localStorage` como respaldo,
de modo que **nunca se queda inutilizable**.

## 🗄️ Modelo de datos

Tabla `tareas`:

| Campo | Tipo | Descripción |
|---|---|---|
| `id` | text | Identificador único (autogestionado). |
| `titulo` | text | Texto de la tarea. |
| `completada` | bool | Indica si la tarea está completada. |
| `creada_en` | datetime | Fecha/hora de creación (ISO). |

## 🔌 Endpoints de la API usados

Rutas relativas de la RESTful Table API (misma convención en vista previa y publicación):

- `GET tables/tareas?limit=500` — listar tareas.
- `POST tables/tareas` — crear tarea.
- `PATCH tables/tareas/{id}` — actualizar tarea (marcar completada).
- `DELETE tables/tareas/{id}` — eliminar tarea.

## 🔮 Funcionalidades no implementadas (próximos pasos)

- Edición del texto de una tarea existente.
- Fechas de vencimiento y recordatorios.
- Categorías, etiquetas o prioridades.
- Reordenar tareas por arrastrar y soltar.
- Búsqueda dentro de la lista.
- Sincronización/almacenamiento multiusuario con autenticación.

## 📝 Notas

- La aplicación es 100 % del lado del cliente; no requiere backend propio.
- La persistencia se delega en la RESTful Table API de la plataforma.
