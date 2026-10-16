# requirements.md — Canales de Contacto Directo y Leads

- **Nombre del proyecto:** Plataforma Web Piscinas Polaco (Polaco ADM)
- **Feature:** `005-contacto-whatsapp`
- **Versión del documento:** 0.1-draft
- **Estado:** BORRADOR
- **Artefacto asociado:** `design.md`

---

## 1. Contexto y objetivos
Facilitar la conversión directa de visitantes a clientes potenciales (leads) mediante botones contextuales de WhatsApp con mensajes predefinidos según el modelo o proyecto que estén consultando, junto con un formulario de contacto directo prioritario.

## 2. Reglas de Negocio (RN-CNT-xxx)
- **RN-CNT-001 · Mensaje contextual de WhatsApp.** Al hacer clic en un botón de WhatsApp desde la ficha de un modelo o proyecto, el mensaje inicial predefinido debe incluir el nombre del modelo, su precio "desde" referencial y la URL de la ficha.
- **RN-CNT-002 · Registro obligatorio de Leads.** Todo contacto enviado a través del formulario público debe registrarse en la base de datos interna antes de redirigir o notificar.

## 3. Especificaciones Funcionales (Features F-CNT-xxx)
- **F-CNT-001 (CTA WhatsApp Contextual):** Botón flotante y botones de acción en fichas que abren la API de WhatsApp (`wa.me`) con texto personalizado.
- **F-CNT-002 (Formulario de Contacto Prioritario):** Formulario con validación en servidor (nombre, teléfono, email, localidad, mensaje).
- **F-CNT-003 (Gestión de Leads en Back-office):** Panel en el back-office para que el administrador consulte, marque como contactado o exporte la lista de mensajes/leads recibidos.