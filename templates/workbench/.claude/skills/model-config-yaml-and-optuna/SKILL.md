---
name: model-config-yaml-and-optuna
description: Gestiona configuración de variables, monotonicidades, hiperparámetros y optimización en YAML
---

## Objetivo
Dejar la configuración del modelado en archivos editables y trazables.

## Reglas
- Mantén YAML editable de hiperparámetros.
- Mantén YAML editable de variables y monotonicidades.
- Genera además YAML o CSV con todas las variables candidatas y su estado.
- Si la tarea lo pide, integra Optuna para:
  - XGBoost
  - Random Forest
  - deep learning
- Los rangos de búsqueda deben vivir en YAML.
- Debe poderse:
  - fijar valores
  - ajustar rangos
  - desactivar hiperparámetros
  - fijar número máximo de iteraciones
  - activar o desactivar monotonicidades

## Reglas adicionales
- Evita postcalibración que altere medias o propensiones de forma no deseada.
- La versión final del modelo no queda cerrada hasta validación humana.
