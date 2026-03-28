# Business constraints — Home Credit

## Restricciones de negocio y gobierno del modelo

### 1. No leakage
Queda prohibido usar transformaciones o señales que dependan de información posterior al punto de decisión de la solicitud actual.

### 2. Explicabilidad mínima
Aunque se use un modelo fuerte como XGBoost, el equipo debe conservar:
- un baseline interpretable;
- lectura de drivers principales;
- visión de qué familias de variables aportan valor.

### 3. Calidad y robustez
No se aceptará una solución basada en:
- joins mal definidos;
- agregaciones opacas;
- tratamiento inconsistente de missing values;
- decisiones no documentadas.

### 4. Evaluación segmentada
El rendimiento no debe revisarse solo a nivel global. Debe analizarse, cuando sea posible, en subsegmentos como:
- tipo de ingreso;
- tipo de ocupación / relación laboral;
- tipo de vivienda o family status;
- profundidad de histórico disponible;
- grupos con alta missingness.

### 5. Reproducibilidad
La solución debe poder convertirse en un pipeline modular:
- dependencias declaradas;
- pasos de preparación claros;
- entrenamiento reproducible;
- scoring repetible.

### 6. Ambición técnica esperada
El jurado sí espera:
- EDA potente;
- feature engineering serio;
- benchmark fuerte;
- análisis de rendimiento por cohortes o subgrupos;
- una propuesta de productización.

No basta con “hacer un notebook y sacar un AUC”.
