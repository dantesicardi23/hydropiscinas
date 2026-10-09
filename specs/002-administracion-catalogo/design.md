# design.md — Administración del Catálogo (Back-office)

- **Feature:** `002-administracion-catalogo`
- **Versión del documento:** 0.1-draft
- **Estado:** BORRADOR
- **requirements.md de referencia:** `specs/002-administracion-catalogo/requirements.md`

---

## 1. Arquitectura General y Módulos

El módulo administrativo extiende la capa de datos (`src/Datos`) e introduce componentes de servicio en `src/Servicios` para operaciones de escritura (mutaciones), las cuales están totalmente prohibidas en la interfaz pública.

Las peticiones administrativas requieren verificación previa en la capa de soporte (`src/Soporte/Autenticacion.php`) antes de invocar los métodos del controlador/API.

---

## 2. Decisiones Técnicas (ADR)

### D-ADM-01 — Sesión por Cookies Seguras para el Back-office
- **Contexto:** A diferencia del sitio público (que es completamente stateless, D-04 de spec 001), el back-office requiere autenticación y control de acceso.
- **Decisión:** Se utiliza la sesión nativa de PHP (`session_start()`) con cookies con atributos `HttpOnly`, `SameSite=Strict` y `Secure`.

### D-ADM-02 — Escritura y Almacenamiento de Imágenes
- **Contexto:** Se requiere guardar los archivos físicos de las imágenes cargadas por el administrador.
- **Decisión:** Las imágenes se procesan, renombran con un UUID/hash único y se almacenan en el directorio `public/assets/img/modelos/`. En la base de datos solo se guarda la ruta relativa o nombre del archivo (`url_archivo`).

### D-ADM-03 — Validaciones de Entrada en Servidor
- **Contexto:** Evitar inyecciones SQL y garantizar datos limpios en base de datos.
- **Decisión:** Toda entrada proveniente de formularios de administración se valida y sanitiza en el servidor antes de guardarla. Todas las operaciones SQL se ejecutan mediante Sentencias Preparadas (PDO / Parametrized Queries).