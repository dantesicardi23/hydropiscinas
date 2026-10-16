# design.md — Configurador de Proyectos y Presupuesto Estimado

- **Feature:** `006-configurador-presupuestos`
- **requirements.md de referencia:** `specs/006-configurador-presupuestos/requirements.md`

---

## 1. Decisiones Técnicas (ADR)
- **D-CFG-01 (Modelo de Datos de Opcionales):**
  - `opcionales`: `id`, `categoria_opcional` (iluminacion, climatizacion, bordes), `nombre`, `precio`, `publicado`.
- **D-CFG-02 (Cálculo en Cliente y Servidor):** El cliente actualiza el total en JS mediante cambio de estado de inputs, pero el resumen final y PDF/Email se re-calcula estrictamente en el servidor.