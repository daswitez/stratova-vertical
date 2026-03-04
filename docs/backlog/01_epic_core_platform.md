# EPIC-01: Core Platform (Librería Base)

**Objetivo:** Desarrollar la arquitectura base compartida por todos los microservicios de Solveria para asegurar consistencia, reducir código duplicado y facilitar la escalabilidad enterprise.

## Tareas (User Stories / Tasks)

- [ ] **CORE-01: Configuración Base Spring Boot**
  - Establecer arquetipo base (`Spring Boot 3.4.0`, `Java 21`).
  - Configurar gestión de dependencias (BOM) para todos los microservicios.
- [ ] **CORE-02: Sistema de Observabilidad Compartido**
  - Configurar logs estructurados (JSON) para agregación (ELK/Datadog).
  - Implementar trazas distribuidas (OpenTelemetry/Micrometer).
  - Configurar métricas base de JVM y HTTP.
- [ ] **CORE-03: Manejo de Excepciones Global (Error Handling)**
  - Crear un `@ControllerAdvice` global.
  - Definir estructura estándar de errores de API (ProblemDetail/RFC 7807).
  - Mapear excepciones comunes (NotFound, Unauthorized, BadRequest).
- [ ] **CORE-04: Soporte Multi-Tenant Base**
  - Desarrollar interceptores para capturar el `Tenant ID` del request (ej. headers o JWT).
  - Configurar enrutamiento de base de datos o separación por esquemas según el `Tenant ID` (SaaS Multi-Tenant).
- [ ] **CORE-05: Auditoría de Datos**
  - Implementar `@EntityListeners` (JPA) o interceptores (Mongo) para poblar automáticamente campos de auditoría (`createdAt`, `createdBy`, `updatedAt`, `updatedBy`).
- [ ] **CORE-06: Utilidades Compartidas**
  - Clases de utilidad para validación, sanitización de datos y manipulación de fechas/horas (UTC por defecto).
  - Interfaces y DTOs base de paginación y ordenamiento.
- [ ] **CORE-07: Testing y Arquitectura (ArchUnit)**
  - Definir reglas estrictas de Clean Architecture usando ArchUnit para que sean heredadas/aplicadas por los servicios.
