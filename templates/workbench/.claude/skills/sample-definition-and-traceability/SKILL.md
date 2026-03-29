---
name: sample-definition-and-traceability
description: Define la muestra analítica y deja trazabilidad completa de población, filtros y exclusiones
---

## Objetivo
Construir y documentar la fase de definición de muestras como etapa separada de data quality, EDA y modelado.

## Debes documentar
- unidad de análisis;
- ventana temporal de observación;
- definición del target;
- filtros de selección;
- población inicial;
- exclusiones aplicadas;
- justificación analítica o de negocio;
- tamaño final de cada muestra.

## Reglas
- no elimines casos sin justificación explícita;
- si la tarea exige excluir casos, deja la decisión preparada para validación humana;
- distingue problemas de originación y comportamentales;
- considera sesgos por observaciones repetidas por individuo u objeto;
- deja trazabilidad clara en `workbench/docs/`.
