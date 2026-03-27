# Paisaje de datos — PKDD’99

## Visión general
El caso combina:
- información de cuentas;
- información de clientes;
- relaciones entre clientes y cuentas;
- préstamos;
- órdenes;
- transacciones;
- metadatos territoriales.

## Idea de trabajo esperada
No se quiere una tabla plana inmediata.
Se espera que el equipo:
1. documente la granularidad de cada tabla;
2. identifique qué tabla define el target;
3. fije la fecha de corte;
4. decida qué agregaciones históricas son válidas;
5. documente qué señales quedarían prohibidas por ser posteriores al evento.

## Puntos de atención
- relaciones entre cuenta, cliente y préstamo;
- transacciones repetidas en el tiempo;
- riesgo de leakage extremo si se usan saldos o eventos posteriores;
- necesidad de backlog claro para preparar features temporales.
