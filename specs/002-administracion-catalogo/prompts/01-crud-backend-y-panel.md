# Prompt 01: CRUD Backend y Panel de Administración del Catálogo

> **Propósito:** Implementar la autenticación de administradores, los servicios de mutación de datos en `src/Servicios/`, el procesamiento de imágenes y la interfaz web del panel de administración en `public/admin/`.

---

## Contexto y Fuentes de Verdad
Antes de ejecutar la tarea, leé y tomá como referencia exclusiva:
- `AGENTS.md` (raíz)
- `specs/001-catalogo-modelos/requirements.md` y `design.md`
- `specs/002-administracion-catalogo/requirements.md` y `design.md`
- `database/schema.sql`

---

## Tareas a Ejecutar

### 1. Actualización de Base de Datos (`database/schema.sql`)
- Agregar la tabla `usuarios` (id, email, password_hash, fecha_creacion) para el control de acceso administrativo.
- Incluir un usuario administrador por defecto (con contraseña hasheada mediante `password_hash()`) en el *seed data*.

### 2. Autenticación y Capa de Soporte (`src/Soporte/`)
- `Autenticacion.php`: Gestionar el inicio de sesión (`session_start()`), verificación de credenciales (`password_verify()`), destrucción de sesión y middleware/función de verificación de sesión activa para proteger rutas administrativas (`D-ADM-01`).
- Asegurar que las cookies de sesión usen las directivas `HttpOnly`, `SameSite=Strict` y `Secure`.

### 3. Capa de Servicios y Mutaciones (`src/Servicios/`)
- `CategoriaServicio.php`:
  - Crear y editar categorías (validando nombres duplicados).
  - Eliminar categorías únicamente si no tienen modelos asociados (`RN-ADM-002`).
- `ModeloServicio.php`:
  - Crear modelos (por defecto `publicado = 0`, según `RN-ADM-003`).
  - Editar atributos y alternar estado de publicación (`publicado`).
  - Eliminar modelo (con borrado en cascada de imágenes).
  - Validar sintaxis de `videoUrl` si está presente (`RN-ADM-006`).
- `ImagenServicio.php`:
  - Guardar imágenes en `public/assets/img/modelos/` renombrando los archivos con hash/UUID único (`D-ADM-02`).
  - Gestionar el orden de galería y garantizar que exactamente una imagen sea la principal (`posicion = 1`, `RN-ADM-004`).

### 4. Vistas y Endpoints del Back-office (`public/admin/`)
- `public/admin/login.php`: Formulario de inicio de sesión del administrador.
- `public/admin/index.php`: Panel principal / Dashboard con listado de categorías y modelos.
- `public/admin/modelos.php`: Formulario para alta, edición, carga/ordenamiento de imágenes y cambio de estado publicado.
- `public/admin/categorias.php`: Interfaz para gestión (CRUD) de categorías.

---

## Restricciones
- Todas las operaciones SQL de escritura deben utilizar consultas parametrizadas (PDO) y manejo de transacciones en operaciones compuestas (`D-ADM-03`, `D-ADM-04`).
- Toda entrada/salida de datos en HTML debe estar neutralizada con `htmlspecialchars()`.
- Ninguna ruta bajo `public/admin/` (excepto `login.php`) debe ser accesible sin una sesión de administrador activa (`RN-ADM-001`).

---

## Verificación
1. Mostrame la lista de archivos creados y modificados.
2. Confirmá cómo se protegen las rutas privadas y cómo se maneja la subida de archivos físicos.