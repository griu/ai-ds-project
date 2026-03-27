# Restricciones de negocio — PKDD’99

## Restricciones clave
- El score debe apoyarse solo en información observable hasta la fecha de originación.
- La documentación debe dejar muy claro qué está permitido y qué no.
- El objetivo de la demo es la calidad del planteamiento, no el mejor accuracy aparente.

## Hipótesis operativas para la demo
- El dataset se usará como caso de entrenamiento metodológico.
- Se podrán comparar un baseline clásico y un modelo boosting en fases posteriores.
- El interés principal es documentar un pipeline temporal correcto.

## Riesgos percibidos por el sponsor
- usar sin darse cuenta transacciones futuras;
- confundir préstamo, cuenta y cliente como unidad de modelización;
- generar features irreproducibles;
- presentar resultados engañosos por mala definición temporal.
