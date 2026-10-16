# design.md — Canales de Contacto Directo y Leads

- **Feature:** `005-contacto-whatsapp`
- **requirements.md de referencia:** `specs/005-contacto-whatsapp/requirements.md`

---

## 1. Decisiones Técnicas (ADR)
- **D-CNT-01 (Tabla de Leads):** `contacto_leads` (`id`, `nombre`, `telefono`, `email`, `localidad`, `modelo_id`, `mensaje`, `estado`, `fecha_creacion`).
- **D-CNT-02 (Generación de enlaces WhatsApp):** Helper en JS/PHP que codifica en URL (`urlencode`) las variables de contexto (`%0A` para saltos de línea).
- **D-CNT-03 (Protección Anti-Spam):** Implementación de trampa Honeypot y control de frecuencia (rate limit) básico por IP en la recepción del formulario.