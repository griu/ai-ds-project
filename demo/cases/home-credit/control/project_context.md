# Contexto del proyecto — Home Credit Default Risk

## Propósito de la demo
Esta demo debe mostrar un modo de trabajo gobernado entre **control** y **workbench** para un caso realista de modelización avanzada de riesgo de crédito a partir de un dataset público multi-tabla.

El objetivo no es enseñar notebooks sueltos, sino demostrar que:
- el problema se define bien desde negocio y datos;
- las tareas se secuencian con criterio;
- el área de ejecución trabaja con autonomía pero bajo gobierno;
- se llega a una propuesta seria de calidad de datos, EDA, feature engineering, modelización, evaluación y productización.

## Tipo de caso
Caso de **credit risk / probability of default** a partir del conjunto de datos público Home Credit.

## Audiencia
La audiencia esperada es técnica y exigente:
- data scientists senior;
- perfiles de riesgo/model risk;
- personas acostumbradas a revisar data quality, EDA potente, feature engineering, benchmarking de modelos y diseño de pipelines productivos.

## Qué debe demostrar el sistema
El sistema debe ser capaz de guiar de forma autónoma una progresión razonable, sin saltar pasos:
1. consolidar framing del caso, target, unidad de predicción y criterios de evaluación;
2. ordenar paisaje de datos, granularidades, joins y riesgos de leakage;
3. preparar conectividad y entorno técnico;
4. definir y ejecutar una EDA potente orientada a decisiones y nuevas features;
5. comparar enfoques de modelización:
   - baseline interpretable (por ejemplo GLM / logistic)
   - modelo fuerte tabular (por ejemplo XGBoost o similar)
   - opcionalmente una alternativa más compleja solo si está justificada;
6. evaluar rendimiento global y por subsegmentos;
7. dejar una propuesta modular de pipeline y un plan de monitoring / drift.

## Restricción importante para el control plane
El control plane debe decidir el siguiente paso **solo** a partir del estado real del proyecto, pero también debe evitar quedarse en tareas demasiado pobres si ya hay material suficiente para formular una fase más rica.

## Resultado esperado de la demo
Que el público vea un workflow serio de Data Science, no una simple generación automática de texto.
