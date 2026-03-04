# EPIC-03: AI Service (Base Artificial Intelligence)

**Objetivo:** Crear el servicio central y fundacional que interactúa con los modelos de lenguaje (LLMs) y la base de datos de conocimiento (Vector DB), exponiendo capacidades cognitivas a los agentes de negocio.

## Tareas (User Stories / Tasks)

- [ ] **AI-01: Integración Base con LLM (Ej. OpenAI)**
  - Configurar conectores base usando Spring AI.
  - Implementar lógica de fallback e inyección segura del `API_KEY`.
- [ ] **AI-02: Configuración de Base de Datos Vectorial (PgVector)**
  - Configurar infraestructura local en Docker para almacenamiento de embeddings.
  - Desarrollar servicios de carga de documentos (ETL básico) y chunking semántico.
- [ ] **AI-03: Implementación de Retrieval-Augmented Generation (RAG)**
  - Crear motor de búsqueda de similitud sobre la Vector DB conectada al generador LLM.
  - Funcionalidad para inyectar "Datos Reales Actualizados" como contexto del RAG.
- [ ] **AI-04: Gestión de Memoria de Contexto (MongoDB y Redis)**
  - Utilizar Redis para la memoria a corto plazo (Short-Term Context Window) de las conversaciones activas.
  - Utilizar MongoDB para almacenar el historial de decisiones permanente y el estado central por Simulación/Usuario.
- [ ] **AI-05: Streaming de Respuestas**
  - Implementar Server-Sent Events (SSE) o WebSockets para emitir respuestas de los agentes en tiempo real hacia el front-end a medida que el LLM genera la inferencia.
- [ ] **AI-06: Control de Costos y Rate Limiting de IA**
  - Contabilizar el uso de tokens por Tenant / Organización para facturación.
  - Límites de uso de prompts por tipo de usuario (Estudiante vs Cliente Enterprise).
- [ ] **AI-07: Interfaz Limpia (Clean Architecture)**
  - Asegurar que la capa `Domain/Application` desconozca completamente qué LLM (OpenAI vs Anthropic) o qué Vector Store (PgVector vs Chroma) se está utilizando (Hexagonal Ports & Adapters).
