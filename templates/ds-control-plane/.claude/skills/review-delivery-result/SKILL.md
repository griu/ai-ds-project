---
name: review-delivery-result
description: Revisa el resultado devuelto por el repo de ejecución y detecta lagunas, riesgos o trabajo incompleto
---

# Cuándo usar esta skill
Úsala cuando el repo de ejecución haya actualizado `task_result.md`.

# Qué revisar
- si el objetivo inicial se ha cumplido
- si los outputs prometidos existen
- si hay incidencias sin resolver
- si la conectividad o dependencias técnicas han quedado definidas cuando eran necesarias
- si el siguiente paso depende de resolver primero algo pendiente

# Salida
Escribe `review_notes.md` con:
- resumen breve
- estado de cierre
- riesgos
- recomendación de siguiente paso
