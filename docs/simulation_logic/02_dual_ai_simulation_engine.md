# Lógica del Motor Dual de Simulación por IA (Predictor vs Realidad)

Esta documentación explica por qué Solveria no utiliza un algoritmo tradicional determinista de simulación, y cómo implementa modelos avanzados de Inteligencia Artificial (impulsados por **DeepSeek**) para resolver el problema fundamental del sesgo predictivo.

## 1. El Problema de Simular la Realidad
Si un usuario o un Agente Estratégico decide tomar una acción (ej. Lanzar el Producto A con precio de $10 USD), y la misma red neuronal que genera el plan de negocios evalúa el *resultado* de ese plan, la IA sufrirá el "Sesgo de Confirmación del Creador": Asumirá que como su plan es bueno, las ventas necesariamente serán un éxito.

Esto destruye el rigor y aleatoriedad del mercado real.

## 2. Solución: Arquitectura de IA "Dual-Model"
El motor de simulación consta de dos "cerebros" o instancias de LLM (empleando DeepSeek) que están obligados a ser adversarios conceptuales.

### A. El Modelo Predictor (El Bando Corporativo)
- **Rol:** Son los Agentes Internos (Mercado, Finanzas).
- **Acceso a Datos:** Tienen acceso a la base de datos empresarial de la startup, al estado de cuentas (MongoDB) y a sus propios estudios de mercado.
- **Función:** Generar planes, analizar la factibilidad de acciones, y sugerir al usuario el camino óptimo. Ellos "Creen" que saben lo que pasará, pero no controlan el entorno.

### B. El Modelo de Realidad (El Mercado/Entorno)
- **Rol:** Orquestador Ambiental Adverso.
- **Acceso a Datos:** Tiene acceso a la base de datos Vectorial (RAG) con noticias actuales masivas del sector, crisis macroeconómicas, la agresión de la competencia y el sentimiento del consumidor.
- **Función:** Recibir la "acción planeada" por el bando corporativo, contrastarla contra el caos del mercado y calcular el **Resultado Verdadero**.

## 3. El Flujo a través de la Vector DB
Para que la IA no improvise ni alucine resultados locos, fundamenta sus decisiones de impacto consultando datos casi en tiempo real a través del Retrieval-Augmented Generation (RAG).

1. **Acción inyectada al Modelo de Realidad:** *"Startup X lanza App Financiera dirigida a universitarios en México, con presupuesto de $50k USD en TikTok"*.
2. **Consulta Vectorial (Similarity Search):** El Modelo de Realidad consulta en la base de datos vectorial el costo de adquisición de clientes (CAC) actual en el mercado Fintech Mexicano, la saturación del canal TikTok y movimientos de competidores grandes (ej. NuBank).
3. **Inferencia (DeepSeek Engine):** El Modelo de Realidad procesa la consulta RAG y concluye: *"El presupuesto de $50k USD es insuficiente contra el ruido mediático actual del competidor Y. El CAC se asume un 40% más alto de lo planeado"*.
4. **Resolución y Escritura:** El Modelo de Realidad dictamina que la campaña consiguió 8,000 usuarios (no los 20,000 previstos por el Predictor), y escribe este "resultado real" en MongoDB.

## 4. Aleatoriedad Orgánica (Randomness)
El modelo de realidad inyecta aleatoriedad jugando con la parametrización del LLM (Ej. ajustando la función de *Temperature*) y mediante Eventos Cisne Negro recuperados de la Base de Datos Vectorial, imitando cómo el mundo real golpea a las empresas con eventos inesperados independientemente de lo buena que parezca ser una estrategia corporativa.
