# 📚 Guía de Repositorios - Stratova AI

Esta plataforma utiliza una arquitectura **Multi-Repo**, gestionada por un repositorio padre ("Vertical"). En total, el proyecto se divide en 4 repositorios independientes para asegurar el desacoplamiento, la escalabilidad y facilitar el CI/CD.

## 🏗️ 1. Repositorio Vertical (El Orquestador)
**Ubicación local:** `/ProyectoAI/` (Carpeta Raíz)

*   **¿Qué contiene?** Documentación global, scripts de compilación (`build-all.ps1`), scripts de pruebas, y configuraciones de Docker que levantan toda la base de datos de la plataforma al mismo tiempo.
*   **Propósito:** Es el "director de orquesta". Su único trabajo es gestionar el ecosistema, no contiene código de negocio.
*   **¿Cuándo hacer commits aquí?** Solo cuando cambies documentación global (`README.md`, este archivo), modifiques puertos en un `docker-compose.yml`, o actualices un script de la carpeta `scripts/`.
*   **⚠️ Cuidado con Git:** Este repositorio tiene un archivo `.gitignore` configurado para ignorar las carpetas hijas (`core-plataform`, `iam-service`, `ai-service`). Esto evita que la vertical "absorba" el código de los servicios.

---

## 🛠️ 2. core-plataform (Librería Central)
**Ubicación local:** `/ProyectoAI/core-plataform/`

*   **¿Qué contiene?** Clases de utilidades (IAM base, Auditoría, Multi-tenancy, excepciones comunes).
*   **Propósito:** Es una librería (jar) consumible. Provee las bases estructurales que los otros servicios necesitan para funcionar.
*   **¿Cuándo hacer commits aquí?** Cuando modifiques una entidad que se usa en toda la plataforma, o agregues soporte transversal (ej. un nuevo filtro de seguridad).
*   **Instrucciones de Commit:**
    1. Abre tu terminal y ubícate en la carpeta: `cd ProyectoAI/core-plataform/`
    2. Como este repositorio está ignorado por el padre, **DEBES USAR FORCE** para agregar archivos:
       ```bash
       git add . -f
       git commit -m "feat: [tu descripción clara del cambio]"
       git push origin main
       ```
    3. *Recuerda:* Después de actualizar este repo, debes correr `mvn clean install` para que los otros servicios vean los cambios reflejados localmente.

---

## 🔐 3. iam-service (Identidad y Accesos)
**Ubicación local:** `/ProyectoAI/iam-service/`

*   **¿Qué contiene?** Seguridad, generación de Tokens JWT, y gestión de roles (Docente, Estudiante, Empresa).
*   **Propósito:** Es el microservicio encargado de validar "Quién eres" y "Qué puedes hacer" en el Simulador Stratova. Corre por defecto en el puerto `8080`.
*   **¿Cuándo hacer commits aquí?** Si necesitas crear un nuevo Rol, modificar la expiración de sesión, o actualizar los permisos de un endpoint.
*   **Instrucciones de Commit:**
    1. Abre tu terminal y ubícate en la carpeta: `cd ProyectoAI/iam-service/`
    2. Usa el parámetro `force` para saltar el bloqueo del repositorio padre:
       ```bash
       git add . -f
       git commit -m "fix: [tu descripción del cambio de seguridad]"
       git push origin main
       ```

---

## 🤖 4. ai-service (Inteligencia Artificial y Simulador)
**Ubicación local:** `/ProyectoAI/ai-service/`

*   **¿Qué contiene?** Spring AI, motor de decisiones financieras, conexiones con OpenAI y búsquedas en MongoDB/PgVector.
*   **Propósito:** Procesar las decisiones tomadas por los estudiantes, comparar contra tendencias de mercado reales, y generar resultados analíticos por "Ciclo Empresarial". Corre por defecto en el puerto `8091`.
*   **¿Cuándo hacer commits aquí?** Si agregas un nuevo KPI financiero, modificas el comportamiento del "Mercado" (Bounded Contexts), o actualizas los Prompts pasados a ChatGPT.
*   **Instrucciones de Commit:**
    1. Abre tu terminal y ubícate en la carpeta: `cd ProyectoAI/ai-service/`
    2. Usa el parámetro `force` por la regla de ignorar del padre:
       ```bash
       git add . -f
       git commit -m "feat: [tu nueva regla de simulación en IA]"
       git push origin main
       ```

---

### 🚨 Regla de Oro para el Desarrollo
**Nunca hagas `git add .` en la carpeta raíz (`ProyectoAI/`) esperando subir los cambios de los microservicios.**
Debes navegar (`cd`) explícitamente dentro de la carpeta del microservicio afectado, usar `git add . -f`, hacer tu commit y luego salir de ahí. El desacoplamiento es la clave de esta arquitectura.

---

## 🐧 Comandos de Ejecución y Compilación (Linux / Ubuntu)

Dado que los scripts originales del proyecto están en PowerShell (`.ps1`), se ha creado una copia adaptada para entornos **Bash / Linux** en la carpeta `scripts_linux/`.

Todos estos scripts ya tienen permisos de ejecución. Para correrlos, abre tu terminal en la carpeta principal `ProyectoAI/` y usa:

### 1. Compilación
*   **Instalar solo el Core:** `./scripts_linux/install-core.sh`
*   **Compilar toda la plataforma:** `./scripts_linux/build-all.sh`
*   *(Opcional: saltar tests)* `./scripts_linux/build-all.sh --skip-tests`

### 2. Pruebas Automatizadas
*   **Correr todos los tests de todos los repositorios:** `./scripts_linux/test-all.sh`

### 3. Entorno de Desarrollo Local (Docker - AI Service)
Para probar localmente el servicio de Inteligencia artificial, necesitas levantar su base de datos Postgres+PgVector.
*   **Para levantar Postgres:** `./scripts_linux/dev-up.sh`
*   **Para apagar y limpiar Postgres:** `./scripts_linux/dev-down.sh`
