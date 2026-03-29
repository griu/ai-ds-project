---
name: monotonicity-diagnostics
description: Diagnostica monotonicidades respecto al target para apoyar modelado posterior
---

## Objetivo
Analizar monotonicidades respecto al target con justificación:
- visual
- numérica
- de negocio

## Reglas
- Trata variables binarias numéricas como continuas.
- Usa los bivariantes del EDA como soporte principal.
- Documenta una propuesta de monotonicidades candidata para XGBoost.
- No cierres la decisión como definitiva sin validación empírica posterior.
