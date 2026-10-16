# Prompt 01: Búsqueda por Texto y Filtros de Precisión

> **Propósito:** Implementar la lógica de consulta dinámica multi-criterio en `src/Datos/` y `src/Servicios/`, actualizar el endpoint de la API pública en `public/api/catalogo.php` y maquetar los controles de filtrado en la vista de `public/index.php`.

---

## Contexto y Fuentes de Verdad
Antes de ejecutar la tarea, leé y tomá como referencia exclusiva:
- `AGENTS.md` (raíz)
- `specs/001-catalogo-modelos/requirements.md` y `design.md`
- `specs/003-busqueda-filtros/requirements.md` y `design.md`
- `database/schema.sql`

---

## Tareas a Ejecutar

### 1. Capa de Datos y Consultas Dinámicas (`src/Datos/PiscinaDAO.php`)
- Extender el método de consulta de catálogo para aceptar los filtros opcionales de precisión:
  - Búsqueda por texto libre (en `nombre` y `descripcion` usando `LIKE %término%`, insensible a mayúsculas/acentos `RN-BUS-004`).
  - Rangos de dimensiones: `largo_min`, `largo_max`, `ancho_min`, `ancho_max`, `profundidad_min`, `profundidad_max`.
  - Material exacto (`material`).
- Construir la cláusula `WHERE` dinámicamente mediante `Prepared Statements` (PDO bindings) combinando todos los criterios activos con el operador lógico `AND` (`RN-BUS-001`, `D-BUS-01`).
- Preservar la cláusula `ORDER BY` con la semilla determinista (`RAND(seed)`) o el orden explícito elegido por el usuario (`D-BUS-03`).

### 2. Endpoint de API Pública (`public/api/catalogo.php`)
- Procesar los nuevos parámetros provenientes de la petición GET (`q`, `largo_min`, `largo_max`, `ancho_min`, `ancho_max`, `profundidad_min`, `profundidad_max`, `material`).
- Validar y sanitizar cada parámetro de entrada antes de enviarlo a la capa DAO.
- Retornar la respuesta JSON con la lista filtrada de modelos, la cantidad de resultados encontrados y los metadatos de la consulta.

### 3. Interfaz y Persistencia en la URL (`public/index.php` y `public/assets/js/`)
- Maquetar el panel lateral/superior de filtros de precisión en `public/index.php` con Bootstrap (desplegable/collapsible en pantallas móviles `RN-007`).
- Implementar la lógica JavaScript/AJAX para enviar la búsqueda y actualizar la grilla de productos sin recargar la página completa (`CA-4`).
- Reflejar inmediatamente todos los parámetros de filtrado en la URL (`query string`) para mantener la persistencia al compartir el enlace o presionar el botón "Atrás" (`RN-BUS-005`).
- Agregar el botón "Limpiar Filtros" que restablece los controles y devuelve la vista general del catálogo conservando la semilla de la visita (`RN-BUS-003`).

---

## Restricciones
- No modifiques el comportamiento stateless ni invalides la semilla de orden aleatorio de la visita (`RN-BUS-002`).
- Ningún parámetro de búsqueda debe ser concatenado directamente en las sentencias SQL.
- Toda salida de texto proveniente de la búsqueda debe sanitizarse con `htmlspecialchars()`.

---

## Verificación
1. Mostrame la lista de archivos creados o modificados.
2. Confirmá cómo se construyen las sentencias parametrizadas y cómo se sincroniza la URL del navegador al aplicar filtros.