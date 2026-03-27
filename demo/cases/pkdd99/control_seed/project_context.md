# Contexto inicial del proyecto — PKDD’99 Financial Hackathon

## Nombre del caso
Temporal Relational Credit Challenge — PKDD’99

## Objetivo de negocio
Definir de forma gobernada un proyecto de scoring de préstamos respetando estrictamente la fecha de corte y la observabilidad temporal.

## Qué se quiere demostrar en la demo
Se quiere demostrar que:
- un problema temporal mal planteado puede dar resultados artificialmente buenos;
- Claude puede ayudar a estructurar el proyecto antes del código;
- la restricción temporal debe quedar fijada desde la primera iteración;
- el método es reusable para otros proyectos con transacciones e histórico.

## Qué datos de partida se asume que existen
- dataset relacional con préstamos, cuentas y transacciones;
- información de clientes y relaciones;
- posibilidad de extraer tablas o trabajar con dumps locales.

## Cómo se quiere usar el modelo
Como score al momento de originación del préstamo o como clasificación apoyada en información disponible hasta la fecha de concesión.

## Restricciones de la demo
- trabajar en castellano;
- no mezclar información posterior a la fecha del préstamo;
- no entrar en modelización en la primera iteración;
- convertir el problema temporal en backlog técnico y documental.
