-- ============================================================================
-- database/seed.sql — Datos de ejemplo para desarrollo (feature 001)
-- Son datos FICTICIOS, claramente de ejemplo; no son contenido real del cliente.
--
-- Fuente de verdad: specs/001-catalogo-modelos/requirements.md §5 (F-CAT-001 y
-- F-CAT-002) y las reglas RN-xxx citadas en cada bloque.
--
-- D-06 / RN-008: los textos se guardan CRUDOS, sin escapar ni limpiar. Las
-- etiquetas HTML y las comillas se insertan tal cual están en el literal: la
-- neutralización ocurre al mostrar, nunca al guardar.
--
-- Los ids los asigna AUTO_INCREMENT en el orden de inserción. Eso importa:
-- RN-011 desempata por id ascendente, y por eso los modelos empatados se
-- insertan en el orden en que deben aparecer (id 1 antes que id 2, etc.).
-- ============================================================================


-- ---------------------------------------------------------------------------
-- Caso 1 · Tres categorías.
-- "Obra" existe en la tabla pero ningún modelo suyo estará publicado: sirve
-- para probar RN-005 (una categoría sin modelos publicados no aparece como
-- opción de navegación; design.md D-02: la lista se deriva de lo publicado).
-- ---------------------------------------------------------------------------
INSERT INTO categoria (nombre) VALUES
  ('Fibra de vidrio'),
  ('Liner'),
  ('Obra');


-- ---------------------------------------------------------------------------
-- Casos 2, 3, 6, 7, 8 y 9 · Modelos.
-- Caso 2: ~8 modelos con precios en pesos argentinos (aquí van 9).
-- Caso 3: F-CAT-001/CA-6 y F-CAT-002/CA-5 — modelos NO publicados
--         ("Atlantis 5x3" en categoría Fibra y los dos de Obra): no aparecen
--         en el catálogo ni son accesibles por su dirección directa (RN-002).
-- Caso 4: categoría "Obra" cuyos modelos están TODOS sin publicar (RN-005).
-- Caso 5: F-CAT-002/CA-3 — "Liner Compact 4x3" está publicado y NO tiene
--         imágenes: su ficha debe mostrar la imagen de reemplazo.
-- Caso 6: RN-010 — "Olympus 6x3" (id 1) tiene video; el resto no tiene
--         (video_url NULL) y no debe mostrarse ningún indicador de video.
--         D-10: el video es un enlace a un servicio externo (decisión
--         provisoria); el enlace de abajo es ficticio, como los archivos.
-- Caso 7: RN-011 / F-CAT-001/CA-10 — ids 1 y 2 tienen el MISMO nombre y el
--         MISMO precio (empate doble); ids 6 y 7 tienen el mismo precio con
--         nombres distintos. El desempate es por id ascendente: siempre
--         "Olympus 6x3" de id 1 antes que el de id 2, y "Liner Clásico"
--         (id 6) antes que "Liner Compact" (id 7) al ordenar por precio.
-- Caso 8: RN-008 / F-CAT-001/CA-12 y F-CAT-002/CA-7 — "Tempest Pro «especial»"
--         (id 4) tiene etiquetas HTML y comillas en el nombre y en la
--         descripción, GUARDADOS CRUDOS: deben verse como texto literal.
-- Caso 9: "Liner Clásico 7x4" (id 6) tiene una descripción con saltos de
--         línea reales (fin de línea dentro del literal) que deben mostrarse
--         tal cual (RN-008).
-- ---------------------------------------------------------------------------
INSERT INTO modelo (categoria, nombre, descripcion, largo, ancho, profundidad, material, precio_desde, video_url, publicado) VALUES
  (1, 'Olympus 6x3',
   'Piscina de fibra de vidrio Olympus 6x3, el modelo más pedido de la línea.
Escalera integrada y borde perimetral de serie.',
   6.00, 3.00, 1.35, 'Fibra de vidrio', 8900000.00,
   'https://www.youtube.com/watch?v=video-de-ejemplo-olympus', 1);

INSERT INTO modelo (categoria, nombre, descripcion, largo, ancho, profundidad, material, precio_desde, video_url, publicado) VALUES
  (1, 'Olympus 6x3',
   'Segunda unidad de ejemplo: mismo nombre y mismo precio que la Olympus 6x3 de id 1, para probar el desempate por identificador (RN-011).',
   6.00, 3.00, 1.35, 'Fibra de vidrio', 8900000.00, NULL, 1);

INSERT INTO modelo (categoria, nombre, descripcion, largo, ancho, profundidad, material, precio_desde, video_url, publicado) VALUES
  (1, 'Delfín 8x4',
   'Modelo de fibra de vidrio de la línea Delfín, con amplio deck de acceso.',
   8.00, 4.00, 1.50, 'Fibra de vidrio', 12400000.00, NULL, 1);

INSERT INTO modelo (categoria, nombre, descripcion, largo, ancho, profundidad, material, precio_desde, video_url, publicado) VALUES
  (1, 'Tempest <b>Pro</b> "especial"',
   'Caso 8 (RN-008): este texto se guardó crudo, con etiquetas y comillas, y debe mostrarse como contenido literal, nunca como código.
Incluye comillas ''simples'' y "dobles" tal como se cargaron.',
   7.50, 3.75, 1.45, 'Fibra de vidrio', 10150000.00, NULL, 1);

INSERT INTO modelo (categoria, nombre, descripcion, largo, ancho, profundidad, material, precio_desde, video_url, publicado) VALUES
  (1, 'Atlantis 5x3',
   'Modelo NO publicado: no debe aparecer en el catálogo ni ser accesible por su dirección directa (F-CAT-001/CA-6, F-CAT-002/CA-5).',
   5.00, 3.00, 1.30, 'Fibra de vidrio', 7300000.00, NULL, 0);

INSERT INTO modelo (categoria, nombre, descripcion, largo, ancho, profundidad, material, precio_desde, video_url, publicado) VALUES
  (2, 'Liner Clásico 7x4',
   'Piscina de liner con borde de hasta 1 metro de ancho.
Descripción con saltos de línea reales (caso 9): el sistema debe conservarlos
y mostrarlos tal como fueron cargados (RN-008).

Tercer párrafo después de una línea en blanco.',
   7.00, 4.00, 1.60, 'Liner sobre osamenta de acero', 11750000.00, NULL, 1);

INSERT INTO modelo (categoria, nombre, descripcion, largo, ancho, profundidad, material, precio_desde, video_url, publicado) VALUES
  (2, 'Liner Compact 4x3',
   'Modelo publicado SIN imágenes (caso 5, F-CAT-002/CA-3): su ficha debe mostrar la imagen de reemplazo y el resto de la información completa. Mismo precio que Liner Clásico 7x4 para probar el desempate por id (RN-011).',
   4.00, 3.00, 1.40, 'Liner sobre osamenta de acero', 11750000.00, NULL, 1);

INSERT INTO modelo (categoria, nombre, descripcion, largo, ancho, profundidad, material, precio_desde, video_url, publicado) VALUES
  (3, 'Obra Bruta 6x3',
   'Modelo de la categoría Obra, sin publicar: la categoría Obra no debe aparecer entre las opciones de navegación porque ninguno de sus modelos está publicado (RN-005).',
   6.00, 3.00, 1.45, 'Albañilería con revestimiento cerámico', 6500000.00, NULL, 0);

INSERT INTO modelo (categoria, nombre, descripcion, largo, ancho, profundidad, material, precio_desde, video_url, publicado) VALUES
  (3, 'Obra Bruta 8x4',
   'Segundo modelo sin publicar de la categoría Obra, para que la categoría quede sin ningún modelo publicado (RN-005).',
   8.00, 4.00, 1.60, 'Albañilería con revestimiento cerámico', 6500000.00, NULL, 0);


-- ---------------------------------------------------------------------------
-- Caso 10 · Imágenes con textoAlternativo.
-- LOS ARCHIVOS AÚN NO EXISTEN: los nombres de archivo de abajo son
-- ficticios y solo indican la forma esperada (dónde se guardan y cómo se
-- cargan las imágenes es la spec 002-administracion-catalogo).
-- posicion 1 = imagen principal de la galería (requirements.md §3).
-- El modelo id 7 ("Liner Compact 4x3") queda sin imágenes a propósito
-- (caso 5). Los modelos no publicados tampoco tienen imágenes: en la 001
-- nadie los abre.
-- ---------------------------------------------------------------------------
INSERT INTO imagen_modelo (modelo, archivo, posicion, texto_alternativo) VALUES
  (1, 'img/modelos/olympus-6x3-01.webp', 1, 'Vista lateral de la piscina Olympus 6x3 con su deck de fibra'),
  (1, 'img/modelos/olympus-6x3-02.webp', 2, 'Detalle del borde perimetral y la escalera integrada'),
  (1, 'img/modelos/olympus-6x3-03.webp', 3, 'Vista cenital completa del modelo Olympus 6x3');

INSERT INTO imagen_modelo (modelo, archivo, posicion, texto_alternativo) VALUES
  (2, 'img/modelos/olympus-6x3-alt-01.webp', 1, 'Segunda Olympus 6x3, imagen principal de su galería');

INSERT INTO imagen_modelo (modelo, archivo, posicion, texto_alternativo) VALUES
  (3, 'img/modelos/delfin-8x4-01.webp', 1, 'Piscina Delfín 8x4 vista desde el fondo'),
  (3, 'img/modelos/delfin-8x4-02.webp', 2, 'Escalera de acceso del modelo Delfín 8x4');

INSERT INTO imagen_modelo (modelo, archivo, posicion, texto_alternativo) VALUES
  (4, 'img/modelos/tempest-pro-01.webp', 1, 'Imagen principal del modelo Tempest Pro: el texto alternativo también se guarda crudo si el cliente lo carga con etiquetas');

INSERT INTO imagen_modelo (modelo, archivo, posicion, texto_alternativo) VALUES
  (6, 'img/modelos/liner-clasico-7x4-01.webp', 1, 'Liner Clásico 7x4 con borde ancho'),
  (6, 'img/modelos/liner-clasico-7x4-02.webp', 2, 'Detalle del revestimiento de liner');
