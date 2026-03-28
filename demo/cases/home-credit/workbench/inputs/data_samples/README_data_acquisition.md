# Data acquisition notes — Home Credit

## Objetivo
Esta carpeta debe alojar los ficheros de trabajo del caso una vez descargados del origen público correspondiente.

## Ficheros esperados
Como mínimo, el caso debería contemplar:
- `application_train.*`
- `application_test.*`
- `bureau.*`
- `bureau_balance.*`
- `previous_application.*`
- `POS_CASH_balance.*`
- `credit_card_balance.*`
- `installments_payments.*`

## Recomendación operativa
Para la demo no es obligatorio descargar todo al principio, pero sí debe quedar definido:
- qué tablas son obligatorias para una primera baseline;
- qué tablas se incorporarán en una segunda iteración;
- cómo validar que las claves de unión son correctas;
- cómo evitar joins explosivos.

## Recomendación de trabajo
Primero:
1. consolidar framing y paisaje de datos;
2. preparar conectividad / entorno;
3. validar lectura de tabla principal y una o dos tablas históricas;
4. luego escalar a un feature store analítico más rico.

## Resultado esperado
Cuando esta carpeta se use de verdad, el proyecto debería poder pasar de “inputs documentales” a “dataset materializado y listo para profiling / agregación”.
