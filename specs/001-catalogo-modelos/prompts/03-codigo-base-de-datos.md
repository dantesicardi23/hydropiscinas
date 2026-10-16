# Prompt 03: Código Base y Lectura del Catálogo Público

> **Propósito:** Implementar la conexión a la base de datos, los DAOs en `src/Datos/`, la API en `public/api/` y la vista pública principal en `public/index.php`.

---

## Contexto y Fuentes de Verdad
- `AGENTS.md` (raíz)
- `specs/001-catalogo-modelos/requirements.md` y `design.md`
- `database/schema.sql` (creado en el prompt 02)

---

## Tareas a Ejecutar

1. **Configuración (`config/config.php.example`):**
   - Plantilla de constantes de conexión PDO (`DB_HOST`, `DB_NAME`, `DB_USER`, `DB_PASS`, `DB_PORT`).

2. **Capa de Datos (`src/Datos/`):**
   - `Conexion.php`: Singleton / Conexión PDO configurada con `ERRMODE_EXCEPTION` y `FETCH_ASSOC`.
   - `CategoriaDAO.php`: Método para obtener únicamente categorías con modelos publicados (`RN-005`, `D-02`).
   - `PiscinaDAO.php`: Métodos para consultar modelos publicados aplicando filtro de categoría, orden por semilla (`RAND(seed)`) u orden explícito (`D-03`), y consulta de ficha técnica por ID.

3. **Capa Pública (`public/`):**
   - `public/api/catalogo.php`: Endpoint JSON para responder las peticiones AJAX de filtrado y ordenamiento.
   - `public/index.php`: Interfaz del catálogo maquetada con Bootstrap por CDN (`D-09`), grilla de productos, selector de categorías/orden y modal/detalle para la ficha técnica.

---

## Restricciones
- Asegurá que todo texto en HTML pase por sanitización (`htmlspecialchars`).
- Mantené `public/` como la única carpeta expuesta al servidor web.
- No utilices frameworks de PHP.