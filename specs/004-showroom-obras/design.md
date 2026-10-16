# design.md — Showroom de Obras Terminadas

- **Feature:** `004-showroom-obras`
- **Versión del documento:** 0.1-draft
- **Estado:** BORRADOR
- **requirements.md de referencia:** `specs/004-showroom-obras/requirements.md`

---

## 1. Arquitectura General y Esquema de Datos

Se incorporan dos nuevas entidades al dominio relacional: `obras` e `imagenes_obra`.

---

## 2. Decisiones Técnicas (ADR)

### D-OBR-01 — Estructura de Tablas Relacionales
- **Decisión:** 
  - `obras`: `id` (PK), `modelo_id` (FK a `modelos`, NULLable), `titulo`, `descripcion`, `zona_geografica`, `tipo_construccion`, `publicado`, `fecha_creacion`.
  - `imagenes_obra`: `id` (PK), `obra_id` (FK a `obras` con `ON DELETE CASCADE`), `url_archivo`, `posicion`, `texto_alternativo`.

### D-OBR-02 — Optimización de Imágenes para Showroom
- **Decisión:** Las imágenes subidas desde el back-office se procesan en el servidor para generar una versión optimizada (WebP / compresión progresiva) y una miniatura (thumbnail) para la grilla del Showroom.

### D-OBR-03 — Filtro sin Recarga y Estado en URL
- **Decisión:** La selección de `zona_geografica` y `tipo_construccion` se sincroniza con el `query string` de la URL (`?zona=posadas&tipo=deck`) igual que en la Spec 003.