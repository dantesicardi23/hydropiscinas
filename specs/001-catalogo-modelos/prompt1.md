Antes de empezar, leé completos estos tres archivos, que son la fuente de verdad:
- AGENTS.md (raíz)
- specs/001-catalogo-modelos/requirements.md
- specs/001-catalogo-modelos/design.md

TAREA: crear únicamente el esqueleto de carpetas del proyecto, tal como figura en la sección
"Estructura de directorios" de AGENTS.md. Nada más.

Creá estas carpetas, cada una con un archivo vacío .gitkeep:
- public/api
- public/assets/css
- public/assets/js
- public/assets/img
- src/Datos
- src/Servicios
- src/Soporte
- templates
- config
- database
- tests

Creá también un .gitignore en la raíz que excluya, como mínimo: config/config.php (las
credenciales no se versionan), archivos del sistema operativo (.DS_Store, Thumbs.db), carpetas de
editores (.idea/, .vscode/) y archivos *.log.

RESTRICCIONES:
- No crees ningún archivo de código (PHP, JS, CSS, HTML, SQL) ni de configuración fuera de los
  indicados.
- No instales dependencias ni inicialices Composer, npm u otra herramienta.
- No crees carpetas ni archivos que no estén en esta lista. Si creés que falta algo, preguntame
  antes de agregarlo.
- No modifiques AGENTS.md ni los archivos de specs/.

CÓMO VERIFICAR (según AGENTS.md):
1. Mostrame el árbol resultante del proyecto.
2. Confirmá que solo public/ está pensada para quedar expuesta por el servidor web, y que
   config/config.php quedó excluido por .gitignore.
3. Citá qué regla de AGENTS.md aplicaste en cada decisión.
4. Si algo no está cubierto por AGENTS.md, requirements.md ni design.md, planteá la duda y
   esperá mi respuesta; no lo resuelvas por tu cuenta.