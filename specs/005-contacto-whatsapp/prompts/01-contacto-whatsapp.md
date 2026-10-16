# Prompt 01: Implementación de Contacto Directo y Gestión de Leads

> **Propósito:** Crear la tabla `contacto_leads`, la lógica de enlaces de WhatsApp contextuales, la API de procesamiento de formularios y el módulo de administración de leads en `public/admin/leads.php`.

---

## Tareas a Ejecutar
1. **BD:** Agregar tabla `contacto_leads` a `database/schema.sql` con índices en `estado` y `fecha_creacion`.
2. **Backend:** Crear `src/Datos/LeadDAO.php` y `src/Servicios/LeadServicio.php`.
3. **Frontend público:** Agregar el componente de WhatsApp en `public/index.php`, `public/showroom.php` y el modal de ficha.
4. **Back-office:** Crear la interfaz de gestión de contactos en `public/admin/leads.php`.