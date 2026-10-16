# Prompt 01: Implementación del Showroom de Obras Terminadas

> **Propósito:** Crear las tablas de obras en `database/schema.sql`, implementar `ObraDAO.php` y `ObraServicio.php`, y desarrollar tanto la vista pública en `public/showroom.php` como el módulo administrativo en `public/admin/obras.php`.

---

## Contexto y Fuentes de Verdad
- `AGENTS.md` (raíz)
- `specs/001-catalogo-modelos/requirements.md` y `design.md`
- `specs/004-showroom-obras/requirements.md` y `design.md`
- `database/schema.sql`

---

## Tareas a Ejecutar

### 1. Base de Datos (`database/schema.sql`)
- Crear la tabla `obras` con campos para título, descripción, zona geográfica, tipo de construcción, `modelo_id` opcional y bandera `publicado`.
- Crear la tabla `imagenes_obra` relacionada con `ON DELETE CASCADE`.
- Agregar índices en `publicado`, `zona_geografica` y `tipo_construccion`.
- Incluir *seed data* con al menos 3 obras terminadas de prueba con imágenes.

### 2. Capa de Datos y Servicios (`src/Datos/` y `src/Servicios/`)
- `ObraDAO.php`: Métodos para listar obras publicadas con filtros por zona/tipo, consulta por ID y métodos CRUD para el panel administrativo.
- `ObraServicio.php`: Validaciones de entrada, manejo de transacciones SQL y procesamiento/almacenamiento de imágenes físicas en `public/assets/img/obras/`.

### 3. Interfaz Pública (`public/showroom.php`)
- Vista pública del Showroom con maquetación en grilla Bootstrap.
- Controles de filtrado por zona y tipo de construcción.
- Carga dinámica mediante AJAX y actualización de la URL del navegador.
- Modal / Galería deslizable para ver fotos en alta resolución.

### 4. Interfaz Administrativa (`public/admin/obras.php`)
- Formulario CRUD para alta, modificación, carga de imágenes y cambio de estado de obras (protegido por sesión de administrador).

---

## Restricciones
- Usar exclusivamente consultas parametrizadas (PDO).
- Sanitizar todas las salidas HTML con `htmlspecialchars()`.
- Exigir sesión administrativa activa para cualquier acción en `public/admin/obras.php`.

---

## Verificación
1. Mostrame los archivos creados y modificados.
2. Confirmá cómo se conectan las obras terminadas con los modelos del catálogo público.