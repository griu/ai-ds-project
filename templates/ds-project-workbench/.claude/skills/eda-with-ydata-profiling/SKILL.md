---
name: eda-with-ydata-profiling
description: Genera un perfilado exploratorio estándar con ydata-profiling y lo usa para apoyar limpieza, validación y feature engineering
---

# Cuándo usar esta skill
Úsala cuando la tarea implique análisis exploratorio inicial, validación de calidad, limpieza o definición de variables.

# Reglas
- Usa `ydata-profiling` como herramienta estándar para generar el perfilado inicial del dataset.
- Genera, como mínimo, un informe HTML y, si aporta valor al flujo, una salida JSON.
- Distingue entre perfilado general del dataset y análisis dirigidos por el target.
- No conviertas la EDA en modelización prematura.
- Si el target existe y el problema lo requiere, complementa el perfilado con análisis bivariantes manuales o código adicional; no fuerces a `ydata-profiling` a cubrir todo el análisis inferencial.

# Procedimiento
1. Valida esquema, tipos, nulos y duplicados.
2. Genera un perfilado base con `ydata-profiling`.
3. Revisa en el informe:
   - calidad de tipos
   - missingness relevante
   - cardinalidad
   - correlaciones o asociaciones destacadas
   - valores atípicos y distribuciones problemáticas
4. Si hay target o segmentación relevante, añade análisis específicos para:
   - continua vs target
   - discreta vs target
   - cortes temporales o cohortes, si existen
5. Documenta hallazgos accionables en `docs/`.
6. Si la EDA revela reglas de limpieza o nuevas familias de variables, propónlas explícitamente.

# Outputs recomendados
- `docs/eda_profile_report.html`
- `docs/eda_profile_summary.md`
- código reusable en `src/` o notebook en `notebooks/`, según el alcance de la tarea
