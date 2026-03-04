# Estrategia de Testing y Calidad (QA)

En un entorno altamente asíncrono y dependiente de modelos de IA estocásticos (como DeepSeek), las pruebas tradicionales (Assersions 1:1) son insuficientes. Esta estrategia define cómo garantizaremos la estabilidad de **Solveria SSSP**.

## 1. Pruebas Unitarias (Unit Testing)
- **Frameworks:** JUnit 5, Mockito, AssertJ.
- **Alcance:** Obligatorio para todas las clases de dominio puro (`ai-domain`, entidades de Mongo, utilidades).
- **Mocking:** Para probar el *Predictor Agent*, **JAMAS** se conectará al LLM real en un test unitario. Se intercepta el adaptador de Spring AI y se simula una cadena de texto predecible.
- **Cobertura Mínima Esperada:** 80% en los paquetes `application` y `domain`.

## 2. Pruebas de Contrato (Consumer-Driven Contract Testing)
- **Framework:** Pact-JVM.
- **Alcance:** APIs síncronas entre microservicios (Ej. AI consultando perfiles a IAM).
- **Proceso:** El `ai-service` genera un contrato JSON de lo que espera. El `iam-service` lo descarga en su pipeline y verifica que su controlador cumple la promesa.

## 3. Pruebas de Integración y End-to-End (E2E)
- **Frameworks:** Testcontainers (PostgreSQL, MongoDB, Redis), Spring Boot Test.
- **Alcance:** Pruebas que necesitan base de datos real o colas de eventos.
- **Docker en Tests:** Cada pipeline levantará instancias efímeras de `pgvector` y Mongo usando Testcontainers antes de ejecutar la suite `@SpringBootTest`, asegurando que los repositorios JPA y Mongo Templates guarden y recuperen datos correctamente.

## 4. Evaluaciones de IA (LLM-As-A-Judge)
Dado que DeepSeek devolverá respuestas verbales y cálculos heurísticos:
1.  **Test Set Fijo:** Tendremos un set de 20 preguntas fijas de mercado (Ej. "Si vendo agua en el desierto a 5$").
2.  **Métrica de Evaluación:** Un script de prueba comparará la respuesta de la IA no por String exacto, sino pasándole la respuesta a *Otro* LLM (LLM-As-A-Judge) que validará semánticamente si la respuesta fue "Mayormente Existosa", "Fracaso" o "Alucinación".
3.  **Tolerancia RAG:** Evaluaremos si las Vector DBs inyectan el documento correcto (Retrieval Precision) por encima del 90%.

## 5. Pruebas Estáticas y de Arquitectura (ArchUnit)
- **Framework:** ArchUnit, SonarQube, Spotless.
- **Alcance:** Prohibir fallos humanos en la estructura del Clean Architecture.
- **Reglas ArchUnit:**
  - `controllers_should_not_access_repositories_directly()`
  - `domain_classes_should_not_depend_on_framework_classes()`
  - `ai_module_should_only_communicate_via_events_with_finance_module()`
