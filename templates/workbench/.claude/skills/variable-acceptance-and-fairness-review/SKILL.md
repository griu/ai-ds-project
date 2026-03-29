---
name: variable-acceptance-and-fairness-review
description: Revisa variables por causalidad, negocio, fairness, proxies, missing y coherencia de signo o monotonicidad
---

Emite alertas y recomendaciones sobre:
- interpretabilidad de negocio;
- sentido causal o explicativo mínimo;
- fairness, sesgo y regulación;
- proxies de atributos protegidos;
- coherencia de signo o monotonicidad;
- comportamiento de Missing.

Reglas adicionales:
- las variables especialmente protegidas o prohibidas, como género, religión o estado de salud, no deben entrar en ningún caso al modelo;
- identifica explícitamente variables numéricas de naturaleza categórica;
- deja resuelta en esta fase la decisión de qué variables deben tratarse como categóricas en modelado.
