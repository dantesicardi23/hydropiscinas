# requirements.md — Plataforma Web Piscinas Polaco

- **Nombre del proyecto:** Plataforma Web Piscinas Polaco (Polaco ADM)
- **Feature:** `001-catalogo-modelos`
- **Versión del documento:** 0.3-draft
- **Estado:** BORRADOR (decisiones del relevamiento incorporadas; pendiente de validación con el cliente, ver §7.1)
- **Fuente de origen:** presupuesto "Web Plan de Ahorro Piscinas" (emitido el 15-04-2026) y relevamiento posterior
- **Artefacto asociado:** `design.md` — el CÓMO de esta feature (todavía no existe)

> **Este documento es el QUÉ.** Describe comportamiento observable, no implementación.
> Las decisiones técnicas (stack, módulos, base de datos) van en `design.md`.
> Cuando los dos documentos discrepan, el `requirements.md` manda sobre **qué** hay que
> construir y el `design.md` sobre **cómo**; ninguno manda sobre el otro.

---

## 0. Control de versiones del documento

| Versión | Momento | Cambio | Motivo |
|---|---|---|---|
| 0.1-draft | Inicio del proyecto | Contexto, glosario, entidades, RN-001..RN-008, F-CAT-001, F-CAT-002, hoja de ruta | Primer spec derivado del presupuesto |
| 0.2-draft | Relevamiento (preguntas 1 a 7) | Se agregan `precioDesde` y `videoUrl` al Modelo; RN-004 pasa a orden aleatorio fijo por visita; se agregan RN-009, RN-010 y RN-011; nuevos CA de orden, precio y video; el CRUD se separa en la spec 002 | Respuestas del cliente a las preguntas abiertas de la v0.1 |
| 0.3-draft | Cierre de decisiones para el diseño | La visita pasa a durar 30 minutos desde la última apertura del catálogo; RN-004 y RN-006 contemplan el orden recordado en el navegador y su caso borde; nuevo F-CAT-001/CA-12 (texto literal en el listado) | Decisiones tomadas al preparar `design.md` |

**Convención de IDs usada en este documento**

- `RN-xxx` — regla de negocio.
- `F-XXX-nnn` — feature. El prefijo es el del área: `CAT` catálogo, `BUS` búsqueda y filtros,
  `OBR` obras terminadas, `CNT` contacto directo, `CFG` configurador, `PLN` planes de ahorro,
  `PAG` pagos, `SUS` gestión de suscripciones, `ADM` administración de contenido.
- `CA-n` — criterio de aceptación **dentro** de una feature. Los CA son locales a su feature:
  `F-CAT-001/CA-2` no es el mismo criterio que `F-CAT-002/CA-2`.

---

## 1. Contexto y objetivos

**Plataforma web para una empresa de piscinas que presenta su oferta con la experiencia de un
concesionario de alta gama.** El presupuesto original abarca un sitio público (catálogo,
búsqueda, obras terminadas, contacto, planes de ahorro con pagos) y un sistema de gestión
(configurador de proyectos y gestión de suscripciones). Este proyecto se construye por features
independientes, cada una con su propio `requirements.md` y `design.md`.

**Esta feature (001) cubre la parte pública de solo lectura del catálogo:** que un visitante
pueda explorar los modelos de piscinas por categoría, ordenarlos a su gusto y ver la ficha
técnica de cada uno, con su galería, su video y un precio "desde". Es la primera porque define
la entidad **Modelo**, de la que dependen la búsqueda (F-BUS), el configurador (F-CFG) y los
planes de ahorro (F-PLN). La carga y el mantenimiento del catálogo (alta, edición y baja de
categorías y modelos) son la spec `002-administracion-catalogo`.

**Usuarios:** el visitante anónimo, que explora el catálogo desde computadora o celular.

**Objetivo de la feature:** que el visitante encuentre un modelo de su interés y vea toda su
información de un vistazo, con una presentación de nivel premium. El orden aleatorio por
defecto busca que la oferta rote y que no siempre los mismos modelos ocupen el primer lugar.

**Lo que este documento NO hace:** no describe arquitectura, stack ni estructura de carpetas, y
no cubre la carga de contenido del catálogo (spec 002).

---

## 2. Glosario

- **Visitante:** persona anónima que navega el sitio. No tiene cuenta.
- **Visita:** período de navegación de un visitante que dura 30 minutos desde la última vez que
  abrió el catálogo. Si pasa ese tiempo sin abrirlo, la siguiente apertura es una visita nueva.
- **Categoría:** agrupación de modelos con criterio comercial. No hay categorías fijas en la
  spec: son datos que carga el cliente (spec 002).
- **Modelo:** piscina del catálogo, con ficha técnica, precio "desde", galería y video opcional.
- **Ficha técnica:** conjunto de campos fijos, iguales para todos los modelos: descripción,
  dimensiones y material.
- **Precio "desde":** precio de referencia de un modelo. No es un presupuesto: el presupuesto
  estimado lo genera el configurador (F-CFG-001).
- **Galería:** conjunto ordenado de imágenes de un modelo.
- **Publicado:** estado de un modelo que lo hace visible al visitante.
- **Catálogo:** conjunto de modelos publicados, tal como se ve en la pantalla del catálogo.

---

## 3. Entidades del dominio

### Categoría

| Campo | Tipo | Regla |
|---|---|---|
| `id` | entero | Identificador único, asignado por el sistema, inmutable. |
| `nombre` | cadena | Obligatorio, único entre categorías. |

### Modelo

| Campo | Tipo | Regla |
|---|---|---|
| `id` | entero | Identificador único, asignado por el sistema, inmutable. |
| `nombre` | cadena | Obligatorio. |
| `categoria` | referencia a Categoría | Obligatoria: exactamente una (RN-001). |
| `descripcion` | cadena | Obligatoria. Texto plano con saltos de línea. |
| `largo`, `ancho`, `profundidad` | número (metros) | Obligatorios, mayores que cero. |
| `material` | cadena | Obligatorio. |
| `precioDesde` | número (pesos argentinos) | Obligatorio, mayor que cero. Referencial (RN-009). |
| `videoUrl` | cadena | Opcional. Un solo video por modelo (RN-010). |
| `publicado` | booleano | Define si el modelo es visible (RN-002). |

### Imagen de modelo

| Campo | Tipo | Regla |
|---|---|---|
| `id` | entero | Identificador único, asignado por el sistema. |
| `modelo` | referencia a Modelo | Obligatorio. |
| `posicion` | entero | Lugar dentro de la galería. La primera es la imagen principal. |
| `textoAlternativo` | cadena | Descripción de la imagen para accesibilidad. |

### Relaciones

- Una **Categoría** tiene cero o más **Modelos**.
- Un **Modelo** pertenece a **exactamente una** Categoría.
- Un **Modelo** tiene cero o más **Imágenes** y como máximo un **video**.

> Los atributos del configurador (iluminación, climatización, bordes) **no** forman parte del
> Modelo en esta feature: viven en F-CFG-001. La estructura de la ficha es fija; una ficha con
> campos que varían por categoría queda fuera de la v1.

---

## 4. Reglas de negocio (RN-xxx)

- **RN-001 · Una categoría por modelo.** Todo modelo pertenece a exactamente una categoría.
- **RN-002 · Solo lo publicado es visible.** El visitante solo ve modelos publicados. Un modelo
  no publicado no aparece en el catálogo ni es accesible por su dirección directa.
- **RN-003 · Ficha técnica completa.** Un modelo visible siempre muestra nombre, categoría,
  descripción, largo, ancho, profundidad, material y precio "desde".
- **RN-004 · Orden por defecto aleatorio y fijo durante la visita.** Si el visitante no elige un
  orden, los modelos se muestran en orden aleatorio. Ese orden se mantiene idéntico durante toda
  la visita: no cambia al filtrar por categoría, al abrir una ficha y volver, ni al recargar la
  página. Una visita nueva puede mostrar un orden distinto. Si el navegador del visitante no
  permite recordar el orden, este se mantiene mientras la página está abierta y puede cambiar al
  recargarla.
- **RN-005 · Categorías sin modelos no se muestran.** Una categoría sin modelos publicados no
  aparece como opción de navegación.
- **RN-006 · Visitante anónimo.** La v1 del catálogo no requiere cuenta ni datos personales del
  visitante. Para recordar el orden aleatorio, el navegador puede guardar un valor sin significado
  personal.
- **RN-007 · Uso en celular.** El catálogo y la ficha se pueden usar sin zoom ni desplazamiento
  horizontal en pantallas de 360 píxeles de ancho o más.
- **RN-008 · Integridad del texto.** Los textos del catálogo se muestran tal como fueron
  cargados, con sus saltos de línea. El sistema nunca interpreta un texto como contenido
  ejecutable o como formato: un intento de incrustar código se muestra como texto visible.
- **RN-009 · Precio "desde" referencial.** El precio "desde" se muestra con el formato de pesos
  argentinos y siempre como referencia: la ficha no promete ese valor como precio final.
- **RN-010 · Video opcional.** Un modelo puede tener un video. Si no lo tiene, no se muestra
  ningún indicador de video ni espacio reservado para él.
- **RN-011 · Orden elegido por el visitante.** El visitante puede ordenar los modelos por nombre
  (A-Z o Z-A) o por precio "desde" (de menor a mayor o de mayor a menor). Un orden elegido es
  determinista: cuando dos modelos empatan en el criterio, el desempate es por identificador
  ascendente, de modo que el resultado nunca cambia entre dos lecturas del mismo catálogo.

---

## 5. Features (F-XXX-nnn)

### F-CAT-001 — Explorar el catálogo

**Historia de usuario:** Como visitante, quiero ver los modelos de piscinas, filtrarlos por
categoría y ordenarlos según mi preferencia, para encontrar rápido el que me interesa.

**Actor:** visitante anónimo. **Precondición:** el sitio está disponible.

**Criterios de aceptación:**

- **CA-1.** Dado que existen modelos publicados, cuando el visitante abre el catálogo, entonces
  ve todos los modelos publicados, y cada uno muestra su nombre, su categoría, su imagen
  principal, sus dimensiones y su precio "desde".
- **CA-2.** Dado que el visitante elige una categoría, cuando se aplica la selección, entonces se
  muestran únicamente los modelos de esa categoría, la página no se recarga y la categoría
  elegida queda marcada.
- **CA-3.** Dado que hay una categoría elegida, cuando el visitante elige "Todas", entonces vuelven
  a mostrarse todos los modelos publicados.
- **CA-4.** Dado que no existe ningún modelo publicado, cuando el visitante abre el catálogo,
  entonces se muestra un mensaje que lo informa, y no una lista vacía.
- **CA-5.** Dado que no se puede obtener el catálogo, cuando el visitante abre la página, entonces
  se muestra un mensaje de error en el lugar de la lista y el resto del sitio sigue usable.
- **CA-6.** Dado que un modelo no está publicado, cuando el visitante abre el catálogo, entonces
  ese modelo no aparece (RN-002).
- **CA-7.** Dado que el visitante abre el catálogo sin elegir un orden, cuando se muestra la
  lista, entonces los modelos aparecen en orden aleatorio (RN-004).
- **CA-8.** Dado un orden aleatorio ya mostrado, cuando el visitante filtra por categoría, abre
  una ficha y vuelve, o recarga la página, entonces los modelos conservan el mismo orden relativo
  durante esa visita, salvo que el navegador no permita recordar el orden (RN-004).
- **CA-9.** Dado que el visitante elige un orden (nombre A-Z o Z-A, precio de menor a mayor o de
  mayor a menor), cuando se aplica la selección, entonces la lista se reordena sin recargar la
  página y el orden elegido queda marcado (RN-011).
- **CA-10.** Dado un orden elegido y un catálogo sin cambios, cuando se compara dos lecturas,
  entonces el orden de los modelos es idéntico, incluso entre modelos que empatan (RN-011).
- **CA-11.** Dado un celular de 360 píxeles de ancho, cuando el visitante abre el catálogo,
  entonces todo el contenido se ve y se puede usar sin desplazamiento horizontal (RN-007).
- **CA-12.** Dado un modelo cuyo nombre incluye etiquetas o caracteres que parecen código, cuando se
  muestra el listado, entonces se ven como texto literal y no ejecutan nada (RN-008).

**Fuera de alcance de esta feature:** búsqueda por texto, filtros por dimensiones, materiales o
ubicación (F-BUS-001), comparación de modelos, favoritos y paginación.

---

### F-CAT-002 — Ver la ficha técnica de un modelo

**Historia de usuario:** Como visitante, quiero ver toda la información de un modelo, con sus
imágenes y su video, para decidir si me interesa avanzar con él.

**Actor:** visitante anónimo. **Precondición:** existe al menos un modelo publicado.

**Criterios de aceptación:**

- **CA-1.** Dado un modelo publicado, cuando el visitante lo abre desde el catálogo, entonces ve
  su nombre, categoría, descripción, largo, ancho, profundidad, material, precio "desde" y
  galería de imágenes.
- **CA-2.** Dado un modelo con varias imágenes, cuando el visitante elige una de la galería,
  entonces esa imagen pasa a mostrarse en grande y la página no se recarga.
- **CA-3.** Dado un modelo sin imágenes, cuando se muestra su ficha, entonces aparece una imagen
  de reemplazo y el resto de la ficha se ve completa.
- **CA-4.** Dado un modelo con video, cuando el visitante abre su ficha, entonces puede
  reproducirlo en la propia ficha; y dado un modelo sin video, entonces no aparece ningún
  indicador de video ni espacio vacío (RN-010).
- **CA-5.** Dada la dirección de un modelo que no existe o que no está publicado, cuando el
  visitante la abre, entonces se muestra un mensaje de "modelo no encontrado" con un acceso para
  volver al catálogo, y no se revela si el modelo existe sin publicar.
- **CA-6.** Dado que el visitante venía de una categoría y un orden elegidos, cuando vuelve al
  catálogo desde la ficha, entonces la categoría y el orden siguen elegidos (RN-004, RN-011).
- **CA-7.** Dado un modelo cuya descripción incluye etiquetas o caracteres que parecen código,
  cuando se muestra la ficha, entonces se ven como texto literal y no ejecutan nada (RN-008).
- **CA-8.** Dado un celular de 360 píxeles de ancho, cuando el visitante abre una ficha, entonces
  la ficha, la galería y el video se usan sin desplazamiento horizontal (RN-007).

**Fuera de alcance de esta feature:** personalizar el modelo y estimar su presupuesto (F-CFG-001),
botones de contacto con asesores (F-CNT-001), suscripción a un plan de ahorro (F-PLN-001).

---

## 6. Alcance del proyecto

### Dentro del alcance de esta feature (001)

| ID | Feature | Reglas que la gobiernan |
|---|---|---|
| F-CAT-001 | Explorar el catálogo | RN-001, RN-002, RN-004, RN-005, RN-006, RN-007, RN-008, RN-009, RN-011 |
| F-CAT-002 | Ver la ficha técnica de un modelo | RN-002, RN-003, RN-007, RN-008, RN-009, RN-010 |

### Hoja de ruta: el resto del proyecto (cada spec tendrá su propio `requirements.md` y `design.md`)

| Orden | Spec / ID tentativo | Feature | Depende de |
|---|---|---|---|
| 2 | `002-administracion-catalogo` (F-ADM-001) | CRUD de categorías y modelos, con sus imágenes y video. Pendiente: control de acceso al panel y reglas de borrado | 001 |
| 3 | F-BUS-001 | Búsqueda y filtros de precisión (dimensiones, materiales, ubicación de proyectos) | 001 |
| 4 | F-OBR-001 | Showroom de obras terminadas (galería filtrable por zona y tipo de construcción) | 002 |
| 5 | F-CNT-001 | Canales de contacto directo (WhatsApp, llamadas, formularios de prioridad) | 001 |
| 6 | F-CFG-001 | Configurador de proyectos y presupuesto estimado automático | 002 |
| 7 | F-PLN-001 | Planes de ahorro: simulador de cuotas y requisitos legales | 001 |
| 8 | F-SUS-001 | Suscripción online a un plan y panel de gestión de suscripciones | F-PLN-001, 002 |
| 9 | F-PAG-001 | Gestión de pagos con la API del Banco Santander | F-SUS-001 |

Transversales a todas las features: diseño corporativo orientado a la conversión y optimización
total para móviles (aquí se bajan a RN-007 y a los CA de móvil de cada feature).

---

## 7. Pendientes y trazabilidad

### 7.1 Relevamiento: respuestas y supuestos vigentes

| # | Pregunta | Estado | Resolución |
|---|---|---|---|
| 1 | ¿Quién carga el catálogo? | Resuelta | CRUD propio: spec `002-administracion-catalogo` |
| 2 | ¿Categorías y volumen? | Parcial | Las categorías y los modelos se gestionan por CRUD. **No se informó el volumen ni si hay fichas e imágenes listas.** Supuesto: menos de 50 modelos, sin paginación |
| 3 | ¿Precio en la ficha? | Resuelta | Precio "desde" por modelo (RN-009). Supuestos: obligatorio, mayor que cero, en pesos argentinos |
| 4 | ¿Ficha técnica dinámica? | Resuelta | Campos fijos para todos los modelos, cargados por CRUD |
| 5 | ¿Visualización de alta gama? | Resuelta | Galería de imágenes y un video por modelo (RN-010). **Supuesto sin confirmar:** el video es un enlace a un servicio externo, no un archivo subido, y es opcional |
| 6 | ¿Orden del catálogo? | Resuelta | Aleatorio por defecto, fijo durante la visita (30 minutos desde la última apertura, recordado en el navegador) y orden elegible por el visitante (RN-004, RN-011). Supuesto: las opciones de orden son nombre y precio |
| 7 | ¿Stack y hosting? | Parcial | Stack definido (PHP nativo sin framework, Bootstrap, AJAX, MySQL): va a `design.md`. **Falta el hosting** |

**Todavía sin confirmar:** hosting, volumen de modelos, forma del video (enlace o archivo) y
opciones de orden.

### 7.2 Observaciones sobre el documento fuente (presupuesto)

- **El monto no es consistente:** figura `$2.050.000` en cifras y "un millón setecientos mil
  pesos" en letras. No afecta el alcance, pero conviene aclararlo antes de aprobar.
- **Plan de ahorro y requisitos legales:** el presupuesto pide mostrar requisitos legales de los
  planes. Su contenido tiene que venir del cliente; el sistema no lo puede inventar (F-PLN-001).
- **Integración con Santander:** no se indica qué producto o API, ni si habrá entorno de pruebas
  y credenciales. Es el principal riesgo técnico de F-PAG-001.
- **Plazo:** 40 días, sujetos al visto bueno del cliente sobre el relevamiento definitivo. El
  alcance creció respecto del presupuesto (CRUD del catálogo, video, precio y orden elegible), y
  conviene que el cliente lo valide.

### 7.3 Trazabilidad hacia la implementación

| Feature | Criterios | Comportamiento a demostrar |
|---|---|---|
| F-CAT-001 | CA-1..CA-12 | Listado con precio, filtro por categoría y orden elegido sin recarga, orden aleatorio fijo por visita, estados vacío y de error |
| F-CAT-002 | CA-1..CA-8 | Ficha completa con precio, galería, video opcional, modelo inexistente o no publicado, texto literal |
