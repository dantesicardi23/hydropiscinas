# requirements.md — Planes de Ahorro y Simulador de Cuotas

- **Nombre del proyecto:** Plataforma Web Piscinas Polaco (Polaco ADM)
- **Feature:** `007-planes-ahorro`
- **Versión del documento:** 0.1-draft
- **Estado:** BORRADOR
- **Artefacto asociado:** `design.md`

---

## 1. Contexto y objetivos
Presentar la modalidad de Plan de Ahorro para la adquisición de piscinas, ofreciendo un simulador de cuotas dinámico según la cantidad de meses (ej. 12, 24, 36, 60 cuotas) y los requisitos legales del contrato.

## 2. Reglas de Negocio (RN-PLN-xxx)
- **RN-PLN-001 · Cálculo de cuota pura y gastos.** La cuota estimada se compone de `(precioModelo / cantidadCuotas) + gastosAdministrativos`.
- **RN-PLN-002 · Claridad legal.** Se deben incluir las cláusulas informativas sobre adjudicación, licitación y sorteos exigidos por normativa.

## 3. Especificaciones Funcionales (Features F-PLN-xxx)
- **F-PLN-001 (Simulador Público):** Selector de modelo y slider de cantidad de cuotas que actualiza el valor estimado mensual.
- **F-PLN-002 (Pre-inscripción al Plan):** Formulario para solicitar adhesión a un grupo de plan de ahorro.