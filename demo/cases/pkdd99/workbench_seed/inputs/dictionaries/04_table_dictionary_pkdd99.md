# Diccionario resumido de tablas — PKDD’99

## loan
Tabla objetivo del reto.
Contiene el préstamo y su estado.
Es la tabla crítica para definir target y fecha de corte.

## account
Cuenta asociada al cliente y al préstamo.
Puede actuar como eje de agregación para el histórico.

## client
Información de cliente.
Aporta atributos estáticos o semiestáticos.

## disp
Relación entre clientes y cuentas.
Es clave para entender la estructura relacional.

## trans
Transacciones históricas.
Es una de las tablas con más valor para features, pero también la más peligrosa si no se respeta el tiempo.

## order
Órdenes o pagos programados.
Puede aportar regularidad y comportamiento histórico.

## card
Información de tarjetas.
Puede aportar intensidad relacional o señales indirectas de uso.

## district
Metadatos territoriales o de contexto.
Puede aportar variables contextuales.

## Nota metodológica
La demo debe centrarse en cómo estructurar correctamente el proyecto temporal, no en exprimir todas las variables posibles.
