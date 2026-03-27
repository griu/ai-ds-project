# Paisaje de datos — Home Credit

## Visión general
El caso combina:
- una tabla principal de solicitud actual;
- tablas relacionales de histórico;
- varias fuentes que exigen agregaciones por cliente o por solicitud previa.

## Idea de trabajo esperada
No se quiere una unión plana inmediata de todas las tablas.
Se espera que el equipo:
1. documente cada tabla;
2. entienda granularidad y claves;
3. decida qué agregaciones tienen sentido;
4. identifique variables con alto riesgo de leakage;
5. proponga una estrategia de construcción de features reproducible.

## Puntos de atención
- relaciones uno-a-muchos;
- tablas mensuales o repetidas en el tiempo;
- distinta calidad de señal entre fuentes;
- posibilidad de explosión de dimensionalidad si se agregan mal las tablas.
