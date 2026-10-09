# requirements.md — Administración del Catálogo (Back-office)

- **Nombre del proyecto:** Plataforma Web Piscinas Polaco (Polaco ADM)
- **Feature:** `002-administracion-catalogo`
- **Versión del documento:** 0.1-draft
- **Estado:** BORRADOR
- **Fuente de origen:** Presupuesto "Web Plan de Ahorro Piscinas" y hoja de ruta de `001-catalogo-modelos`
- **Artefacto asociado:** `design.md` — el CÓMO de esta feature

> **Este documento es el QUÉ.** Describe comportamiento observable, no implementación.
> Cuando este documento y `design.md` discrepan, `requirements.md` manda sobre qué hay que construir.

---

## 1. Contexto y objetivos

**Esta feature (002) cubre el panel de administración interno para la carga y gestión del catálogo.**
Permite que un usuario administrador realice el ciclo de vida completo (alta, lectura, edición, cambio de estado y baja) sobre las entidades **Categoría**, **Modelo** e **Imagen**, asegurando la integridad de las reglas del negocio definidas en `001-catalogo-modelos`.

**Usuarios:** Administrador del sistema / Personal interno.

**Objetivo de la feature:** Proveer una interfaz administrativa segura y simple para mantener actualizado el catálogo de piscinas público, gestionar la visibilidad de los modelos y administrar el material multimedia (imágenes y video opcional).

---

## 2. Reglas de Negocio Específicas de Administración (RN-ADM-xxx)

- **RN-ADM-001 · Autenticación requerida.** Todas las funciones de la administración exigen que el usuario esté autenticado.
- **RN-ADM-002 · Protección de integridad por categorías en uso.** No se puede eliminar una categoría que tenga modelos asociados (publicados o no publicados). Debe reasignarse o eliminarse los modelos primero.
- **RN-ADM-003 · Estado de publicación independiente.** Un modelo creado por primera vez se guarda por defecto como **No Publicado** salvo que el administrador indique explícitamente publicarlo.
- **RN-ADM-004 · Garantía de imagen principal.** Todo modelo con imágenes asociadas debe tener exactamente una imagen marcada como principal (`posicion = 1`). Si se elimina la imagen principal, la siguiente en orden de posición pasa a ser la principal automáticamente.
- **RN-ADM-005 · Modificación de precios y formato.** El precio "desde" se ingresa como un valor numérico positivo sin símbolos de moneda ni separadores de miles.
- **RN-ADM-006 · Validación de formato de video.** Si se ingresa una URL de video, debe validarse que corresponda a una sintaxis URL válida (enlace externo según D-10 de la spec 001).

---

## 3. Especificaciones Funcionales (Features F-ADM-xxx)

### F-ADM-001 — Gestión de Categorías
* **CA-1 (Alta):** Dado que el administrador ingresa un nombre de categoría no existente, cuando presiona "Guardar", la categoría se crea y queda disponible para asociar modelos.
* **CA-2 (Duplicados):** Dado que el administrador intenta crear una categoría con un nombre ya existente, el sistema rechaza la acción mostrando un mensaje explícito.
* **CA-3 (Baja restringida):** Dado que el administrador intenta eliminar una categoría con modelos asignados, el sistema impide la acción y notifica que existen modelos asociados (RN-ADM-002).

### F-ADM-002 — Gestión de Modelos (CRUD)
* **CA-1 (Creación):** El administrador puede crear un modelo especificando: nombre, categoría obligatoria, descripción, largo, ancho, profundidad, material, precio "desde" y URL de video opcional.
* **CA-2 (Edición):** El administrador puede modificar cualquiera de los atributos de un modelo existente.
* **CA-3 (Cambio de estado):** El administrador puede alternar el estado `publicado` (sí/no) de un modelo. Al despublicarlo, este deja de verse inmediatamente en el catálogo público (RN-002 de spec 001).
* **CA-4 (Eliminación):** Al eliminar un modelo, se eliminan en cascada sus referencias de imágenes asociadas.

### F-ADM-003 — Gestión Multimedia de Ficha
* **CA-1 (Carga de imágenes):** El administrador puede adjuntar imágenes a un modelo indicando su texto alternativo (accesibilidad).
* **CA-2 (Ordenamiento de Galería):** El administrador puede definir la posición/orden de las imágenes en la galería y seleccionar cuál es la imagen principal (`posicion = 1`).