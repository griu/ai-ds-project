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

Reglas adicionales de implementación:
- no hagas imputación de missing por defecto para XGBoost;
- usa `enable_categorical=True` cuando existan variables que deban entrar como categóricas;
- aplica esto a variables textuales, categóricas explícitas y numéricas de naturaleza categórica;
- no uses target encoding suavizado;
- aprovecha parámetros nativos de categóricas como `max_cat_to_onehot`;
- en predicción, trata categorías no vistas en train como missing o no informadas;
- excluye del modelo cualquier variable prohibida o especialmente protegida.
