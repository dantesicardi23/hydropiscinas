# design.md — Búsqueda y Filtros de Precisión

- **Feature:** `003-busqueda-filtros`
- **Versión del documento:** 0.1-draft
- **Estado:** BORRADOR
- **requirements.md de referencia:** `specs/003-busqueda-filtros/requirements.md`

---

## 1. Arquitectura General

El motor de búsqueda amplía el **Componente de consulta del catálogo** en `src/Servicios/` y la **Capa de acceso a datos** en `src/Datos/`[cite: 4]. No crea tablas nuevas; opera mediante consultas SQL dinámicas sobre las entidades `modelos` y `categorias` existentes[cite: 3, 4, 6].

---

## 2. Decisiones Técnicas (ADR)

### D-BUS-01 — Construcción de Consultas Dinámicas con Sentencias Parametrizadas
- **Contexto:** Los filtros son opcionales y combinables (dimensiones, texto, material, categoría)[cite: 1, 3].
- **Decisión:** La capa de datos construye la cláusula `WHERE` agregando dinámicamente las condiciones según los parámetros recibidos. Todos los valores (texto, rangos numéricos) se vinculan obligatoriamente mediante *Prepared Statements* (PDO bindings) para prevenir SQL Injection[cite: 4, 6].

### D-BUS-02 — Búsqueda por Texto Insensible a Acentos y Mayúsculas
- **Contexto:** Mejorar la usabilidad al buscar modelos (RN-BUS-004).
- **Decisión:** En MySQL se utiliza la colación `utf8mb4_unicode_ci` (o `utf8mb4_general_ci`) en los campos `nombre` y `descripcion`, combinado con cláusulas `LIKE %término%` parametrizadas.

### D-BUS-03 — Integración con la Semilla de Ordenamiento
- **Contexto:** Mantener el orden aleatorio determinista por semilla (D-03 de spec 001) al aplicar filtros[cite: 4].
- **Decisión:** La semilla (`seed`) y la opción de orden (`orden`) se pasan siempre como parámetros adicionales en la consulta filtrada. La cláusula `ORDER BY` se aplica sobre el conjunto de resultados que pasa los filtros de la cláusula `WHERE`.