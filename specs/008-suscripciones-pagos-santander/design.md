# design.md — Suscripciones Online y Pagos Santander

- **Feature:** `008-suscripciones-pagos-santander`
- **requirements.md de referencia:** `specs/008-suscripciones-pagos-santander/requirements.md`

---

## 1. Decisiones Técnicas (ADR)
- **D-PAG-01 (Almacenamiento de Credenciales):** Claves de API (`CLIENT_ID`, `CLIENT_SECRET`) almacenadas estrictamente en `config/config.php` (fuera del control de versiones).
- **D-PAG-02 (Tabla de Pagos):** `transacciones_santander` (`id`, `solicitud_id`, `payment_id_externo`, `monto`, `estado`, `payload_respuesta`, `fecha_creacion`).
- **D-PAG-03 (Endpoint Webhook Seguro):** `public/api/webhooks/santander.php` valida la firma HMAC/Header de seguridad antes de procesar el estado del pago.