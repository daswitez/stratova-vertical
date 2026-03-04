# EPIC-05: Motor de Simulación (Modelos Duales IA - Predictor vs Realidad)

**Objetivo:** Desarrollar el núcleo de simulación utilizando Inteligencia Artificial (DeepSeek) respaldado por bases de datos vectoriales, reemplazando los sistemas puramente estadísticos/deterministas.

## Nuevo Paradigma: Simulación por Inteligencia Artificial (Dual Model)
En lugar de depender exclusivamente de algoritmos matemáticos en código duro, la simulación se ejecuta mediante inferencia LLM nutrida con RAG (Retrieval-Augmented Generation) sobre bases de datos vectoriales.
Se requiere un sistema "Dual":
1. **Modelo Predictor (Agentes de la Empresa):** Intentan predecir qué pasará si toman una decisión (ej. Lanzar un producto).
2. **Modelo de Realidad (Entorno/Mercado):** Otro modelo de IA asilado, que conoce la decisión tomada y usa datos actuales/relevantes de la Vector BD para "simular el resultado real", manteniendo la aleatoriedad y simulando el mercado real (el cual no siempre obedece a la predicción interna).

## Tareas (User Stories / Tasks)

- [ ] **SIM-01: Integración con LLM Base para Simulación (DeepSeek)**
  - Configurar los nodos de generación y simulación conectando directamente al modelo DeepSeek.
- [ ] **SIM-02: Base de Datos Vectorial de Contexto de Mercado**
  - Poblar la Vector DB con normativas, datos actuales de competidores, escenarios históricos y tendencias para que los modelos fundamenten sus simulaciones en datos reales y actuales.
- [ ] **SIM-03: Desarrollo del "Modelo Predictor" (Interno)**
  - Diseñar los *System Prompts* para que la IA simule el impacto financiero/operativo esperado *antes* de confirmar una decisión. Su objetivo es asesorar al usuario o a otros agentes.
- [ ] **SIM-04: Desarrollo del "Modelo de Realidad" (El Entorno)**
  - Diseñar una IA aislada del "Predictor". Esta IA actúa como el *Mercado*. Toma la acción del usuario, accede a la misma base de datos, pero inyecta entropía, reacciones de la competencia o variables externas para calcular el *resultado verdadero* de la acción en la simulación.
- [ ] **SIM-05: Consolidación de Resultados en Base de Datos (Mongo)**
  - El Modelo de Realidad inyecta los nuevos KPIs (ej. Ventas conseguidas reales, costos incurridos reales) de vuelta en la base de datos documental (MongoDB) para que los Agentes Aislados asimilen el impacto.
- [ ] **SIM-06: Motor Generador de "Eventos Aleatorios" (Prompt Injections)**
  - Alimentar al Modelo de Realidad periódicamente con eventos exógenos documentados en la Vector DB (ej. "Crisis de suministros detectada en noticias") para alterar el flujo de la simulación de forma orgánica, no pre-programada.
