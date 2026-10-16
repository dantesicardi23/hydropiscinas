-- ============================================================================
-- database/schema.sql — Estructura del catálogo (feature 001-catalogo-modelos)
-- Fuente de verdad: specs/001-catalogo-modelos/requirements.md §3 (entidades del
-- dominio) y design.md (D-02, D-03, D-06, D-08).
--
-- Sin CREATE DATABASE ni USE: el script se ejecuta con la base ya elegida.
-- Sin usuarios, permisos, vistas, procedimientos ni disparadores.
-- Motor InnoDB y utf8mb4 (D-01: MySQL). La collation utf8mb4_unicode_ci existe
-- tanto en MySQL 8 como en MariaDB 10.4 (XAMPP): no se usan funciones ni
-- collations exclusivas de una versión.
-- ============================================================================


-- ----------------------------------------------------------------------------
-- categoria — requirements.md §3 (Categoría) / D-08, RN-005
-- Tres colecciones separadas: la categoría es una entidad, no un texto libre
-- dentro del modelo (D-08: "Fibra" y "fibra" no pueden ser dos categorías
-- distintas). El nombre único garantiza esa unicidad.
-- OJO (RN-005 / D-02): la lista de categorías que ve el visitante NO se lee de
-- esta tabla sola; se deriva en cada consulta a partir de los modelos
-- publicados. Aquí solo se guarda el catálogo completo de categorías.
-- ----------------------------------------------------------------------------
CREATE TABLE categoria (
  id      INT UNSIGNED NOT NULL AUTO_INCREMENT,
  nombre  VARCHAR(255) NOT NULL,
  PRIMARY KEY (id),
  CONSTRAINT uq_categoria_nombre UNIQUE (nombre)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- ----------------------------------------------------------------------------
-- modelo — requirements.md §3 (Modelo) / D-08, RN-001, RN-002, RN-003, RN-010
-- RN-001: categoria es obligatoria y clave foránea → "un modelo sin categoría"
-- no se puede guardar (D-08: la regla la garantiza la forma del modelo).
-- RN-003: los campos de la ficha son NOT NULL (nombre, descripción, medidas,
-- material y precio "desde"); un modelo publicado siempre se muestra completo.
-- RN-009: precio_desde se guarda como número (DECIMAL), nunca formateado
-- (D-06: el formato de pesos argentinos se aprecia al mostrar; además RN-011
-- exige poder ordenar por precio).
-- RN-010 / D-10: video_url es opcional (NULL) y guarda solo la dirección de un
-- servicio externo (decisión provisoria).
-- RN-002 / D-02: publicado es obligatorio con defecto "no publicado": la
-- visibilidad se consulta siempre en el servidor y el estado por defecto es el
-- que oculta.
-- D-03: NO existe ningún campo de orden o posición en la categoría o en el
-- modelo: el orden se deriva en cada lectura, nunca se persiste.
-- No hay columnas de fecha de alta ni de modificación: la spec no las define.
--
-- Clave foránea: se deja la acción por defecto (RESTRICT, sin cascada).
-- Las reglas de borrado de categorías y modelos se deciden en la spec
-- 002-administracion-catalogo; decretarlas aquí sería adelantar una decisión.
--
-- Índice: los modelos publicados filtrados por categoría (D-02 + D-07) es la
-- consulta del catálogo; la columna categoria va primera porque además este
-- índice es el que exige la clave foránea (no se crea otro índice duplicado).
-- ----------------------------------------------------------------------------
CREATE TABLE modelo (
  id            INT UNSIGNED   NOT NULL AUTO_INCREMENT,
  categoria     INT UNSIGNED   NOT NULL,
  nombre        VARCHAR(255)   NOT NULL,
  descripcion   TEXT           NOT NULL,
  largo         DECIMAL(10,2)  NOT NULL,
  ancho         DECIMAL(10,2)  NOT NULL,
  profundidad   DECIMAL(10,2)  NOT NULL,
  material      VARCHAR(255)   NOT NULL,
  precio_desde  DECIMAL(12,2)  NOT NULL,
  video_url     VARCHAR(2048)  NULL,
  publicado     BOOLEAN        NOT NULL DEFAULT 0,
  PRIMARY KEY (id),
  CONSTRAINT fk_modelo_categoria FOREIGN KEY (categoria) REFERENCES categoria (id),
  CONSTRAINT chk_modelo_largo          CHECK (largo > 0),
  CONSTRAINT chk_modelo_ancho          CHECK (ancho > 0),
  CONSTRAINT chk_modelo_profundidad    CHECK (profundidad > 0),
  CONSTRAINT chk_modelo_precio_desde   CHECK (precio_desde > 0),
  INDEX idx_modelo_categoria_publicado (categoria, publicado)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- ----------------------------------------------------------------------------
-- imagen_modelo — requirements.md §3 (Imagen de modelo) / D-08, RN-003
-- D-08: las imágenes son una entidad aparte (no una lista dentro del modelo)
-- para poder ordenarlas y guardar el texto alternativo de cada una.
-- RN-001 análogo para imagen.modelo: obligatoria y clave foránea a modelo.
-- posicion: la única "posición" que existe en el modelo de datos (requirements
-- §3) es la del orden dentro de la galería; la primera es la imagen principal.
-- La restricción de unicidad (modelo, posicion) impide que dos imágenes
-- compitan por el mismo lugar en la misma galería. Ese índice, con modelo
-- primera, también responde "imágenes por modelo" y satisface la clave
-- foránea: no se agrega otro índice.
-- texto_alternativo: requirements.md §3 no lo marca obligatorio (a diferencia
-- de archivo), por eso admite NULL; es TEXT porque la spec no fija un máximo
-- de longitud para los textos (duda abierta de design.md §5).
-- archivo: VARCHAR(2048); dónde se guarda y cómo se carga es la spec 002.
--
-- Clave foránea: acción por defecto (RESTRICT, sin cascada), igual que en
-- modelo: las reglas de borrado se deciden en la spec 002-administracion-catalogo.
-- ----------------------------------------------------------------------------
CREATE TABLE imagen_modelo (
  id                INT UNSIGNED  NOT NULL AUTO_INCREMENT,
  modelo            INT UNSIGNED  NOT NULL,
  archivo           VARCHAR(2048) NOT NULL,
  posicion          INT           NOT NULL,
  texto_alternativo TEXT          NULL,
  PRIMARY KEY (id),
  CONSTRAINT fk_imagen_modelo_modelo FOREIGN KEY (modelo) REFERENCES modelo (id),
  CONSTRAINT uq_imagen_modelo_posicion UNIQUE (modelo, posicion)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
