---
name: eda-with-ydata-profiling
description: Realiza EDA estándar con uso preferente de ydata-profiling y complementos bivariantes respecto al target
---

## Objetivo
Cubrir EDA univariante y bivariante respecto al target respetando `control/PROJECT_TECHNICAL_REQUIREMENTS.md`.

## Reglas
- Prioriza `ydata-profiling` siempre que sea posible.
- Completa con gráficos propios cuando el nivel de detalle requerido no esté cubierto.
- Cubre variables explicativas:
  - continuas
  - binarias
  - categóricas
- Cubre targets:
  - binarios
  - continuos
  - categóricos

## Requisitos mínimos por bivariante
- Mostrar volumen de casos por categoría o tramo.
- Para continuas:
  - usar kernel density o equivalente, o
  - discretización por quantiles.
- Mostrar relación con el target:
  - propensión si binario
  - media si continuo
  - métrica equivalente si categórico
- Si usas quantiles, mostrar propensión o media por tramo.
- Si usas kernel density, incorporar una aproximación rápida tipo LOESS o equivalente.
- Priorizar eficiencia computacional.

## Salidas esperadas
- informe de `ydata-profiling` si aplica
- gráficos adicionales en `workbench/docs/` o `workbench/notebooks/`
- resumen accionable para limpieza, features y modelado
