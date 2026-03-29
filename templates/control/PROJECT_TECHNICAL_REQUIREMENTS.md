<!-- SPDX-License-Identifier: LGPL-3.0-or-later -->

# PROJECT_TECHNICAL_REQUIREMENTS.md

## Propósito
Este documento recoge los requisitos técnicos y funcionales que el framework debe respetar durante framing, definición de muestras, EDA, modelado, validación y preparación para productivización.

---

## 1. EDA obligatorio respecto al target

El flujo debe incluir análisis bivariantes entre variables explicativas y target para:
- explicativas continuas, binarias y categóricas;
- targets binarios, continuos y categóricos.

Cada bivariante debe mostrar, según aplique:
- volumen de casos por categoría o tramo;
- para variables continuas:
  - una aproximación tipo kernel density, o
  - particionado automático por quantiles;
- relación con el target:
  - propensión si el target es binario;
  - media si el target es continuo;
  - métrica equivalente si el target es categórico.

Si se usa discretización por quantiles, debe mostrarse la propensión o media por tramo.
Si se usa kernel density, debe incorporarse una aproximación no paramétrica rápida como LOESS o equivalente, priorizando la eficiencia computacional.

---

## 2. Uso preferente de ydata-profiling

Siempre que sea posible:
- usar `ydata-profiling` para la parte univariante;
- usar `ydata-profiling` también para la parte bivariante respecto al target si la librería lo soporta;
- complementar con gráficos específicos propios cuando el nivel de detalle requerido no quede cubierto.

---

## 3. Diagnóstico de monotonicidades

El flujo debe incorporar un diagnóstico de monotonicidades respecto al target.

Reglas:
- las variables binarias numéricas deben tratarse como continuas a estos efectos;
- el objetivo es proponer un patrón de monotonicidades válido para XGBoost;
- la justificación debe ser:
  - visual;
  - numérica;
  - y de negocio.

---

## 4. Validación humana si el target es continuo

Antes de entrenar modelos con target continuo, el sistema debe evaluar si conviene transformar el target:
- logaritmo;
- u otra función de enlace.

Esta decisión no debe automatizarse completamente.
El flujo debe detenerse y solicitar validación humana antes de continuar.

---

## 5. Validación inicial de monotonicidades

La selección de monotonicidades debe contrastarse comparando:
- modelos sin restricciones;
- modelos con monotonicidades.

El objetivo es validar empíricamente si la restricción aporta valor.

---

## 6. XGBoost

Si se usa XGBoost y se han definido monotonicidades:
- entrenar al menos un modelo sin monotonicidades;
- y otro con monotonicidades.

Comparar siempre en:
- train;
- validation;
- test.

### Binario
Si el target es binario:
- usar logloss como pérdida;
- mostrar gráficos de logloss por iteración para train y validation;
- usar early stopping con paciencia mínima de 20 iteraciones sin mejora;
- usar además un umbral razonable mínimo de mejora;
- reportar:
  - criterio de parada;
  - número final de iteraciones;
  - posibles sugerencias de mejora.

---

## 7. GPU

Siempre que sea posible y exista GPU NVIDIA o equivalente correctamente instalada:
- usar GPU en XGBoost;
- usar GPU en explicabilidad si aplica;
- usar GPU en otras fases costosas cuando aporte valor.

---

## 8. Selección inicial de variables

La selección inicial de variables puede apoyarse en métricas derivadas de modelos iniciales, especialmente XGBoost:
- gain;
- weight;
- frequency;
- u otras equivalentes.

---

## 9. Métricas mínimas

### Clasificación binaria
- AUC
- Gini = 2*AUC - 1

### Regresión
- RMSE
- R² cuando aplique
- MAE
- MAPE

Si el target fue transformado:
- reportar en escala transformada;
- y en escala original cuando sea reversible.

---

## 10. YAML de hiperparámetros

Debe existir una fase inicial con hiperparámetros razonables sugeridos automáticamente.

El usuario debe poder:
- modificar hiperparámetros vía YAML;
- iterar varias veces;
- validar o rechazar resultados;
- recibir sugerencias automáticas de mejora.

---

## 11. YAML o CSV de variables y monotonicidades

Debe existir:
- un YAML editable con variables finales y monotonicidades;
- y un YAML o CSV con todas las variables candidatas, incluyendo:
  - incluidas;
  - excluidas;
  - y motivo o estado.

---

## 12. Optuna

Para modelos con hiperparámetros relevantes:
- XGBoost;
- Random Forest;
- deep learning;

debe incorporarse Optuna.

Los rangos de búsqueda deben definirse en YAML, permitiendo:
- cambiar rangos;
- fijar valores;
- desactivar hiperparámetros.

Casos especiales:
- `learning_rate` puede ser un valor fijo o un esquema de iteración;
- puede fijarse opcionalmente el máximo de iteraciones;
- puede activarse o desactivarse monotonicidad;
- evitar postcalibración que altere medias o propensiones de forma indeseada.

---

## 13. Validación humana de modelos

Los modelos seleccionados en cada etapa deben ser validados por el usuario antes de considerarse definitivos.

La versión final debe quedar fijada en un YAML final con:
- hiperparámetros;
- variables;
- monotonicidades;
- y configuración necesaria para validación o productivización.

---

## 14. Particionado y validación

Patrón preferente:
- train
- validation
- test

El sistema debe sugerir proporciones razonables y contrastarlas con el usuario.

Solo justificar cross-validation de forma excepcional.
Siempre que sea posible:
- reservar una muestra out-of-time para análisis final.

---

## 15. Explicabilidad

Incorporar al menos:
- PDP
- SHAP

### PDP
Debe representarse de forma comparable a los bivariantes del EDA, mostrando efecto marginal.

### SHAP
Debe incluir:
- importancia global;
- análisis bivariante del efecto medio SHAP por variable;
- comparación visual con los bivariantes del EDA.

En todos los casos:
- vigilar tiempos de ejecución;
- aprovechar GPU cuando sea posible.

---

## 16. Reutilización

Cuando sea posible:
- reutilizar skills;
- plantillas;
- módulos;
- y componentes existentes.

El objetivo es acelerar desarrollo, estandarizar y mejorar mantenibilidad.

---

# Requisitos de aceptación de variables para los modelos

## 17. Criterio causal o explicativo mínimo

Las variables incorporadas al modelo deben estar razonadas desde:
- una lógica de causa-efecto; o
- como mínimo, una relación explicativa coherente con el fenómeno que se desea modelizar.

## 18. Alertas por variables con alta relación pero baja interpretabilidad

Si se detectan variables con alta relación estadística con el target pero sin interpretación razonable de negocio, debe levantarse una alerta explícita y comunicarse de forma clara al usuario.

Ejemplo típico:
- usar código postal bruto puede capturar riesgo, pero normalmente como proxy indirecto;
- deben priorizarse variables más causales, como renta o ingresos medios del área, cuando estén disponibles.

## 19. Fairness, sesgo y regulación

Deben levantarse alertas ante variables que puedan presentar problemas de fairness, sesgo o incumplimiento regulatorio conforme a la normativa europea aplicable, incluyendo RGPD y AI Act.

Reglas:
- variables como género, religión, estado de salud u otras categorías especialmente protegidas no deben utilizarse sin revisión explícita;
- si se detectan variables proxy de atributos protegidos, también debe advertirse;
- estas alertas no implican bloqueo automático en todos los casos, pero sí revisión obligatoria y validación explícita antes de su uso.

## 20. Sesgos en signo o monotonicidad

Deben identificarse posibles sesgos en el signo o en la monotonicidad de las variables, tanto en continuas como en discretas, especialmente cuando el comportamiento observado contradiga la lógica de negocio o pueda inducir decisiones injustas.

Reglas:
- si una variable tiene un patrón empírico aparentemente favorable pero poco causal, debe advertirse;
- deben priorizarse transformaciones más causales, como ratios o variables de intensidad normalizadas;
- las monotonicidades podrán forzarse por criterio de negocio, aunque el bivariante no muestre el patrón de forma clara;
- si una variable presenta una señal incoherente por sesgo muestral, definición o selección, debe excluirse o revisarse con validación explícita.

## 21. Tratamiento de Missing

Debe validarse el comportamiento de la categoría Missing o de ausencia de información.

Reglas:
- comprobar que la propensión media o valor medio del target asociado a missing sea razonable;
- evitar incentivos indeseados donde la ausencia de datos favorezca artificialmente decisiones de aceptación o reduzca riesgo de forma sistemática frente a la media.

## 22. Criterio general de inclusión final

Las variables introducidas en el modelo deben tener un sentido causal o explicativo validado, tanto a nivel de:
- presencia o ausencia en el modelo;
- definición de categorías;
- tratamiento de missing;
- signo o monotonicidad esperada.

## 23. Variables no monótonas

Puede permitirse la entrada de variables con comportamiento no estrictamente monótono si existe:
- justificación analítica suficiente; o
- justificación de negocio suficiente;

y si dicha variabilidad se considera aceptable.

---

# Requisitos sobre preparación y definición de muestras

## 24. Consenso previo para eliminar casos

Cualquier decisión de eliminar casos de la muestra deberá:
- estar previamente justificada mediante una razón analítica o de negocio;
- y ser consensuada con el usuario antes de ejecutarse.

## 25. Fase separada de definición de muestras

Entre data quality, EDA y modelado debe existir una etapa específica y explícita de definición de muestras.

Esta etapa debe documentar con precisión:
- cómo se construye la base analítica;
- qué población inicial se toma;
- qué filtros se aplican;
- qué exclusiones se realizan;
- y con qué justificación.

## 26. Unidad de análisis

Debe definirse explícitamente cuál es la unidad de análisis representada por cada fila:
- persona;
- persona-mes;
- operación;
- contrato;
- cliente-producto-mes;
- u otra equivalente.

Cuando sea necesario, esta fase puede requerir agregaciones o `groupby` con:
- sumas;
- medias;
- máximos;
- mínimos;
- contadores;
- u otros agregados coherentes.

## 27. Ventana temporal de observación

Debe definirse con precisión la ventana temporal sobre la que se construyen las variables explicativas.

Ejemplos:
- un año de operaciones;
- una cartera viva en un mes;
- un histórico de comportamiento de los últimos N meses.

Debe ser coherente con el momento real en que el modelo se pretende aplicar.

## 28. Definición de la variable objetivo

Debe definirse explícitamente la variable objetivo, incluyendo:
- significado de negocio;
- ventana futura de observación;
- condición inicial desde la que se mide.

## 29. Filtros de selección de filas

Deben definirse y documentarse todos los filtros de selección de registros.

Cualquier filtro deberá estar justificado desde el punto de vista analítico y de negocio.

## 30. Selección de variables en la muestra

Debe realizarse una selección inicial de variables basada en:
- sentido analítico;
- disponibilidad en el momento futuro de uso;
- consistencia operativa;
- viabilidad de despliegue.

No deben incluirse variables no disponibles en el momento real de uso en producción.

---

# Tipología de problemas de negocio y su impacto en la muestra

## 31. Problemas de originación

En problemas de originación:
- el análisis se sitúa en el momento previo a una contratación, alta o decisión inicial;
- suele haber información limitada;
- predominan variables externas o declarativas;
- normalmente cada cliente u objeto se observa una sola vez.

La muestra debe construirse solo con variables disponibles en ese instante previo.

## 32. Problemas comportamentales

En problemas comportamentales:
- existe observación periódica del objeto;
- las variables se definen respecto a objeto + momento de observación;
- el target se construye a partir de una ventana futura;
- solo deben utilizarse momentos de observación para los que el target futuro sea completamente observable.

Deben recogerse:
- características del objeto en el momento de observación;
- y/o comportamiento histórico previo.

## 33. Repeticiones por individuo u objeto

Si un mismo individuo u objeto aparece repetido en varios periodos, debe evaluarse el sesgo introducido.

Se podrá considerar:
- limitar observaciones;
- ponderar la muestra;
- o metodologías específicas para datos longitudinales o con efectos aleatorios.

## 34. Múltiples definiciones de target

El sistema debe permitir trabajar con distintas definiciones de target:
- impago a 3, 6, 12 o 24 meses;
- abandono a 1 año;
- contratación en próximos N meses;
- fraude en una ventana;
- etc.

Siempre que queden claramente documentadas y alineadas con el caso de uso.

---

# Requisitos adicionales de trazabilidad de muestra

## 35. Trazabilidad clara de la base analítica

La fase de definición de muestras debe dejar trazabilidad clara de:
- población inicial;
- filtros aplicados;
- exclusiones realizadas;
- justificación de cada criterio;
- tamaño final de cada muestra.

## 36. Validación humana obligatoria

Toda decisión relevante sobre:
- exclusión de casos;
- definición de unidad de análisis;
- ventana temporal;
- target;
- criterios de selección;

deberá ser validada con el usuario antes de consolidarse como diseño final.
