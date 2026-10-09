# design.md — Plataforma Web Piscinas Polaco

- **Feature:** `001-catalogo-modelos`
- **Versión del documento:** 0.1-draft
- **Estado:** BORRADOR (pendiente de aprobación)
- **requirements.md de referencia:** [`requirements.md`](./requirements.md) (misma carpeta, v0.3-draft)

> **Este documento es el CÓMO.** Registra decisiones de diseño y su porqué.
> **No contiene código de implementación**, ni nombres exactos de funciones, ni la definición
> de tablas. Eso aterriza al implementar.
>
> **Regla de calibración:** si al leer una decisión dejara de tener sentido al cambiar el
> lenguaje de programación, es que estaba describiendo implementación. Las únicas excepciones son
> las que vienen impuestas por el proyecto (D-01 y D-09), y están marcadas como tales.

---

## 1. Arquitectura general

El sistema es una **aplicación web cliente-servidor de dos piezas que se comunican por una
interfaz de red explícita**. De un lado está la **interfaz**, que corre en el navegador del
visitante: pinta el catálogo, aplica las elecciones de categoría y orden pidiéndole el resultado
al servidor, y recuerda en el propio navegador el valor que mantiene fijo el orden aleatorio.
Del otro lado está la **capa de aplicación**, que consulta los datos, aplica las reglas de
negocio sin depender de nada de la interfaz y lee de un almacén de datos relacional. En esta
feature la capa de aplicación **solo lee**: el visitante nunca escribe nada. La carga del
catálogo es la spec `002-administracion-catalogo`.

La interfaz nunca toca el almacén: toda lectura pasa por la capa de aplicación, que es el único
lugar donde se decide qué es visible (RN-002), en qué orden se muestra (RN-004, RN-011) y cómo
se filtra por categoría. El diseño es **sin estado en el servidor**: no hay sesión de visitante
entre una petición y otra (RN-006). Lo único que se recuerda entre peticiones es un valor sin
significado personal que guarda el navegador. El catálogo se pinta **en el navegador** con datos
que devuelve el servidor, porque la semilla del orden aleatorio vive allí; la ficha de un modelo
la **arma el servidor**, porque se abre por su propia dirección. El orden **se deriva en cada
lectura**: no se guarda ningún campo de posición. El modelo de datos son **tres entidades
relacionadas** (categoría, modelo e imagen) cuyas pertenencias se declaran en el propio modelo
de datos.

---

## 2. Decisiones técnicas (ADR)

### D-01 — Stack impuesto por el proyecto: PHP nativo sin framework, MySQL, AJAX *(restricción de entrada)*

- **Contexto:** el relevamiento (pregunta 7) fijó el stack. No lo elige este diseño: lo recibe.
- **Decisión:** la capa de aplicación se escribe en PHP nativo, sin framework. El almacén es
  MySQL. La interfaz habla con la capa de aplicación por AJAX, y la capa de aplicación responde
  con un formato único de datos. Los accesos a datos y la conexión se organizan como indica §3.
- **Alternativas consideradas:** (a) un framework de PHP, descartada porque el relevamiento pidió
  PHP nativo; (b) un cliente que pinta todo, incluida la ficha, descartada por D-05.
- **Justificación:** al no haber framework, **nada resuelve por defecto** lo que un framework
  daría hecho (enrutado, escape de salida, acceso a datos, validación de entrada). Por eso este
  documento hace explícitas esas decisiones (D-02, D-06, D-07, D-08) en lugar de dejarlas
  implícitas. Esta decisión no sostiene un requisito: es una condición del proyecto, y por eso
  está marcada como restricción de entrada.
- **Requisito relacionado:** ninguno directo (restricción del proyecto)

### D-02 — La visibilidad se decide siempre en el servidor

- **Contexto:** RN-002 exige que un modelo no publicado no aparezca ni sea accesible por su
  dirección directa, y F-CAT-002/CA-5 que el mensaje de "no encontrado" no revele si el modelo
  existe sin publicar.
- **Decisión:** el filtro de "publicado" se aplica **en cada consulta de la capa de aplicación**,
  sin excepción: en el listado, en la ficha y en la lista de categorías disponibles. Un modelo
  inexistente y uno no publicado reciben exactamente la misma respuesta. La interfaz nunca recibe
  un modelo no publicado para ocultarlo después.
- **Alternativas consideradas:** (a) enviar todos los modelos y ocultar los no publicados en la
  interfaz, descartada porque cualquier cliente que hable con la capa de aplicación los vería;
  (b) responder "no publicado" distinto de "no existe", descartada porque revela qué hay
  guardado sin publicar.
- **Justificación:** un requisito que depende de quién pregunta al sistema es una casualidad de
  la implementación actual. Aplicarlo en el único lugar donde se leen los datos es la versión
  que sigue siendo cierta cuando hay otro cliente. La lista de categorías se deriva de lo
  publicado (RN-005) por el mismo motivo: no se guarda ni se mantiene aparte.
- **Requisito relacionado:** F-CAT-001/CA-6, F-CAT-002/CA-5 · RN-002, RN-005

### D-03 — El orden se deriva en cada lectura; el aleatorio se calcula a partir de una semilla

- **Contexto:** RN-004 pide un orden aleatorio que no cambie durante la visita, y RN-011 pide
  órdenes elegibles que nunca cambien entre dos lecturas. Son dos comportamientos opuestos
  (variar entre visitas, no variar dentro de una) sobre los mismos datos.
- **Decisión:** el orden se calcula **en cada consulta, en la capa de aplicación**. Para el
  orden aleatorio, la interfaz envía un valor (la semilla) y la capa de aplicación **lo usa para
  barajar de forma determinista**: la misma semilla sobre el mismo catálogo da siempre el mismo
  orden. Para los órdenes elegidos, el criterio sale de una **lista cerrada** (nombre ascendente
  y descendente, precio ascendente y descendente) con el identificador ascendente como
  desempate. No se guarda ningún campo de posición en el modelo de datos.
- **Alternativas consideradas:** (a) barajar en el navegador, descartada porque dejaría la regla
  de orden repartida en dos lugares y no se podría probar sin un navegador; (b) un orden
  aleatorio nuevo en cada petición, descartada porque contradice RN-004 (cambiaría al filtrar o
  recargar); (c) guardar una posición de rotación en cada modelo, descartada porque obliga a
  mantenerla cada vez que se carga, edita o borra un modelo, y es una oportunidad de
  inconsistencia silenciosa.
- **Justificación:** el orden es una **vista**, no un hecho almacenado. Con una semilla, "aleatorio
  pero estable" deja de ser una contradicción: es una función de la semilla. Y al decidirlo en
  un único lugar, los criterios de aceptación de orden se pueden verificar sin interfaz.
- **Requisito relacionado:** F-CAT-001/CA-7, CA-8, CA-9, CA-10 · RN-004, RN-011

### D-04 — La semilla y su vigencia viven en el navegador, sin cookie ni sesión del servidor

- **Contexto:** RN-004 y el glosario fijan una visita de 30 minutos desde la última apertura del
  catálogo, y RN-006 declara anónimo al visitante. Alguien tiene que recordar la semilla entre
  peticiones.
- **Decisión:** el navegador guarda la semilla junto con el instante de la última apertura del
  catálogo, en su almacenamiento local. Al abrir el catálogo, si pasaron más de 30 minutos desde
  esa marca, genera una semilla nueva; si no, reutiliza la guardada. En ambos casos **renueva la
  marca**. La semilla es un valor sin significado: no identifica a nadie. Si el navegador no
  permite guardar datos, la interfaz usa una semilla que dura lo que la página abierta, y el
  orden puede cambiar al recargar (excepción declarada en F-CAT-001/CA-8).
- **Alternativas consideradas:** (a) almacenamiento de sesión del navegador, descartada porque
  abrir el sitio en otra pestaña daría otro orden; (b) cookie de sesión, descartada porque
  viaja al servidor en cada petición, exige decidir un aviso de cookies y no aporta nada: el
  servidor no necesita saber nada del visitante; (c) sesión en el servidor, descartada porque
  introduce estado justo donde el diseño proyecta que no lo haya, a cambio de resolver un
  problema que se resuelve sin él.
- **Justificación:** es la opción que no genera fricción al visitante: no hay cookies, no hay
  avisos y funciona igual entre pestañas. El almacenamiento local por sí solo no vence nunca; por
  eso la vigencia se guarda **con** la semilla en lugar de depender del navegador. El caso borde
  (navegador sin almacenamiento) degrada el comportamiento, no lo rompe.
- **Requisito relacionado:** F-CAT-001/CA-8 · RN-004, RN-006

### D-05 — El catálogo lo pinta la interfaz; la ficha la arma el servidor

- **Contexto:** F-CAT-001 filtra y ordena sin recargar la página y depende de la semilla que
  solo conoce el navegador; F-CAT-002 se abre por su propia dirección y debe distinguir "no
  encontrado".
- **Decisión:** la pantalla del catálogo es una estructura que **pide los datos a la capa de
  aplicación y los pinta**, incluidos los estados vacío y de error. La pantalla de la ficha la
  **construye el servidor** con los datos del modelo; la interfaz solo agrega el comportamiento
  de la galería. Un modelo no encontrado se responde con un estado de "no encontrado" real.
- **Alternativas consideradas:** (a) catálogo armado por el servidor en la primera carga,
  descartada porque el servidor todavía no conoce la semilla y mostraría un orden que la
  interfaz tendría que corregir de inmediato; (b) ficha pintada también por la interfaz,
  descartada porque un acceso directo a una dirección inexistente no tendría un "no encontrado"
  verdadero, y porque la ficha no se beneficia de repintarse sin recarga.
- **Justificación:** cada pantalla usa el camino que su requisito necesita. El precio es tener
  **dos puntos donde el texto se vuelve pantalla** (el navegador y el servidor), lo que D-06 hace
  explícito para que ninguno quede sin neutralizar.
- **Requisito relacionado:** F-CAT-001/CA-1, CA-4, CA-5 · F-CAT-002/CA-1, CA-2, CA-3, CA-5 · RN-003

### D-06 — Los datos se guardan crudos; se neutraliza y se da formato al mostrar

- **Contexto:** RN-008 exige que un intento de incrustar código se muestre como texto y que el
  texto aparezca tal como fue cargado. RN-009 pide el precio con formato de pesos argentinos.
- **Decisión:** el almacén guarda **los datos exactamente como se cargaron**: el texto sin
  transformar y el precio como número. La neutralización y el formato ocurren **en el momento
  de mostrar**, en los dos puntos de D-05: en el servidor al armar la ficha y en la interfaz al
  pintar el listado. En ambos, el texto se inserta **como contenido literal, nunca como markup**.
  El sistema no reescribe ni "limpia" lo guardado.
- **Alternativas consideradas:** (a) escapar o limpiar al guardar, descartada porque reescribe lo
  que el cliente cargó y reparte la defensa entre dos capas; (b) guardar el precio ya formateado,
  descartada porque impediría ordenar por precio (RN-011) y cambiar el formato; (c) permitir un
  subconjunto de formato en las descripciones, descartada porque introduce un mini-lenguaje que
  la spec no pide.
- **Justificación:** guardar crudo conserva la información y concentra la defensa en el único
  momento en que el dato se convierte en pantalla. Sin framework (D-01) esa defensa **no es
  automática**: por eso se exige en los dos puntos y cada uno tiene su criterio de aceptación
  (F-CAT-001/CA-12 y F-CAT-002/CA-7).
- **Requisito relacionado:** F-CAT-001/CA-12 · F-CAT-002/CA-7 · RN-008, RN-009

### D-07 — La selección vive en la dirección de la página; la interfaz no filtra ni ordena por su cuenta

- **Contexto:** F-CAT-002/CA-6 pide que al volver desde una ficha sigan elegidos la categoría y
  el orden; F-CAT-001/CA-2 y CA-9 piden aplicar la elección sin recargar. Además, lo que el
  visitante envía (categoría, orden, semilla) llega al servidor.
- **Decisión:** la categoría y el orden elegidos se reflejan **en la dirección del catálogo**, de
  modo que el botón de volver, una recarga o un enlace compartido los restauran. Cada elección
  **vuelve a pedir el resultado completo a la capa de aplicación**: la interfaz no filtra ni
  ordena por su cuenta. La capa de aplicación **valida lo que recibe**: la categoría debe ser
  una existente; el orden, uno de la lista cerrada de D-03; la semilla, un valor numérico dentro
  de un rango. Un valor inválido recibe el orden por defecto o un rechazo, nunca se usa tal cual.
  Ningún valor recibido se concatena en una consulta (consultas parametrizadas); como el criterio
  de orden no puede parametrizarse, **se elige de la lista cerrada interna**, no del texto
  recibido.
- **Alternativas consideradas:** (a) guardar la selección en el almacenamiento del navegador,
  descartada porque el botón de volver y un enlace compartido no la restaurarían y mezcla dos
  conceptos con vigencias distintas (la semilla vence, la selección no debería); (b) filtrar y
  ordenar la lista completa en el navegador, descartada porque duplicaría en la interfaz la
  regla de orden de D-03.
- **Justificación:** la dirección es el único estado que sobrevive de forma natural a volver,
  recargar y compartir, sin código adicional. Pedir siempre el resultado al servidor hace que lo
  que se ve sea lo que la capa de aplicación acaba de decidir. El costo (un viaje por elección)
  es aceptable con el volumen supuesto.
- **Requisito relacionado:** F-CAT-001/CA-2, CA-3, CA-9, CA-10 · F-CAT-002/CA-6 · RN-011

### D-08 — Categoría, modelo e imagen son entidades relacionadas, con la pertenencia declarada en el modelo de datos

- **Contexto:** RN-001 exige exactamente una categoría por modelo; RN-005 que las categorías se
  deriven de lo publicado; RN-003 que un modelo visible tenga siempre sus campos.
- **Decisión:** **tres colecciones separadas**. Todo modelo referencia a una categoría y toda
  imagen a un modelo, y esas relaciones se declaran en el modelo de datos con la integridad
  correspondiente. Los campos obligatorios de la ficha se declaran obligatorios en el propio
  modelo de datos.
- **Alternativas consideradas:** (a) la categoría como texto libre dentro del modelo, descartada
  porque "Fibra" y "fibra" pasarían a ser categorías distintas y no habría una lista confiable de
  la que derivar RN-005; (b) las imágenes como una lista dentro del modelo, descartada porque
  no hay forma de ordenarlas ni de agregar el texto alternativo de cada una.
- **Justificación:** una regla garantizada por la forma del modelo no depende de que cada
  componente se acuerde de comprobarla. Con la categoría como entidad, "un modelo sin
  categoría" no se puede guardar.
- **Requisito relacionado:** F-CAT-001/CA-1, CA-2 · F-CAT-002/CA-1 · RN-001, RN-003, RN-005

### D-09 — Bootstrap por CDN, con versión fija e integridad verificada *(restricción de entrada)*

- **Contexto:** el relevamiento decidió usar Bootstrap por CDN. RN-007 exige usar el sitio en
  pantallas de 360 píxeles de ancho.
- **Decisión:** los estilos base se cargan desde un CDN **con una versión exacta** y con la
  verificación de integridad del recurso. Los estilos propios van aparte y se apoyan en esa
  base, sin modificarla.
- **Alternativas consideradas:** (a) copia local, descartada por la decisión del relevamiento;
  (b) CDN con la "última versión", descartada porque un cambio externo podría romper el sitio o
  alterar el archivo sin que nadie lo apruebe.
- **Justificación:** la verificación de integridad hace que un archivo alterado no se ejecute.
  El riesgo que se asume queda registrado: si el CDN no responde, el sitio pierde sus estilos.
- **Requisito relacionado:** F-CAT-001/CA-11 · F-CAT-002/CA-8 · RN-007

### D-10 — El video de un modelo es un enlace a un servicio externo *(provisional)*

- **Contexto:** RN-010 admite un video opcional por modelo. El relevamiento no aclaró si se sube
  como archivo o se enlaza; el supuesto vigente en `requirements.md` §7.1 es el enlace.
- **Decisión:** el modelo guarda **solo la dirección del video** y la ficha lo reproduce desde el
  servicio externo. Mientras no se confirme, esta decisión es **provisional**.
- **Alternativas consideradas:** (a) subir el archivo al servidor, descartada porque exige fijar
  un tamaño y un formato máximos y carga el almacenamiento y la reproducción en el servidor;
  (b) no soportar video, descartada porque el relevamiento lo pidió.
- **Justificación:** es la opción más liviana y no cierra el paso a la otra: si se confirma la
  subida, cambia la entidad y la spec 002, no el resto del diseño. Depende de un tercero, y qué
  servicios se aceptan queda abierto (§5).
- **Requisito relacionado:** F-CAT-002/CA-4 · RN-010

### Matriz de trazabilidad (requisito → decisión)

| Requisito | Decisiones que lo sostienen | ¿Cubierto por alguna decisión? |
|---|---|---|
| RN-001 Una categoría por modelo | D-08 | Sí |
| RN-002 Solo lo publicado es visible | D-02 | Sí |
| RN-003 Ficha técnica completa | D-05, D-08 | Sí |
| RN-004 Orden por defecto aleatorio y fijo | D-03, D-04 | Sí |
| RN-005 Categorías sin modelos no se muestran | D-02, D-08 | Sí |
| RN-006 Visitante anónimo | D-04 | Sí |
| RN-007 Uso en celular | D-09 | Sí |
| RN-008 Integridad del texto | D-06 | Sí |
| RN-009 Precio "desde" referencial | D-06 | Sí |
| RN-010 Video opcional | D-10 | Sí |
| RN-011 Orden elegido por el visitante | D-03, D-07 | Sí |
| F-CAT-001/CA-1 | D-05 | Sí |
| F-CAT-001/CA-2, CA-3 | D-07 | Sí |
| F-CAT-001/CA-4, CA-5 | D-05 | Sí |
| F-CAT-001/CA-6 | D-02 | Sí |
| F-CAT-001/CA-7 | D-03, D-04 | Sí |
| F-CAT-001/CA-8 | D-04 | Sí |
| F-CAT-001/CA-9, CA-10 | D-03, D-07 | Sí |
| F-CAT-001/CA-11 | D-09 | Sí |
| F-CAT-001/CA-12 | D-06 | Sí |
| F-CAT-002/CA-1, CA-3 | D-05, D-08 | Sí |
| F-CAT-002/CA-2 | D-05 | Sí |
| F-CAT-002/CA-4 | D-10 | Sí |
| F-CAT-002/CA-5 | D-02, D-05 | Sí |
| F-CAT-002/CA-6 | D-07 | Sí |
| F-CAT-002/CA-7 | D-06 | Sí |
| F-CAT-002/CA-8 | D-09 | Sí |

**Lectura de la matriz:** las once reglas de negocio y los veinte criterios de aceptación tienen
al menos una decisión que los sostiene. Hay una sola decisión sin requisito que la origine:
**D-01**, que es una condición del proyecto y no una decisión de diseño. Si al implementar
aparece una decisión sin fila aquí, o es implementación —y entonces no iba en este documento— o
es una decisión de diseño que se tomó sin que la spec la pidiera.

---

## 3. Estructura de módulos

Componentes lógicos, con su responsabilidad. Los nombres de archivo exactos se deciden al
implementar. A nivel de directorios, el proyecto separa **una única carpeta pública** —la única
que el servidor web expone— de la **lógica**, las **plantillas**, la **configuración**, los
**scripts de base de datos** y las **pruebas**, que quedan fuera del alcance directo del
navegador.

- **Interfaz del catálogo** *(navegador)* — pide el catálogo, pinta los modelos y los estados
  vacío y de error, aplica categoría y orden reflejándolos en la dirección, y mantiene la semilla
  y su vigencia. No decide reglas de negocio: si algo no se puede hacer, pregunta a la capa de
  aplicación y muestra la respuesta.
- **Pantalla de la ficha** *(servidor y navegador)* — la construye el servidor con los datos del
  modelo; el navegador solo agrega la galería y la reproducción del video.
- **Componente de consulta del catálogo** — entrega los modelos publicados filtrados por
  categoría y ordenados según D-03, junto con las categorías disponibles. Valida lo que recibe
  (D-07). Es el dueño exclusivo de las reglas de visibilidad y de orden. No escribe.
- **Componente de consulta de la ficha** — entrega un modelo publicado con sus imágenes y su
  video, o una respuesta única de "no encontrado" (D-02).
- **Componente de presentación** — da formato al precio y neutraliza el texto antes de que llegue
  al HTML del servidor (D-06). Es el único lugar del servidor donde un dato se convierte en
  pantalla.
- **Formato de respuesta** — estructura única para los datos y los errores que la capa de
  aplicación devuelve a la interfaz, de modo que esta nunca interprete mensajes sueltos.
- **Capa de acceso a datos** — frontera única hacia el almacén. Ningún componente de negocio
  habla con la base directamente, y ningún acceso se construye concatenando texto recibido del
  visitante. Todos los accesos usan consultas parametrizadas.
- **Configuración de conexión** — credenciales y ubicación del almacén, en un único lugar fuera de
  la carpeta pública y fuera del repositorio, para que cambiar de entorno no implique tocar
  lógica.

**Fronteras entre módulos:** la única forma de hablar con la capa de aplicación es la interfaz
del catálogo (y la pantalla de la ficha, que se arma en el servidor). La capa de aplicación no
conoce cómo se ve nada. El acceso a datos no conoce reglas de negocio, solo cómo leer. Ninguna de
estas fronteras se cruza "por comodidad" al implementar: cada cruce es una decisión nueva y
debería entrar como un ADR nuevo.

---

## 4. Fuera de alcance técnico

Enfoques evaluados y descartados para esta feature, con su motivo.

- **Un framework de PHP** — se descartó porque el relevamiento fijó PHP nativo. Es una
  decisión de entrada (D-01), no de diseño.
- **Escritura de datos desde el sitio público** — se descartó porque el visitante solo lee en la
  v1. La carga del catálogo es la spec 002.
- **Sesión o cookie propia del sitio** — se descartó por D-04: no hay nada que el servidor
  necesite recordar del visitante.
- **Caché del listado** — se descartó por la complejidad de invalidación: con la carga del
  catálogo (spec 002) el contenido cambia, y el orden con semilla multiplica las variantes. El
  costo de leer siempre es bajo con el volumen supuesto.
- **Paginación del listado** — se descartó porque la spec no la contempla y con menos de 50
  modelos la lectura completa es suficiente. Deuda consciente, no un olvido.
- **Búsqueda por texto y filtros por dimensiones o material** — se descartó porque es
  F-BUS-001, una spec propia.
- **Copia local de Bootstrap** — se descartó por D-09.
- **Subida de video como archivo** — se descartó por D-10, mientras no se confirme lo contrario.
- **Despliegue y hosting** — se descartó porque el relevamiento no definió el hosting y agregar
  una decisión de despliegue sin requisito que la origine es justamente el caso que la
  trazabilidad busca evitar.

---

## 5. Dudas técnicas pendientes

Lo que no se pudo resolver con la información disponible. No son un defecto del documento: son la
forma honesta de dejar escrito lo que todavía no se sabe.

- **¿Dónde se aloja el sitio?** No se definió. Afecta a la configuración de conexión, a los
  límites de la base de datos disponible y a cómo se expone solo la carpeta pública.
- **¿El video es un enlace o un archivo?** D-10 es provisional. Si se confirma el enlace, falta
  decidir **qué servicios se aceptan** (para que un enlace no apunte a cualquier lugar) y cómo
  se reproduce en la ficha.
- **¿Hay que posicionar el catálogo en buscadores?** Al pintar el catálogo en el navegador (D-05),
  su contenido llega a un buscador de forma más limitada que el de la ficha, que sí lo arma el
  servidor. Si el cliente espera que cada modelo aparezca en buscadores, la ficha ya lo
  resuelve; si lo espera también del listado, D-05 se revisa.
- **¿Cuántos modelos habrá?** Con el supuesto de menos de 50 la lectura completa es suficiente.
  Con cientos, D-07 (un viaje por elección) y la ausencia de paginación se vuelven a evaluar.
- **¿Qué pasa si el visitante manipula la semilla de la dirección?** D-07 la acota a un rango,
  pero no se definió si una semilla enviada por la dirección debe aceptarse siempre o solo
  la que genera la interfaz. Afecta a compartir enlaces: un enlace con semilla reproduciría
  el mismo orden en otro navegador.
- **¿Qué formato exacto tiene el precio?** RN-009 pide pesos argentinos, pero no dice si se
  muestran centavos ni cómo se redondea un valor con decimales.
- **¿Hay un máximo para los textos y la cantidad de imágenes?** La spec no fija un límite para el
  nombre, la descripción ni la galería. Se resuelve en la spec 002, pero condiciona cómo se
  muestran en esta feature.
- **¿Qué hace el sitio si no puede leer el almacén?** F-CAT-001/CA-5 pide un mensaje de error en
  el lugar de la lista, pero no distingue entre "no hay conexión" y "el servidor falló". Queda
  abierto si el mensaje cambia según el motivo.

---

*Documento vivo: cualquier cambio se propone como modificación versionada de este archivo, con
su motivo, y su efecto sobre la matriz de trazabilidad se revisa en el mismo cambio. Si una
decisión deja de sostenerse, se actualiza su ADR —con su contexto nuevo— en lugar de borrar el
anterior.*
