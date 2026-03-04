# EPIC-06: Frontend App (Plataforma Web SaaS)

**Objetivo:** Construir la interfaz orientada al usuario final, tanto para corporativos como instituciones académicas, permitiendo la configuración intuitiva y el seguimiento en tiempo real de las simulaciones y la actividad de los agentes.

## Tareas (User Stories / Tasks)

- [ ] **WEB-01: Estructura del Proyecto Web**
  - Configurar framework frontend (Ej. React / Next.js, TypeScript).
  - Integrar sistema de diseño (Tailwind CSS o Material-UI) y enrutador.
- [ ] **WEB-02: Portal de Autenticación y Tenant Selection**
  - Pantallas de Login/Register conectadas al IAM Service.
  - Flujo de selección de contexto/organización si el usuario pertenece a más de una entidad.
- [ ] **WEB-03: Dashboard del Orquestador Central**
  - Tablero de control visualizando métricas macro (Salud Financiera, Market Share, Riesgo).
  - Ventana de chat/log mostrando las "conversaciones" y decisiones tomadas asíncronamente por los Agentes IA.
- [ ] **WEB-04: Panel de Detalle por Agente**
  - Vistas específicas donde el usuario interviene o aprueba recomendaciones (Ej. Vista del Agente Financiero mostrando Flujos de Caja y TIR proyectada).
- [ ] **WEB-05: Creador de Simulaciones (Wizard)**
  - Flujo paso a paso para iniciar: Seleccionar Tipo de Simulación (Startup, Spin-off, Producto), Inyectar Capital Inicial, Definir Mercado Objetivo.
- [ ] **WEB-06: Visor del Motor Probabilístico**
  - Integración de librerías de gráficos (Recharts / Chart.js / D3) para mostrar curvas de probabilidad, campanas de Gauss de retorno y análisis de sensibilidad (Tornado charts).
- [ ] **WEB-07: Interfaz del Docente/Administrador Académico**
  - Dashboard para ver métricas agregadas de todos los estudiantes, revisar el feedback del *Agente Académico*, y rankear equipos en caso de competencias universitarias.
