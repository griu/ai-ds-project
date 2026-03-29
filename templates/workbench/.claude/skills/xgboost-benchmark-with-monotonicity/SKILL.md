---
name: xgboost-benchmark-with-monotonicity
description: Entrena y compara XGBoost con y sin monotonicidades, respetando métricas, early stopping y validación
---

## Reglas
- Si se han definido monotonicidades candidatas:
  - entrena un modelo sin monotonicidades
  - y otro con monotonicidades
- Compara siempre en:
  - train
  - validation
  - test
- Usa GPU si existe y aporta valor.

## Target binario
- Usa logloss.
- Genera gráficos de logloss por iteración en train y validation.
- Usa early stopping con paciencia mínima de 20.
- Usa además un umbral mínimo razonable de mejora.
- Explica:
  - criterio de parada
  - iteración final
  - sugerencias de mejora

## Salidas esperadas
- benchmark comparativo
- métricas
- curvas de entrenamiento
- recomendación preliminar no definitiva
