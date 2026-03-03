# 🚀 Stratova AI — Guía Completa de Instalación y Ejecución

Esta guía documenta los pasos exactos para clonar, instalar, compilar y ejecutar toda la plataforma **Stratova AI** en un entorno de desarrollo local.

---

## 📐 Arquitectura General

Stratova AI es una plataforma educativa de simulación empresarial impulsada por Inteligencia Artificial. Utiliza una arquitectura **Multi-Repo** compuesta por **4 repositorios** independientes:

```
ProyectoAI/                          ← Repositorio Vertical (orquestador)
├── core-plataform/                  ← Librería compartida (JAR)
├── iam-service/                     ← Microservicio de Identidad y Accesos
├── ai-service/                      ← Microservicio de IA y Simulación
├── scripts/                         ← Scripts PowerShell (Windows)
├── scripts_linux/                   ← Scripts Bash (Linux/Ubuntu)
└── docs/                            ← Documentación global
```

### Repositorios en GitHub

| Repositorio | GitHub | Descripción |
|---|---|---|
| **Vertical** | `daswitez/stratova-vertical` | Orquestador, scripts y documentación global |
| **Core Platform** | `daswitez/core-platform-stratova` | Librería compartida: IAM base, Auditoría, Multi-tenancy |
| **IAM Service** | `daswitez/iam-service-stratova` | Autenticación, JWT, roles y permisos |
| **AI Service** | `daswitez/ai-service-stratova` | Motor de simulación, Spring AI, OpenAI, PgVector |

---

## 🧩 Descripción de cada Repositorio

### 1. Core Platform (`core-plataform/`)
- **Tipo:** Librería JAR (no ejecutable)
- **Tecnología:** Spring Boot 3.4.0, Java 21
- **Contenido:**
  - Modelo de dominio IAM (Roles, Permisos, Usuarios)
  - Sistema de Auditoría (eventos, listeners)
  - Observabilidad (métricas, logging, correlation IDs)
  - Excepciones comunes del dominio
  - Especificaciones de Multi-tenancy
- **Importante:** Esta librería se instala en el repositorio local de Maven para que los otros servicios la consuman como dependencia.

### 2. IAM Service (`iam-service/`)
- **Tipo:** Microservicio ejecutable
- **Puerto:** `8080` (por defecto)
- **Tecnología:** Spring Boot 3.4.0, Java 21, PostgreSQL, Spring Security, JWT, Flyway
- **Contenido:**
  - Autenticación y autorización OAuth2/JWT
  - Gestión de Usuarios, Roles y Permisos (CRUD)
  - API REST documentada con SpringDoc/Swagger
  - Contract Testing con Pact
- **Depende de:** `core-platform` (JAR)

### 3. AI Service (`ai-service/`)
- **Tipo:** Microservicio ejecutable
- **Puerto:** `8091` (por defecto)
- **Tecnología:** Spring Boot 3.4.0, Java 21, Spring AI 1.1.2, OpenAI, PostgreSQL + PGVector
- **Arquitectura interna:** Clean Architecture (Hexagonal) dividida en 5 módulos:

  | Módulo | Responsabilidad |
  |---|---|
  | `ai-domain` | Entidades y reglas de negocio puras |
  | `ai-application` | Casos de uso y puertos |
  | `ai-infrastructure` | Adaptadores (DB, LLM, APIs externas) |
  | `ai-api` | Controladores REST |
  | `ai-bootstrap` | Punto de entrada de Spring Boot |

- **Base de datos:** PostgreSQL 16 con extensión PGVector (para búsqueda vectorial/RAG)
- **Docker Compose:** Levanta Postgres+PGVector en puerto `5434`
- **Depende de:** `core-platform` (JAR)

---

## 🔧 Prerrequisitos

Antes de clonar el proyecto, asegurate de tener instalado:

| Herramienta | Versión mínima | Comando para verificar |
|---|---|---|
| **Java JDK** | 21 | `java -version` |
| **Maven** | 3.8.1 | `mvn -version` (opcional, se usa `mvnw`) |
| **Git** | 2.x | `git --version` |
| **Docker** | 20.x | `docker --version` |
| **Docker Compose** | 2.x | `docker compose version` |

### Instalación de Java 21 en Ubuntu/Debian
```bash
sudo apt update
sudo apt install openjdk-21-jdk
java -version   # Verificar
```

### Instalación de Docker en Ubuntu
```bash
sudo apt update
sudo apt install docker.io docker-compose-v2
sudo usermod -aG docker $USER
# Reiniciar la sesión para que tome efecto
```

---

## 📥 Paso 1: Clonar los Repositorios

El orden de clonación es importante. Primero se clona el **repositorio vertical** (que actúa como carpeta raíz), y luego se clonan los servicios dentro de él.

```bash
# 1. Clonar el repositorio vertical (orquestador)
git clone https://github.com/daswitez/stratova-vertical.git ProyectoAI
cd ProyectoAI

# 2. Clonar los 3 servicios dentro de la carpeta del vertical
git clone https://github.com/daswitez/core-platform-stratova.git core-plataform
git clone https://github.com/daswitez/iam-service-stratova.git iam-service
git clone https://github.com/daswitez/ai-service-stratova.git ai-service
```

### Estructura resultante
```
ProyectoAI/               ← Repo vertical
├── core-plataform/        ← Repo core-platform
├── iam-service/           ← Repo iam-service
├── ai-service/            ← Repo ai-service
├── scripts/
├── scripts_linux/
└── docs/
```

> **Nota:** Cada carpeta hija es un repositorio Git independiente. Las carpetas `core-plataform/`, `iam-service/` y `ai-service/` están en el `.gitignore` del vertical para evitar conflictos.

---

## 🏗️ Paso 2: Compilar el Proyecto

### Orden de compilación (OBLIGATORIO)

El orden importa porque los servicios dependen del `core-platform`:

```
core-platform (install) → iam-service (build) → ai-service (build)
```

### Opción A: Script automático (recomendado)

#### Linux / Ubuntu
```bash
# Compilar todo (con tests)
./scripts_linux/build-all.sh

# Compilar todo (sin tests, más rápido)
./scripts_linux/build-all.sh --skip-tests
```

#### Windows (PowerShell)
```powershell
# Compilar todo
.\scripts\build-all.ps1

# Compilar todo (sin tests)
.\scripts\build-all.ps1 -SkipTests
```

### Opción B: Compilar manualmente paso a paso

```bash
# 1. Instalar core-platform en Maven local
cd core-plataform
./mvnw clean install -DskipTests
cd ..

# 2. Compilar iam-service
cd iam-service
./mvnw clean verify -DskipTests
cd ..

# 3. Compilar ai-service
cd ai-service
./mvnw clean verify -DskipTests
cd ..
```

### Instalar solo el Core
Si únicamente modificaste el `core-platform` y querés que los servicios vean los cambios:

```bash
# Linux
./scripts_linux/install-core.sh

# Windows (PowerShell)
.\scripts\install-core.ps1
```

---

## 🗄️ Paso 3: Levantar Bases de Datos

### AI Service — PostgreSQL + PGVector
El `ai-service` requiere una base de datos PostgreSQL con la extensión PGVector. Se levanta con Docker Compose:

```bash
# Linux - Levantar Postgres (espera healthcheck automáticamente)
./scripts_linux/dev-up.sh

# Linux - Apagar Postgres
./scripts_linux/dev-down.sh
```

O manualmente:
```bash
cd ai-service
docker compose up -d
cd ..
```

**Configuración por defecto del Postgres del AI Service:**

| Variable | Valor por defecto |
|---|---|
| Host | `127.0.0.1` |
| Puerto | `5434` |
| Base de datos | `ai_service` |
| Usuario | `postgres` |
| Contraseña | `postgres` |

### IAM Service — PostgreSQL
El `iam-service` necesita su propia instancia de PostgreSQL configurada en su `application.yml`. Revisá el archivo `iam-service/src/main/resources/application.yml` para ver los datos de conexión.

---

## ▶️ Paso 4: Ejecutar los Servicios

Una vez compilado todo y con las bases de datos levantadas:

```bash
# Ejecutar IAM Service (puerto 8080)
cd iam-service
./mvnw spring-boot:run
# En otra terminal...

# Ejecutar AI Service (puerto 8091)
cd ai-service
./mvnw spring-boot:run -pl modules/ai-bootstrap
```

### Verificar que los servicios están corriendo

| Servicio | URL de verificación |
|---|---|
| IAM Service | `http://localhost:8080/actuator/health` |
| AI Service | `http://localhost:8091/actuator/health` |
| IAM Swagger UI | `http://localhost:8080/swagger-ui.html` |
| AI Swagger UI | `http://localhost:8091/swagger-ui.html` |

---

## 🧪 Paso 5: Ejecutar Tests

```bash
# Linux - Ejecutar todos los tests de todos los repos
./scripts_linux/test-all.sh

# Windows (PowerShell)
.\scripts\test-all.ps1
```

O individualmente:
```bash
cd iam-service && ./mvnw test && cd ..
cd ai-service && ./mvnw test && cd ..
```

---

## 🔄 Paso 6: Formateo de Código (Spotless)

El proyecto usa **Spotless** con **Google Java Format (estilo AOSP)** para mantener un formato consistente. Si Maven falla con errores de formato, ejecutá:

```bash
# Formatear un servicio específico
cd core-plataform && ./mvnw spotless:apply && cd ..
cd iam-service && ./mvnw spotless:apply && cd ..
cd ai-service && ./mvnw spotless:apply && cd ..
```

> **Tip:** Siempre corré `spotless:apply` antes de hacer commit para evitar que el CI rechace tu código.

---

## 📝 Workflow de Git (Commits)

Dado la estructura Multi-Repo, **cada servicio tiene su propio repositorio Git**. Para hacer commits:

```bash
# Ejemplo: Commitear cambios en iam-service
cd iam-service
git add . -f
git commit -m "feat: nueva funcionalidad de permisos"
git push origin main
cd ..
```

> **⚠️ Importante:** Siempre usá `git add . -f` dentro de los servicios porque el `.gitignore` del repositorio vertical puede bloquear el tracking.

Para más detalles sobre el workflow de Git, consultá: [GIT-WORKFLOW.md](./GIT-WORKFLOW.md)

---

## 📋 Resumen Rápido de Comandos

| Acción | Linux | Windows |
|---|---|---|
| Compilar todo | `./scripts_linux/build-all.sh` | `.\scripts\build-all.ps1` |
| Compilar sin tests | `./scripts_linux/build-all.sh --skip-tests` | `.\scripts\build-all.ps1 -SkipTests` |
| Instalar core | `./scripts_linux/install-core.sh` | `.\scripts\install-core.ps1` |
| Tests globales | `./scripts_linux/test-all.sh` | `.\scripts\test-all.ps1` |
| Levantar DB (AI) | `./scripts_linux/dev-up.sh` | Docker manual |
| Apagar DB (AI) | `./scripts_linux/dev-down.sh` | Docker manual |
| Formatear código | `./mvnw spotless:apply` | `.\mvnw spotless:apply` |

---

## 🛠️ Stack Tecnológico

| Categoría | Tecnología |
|---|---|
| Lenguaje | Java 21 |
| Framework | Spring Boot 3.4.0 |
| IA | Spring AI 1.1.2, OpenAI API |
| Base de datos | PostgreSQL 16, PGVector, MongoDB Atlas |
| Seguridad | Spring Security, OAuth2, JWT |
| Migraciones | Flyway |
| API Docs | SpringDoc OpenAPI (Swagger UI) |
| Formato de código | Spotless + Google Java Format (AOSP) |
| Contract Testing | Pact |
| Architecture Testing | ArchUnit |
| Contenedores | Docker, Docker Compose |
| Build Tool | Maven 3.8.1+ (via Maven Wrapper) |
