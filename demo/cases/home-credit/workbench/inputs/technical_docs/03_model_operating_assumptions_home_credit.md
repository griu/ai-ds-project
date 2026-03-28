# Model operating assumptions — Home Credit

## Uso previsto del score
El score resultante se usaría como pieza de apoyo a decisión en originación o priorización de solicitudes, no como único criterio automático incuestionable.

## Lo que importa del modelo
1. buena capacidad de ranking;
2. estabilidad razonable;
3. comportamiento entendible por segmentos;
4. posibilidad de convertirlo en un flujo reproducible.

## Supuestos de modelización
- Debe existir un baseline simple e interpretable.
- Debe probarse un modelo tabular fuerte como referencia principal.
- El uso de modelos más complejos solo está justificado si mejora de forma clara y sostenible.

## Validación recomendada
Como mínimo:
- split de train / validation / test;
- revisión de overfitting;
- comparación consistente entre candidatos;
- evaluación por subsegmentos.

Si el equipo puede justificar una validación más robusta con proxies temporales o cohortes, se considera un plus.

## Entregables de modelado esperados
- definición del target y unidad de observación;
- blueprint de datasets de entrenamiento;
- baseline;
- modelo fuerte;
- tabla comparativa de métricas;
- lectura de variables / familias más importantes;
- propuesta de threshold o uso operativo;
- limitaciones y próximos pasos.

## Entregables de productización esperados
- pipeline modular de preparación de datos;
- pipeline de entrenamiento;
- pipeline de scoring;
- smoke tests mínimos;
- plan de monitoring:
  - data quality;
  - feature drift;
  - score drift;
  - rendimiento por subsegmentos, cuando haya feedback.
