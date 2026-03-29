---
name: explainability-pdp-shap
description: Genera validación avanzada con PDP y SHAP respetando tiempos de ejecución
---

## Objetivo
Incorporar explicabilidad avanzada para apoyar la decisión final de variables y modelo.

## Reglas
- Genera PDP comparables a los bivariantes del EDA.
- Genera SHAP con:
  - importancia global
  - efecto medio por variable
  - comparación visual con EDA
- Usa GPU cuando sea posible y útil.
- Vigila tiempos de ejecución.

## Salidas esperadas
- artefactos de PDP
- artefactos de SHAP
- interpretación accionable para selección de variables y validación del modelo
