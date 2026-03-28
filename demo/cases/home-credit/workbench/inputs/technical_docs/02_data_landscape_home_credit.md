# Data landscape — Home Credit

## Estructura general
El dataset tiene una tabla principal de aplicaciones actuales y varias tablas históricas con granularidad uno-a-muchos. El reto técnico clave es convertir históricos transaccionales o mensuales en features agregadas útiles a nivel de solicitud actual.

## Tabla principal
### `application_train`
- granularidad: una fila por solicitud / observación principal de entrenamiento
- clave principal: `SK_ID_CURR`
- contiene `TARGET`
- mezcla variables numéricas, categóricas y señales de comportamiento / contexto

### `application_test`
- misma granularidad y estructura similar
- no contiene `TARGET`

## Tablas históricas relevantes

### `bureau`
- historial del cliente en otras entidades
- granularidad: múltiples registros por `SK_ID_CURR`
- clave adicional: `SK_ID_BUREAU`

### `bureau_balance`
- historial mensual asociado a `bureau`
- granularidad: múltiples registros por `SK_ID_BUREAU`
- requiere agregación temporal y luego agregación a nivel cliente

### `previous_application`
- solicitudes previas del propio cliente
- granularidad: múltiples registros por `SK_ID_CURR`
- clave adicional: `SK_ID_PREV`

### `POS_CASH_balance`
- estado mensual de productos POS / cash
- granularidad: múltiples registros por `SK_ID_PREV`

### `credit_card_balance`
- estado mensual de tarjetas
- granularidad: múltiples registros por `SK_ID_PREV`

### `installments_payments`
- pagos a plazos
- granularidad: múltiples registros por `SK_ID_PREV`

## Join keys principales
- `SK_ID_CURR`: une aplicación actual con históricos del cliente
- `SK_ID_BUREAU`: une `bureau` con `bureau_balance`
- `SK_ID_PREV`: une `previous_application` con tablas de producto / pagos

## Riesgos técnicos esperables
- explosión de filas por joins incorrectos;
- agregaciones no reproducibles;
- leakage temporal si se usan mal estados históricos;
- missingness masivo y heterogéneo;
- columnas con semántica especial;
- señales codificadas como días relativos;
- categorías con cardinalidad moderada / alta.

## Hallazgos que se esperan en la EDA
La EDA debería investigar al menos:
- missingness y su posible valor predictivo;
- outliers y rangos anómalos;
- columnas centinela / codificaciones especiales;
- profundidad y cobertura del histórico por cliente;
- diferencia entre “sin histórico” y “histórico con comportamiento limpio”;
- dispersión por tipo de fuente.

## Implicación para modelado
No es un caso de tabla única. La calidad del feature engineering será una de las claves principales del rendimiento final.
