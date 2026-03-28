# Table dictionary — Home Credit (working version)

## Tabla principal
### application_train
- clave principal: `SK_ID_CURR`
- target: `TARGET`
- observación: solicitud principal / cliente en el dataset de entrenamiento

## Variables/familias relevantes en tabla principal
- demográficas y familiares
- empleo e ingresos
- vivienda y patrimonio
- exposición crediticia declarada
- comportamiento previo resumido
- señales externas tipo `EXT_SOURCE_*`
- días relativos (`DAYS_*`)

## Tablas auxiliares y claves

### bureau
- clave propia: `SK_ID_BUREAU`
- clave de cliente: `SK_ID_CURR`
- aporta histórico en otras entidades

### bureau_balance
- clave de histórico externo: `SK_ID_BUREAU`
- granularidad mensual
- necesita agregación previa a un nivel compatible con `bureau`

### previous_application
- clave propia: `SK_ID_PREV`
- clave de cliente: `SK_ID_CURR`
- solicitudes previas del cliente

### POS_CASH_balance
- clave: `SK_ID_PREV`
- granularidad mensual

### credit_card_balance
- clave: `SK_ID_PREV`
- granularidad mensual

### installments_payments
- clave: `SK_ID_PREV`
- granularidad de pago / cuota

## Puntos de atención del diccionario
- varias tablas son uno-a-muchos y no deben unirse sin agregación;
- algunas columnas pueden contener valores especiales o sentinelas;
- los campos de días relativos deben interpretarse con cuidado;
- la ausencia de histórico puede ser señal en sí misma;
- conviene separar claramente features:
  - snapshot de solicitud actual
  - históricas agregadas
  - ratios / recencias / counts
  - flags de ausencia / cobertura de histórico

## Variable objetivo confirmada
- `TARGET`

## Métrica principal confirmada para el ejercicio
- ROC AUC
