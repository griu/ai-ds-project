# Restricciones de negocio — Home Credit

## Restricciones clave
- La solución debe ser explicable a negocio.
- Debe ser reusable para futuros proyectos de crédito retail.
- El resultado de la demo debe servir para debatir el diseño del proyecto, no solo el rendimiento del modelo.
- El sponsor quiere dejar documentadas las decisiones y dudas desde el principio.

## Hipótesis operativas para la demo
- El scoring podría usarse en un flujo batch diario o por lotes recurrentes.
- El score no sustituye de forma automática la decisión final humana.
- El equipo quiere poder comparar baseline clásico y XGBoost en fases posteriores.

## Riesgos percibidos por el sponsor
- leakage temporal por variables mal agregadas;
- documentación insuficiente del problema;
- dependencia de notebooks poco mantenibles;
- falta de trazabilidad desde el framing hasta el pipeline.
