# design.md — Planes de Ahorro y Simulador de Cuotas

- **Feature:** `007-planes-ahorro`
- **requirements.md de referencia:** `specs/007-planes-ahorro/requirements.md`

---

## 1. Decisiones Técnicas (ADR)
- **D-PLN-01 (Configuración de Planes):** Tabla `planes_config` para parametrizar tasa de gastos administrativos, cantidad de cuotas permitidas y texto legal de bases y condiciones.
- **D-PLN-02 (Solicitudes de Adhesión):** Tabla `plan_solicitudes` para almacenar los datos de pre-suscripción antes de pasar al pasarela de pagos.