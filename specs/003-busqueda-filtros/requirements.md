# requirements.md — Búsqueda y Filtros de Precisión

- **Nombre del proyecto:** Plataforma Web Piscinas Polaco (Polaco ADM)
- **Feature:** `003-busqueda-filtros`
- **Versión del documento:** 0.1-draft
- **Estado:** BORRADOR
- **Fuente de origen:** Presupuesto "Web Plan de Ahorro Piscinas" (§1) y hoja de ruta de `001-catalogo-modelos` (§6)[cite: 1, 3]
- **Artefacto asociado:** `design.md` — el CÓMO de esta feature

> **Este documento es el QUÉ.** Describe comportamiento observable, no implementación.
> Cuando este documento y `design.md` discrepan, `requirements.md` manda sobre qué hay que construir.

---

## 1. Contexto y objetivos

**Esta feature (003) cubre el motor de búsqueda por texto y los filtros de precisión del catálogo público.**
Permite que un visitante filtre las piscinas publicadas según criterios específicos (dimensiones mínimas/máximas, tipo de material) o busque por palabras clave en nombre y descripción[cite: 1, 3], encontrando rápidamente el modelo adecuado para su terreno.

**Usuarios:** Visitante anónimo (navegación pública)[cite: 3].

**Objetivo de la feature:** Ofrecer una experiencia de filtrado fluida y en tiempo real (vía AJAX/Fetch sin recargar la página)[cite: 1, 3], combinando los filtros de precisión con la categoría elegida y respetando el orden aleatorio fijado por la semilla de la visita (RN-004)[cite: 3, 4].

---

## 2. Reglas de Negocio Específicas de Búsqueda (RN-BUS-xxx)

- **RN-BUS-001 · Filtros combinables.** Los filtros de categoría (001), búsqueda por texto, dimensiones y material son aditivos (operación lógica AND).
- **RN-BUS-002 · Preservación del orden y la visita.** Aplicar o limpiar filtros no cambia la semilla del orden aleatorio de la visita ni el orden explícito seleccionado por el visitante (RN-004, RN-011)[cite: 3, 4].
- **RN-BUS-003 · Estado sin resultados.** Si la combinación de filtros no arroja ningún modelo publicado, se muestra un mensaje claro indicando que no hay coincidencias y ofreciendo un botón para "Limpiar Filtros", sin romper la interfaz.
- **RN-BUS-004 · Sanitización de términos de búsqueda.** La búsqueda por texto ignora espacios en blanco adicionales al inicio/final y trata mayúsculas, minúsculas y acentos de manera no sensible (case-insensitive & accent-insensitive).
- **RN-BUS-005 · Persistencia en la URL.** Todos los criterios de búsqueda y filtrado aplicados deben reflejarse en la dirección (query string) para permitir compartir el enlace o usar el botón "Atrás" del navegador (complementa D-07 de la spec 001).

---

## 3. Especificaciones Funcionales (Features F-BUS-xxx)

### F-BUS-001 — Búsqueda y Filtros de Precisión

**Historia de usuario:** Como visitante, quiero filtrar las piscinas por sus medidas y material o buscar por nombre, para encontrar el modelo exacto que entra en mi patio.

* **CA-1 (Búsqueda por texto):** Dado que el visitante ingresa un término en el buscador (ej: "compacta" o "solarium"), el sistema retorna únicamente los modelos publicados cuyo nombre o descripción contengan dicho término.
* **CA-2 (Filtro por dimensiones):** Dado que el visitante establece un rango de dimensiones (ej. Largo entre 5m y 8m, Ancho máximo 4m), el catálogo muestra solo las piscinas que cumplen simultáneamente con todas las cotas especificadas[cite: 1, 3].
* **CA-3 (Filtro por material):** Dado que el visitante selecciona un material específico (ej. "Fibra de vidrio"), la lista se actualiza mostrando solo los modelos construidos en ese material[cite: 1, 3].
* **CA-4 (Actualización sin recarga):** Al modificar cualquier filtro, la lista de modelos se actualiza mediante AJAX/Fetch sin recargar la página completa, manteniendo el estado visual del panel de filtros[cite: 1, 3].
* **CA-5 (Limpieza de filtros):** El visitante dispone de una acción para "Limpiar filtros" que restaura la vista general del catálogo manteniendo la categoría actual o volviendo a "Todas".