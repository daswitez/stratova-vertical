# Estrategia de Bases de Datos y Segregación de Datos

Dado que la plataforma **Solveria SSSP** se desplegará en AWS utilizando contenedores administrados para todos los servicios incluyendo las bases de datos (evitando servicios gestionados tipo SaaS como MongoDB Atlas por temas de costos/control inicial), la estrategia de partición de datos (Data Segregation) es crítica para el rendimiento de la simulación dual con Inteligencia Artificial.

Contamos con tres motores de base de datos principales, cada uno contenerizado vía Docker (`docker-compose`) localmente y orquestado de manera aislada en despliegue:

## 1. PostgreSQL (Relacional Estricto)

**Caso de Uso:** Identidad, Configuración Global y Facturación.
- **Microservicio Dueño:** `iam-service` (Identity & Access Management).
- **Características:** Transacciones ACID, alta consistencia, bloqueos a nivel de fila y relaciones rígidas.
- **Tipos de Datos a Almacenar:**
  - Tablas transaccionales puras: `users`, `roles`, `permissions`, `tenants`.
  - Asignaciones Multi-Tenant: El mapeo estricto que dicta a qué organización o universidad pertenece un individuo, y qué simulaciones puede ver o afectar.
  - Planes de suscripción y límites de uso (Rate limits, token quotas para la IA).
- **Por qué NO usar Mongo/Redis aquí:** La seguridad de accesos y la integridad referencial no pueden estar sujetas a inconsistencia temporal (Eventual Consistency) ni a esquemas dinámicos.

## 2. MongoDB (Estado del Mundo / Documental)

**Caso de Uso:** Memoria Asíncrona, Event Bus Persistente y Estado de la Empresa.
- **Microservicio Dueño:** `ai-service` (AI Agents & Predictor) y `simulation-service`.
- **Características:** Esquema flexible (JSON/BSON), alta velocidad de ingesta, soporte nativo de *Change Streams* (para despertar agentes aislados).
- **Tipos de Datos a Almacenar:**
  - **Estado Central (State):** Colecciones con "fotografías" del negocio simulado (`balance_sheets`, `marketing_budgets`, `supply_chain_logs`). 
  - **Historial de Decisiones (Eventos):** Cada decisión tomada por el humano o sugerida por el Agente Predictivo se guarda como un "Documento de Decisión" en crudo.
  - **Plantillas Generadas:** Metadatos de los reportes de `.xlsx` generados por el Agente Financiero.
- **Por qué NO usar Postgres aquí:** Un Balance Sheet (Estado Financiero) generado por IA o mutado por una Campaña de Marketing no tiene columnas predecibles al 100%. Obligar a este modelo a caber en tablas relacionales frenaría la flexibilidad del comportamiento asíncrono y los diferentes dominios que manejan los agentes.

## 3. PostgreSQL + PgVector (Vectorial / Semántica)

**Caso de Uso:** Motor RAG (Retrieval-Augmented Generation) Contextual.
- **Microservicio Dueño:** `simulation-service` (Reality Engine).
- **Características:** Base Postgres 16 con extensión especializada para indexar y buscar matrices numéricas hiperbólicas (Embeddings).
- **Tipos de Datos a Almacenar:**
  - **Contexto de Mercado "Real":** Noticias sobre competidores convertidas en Embeddings de 1536 dimensiones.
  - **Normativas y Reglas:** Corpus de texto legal que el "Agente Legal" o el Motor de Realidad consulta velozmente para saber si una acción de Spin-off incumple una ley.
  - **Casos de Estudio Históricos:** Situaciones de éxito de la vida real (ej. "Lanzamiento del iPhone") que el modelo compara usando distancia de conseno para emular probabilísticamente impactos similares.

## 4. Redis (Caché Volátil y Lock Distribuido)

**Caso de Uso:** Alta Velocidad, Short-Term Memory, Rate Limiting y Locks.
- **Microservicio Dueño:** Utilizado transversalmente por la `core-platform`. Principalmente impacta al `API Gateway` y al `ai-service`.
- **Características:** In-memory, Key-Value y colas ultrarrápidas con TTL (Time-to-Live).
- **Tipos de Datos a Almacenar:**
  - **Short-Term Context Window:** Ocultar prompts redundantes. Si el usuario hace dos preguntas de IA en la misma ventana de chat en 5 segundos, la memoria a corto plazo del contexto del chat vive en Redis, no en Mongo que es memoria a largo plazo (episódica).
  - **Caché de Autenticación (JWT Blacklist):** Para invalidar tokens prematuramente.
  - **Distributed Locks (Mutex):** En un diseño multi-agente, si Marketing y Finanzas por alguna razón intentan mutar un dato crítico simultáneamente, Redis gestiona el Lock para evitar condiciones de carrera antes de escribir a Mongo.
  - **Rate Limiting:** Contadores rápidos de peticiones HTTP para mitigar abusos de las APIs costosas de la IA.

---

## Flujo de Escritura Típico (Data Flow por Capas)

1. El usuario hace login. Se lee su jerarquía validada en **PostgreSQL (IAM)**.
2. Inicia sesión en la UI y envía mensajes chat a la IA. Estos mensajes recientes viven 30 minutos en **Redis (Memoria Corta)**.
3. El Agente de IA toma una decisión corporativa. El JSON de la estrategia se inyecta permanentemente en **MongoDB (Estado Central)**.
4. El Change Stream de MongoDB despierta al *Motor de Realidad*.
5. El Motor de Realidad consulta **PgVector (Vector DB)** para ver condiciones de mercado recientes, asesta su respuesta y devuelve un Score.
6. La "salud" post-evaluación se re-escribe en **MongoDB** como el nuevo Balance, esperando el próximo ciclo.
