# Orquestación de Contenedores y Bases de Datos (Docker)

Esta sección documenta la infraestructura de contenedores que soporta los motores de bases de datos para los diferentes microservicios de **Solveria SSSP**. Utilizamos Docker Compose para aislar y orquestar estas dependencias de infraestructura localmente y en entornos de despliegue.

## 1. Estrategia de Contenerización
La plataforma Solveria sigue un principio de **Database-per-Service** (Base de Datos por Servicio) para garantizar el bajo acoplamiento y el aislamiento de fallos. Sin embargo, para no sobrecargar el entorno, se consolida la ejecución de los contenedores usando `docker-compose.yml` aislados por repositorio.

No se contenerizan directamente las aplicaciones Java (Spring Boot) durante la fase de desarrollo activo. Únicamente se contenerizan las piezas de infraestructura de datos (Bases de datos relacionales, documentales y vectoriales), permitiendo que el desarrollador levante el microservicio localmente (puertos 8080, 8091) conectándose a la BD en Docker.

## 2. Bases de Datos por Servicio

### A. IAM Service (Identity Data)
- **Tipo:** Relacional
- **Motor:** PostgreSQL (Versión 16)
- **Uso:** Almacena el modelo de dominio duro: Usuarios, Roles, Permisos, Grupos y Jerarquías de Tenants.
- **Por qué Postgres:** Necesitamos transacciones ACID estrictas, integridad referencial sólida y bloqueos a nivel de fila para garantizar que la asignación de permisos no sufra condiciones de carrera (Race conditions).

### B. AI Service / Predictor & Simulation Engine
- **Tipo:** Vectorial + Documental (Estado Compartido)
- **Motor Primario (Vectorial):** `pgvector/pgvector:pg16` (PostgreSQL 16 con extensión pgvector).
  - **Uso:** Almacenar los embeddings generados a partir de contexto de mercado, normativas legales, noticias macroeconómicas o historiales asíncronos. Permite realizar Búsqueda Semántica (RAG - *Similarity Search*) para alimentar a DeepSeek.
  - **Archivos:** Configurado actualmente en `~/Downloads/ProyectoAI/ai-service/docker-compose.yml`.
  - **Por qué PgVector:** La adopción de Spring AI facilita enormemente la integración con Postgres cuando este tiene el plugin `vector` activado. Evita añadir otra base de datos de nicho como ChromaDB o Milvus en fases tempranas.
- **Motor Secundario (Estado Event-Driven):** MongoDB (Contenedor Local de Docker)
  - **Uso:** Base de datos documental central. Almacena en JSON el estado actual de la empresa simulada (Presupuestos, Flujos de Caja, Decisiones en crudo).
  - **Por qué Mongo:** El concepto de esquemas flexibles es ideal porque el agente financiero arrojará JSONs con una estructura distinta al agente de marketing. Además, las capacidades de *Change Streams* son perfectas para el Event Bus asíncrono.

### C. Core Platform & API Gateway (Caché y Locks)
- **Tipo:** In-Memory Key-Value Store
- **Motor:** Redis (Contenedor Local de Docker)
- **Uso:** Almacena la memoria a corto plazo de conversaciones (Short-Term Context Window), validación rápida de tokens bloqueados (Blacklist), control de transacciones multi-agente vía Distributed Locks, y Rate Limiting para las APIs LLM.

## 3. Comandos de Orquestación Docker (Dev Workflow)

El repositorio incluye automatizaciones base (en `~/Downloads/ProyectoAI/scripts_linux/`) para gestionar los contenedores de forma fluida:

- **Levantar Infraestructura:**
  Los contenedores (como el PgVector de `ai-service`) se levantan automáticamente usando scripts provistos:
  ```bash
  # Ejemplo: Levantar las bases de datos requeridas para el motor de Inteligencia Artificial
  cd ai-service
  docker-compose up -d
  # O utilizar el script dedicado: ./scripts_linux/dev-up.sh
  ```

- **Limpieza y Destrucción:**
  ```bash
  # Bajar los contenedores
  docker-compose down
  # O usar: ./scripts_linux/dev-down.sh
  ```

### Detalles Técnicos del Contenedor de IA (PgVector)
Revisando el actual `docker-compose.yml` del `ai-service`:
- **Imagen:** `pgvector/pgvector:pg16`
- **Volumen Persistente:** Se monta un volumen `ai_service_pgdata` mapeado a `/var/lib/postgresql/data` para garantizar que los embeddings vectorizados no se pierdan al reiniciar el contenedor.
- **Aislamiento de Puertos:** Utiliza variables de entorno (alojadas en archivos `.env`) para el mapeo, evitando conflictos. Frecuentemente se mapea el puerto local `5434` al `5432` del contenedor para no colisionar con una instancia local de PostgreSQL del desarrollador o del `iam-service`.

## 4. Evolución hacia Producción en AWS
En un futuro entorno de Staging o Producción en AWS:
1. Las bases de datos migrarán hacia orquestación gestionada en AWS (Ej. AWS RDS para Postgres, Amazon DocumentDB/Mongo sobre EC2, y Amazon ElastiCache para Redis). Todo permanecerá dentro de la misma VPC.
2. Los artefactos Java `.jar` de los microservicios se empaquetarán en imágenes Docker (vía Dockerfiles o Spring Boot Buildpacks).
3. Todo el enjambre se gestionará mediante **Kubernetes (EKS)** o ECS para auto-escalar los Webhook Listeners del Motor de Realidad y del Event Bus.
