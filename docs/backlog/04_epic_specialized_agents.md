# EPIC-04: Agentes de IA Especializados (Business Domain)

**Objetivo:** Desarrollar el ecosistema de agentes, cada uno aislado y especializado en diferentes áreas del conocimiento corporativo. Los agentes operan de forma asíncrona liderados por eventos de negocio, consumiendo un estado central compartido.

## Nuevo Paradigma: Aislamiento y Memoria Independiente
Los agentes ya no se comunican directamente y de forma constante entre sí.
- **Aislamiento:** Cada agente (Finanzas, Mercado, Operaciones) es un ente aislado con su propia lógica de inferencia.
- **Memoria (Mongo/PgVector):** Cada agente tiene acceso a la memoria a largo plazo vectorial y a la base de datos documental (MongoDB) que representa el estado actual de la empresa.
- **Comunicación Indirecta:** Si Marketing lanza una campaña, actualiza el presupuesto y proyecciones en la base de datos central. El agente de Finanzas, al recibir el evento de "Cambio en BD", lee el nuevo estado y reacciona de forma asíncrona.

## Tareas (User Stories / Tasks)

- [ ] **AGN-01: Arquitectura de Aislamiento y Memoria (Memory & State)**
  - Implementar conectores individuales para que cada agente lea/escriba en colecciones de MongoDB específicas a su dominio, pero visibles transversalmente.
- [ ] **AGN-02: Motor de Reportes Asíncronos (Event-Driven Reporting)**
  - Desarrollar sistema donde los agentes no reportan constantemente, sino solo ante **eventos o cambios relevantes** en el negocio (ej. "Caída de ventas del 15%").
  - Generación de reportes estructurados mediante plantillas de Excel, llenados dinámicamente con consultas a la base de datos (Mongo).
  - Envío de estos reportes por correo electrónico al usuario o al rol administrativo correspondiente.
- [ ] **AGN-03: Agente Financiero**
  - Especializado en leer movimientos de la BD y recalcular proyecciones (burn rate, cash flow) cuando otros agentes ejecutan gastos (ej. Marketing).
- [ ] **AGN-04: Agente de Mercado / Marketing**
  - Decide lanzamientos de campañas y modificaciones de precios; inyecta estas decisiones en la BD central para que interactúen con el modelo de simulación de "Realidad".
- [ ] **AGN-05: Agente Operativo / Supply Chain**
  - Especialización en logística e inventario. Solo alerta (vía email/Excel) cuando detecta rupturas de stock inminentes o ineficiencias graves.
- [ ] **AGN-06: Agente Legal**
  - Validación de riesgos regulatorios básicos y estructura de sociedades (Spin-offs) de forma reactiva.
- [ ] **AGN-07: Agente Académico (Tutor Silencioso)**
  - Observa las métricas unificadas en la base de datos; emite reportes periódicos al profesor evaluando el desempeño de las decisiones tomadas por los estudiantes.
