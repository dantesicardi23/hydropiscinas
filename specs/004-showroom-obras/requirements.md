# requirements.md — Showroom de Obras Terminadas

- **Nombre del proyecto:** Plataforma Web Piscinas Polaco (Polaco ADM)
- **Feature:** `004-showroom-obras`
- **Versión del documento:** 0.1-draft
- **Estado:** BORRADOR
- **Fuente de origen:** Presupuesto "Web Plan de Ahorro Piscinas" (§1) y hoja de ruta de `001-catalogo-modelos` (§6)
- **Artefacto asociado:** `design.md` — el CÓMO de esta feature

> **Este documento es el QUÉ.** Describe comportamiento observable, no implementación.
> Cuando este documento y `design.md` discrepan, `requirements.md` manda sobre qué hay que construir.

---

## 1. Contexto y objetivos

**Esta feature (004) cubre el portafolio público de proyectos instalados y su gestión administrativa.**
Permite que los visitantes exploren fotos de proyectos reales finalizados por la empresa, filtrando por ubicación geográfica (zona/localidad) y por tipo de construcción o instalación. Además, incluye el módulo administrativo para que el personal interno cargue y mantenga las obras.

**Usuarios:** 
- Visitante anónimo (navegación pública).
- Administrador / Back-office (carga y publicación).

**Objetivo de la feature:** Generar prueba social de alta gama mostrando la calidad de terminación de los proyectos instalados, conectando las fotos de las obras con el modelo de piscina correspondiente del catálogo cuando aplique.

---

## 2. Reglas de Negocio Específicas del Showroom (RN-OBR-xxx)

- **RN-OBR-001 · Publicación independiente.** Una obra terminada posee su propio estado `publicado` (sí/no) independiente de los modelos del catálogo.
- **RN-OBR-002 · Asociación opcional a modelo.** Una obra puede estar asociada a un `Modelo` del catálogo o registrarse como una obra a medida/personalizada.
- **RN-OBR-003 · Clasificación geográfica y tipo.** Toda obra debe tener asignada obligatoriamente una zona geográfica (ej. Posadas, Oberá, Encarnación) y un tipo de construcción/instalación (ej. Sobre terreno, Enterrada, Solarium deck, Aterrazada).
- **RN-OBR-004 · Múltiples fotos por obra.** Una obra consta de un título, ubicación, descripción corta, fecha de finalización opcional y una galería de fotos con su correspondiente texto alternativo.

---

## 3. Especificaciones Funcionales (Features F-OBR-xxx)

### F-OBR-001 — Explorar el Showroom (Público)
* **CA-1 (Listado de proyectos):** El visitante explora las fichas de obras terminadas con su foto destacada, ubicación y tipo de instalación.
* **CA-2 (Filtro por Zona y Tipo):** Al seleccionar una zona geográfica o un tipo de construcción, la grilla se actualiza dinámicamente mediante AJAX/Fetch sin recargar la página.
* **CA-3 (Detalle de Obra):** Al abrir una obra, se despliega la galería en alta resolución, la ficha técnica del proyecto y un enlace directo al modelo de piscina asociado (si aplica) para cotizarlo.

### F-OBR-002 — Gestión de Obras (Back-office)
* **CA-1 (CRUD de Obras):** El administrador puede crear, editar, publicar/despublicar y eliminar proyectos finalizados.
* **CA-2 (Carga de Galería):** El administrador sube y reordena múltiples fotografías por obra en `public/assets/img/obras/`.