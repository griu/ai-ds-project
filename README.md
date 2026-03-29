# ai-ds-project

Repositorio maestro del framework de demo para proyectos de Data Science gobernados con VS Code + Claude.

## Qué contiene
- `templates/control/`: plantilla del área de gobierno del proyecto.
- `templates/workbench/`: plantilla del área de ejecución del proyecto.
- `demo/cases/<slug>/control/`: overlays del caso para `control/`.
- `demo/cases/<slug>/workbench/`: overlays del caso para `workbench/`.
- `demo/scripts/`: scripts para instanciar un proyecto nuevo y publicarlo.

## Modelo operativo
Este repo **no es** el proyecto activo del caso.

Este repo sirve como:
- plantilla viva del método;
- repositorio donde evolucionan prompts, skills, agentes y documentación base;
- fuente para crear nuevos proyectos instanciados.

## Qué se crea por cada caso
Cada caso se instancia como **un único repo nuevo fuera de este repo maestro**.

Ejemplo:
- repo maestro: `/home/griu/git/ai-ds-project`
- caso instanciado: `/home/griu/git/home-credit`

Dentro del caso instanciado quedan dos áreas de trabajo:
- `control/`
- `workbench/`

## Flujo resumido
1. Instancia el caso con `demo/scripts/create_case_instance.sh`.
2. Abre `control/` en una ventana de VS Code.
3. Abre `workbench/` en otra ventana de VS Code.
4. En `control/`, redacta `next_task.md`.
5. En `workbench/`, usa como fuente de verdad `../control/next_task.md`.
6. En `workbench/`, actualiza `task_result.md`.
7. En `control/`, revisa `../workbench/task_result.md`.

## Notas de entorno
- `pyproject.toml` es el formato preferido cuando haya que preparar dependencias.
- Cada área puede crear su `.venv/` local si lo necesita.
- La conectividad de datos se define como tarea explícita al inicio del proyecto.

## License

ai-ds-project is free software: you can redistribute it and/or modify it
under the terms of the GNU Lesser General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

ai-ds-project is distributed in the hope that it will be useful, but
WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public
License for more details.

You should have received a copy of the GNU Lesser General Public License
along with ai-ds-project. See [COPYING.LESSER](./COPYING.LESSER). The
project also includes [COPYING](./COPYING), the GNU General Public License
v3 referenced by LGPL-3.0.

## Files header

```python
# SPDX-License-Identifier: LGPL-3.0-or-later
```
