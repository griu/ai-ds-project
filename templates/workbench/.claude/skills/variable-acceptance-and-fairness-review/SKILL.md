---
name: variable-acceptance-and-fairness-review
description: Revisa variables por causalidad, negocio, fairness, proxies, missing y coherencia de signo o monotonicidad
---

## Objetivo
Emitir alertas y recomendaciones sobre aceptación o rechazo de variables candidatas antes del modelado definitivo.

## Debes revisar
- interpretabilidad de negocio;
- sentido causal o explicativo mínimo;
- variables con alta relación estadística pero baja interpretabilidad;
- fairness, sesgo y regulación;
- proxies de atributos protegidos;
- coherencia de signo o monotonicidad;
- comportamiento de Missing;
- aceptabilidad de patrones no monótonos.

## Reglas
- no bloquees automáticamente todos los casos, pero sí eleva revisión obligatoria cuando corresponda;
- prioriza variables más causales o transformaciones más explicativas;
- documenta alertas, riesgos y recomendación de uso o exclusión.
