Antes de empezar, leé completos estos archivos, que son la fuente de verdad:
- AGENTS.md (raíz)
- specs/001-catalogo-modelos/requirements.md (v0.4-draft, sección 3 "Entidades del dominio")
- specs/001-catalogo-modelos/design.md (especialmente D-02, D-06 y D-08)

TAREA: crear los dos scripts SQL de la base de datos, y nada más:
- database/schema.sql  (estructura)
- database/seed.sql    (datos de ejemplo para desarrollo)

REQUISITOS DE schema.sql
- Tres tablas, una por entidad: categoría, modelo e imagen de modelo. Nombres de tablas y
  columnas en español, en minúsculas y con guion bajo (por ejemplo precio_desde, video_url).
- Campos exactamente los de la sección 3 de requirements.md. No agregues columnas que la spec no
  define (nada de fechas de alta o modificación, ni de orden ni de posición en categoría o
  modelo). La única "posicion" es la de la imagen, que es el orden dentro de la galería.
- Integridad declarada en el modelo de datos (origen: RN-001, RN-003 / D-08):
  - modelo.categoria: obligatoria, clave foránea a categoría.
  - imagen.modelo: obligatorio, clave foránea a modelo.
  - Campos obligatorios de la ficha como NOT NULL: nombre, categoría, descripción, largo, ancho,
    profundidad, material y precio "desde". video_url es opcional (admite NULL).
  - nombre de categoría único.
  - largo, ancho, profundidad y precio "desde" mayores que cero (CHECK).
  - publicado: booleano, obligatorio, por defecto no publicado.
  - En imagen, la posición no puede repetirse dentro del mismo modelo.
- Borrado: dejá las claves foráneas con la acción por defecto (RESTRICT, sin cascada). Las reglas
  de borrado se deciden en la spec 002; dejá un comentario que lo diga.
- Tipos: precio "desde" como DECIMAL(12,2); medidas como DECIMAL; textos sin límites de negocio
  inventados (la spec no los fija: es una duda abierta de design.md §5), usando VARCHAR(255) para
  nombres y material, TEXT para descripción, VARCHAR(2048) para video_url y archivo.
- Motor InnoDB y juego de caracteres utf8mb4. Compatible con MySQL 8 y MariaDB 10.4 (XAMPP): no
  uses funciones exclusivas de una versión.
- Índices solo para lo que el diseño consulta: modelos publicados filtrados por categoría, e
  imágenes por modelo.
- No incluyas CREATE DATABASE ni USE (el script se ejecuta con la base ya elegida), ni usuarios,
  permisos, vistas, procedimientos ni disparadores.
- Comentá cada tabla con la regla o decisión de la que sale (RN-xxx / D-xx).

REQUISITOS DE seed.sql (datos ficticios, claramente de ejemplo)
Debe incluir, como mínimo, estos casos, cada uno comentado con el criterio que ayuda a probar:
1. 3 categorías.
2. Alrededor de 8 modelos, con precios en pesos argentinos.
3. Al menos 1 modelo NO publicado (F-CAT-001/CA-6, F-CAT-002/CA-5).
4. Una categoría cuyos modelos estén todos sin publicar (RN-005).
5. Al menos 1 modelo sin imágenes (F-CAT-002/CA-3).
6. Al menos 1 modelo con video y varios sin video (RN-010).
7. Dos modelos con el mismo nombre y dos con el mismo precio, para probar el desempate por
   identificador (RN-011, F-CAT-001/CA-10).
8. Un modelo cuyo nombre y descripción contengan etiquetas HTML y comillas, para probar la
   neutralización (RN-008, F-CAT-001/CA-12, F-CAT-002/CA-7). Guardalos crudos, sin escapar.
9. Una descripción con saltos de línea.
10. Imágenes con textoAlternativo. Los archivos referenciados todavía no existen: usá nombres
    de archivo ficticios y avisalo en un comentario.

RESTRICCIONES
- Solo creás database/schema.sql y database/seed.sql. Podés borrar database/.gitkeep.
- No toques AGENTS.md, specs/ ni otras carpetas. No crees código PHP, JS ni CSS.
- Si algo no está cubierto por AGENTS.md, requirements.md ni design.md, planteá la duda y
  esperá mi respuesta; no la resuelvas por tu cuenta.

CÓMO VERIFICAR (según AGENTS.md)
Si tenés MySQL o MariaDB disponible, creá una base temporal, ejecutá schema.sql y seed.sql, y
mostrame el resultado de estas comprobaciones:
1. Cantidad de modelos publicados y no publicados.
2. Las categorías derivadas solo de modelos publicados: la categoría del caso 4 no debe aparecer
   (RN-005).
3. Un INSERT de modelo sin categoría debe fallar.
4. Un INSERT con largo igual a 0 debe fallar.
5. Un INSERT de categoría con nombre repetido debe fallar.
6. Un INSERT de imagen con posición repetida en el mismo modelo debe fallar.
Si no podés ejecutar la base, decímelo explícitamente: no afirmes que lo verificaste.
Para cerrar, citá qué regla de AGENTS.md o decisión de design.md aplicaste en cada paso.