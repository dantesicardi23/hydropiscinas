# AGENTS.md — Plataforma Web Piscinas Polaco

## Propósito

Plataforma web para una empresa de piscinas, con la experiencia de un concesionario de alta
gama. El proyecto se construye por features independientes, cada una en su propia carpeta de
`specs/` con su `requirements.md` (el QUÉ) y su `design.md` (el CÓMO).

**Spec activa:** `specs/001-catalogo-modelos/` — la parte pública y de solo lectura del
catálogo: explorar modelos por categoría, ordenarlos y ver la ficha de cada uno. El visitante
es anónimo. **Próxima spec:** `002-administracion-catalogo` (CRUD de categorías y modelos).

**Stack (impuesto por el proyecto):** PHP nativo sin framework, MySQL, Bootstrap por CDN y AJAX.
(origen: D-01, D-09)

## Reglas que no se negocian

- Decidí la visibilidad **en el servidor, en cada consulta**: solo se muestran modelos
  publicados, en el listado, en la ficha y en la lista de categorías. Un modelo inexistente y uno
  no publicado reciben exactamente la misma respuesta. (origen: RN-002, RN-005 / D-02)
- Validá en el servidor todo lo que llega del visitante: la categoría debe existir, el orden debe
  ser uno de la lista cerrada y la semilla debe ser un valor numérico dentro de un rango. Un valor
  inválido nunca se usa tal cual. (origen: RN-011 / D-07)
- Usá consultas parametrizadas para todo acceso a datos; nunca concatenes texto recibido del
  visitante en una consulta. El criterio de orden no se puede parametrizar: elegilo de la lista
  cerrada interna, nunca del texto recibido. (origen: D-07)
- Guardá los datos crudos y neutralizá al mostrar: el texto se inserta **como contenido literal,
  nunca como markup**, en los dos puntos donde se vuelve pantalla (el servidor al armar la ficha
  y el navegador al pintar el listado). No escapés ni limpies al guardar. Sin framework esto no es
  automático: es tu responsabilidad en cada punto. (origen: RN-008 / D-06)
- Guardá el precio como número y dalo formato de pesos argentinos solo al mostrarlo; siempre
  presentalo como referencia ("desde"), nunca como precio final. (origen: RN-009 / D-06)
- Derivá el orden en cada lectura, en la capa de aplicación. No persistas ningún campo de
  posición. El orden aleatorio se calcula a partir de la semilla que envía la interfaz: la misma
  semilla sobre el mismo catálogo da siempre el mismo orden. Para los órdenes elegidos, el
  desempate es por identificador ascendente. (origen: RN-004, RN-011 / D-03)
- La semilla vive solo en el navegador, junto con la hora de la última apertura del catálogo, y
  vence a los 30 minutos. No uses cookies propias ni sesiones de PHP: el servidor no recuerda
  nada del visitante. (origen: RN-004, RN-006 / D-04)
- Cargá Bootstrap por CDN con una **versión exacta** y la verificación de integridad (SRI); nunca
  "la última versión". (origen: RN-007 / D-09)

## Arquitectura

- Ningún componente de negocio habla con la base de datos directamente: todo acceso pasa por la
  capa de acceso a datos, y la conexión se resuelve en un único lugar. (origen: design.md §3,
  fronteras entre módulos)
- La capa de aplicación **solo lee** en la 001: el visitante no escribe nada. La escritura del
  catálogo pertenece a la 002. (origen: design.md §1)
- El catálogo lo pinta la interfaz con datos que devuelve el servidor; la ficha la arma el
  servidor. No cambies este reparto sin un ADR nuevo. (origen: D-05)
- La categoría y el orden elegidos viven en la dirección de la página, y cada elección vuelve a
  pedir el resultado completo al servidor: la interfaz no filtra ni ordena por su cuenta.
  (origen: D-07)
- Categoría, modelo e imagen son tres entidades relacionadas, con la pertenencia y los campos
  obligatorios declarados en el modelo de datos. (origen: RN-001, RN-003 / D-08)
- Solo la carpeta `public/` queda expuesta por el servidor web. Las credenciales viven en
  `config/`, fuera de `public/` y fuera del repositorio. (origen: design.md §3, configuración de
  conexión)

### Estructura de directorios

Es la estructura aprobada; los nombres exactos de archivo se deciden al implementar, y cambiar
la forma de las carpetas es una decisión nueva, no un ajuste.

```
/
├── AGENTS.md
├── specs/
│   ├── 001-catalogo-modelos/        requirements.md · design.md
│   └── 002-administracion-catalogo/ (se crea cuando le toque)
├── public/                          única carpeta expuesta por el servidor web
│   ├── (pantallas del catálogo y de la ficha)
│   ├── api/                         respuestas de datos para el AJAX
│   └── assets/                      css · js · img
├── src/
│   ├── Datos/                       capa de acceso a datos
│   ├── Servicios/                   consultas del catálogo y de la ficha
│   └── Soporte/                     formato de respuesta y presentación
├── templates/                       plantillas HTML
├── config/                          configuración de conexión (sin credenciales en el repo)
├── database/                        scripts de estructura y datos de ejemplo
└── tests/                           una prueba por criterio de aceptación
```

## Qué no hacer

- **No agregues** funcionalidad que no tenga un requisito en `requirements.md`; si algo no está
  en la spec, no lo implementes: preguntame primero. (origen: requirements.md §6, fuera de
  alcance)
- No propongas cuentas de usuario, autenticación ni escritura desde el sitio público dentro de
  la 001. El alta, la edición y la baja del catálogo son la 002. (origen: RN-006 / design.md §4)
- No agregues un framework ni una biblioteca nueva sin un ADR que la justifique. (origen: D-01)
- No implementes caché, paginación, búsqueda por texto ni filtros por dimensiones o material:
  están descartados o son otras specs. (origen: design.md §4)
- No implementes la subida del video como archivo: la decisión vigente es el enlace a un servicio
  externo y es **provisional**. Si hace falta cambiarla, preguntame. (origen: RN-010 / D-10)
- No calcules presupuestos ni muestres atributos del configurador (iluminación, climatización,
  bordes): son otra feature. (origen: requirements.md §3, §6)

## Cómo verificar

Antes de dar por terminada una tarea, confirmá que respetaste las reglas de arriba y citá cuál
aplicaste en cada paso.

Cada criterio de aceptación de `requirements.md` debe tener una prueba en `tests/`. Una tarea no
está terminada si deja un criterio sin demostrar.

Si una decisión no está cubierta por `requirements.md` ni por `design.md`, no la tomes por tu
cuenta: planteá la duda y esperá la respuesta. Hay dudas ya registradas en `design.md` §5
(hosting, forma del video, indexación del catálogo en buscadores, formato del precio, límites de
los textos) que **no podés resolver vos**.

Si el código y la spec se contradicen, no lo dejes pasar en silencio: proponé el cambio como una
nueva versión del documento afectado, con su motivo.

Cada spec vive en `specs/NNN-nombre/` con su `requirements.md` y su `design.md`. Una spec puede
tener su propio `AGENTS.md` con reglas que solo le aplican a ella; en ese caso, las suyas
complementan las de este archivo y no las reemplazan.

`requirements.md` y `design.md`, en la carpeta de cada spec, son la fuente de verdad. Este
archivo resume reglas de esos dos documentos: ante un conflicto, mandan ellos.
