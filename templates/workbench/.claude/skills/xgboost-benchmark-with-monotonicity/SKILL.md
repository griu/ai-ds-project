---
name: xgboost-benchmark-with-monotonicity
description: Entrena y compara XGBoost con y sin monotonicidades, respetando métricas, early stopping y validación
---

Si se han definido monotonicidades candidatas:
- entrena un modelo sin monotonicidades;
- y otro con monotonicidades.

Compara siempre en:
- train
- validation
- test

Si el target es binario:
- usa logloss;
- genera curvas de logloss por iteración;
- usa early stopping con paciencia mínima de 20;
- explica criterio de parada e iteración final.
