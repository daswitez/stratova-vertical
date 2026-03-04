# Master Backlog - Solveria SSSP

Este es el registro maestro (Master Backlog) de todas las épicas y tareas principales para la construcción de **Solveria Strategic Simulation Platform (SSSP)**.

## Épicas Principales

1. **[EPIC-01] Core Platform (Librería Base)**
   - Funcionalidades transversales compartidas por todos los microservicios.
   - Observabilidad, manejo de excepciones, multi-tenancy base.
2. **[EPIC-02] IAM Service (Gestión de Identidad y Accesos)**
   - Autenticación, autorización, gestión de usuarios, roles y permisos.
   - Soporte para diferentes tenants (Universidades, Empresas, Consultoras).
3. **[EPIC-03] AI Service (Módulo de Inteligencia Artificial Base)**
   - Integración con modelos fundacionales (LLMs).
   - Motor de búsqueda semántica (RAG) y bases de datos vectoriales.
4. **[EPIC-04] Agentes de IA Especializados**
   - Implementación de los agentes de dominio (Financiero, Mercado, Operativo, Legal, Estratégico, Académico).
   - Orquestación y comunicación multiagente.
5. **[EPIC-05] Motor de Simulación y Datos (Simulation & Data Engine)**
   - Ingesta de datos reales de la web.
   - Configuración de escenarios probabilísticos (Monte Carlo, sensibilidades).
6. **[EPIC-06] Frontend App (Plataforma Web SaaS)**
   - Interfaz de usuario para configurar, visualizar y analizar las simulaciones.

Para ver el detalle de cada épica, consulta los archivos individuales en este directorio `docs/backlog/`.
