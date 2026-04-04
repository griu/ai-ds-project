<!-- SPDX-License-Identifier: LGPL-3.0-or-later -->

# AUTOMATION_POLICY.md

## Propósito
Definir cómo debe avanzar el flujo de forma autónoma desde el chat de `control` en VS Code usando `workbench` como subagente, sin alterar la traza documental principal del proyecto.

## Principio general
El flujo puede continuar automáticamente mientras:
- la siguiente tarea forme parte del plan previsto;
- no haya replanificación;
- no haya reapertura de fases previas;
- no haya validación humana obligatoria;
- no haya bloqueo técnico;
- y no se alcance el límite de iteraciones automáticas.

## Papel de cada componente
### `control`
- gobierna el proyecto;
- redacta o limpia `control/next_task.md`;
- invoca a `workbench` como subagente cuando procede;
- revisa el resultado;
- actualiza `control/review_notes.md`;
- actualiza `control/WORKFLOW_STATE.md`;
- decide si continúa o se detiene.

### `workbench`
- ejecuta exactamente la tarea activa;
- no redefine el plan;
- actualiza `workbench/task_result.md`;
- actualiza `workbench/WORKBENCH_STATE.md`;
- informa si hay bloqueo, replanificación o validación humana obligatoria.

### `app`
- monitoriza estado y traza;
- ayuda a orientar al usuario;
- muestra prompts y artefactos;
- pero **no es el motor principal de ejecución** del bucle autónomo.

## Condiciones de continuación automática
`control` puede seguir invocando a `workbench` si:
- existe una tarea activa válida y limpia;
- la tarea siguiente es continuidad natural del plan;
- no aparece replanificación;
- no aparece reapertura de una fase previa;
- no hay contradicción metodológica relevante;
- `workbench` no reporta bloqueo;
- y el contador de iteraciones automáticas es menor que `10`.

## Condiciones de parada humana
El flujo debe detenerse si:
- aparece una decisión reservada a validación humana;
- falta información crítica;
- se detecta contradicción relevante;
- hay que redefinir una tarea previa;
- aparece una tarea nueva no prevista;
- se reabre una fase anterior;
- `workbench` reporta bloqueo;
- o se alcanza el límite de `10` iteraciones automáticas consecutivas.

## Decisiones típicamente reservadas a la persona
- definición final de la muestra;
- exclusión de casos;
- transformación del target continuo;
- aceptación de variables sensibles o proxy;
- aprobación final del modelo;
- aprobación final del YAML definitivo.

## Regla de limpieza documental
### `control/next_task.md`
Debe contener **solo** la tarea activa vigente.

### `workbench/task_result.md`
Debe contener **solo** el resultado de la tarea actual o de la última ejecución cerrada.

La trazabilidad histórica debe vivir en:
- Git;
- `history/`;
- o artefactos específicos,
pero no como acumulación desordenada dentro de esos dos archivos.

## Límite de seguridad
Máximo de `10` iteraciones automáticas consecutivas.
Al alcanzar el límite, `control` debe detener el flujo y pedir confirmación o ayuda humana aunque no haya errores aparentes.
