# requirements.md — Configurador de Proyectos y Presupuesto Estimado

- **Nombre del proyecto:** Plataforma Web Piscinas Polaco (Polaco ADM)
- **Feature:** `006-configurador-presupuestos`
- **Versión del documento:** 0.1-draft
- **Estado:** BORRADOR
- **Artefacto asociado:** `design.md`

---

## 1. Contexto y objetivos
Permitir que el visitante personalice un proyecto de piscina seleccionando un modelo base y equipamiento adicional (luces LED, climatización, sistemas de filtrado, bordes/decks), obteniendo un presupuesto estimado interactivo en tiempo real.

## 2. Reglas de Negocio (RN-CFG-xxx)
- **RN-CFG-001 · Presupuesto referencial no vinculante.** El total calculado es una estimación. Se debe mostrar una leyenda clara indicando que el valor final está sujeto a inspección del terreno.
- **RN-CFG-002 · Cálculo dinámico.** El costo total = `precioDesde` del modelo + suma de precios de opcionales seleccionados.

## 3. Especificaciones Funcionales (Features F-CFG-xxx)
- **F-CFG-001 (Paso a paso interactivo):** 1) Elección de modelo -> 2) Elección de luces/filtrado -> 3) Elección de bordes -> 4) Resumen y descarga/envío de cotización.
- **F-CFG-002 (Administración de Opcionales):** CRUD en back-office para gestionar los equipamientos adicionales y sus precios unitarios.