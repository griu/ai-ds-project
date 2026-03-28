# Jury and demo goals — Home Credit

## Qué espera ver un jurado técnico exigente
El jurado no espera una simple síntesis documental. Espera ver criterio profesional en:

- definición del problema y del target;
- comprensión de la estructura multi-tabla;
- identificación de riesgos de calidad y leakage;
- hipótesis de EDA y feature engineering con valor;
- comparación de modelos con baseline y modelo fuerte;
- evaluación rigurosa:
  - train / validation / test;
  - estabilidad;
  - calibración si procede;
  - rendimiento por subsegmentos;
- visión de productización:
  - pipeline reproducible;
  - modularidad;
  - smoke tests;
  - monitoring y drift.

## Criterio didáctico para la demo
La demo debe enseñar autonomía gobernada:
- `control` revisa, prioriza y decide;
- `workbench` ejecuta y reporta;
- ninguna de las dos áreas debe avanzar por inercia;
- pero tampoco debe atascarse en tareas triviales si la información disponible permite una formulación más rica.

## Señales de una buena progresión
La secuencia será considerada buena si, en pocas iteraciones, se llega a:
1. definición cerrada del caso;
2. blueprint de datos y joins;
3. conectividad y entorno;
4. EDA fuerte con hallazgos accionables;
5. feature set documentado;
6. benchmark de modelos;
7. evaluación avanzada;
8. propuesta de pipeline productivo.

## Señales de una mala progresión
- quedarse en resúmenes pobres de inputs;
- abrir modelización sin haber cerrado target, métrica, joins o leakage;
- no distinguir claramente qué se sabe y qué falta;
- no traducir el análisis en decisiones de modelado y explotación.

## Regla para control
Si la documentación base ya contiene material suficiente, formula tareas que tengan ambición profesional, pero sigan siendo verificables y acotadas.
