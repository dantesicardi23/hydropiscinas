# requirements.md — Suscripciones Online y Pagos Santander

- **Nombre del proyecto:** Plataforma Web Piscinas Polaco (Polaco ADM)
- **Feature:** `008-suscripciones-pagos-santander`
- **Versión del documento:** 0.1-draft
- **Estado:** BORRADOR
- **Artefacto asociado:** `design.md`

---

## 1. Contexto y objetivos
Integrar la pasarela de pagos / API del Banco Santander para permitir el cobro online de la cuota de suscripción inicial o cuotas mensuales de los planes de ahorro de forma segura.

## 2. Reglas de Negocio (RN-PAG-xxx)
- **RN-PAG-001 · Confirmación por Webhook.** Ninguna suscripción o pago se da por aprobado en el sistema hasta recibir el callback/webhook firmado y verificado desde el servidor de Banco Santander.
- **RN-PAG-002 · Trazabilidad de transacciones.** Todo intento de pago (aprobado, rechazado, pendiente) debe registrarse con su id de transacción externo y logs de auditoría.

## 3. Especificaciones Funcionales (Features F-PAG-xxx)
- **F-PAG-001 (Checkout de Pago):** Redirección o checkout transparente con la pasarela de Santander.
- **F-PAG-002 (Recepción de Webhooks):** Endpoint seguro de notificación estado de pago.
- **F-PAG-003 (Panel de Transacciones):** Vista en el back-office para auditar los pagos recibidos.