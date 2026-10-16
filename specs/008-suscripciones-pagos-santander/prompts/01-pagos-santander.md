# Prompt 01: Integración de la API de Pagos Banco Santander

> **Propósito:** Implementar la comunicación con la pasarela de Banco Santander, el manejador de webhooks y la auditoría de pagos en el back-office.

---

## Tareas a Ejecutar
1. **BD:** Agregar tabla `transacciones_santander` a `database/schema.sql`.
2. **Backend:** Crear `SantanderService.php` en `src/Servicios/` para la comunicación con la API REST de Santander.
3. **Endpoint Webhook:** Implementar `public/api/webhooks/santander.php` con validación de seguridad.
4. **Back-office:** Crear el reporte de pagos en `public/admin/pagos.php`.