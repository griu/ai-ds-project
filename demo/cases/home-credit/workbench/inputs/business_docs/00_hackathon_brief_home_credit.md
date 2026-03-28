# Hackathon brief — Home Credit Default Risk

## Contexto
El reto consiste en diseñar una solución de riesgo de crédito sobre un dataset público multi-tabla inspirado en un proceso de concesión minorista. El objetivo es estimar la probabilidad de incumplimiento de una solicitud utilizando información de la solicitud actual y el histórico financiero del cliente.

## Objetivo de negocio
Mejorar la capacidad de priorizar y decidir solicitudes con un enfoque cuantitativo reproducible que:
- reduzca el riesgo esperado de impago;
- mantenga una experiencia comercial razonable;
- permita explicar decisiones y segmentar riesgos.

## Unidad de predicción
Una **solicitud / registro principal** de la tabla de aplicación actual.

## Variable objetivo
La variable objetivo del ejercicio es **`TARGET`** en la tabla principal de entrenamiento (`application_train`):
- `1` = mayor riesgo / evento de incumplimiento según la definición del dataset;
- `0` = no evento.

## Métrica principal
Para el ejercicio se fija como métrica principal:
- **ROC AUC** en validación y test.

Métricas secundarias recomendadas:
- Gini derivado;
- lift / capture en percentiles altos;
- análisis de threshold para uso operativo;
- calibración, si el equipo la trabaja.

## Qué se espera de una solución fuerte
Una solución fuerte no se limita a entrenar un modelo sobre la tabla principal. Debe:
1. integrar las tablas históricas relevantes;
2. resolver granularidades uno-a-muchos con agregaciones razonadas;
3. identificar patrones de missingness, valores extraños y codificaciones especiales;
4. proponer nuevas features;
5. comparar al menos:
   - un baseline interpretable,
   - un modelo tabular fuerte;
6. evaluar rendimiento global y por subsegmentos relevantes;
7. dejar preparado un esqueleto de pipeline reproducible.

## Entregables esperados
- framing del caso y blueprint de datos;
- plan de calidad de datos;
- EDA con hallazgos accionables;
- propuesta de features;
- benchmark de modelos;
- evaluación completa;
- propuesta de pipeline de entrenamiento / scoring / monitoring.

## Restricción del hackathon
El caso debe resolverse de forma profesional, pero con foco: no se premia complejidad gratuita. Toda complejidad adicional debe estar justificada por mejora esperada o robustez.
