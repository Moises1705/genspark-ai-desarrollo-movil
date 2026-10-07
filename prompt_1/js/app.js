/**
 * Mi Lista de Tareas
 *
 * Persistencia con degradación automática:
 *  1. Intentamos usar la RESTful Table API (tabla "tareas") cuando la app se
 *     sirve por http(s) — es decir, en el sitio PUBLICADO o en la vista previa.
 *  2. Si esa API no responde (vista previa sin backend, sin conexión, o el
 *     archivo abierto localmente con file://), caemos automáticamente a
 *     localStorage para que la app siga siendo totalmente funcional.
 *
 * Motivo: abrir el index.html con doble clic usa el protocolo file://, donde
 * las rutas relativas no resuelven y el navegador bloquea las peticiones por
 * CORS (origin 'null'). En ese caso la API no puede usarse y localStorage es
 * el respaldo correcto.
 */

const TABLE = 'tareas';
const LS_KEY = 'mis_tareas_v1';

// Asumimos API disponible salvo en file://, donde sabemos que no puede serlo.
let apiDisponible = window.location.protocol !== 'file:';

// Estado en memoria
let tareas = [];
let filtroActual = 'todas';

// Referencias al DOM
const form = document.getElementById('task-form');
const input = document.getElementById('task-input');
const listaEl = document.getElementById('task-list');
const emptyEl = document.getElementById('empty-state');
const loadingEl = document.getElementById('loading-state');
const statsEl = document.getElementById('task-stats');
const clearBtn = document.getElementById('clear-completed');
const filterBtns = document.querySelectorAll('.filters__btn');

/* -------------------- Utilidades -------------------- */

function nuevoId() {
  return 't_' + Date.now().toString(36) + Math.random().toString(36).slice(2, 8);
}

/* -------------------- Persistencia local -------------------- */

function lsLeer() {
  try {
    return JSON.parse(localStorage.getItem(LS_KEY)) || [];
  } catch {
    return [];
  }
}

function lsEscribir() {
  try {
    localStorage.setItem(LS_KEY, JSON.stringify(tareas));
  } catch (err) {
    console.error('No se pudo guardar en localStorage', err);
  }
}

/* -------------------- Capa de datos -------------------- */

/** Carga todas las tareas. */
async function cargarTareas() {
  if (apiDisponible) {
    try {
      const res = await fetch(`${TABLE}?limit=500`);
      if (!res.ok) throw new Error('API no disponible');
      const data = await res.json();
      tareas = Array.isArray(data.data) ? data.data : [];
      loadingEl.hidden = true;
      render();
      return;
    } catch {
      // La API no está disponible: degradamos a almacenamiento local.
      apiDisponible = false;
      console.info('Table API no disponible; usando almacenamiento local.');
    }
  }
  tareas = lsLeer();
  loadingEl.hidden = true;
  render();
}

/** Crea una tarea nueva y la devuelve. */
async function crearTarea(titulo) {
  const base = { titulo, completada: false, creada_en: new Date().toISOString() };

  if (apiDisponible) {
    try {
      const res = await fetch(TABLE, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(base)
      });
      if (!res.ok) throw new Error('No se pudo crear la tarea');
      return await res.json();
    } catch {
      apiDisponible = false; // degradar y continuar en local
    }
  }

  const nueva = { id: nuevoId(), ...base };
  tareas.unshift(nueva);
  lsEscribir();
  return nueva;
}

/** Actualiza parcialmente una tarea (marcar/desmarcar). */
async function actualizarTarea(id, cambios) {
  if (apiDisponible) {
    try {
      const res = await fetch(`${TABLE}/${id}`, {
        method: 'PATCH',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(cambios)
      });
      if (!res.ok) throw new Error('No se pudo actualizar la tarea');
      return await res.json();
    } catch {
      apiDisponible = false;
    }
  }
  lsEscribir();
  return null;
}

/** Elimina una tarea. */
async function eliminarTarea(id) {
  if (apiDisponible) {
    try {
      const res = await fetch(`${TABLE}/${id}`, { method: 'DELETE' });
      if (!res.ok && res.status !== 204) throw new Error('No se pudo eliminar la tarea');
      return;
    } catch {
      apiDisponible = false;
    }
  }
  lsEscribir();
}

/* -------------------- Render -------------------- */

function tareasFiltradas() {
  if (filtroActual === 'pendientes') return tareas.filter(t => !t.completada);
  if (filtroActual === 'completadas') return tareas.filter(t => t.completada);
  return tareas;
}

function render() {
  const visibles = tareasFiltradas();
  listaEl.innerHTML = '';
  visibles.forEach(tarea => listaEl.appendChild(crearElementoTarea(tarea)));
  emptyEl.hidden = visibles.length > 0;
  actualizarEstadisticas();
}

function crearElementoTarea(tarea) {
  const item = document.createElement('article');
  item.className = 'task' + (tarea.completada ? ' is-completed' : '');
  item.dataset.id = tarea.id;

  const checkbox = document.createElement('input');
  checkbox.type = 'checkbox';
  checkbox.className = 'task__checkbox';
  checkbox.checked = !!tarea.completada;
  checkbox.setAttribute('aria-label', 'Marcar como completada');
  checkbox.addEventListener('change', () => toggleTarea(tarea));

  const titulo = document.createElement('span');
  titulo.className = 'task__title';
  titulo.textContent = tarea.titulo;
  titulo.addEventListener('click', () => toggleTarea(tarea));

  const del = document.createElement('button');
  del.type = 'button';
  del.className = 'task__delete';
  del.setAttribute('aria-label', 'Eliminar tarea');
  del.innerHTML = '<i class="fa-solid fa-trash-can" aria-hidden="true"></i>';
  del.addEventListener('click', () => borrarTarea(tarea));

  item.append(checkbox, titulo, del);
  return item;
}

function actualizarEstadisticas() {
  const total = tareas.length;
  const completadas = tareas.filter(t => t.completada).length;
  const pendientes = total - completadas;
  statsEl.textContent = `${pendientes} pendiente${pendientes === 1 ? '' : 's'} · ${completadas} completada${completadas === 1 ? '' : 's'}`;
  clearBtn.disabled = completadas === 0;
}

/* -------------------- Acciones -------------------- */

async function toggleTarea(tarea) {
  const nuevoEstado = !tarea.completada;
  tarea.completada = nuevoEstado; // actualización optimista
  render();
  try {
    await actualizarTarea(tarea.id, { completada: nuevoEstado });
  } catch (err) {
    console.error(err);
    tarea.completada = !nuevoEstado; // revertir
    render();
  }
}

async function borrarTarea(tarea) {
  const idx = tareas.indexOf(tarea);
  tareas.splice(idx, 1);
  render();
  try {
    await eliminarTarea(tarea.id);
  } catch (err) {
    console.error(err);
    tareas.splice(idx, 0, tarea); // revertir
    render();
  }
}

async function limpiarCompletadas() {
  const completadas = tareas.filter(t => t.completada);
  if (completadas.length === 0) return;
  tareas = tareas.filter(t => !t.completada);
  if (!apiDisponible) lsEscribir();
  render();
  try {
    await Promise.all(completadas.map(t => eliminarTarea(t.id)));
  } catch (err) {
    console.error(err);
    cargarTareas();
  }
}

/* -------------------- Eventos -------------------- */

form.addEventListener('submit', async (e) => {
  e.preventDefault();
  const titulo = input.value.trim();
  if (!titulo) return;

  input.value = '';
  input.focus();

  try {
    await crearTarea(titulo);
    render();
  } catch (err) {
    console.error(err);
    alert('No se pudo agregar la tarea. Inténtalo de nuevo.');
  }
});

filterBtns.forEach(btn => {
  btn.addEventListener('click', () => {
    filtroActual = btn.dataset.filter;
    filterBtns.forEach(b => b.classList.toggle('is-active', b === btn));
    render();
  });
});

clearBtn.addEventListener('click', limpiarCompletadas);

// Inicializar
cargarTareas();
