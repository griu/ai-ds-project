---
name: eda-with-ydata-profiling
description: Realiza EDA estándar con uso preferente de ydata-profiling y complementos bivariantes respecto al target
---

Prioriza `ydata-profiling`.
Completa con gráficos propios cuando haga falta más detalle.

Cubre:
- variables continuas, binarias y categóricas;
- targets binarios, continuos y categóricos;
- volumen por categoría o tramo;
- propensión, media o métrica equivalente;
- quantiles o kernel density;
- aproximación rápida tipo LOESS si hace falta.

Reglas operativas adicionales:
- si generas notebooks de EDA, deben guardarse ejecutados y con outputs visibles;
- si generas gráficos de EDA como imágenes, deben mostrarse también dentro del notebook correspondiente.
