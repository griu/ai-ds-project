# Diccionario resumido de tablas — Home Credit

## application_train / application_test
Tabla principal de solicitud actual.
Unidad esperada: una fila por solicitud actual.

## bureau
Historial de créditos del cliente en otras instituciones.
Valor potencial:
- endeudamiento histórico;
- comportamiento previo;
- exposición externa.

## bureau_balance
Histórico mensual asociado a créditos reportados en bureau.
Valor potencial:
- evolución temporal;
- severidad o regularidad de incidencias.

## previous_application
Solicitudes anteriores del mismo cliente.
Valor potencial:
- recurrencia;
- comportamiento en relaciones previas;
- patrón de aceptación o rechazo histórico.

## POS_CASH_balance
Snapshots mensuales de préstamos POS y cash previos.
Valor potencial:
- comportamiento de pago;
- evolución de saldo y retrasos.

## installments_payments
Pagos a plazos históricos.
Valor potencial:
- puntualidad;
- desviaciones respecto al calendario esperado;
- intensidad de pago.

## credit_card_balance
Balance mensual de tarjetas previas.
Valor potencial:
- utilización;
- tensión financiera;
- comportamiento revolvente.

## Nota metodológica
El objetivo de la demo no es fijar una ingeniería de features definitiva, sino crear un backlog gobernado para llegar a ella.
