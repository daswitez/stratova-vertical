# EPIC-02: IAM Service (Identity & Access Management)

**Objetivo:** Proveer un sistema seguro, robusto e independiente para la autenticación y autorización de todos los usuarios (académicos y corporativos) dentro de la plataforma Solveria.

## Tareas (User Stories / Tasks)

- [ ] **IAM-01: Modelo de Datos de Identidad (PostgreSQL)**
  - Diseñar entidades de Base de Datos relacional para `User`, `Role`, `Permission`, `Tenant` y `OrganizationGroup` (para holdings/universidades).
  - Configurar migraciones con Liquibase o Flyway.
- [ ] **IAM-02: Autenticación (Login / Registro)**
  - Implementar endpoint de Login con generación de JWT.
  - Implementar flujo de Registro con validación de email.
  - Soporte opcional para SSO/SAML (Enterprise).
- [ ] **IAM-03: Autorización y Control de Accesos (RBAC)**
  - Implementar chequeo de permisos sobre el JWT (`@PreAuthorize`).
  - CRUD para perfiles de sistema (Admin de Holding, Profesor, Estudiante, Estratega Corporativo).
- [ ] **IAM-04: Gestión de Multi-Tenancy a nivel Usuario**
  - Mapear usuarios a Múltiples Tenants (un profesor puede pertenecer a dos universidades, o un asesor a dos holdings).
  - Añadir soporte para selección de tenant activo (Context Switch) en sesión.
- [ ] **IAM-05: Gestión de Invitaciones y Equipos (Teams)**
  - Flujo de creación de "Grupos de Simulación" o "Aulas".
  - Envío de links/códigos de invitación seguros.
- [ ] **IAM-06: Security & Rate Limiting**
  - Configurar encriptación de contraseñas fuerte (Bcrypt/Argon2).
  - Bloqueo temporal por múltiples intentos fallidos de login (Brute-force protection).
- [ ] **IAM-07: PACT Contract Testing**
  - Definir contratos Provider para que otros servicios (como AI-Service) puedan validar que el IAM responde correctamente sin levantar la DB de IAM.
