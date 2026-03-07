# Requirements de Datos: Departamento de Recursos Humanos (HR Agent)

El Agente de Recursos Humanos (HR) gestiona el talento, el activo más valioso e impredecible de la empresa. Modela la productividad, el costo de la nómina y la capacidad de la empresa para ejecutar sus estrategias.

## 1. Estado Interno (Digital Twin - MongoDB)

### 1.1. Estructura y Headcount (Organizational Node)
*   **`total_headcount`**: Número total de empleados activos.
*   **`open_requisitions`**: Casillas vacías que se están reclutando activamente.
*   **Desglose por Departamento:**
    *   `sales_headcount`, `engineering_headcount`, `support_headcount`, etc.
*   **`management_span_of_control`**: Ratio de líderes vs contribuyentes individuales. (Si es muy alto, la eficiencia baja por falta de dirección).

### 1.2. Costos Laborales (Payroll & Benefits)
*   **`average_salary_per_department`**: Salario base promedio por área.
*   **`total_monthly_payroll`**: Gasto total en salarios (impacta directamente el OPEX en Finanzas).
*   **`payroll_tax_and_benefits_rate`**: Porcentaje extra sobre el salario base (ej. 25% para cubrir seguro médico, impuestos locales).
*   **`bonus_and_commission_pool`**: Dinero variable pagado por rendimiento (crítico para Ventas).

### 1.3. Dinámica del Talento (Talent Dynamics)
*   **`employee_nps` (eNPS):** Satisfacción interna del equipo (-100 a 100). Si es bajo, la rotación explotará pronto.
*   **`attrition_rate_monthly` (Churn de Empleados):** Porcentaje de empleados que renuncian cada mes.
*   **`time_to_fill_days`**: Días promedio que toma cerrar una vacante desde que se publica hasta que el candidato firma.
*   **`onboarding_ramp_up_time_months`**: Tiempo hasta que un nuevo empleado llega al 100% de productividad (Ej. Un vendedor nuevo tarda 3 meses en empezar a cerrar cuota).

### 1.4. Productividad y Cultura (Productivity Metrics)
*   **`average_productivity_index` (0.0 - 1.0):** Multiplicador de eficiencia. Si la moral es baja, rinden al 0.6x.
*   **`training_budget_per_employee`**: Inversión en capacitación.
*   **`burnout_risk_score`**: Métrica sintética basada en horas extra o presión por metas inalcanzables.

---

## 2. Variables Macroeconómicas y de Mercado (Reality Model)

El mercado laboral es altamente elástico y reacciona a los ciclos económicos globales.

### 2.1. Mercado Laboral General
*   **Tasa de Desempleo (Unemployment Rate):**
    *   **Dato Real:** BLS (Bureau of Labor Statistics) o Eurostat.
    *   **Impacto:** Relación inversa al tiempo de contratación. Si el desempleo es alto (ej. 8%), el `time_to_fill_days` baja y los salarios se estancan. Si es del 3% (pleno empleo), retener talento es carísimo.
*   **Crecimiento Salarial Real (Wage Growth):**
    *   **Dato Real:** Índices de crecimiento salarial del sector.
    *   **Impacto:** Si la inflación sube al 6% y la empresa no ajusta salarios, el Reality Engine desploma el `eNPS` y dispara la fuga de cerebros (`attrition_rate`).

### 2.2. Competencia por Talento Especializado
*   **Saturación de Roles Tech (Software Engineers, Data Scientists):**
    *   **Dato Real:** Reportes de plataformas como LinkedIn o Glassdoor sobre exceso o escasez de talento STEM.
    *   **Impacto:** En un *boom* de IA, el salario promedio de ingenieros en la simulación sube automáticamente un 20% anual. Si el Agente de HR no pide a Finanzas ajustar el presupuesto, no podrá contratar, bloqueando al Agente de R&D (Product Development).

### 2.3. Tendencias de Trabajo (Workplace Trends)
*   **Índice de Retorno a la Oficina vs. Trabajo Remoto:**
    *   **Impacto:** Si la startup forza el retorno a la oficina en 5 días a la semana (decisión del usuario), y el mercado (RAG de PgVector) dicta que la tendencia es híbrida, el Motor de Realidad penaliza el `eNPS` inmediatamente, modelando una "Gran Renuncia" localizada.

---

## 3. Lógica de Simulación y Disparadores (Triggers)

*   **Trigger de "Escalabilidad Rota":** El usuario consigue una inyección de $5M USD. Ordena duplicar el tamaño de la empresa en 2 meses. El Agente de HR intenta reclutar, pero el Reality Engine dicta que el `time_to_fill` para 50 ingenieros es de 4 meses mínimo, y el `ramp_up_time` es de 3 meses.
*   **Efecto:** El dinero se quema en reclutadores y marketing de empleador, pero la capacidad de producción (Agente de Ops/R&D) no aumenta hasta el mes 7. El Agente de HR emite un reporte de alerta por "Crecimiento Irrealista".
*   **Trigger de "Burnout Colectivo":** El Agente Comercial sube las cuotas de ventas un 50% sin subir las comisiones ni el `total_headcount`. Las horas extra suben.
*   **Efecto:** El Reality Engine eleva el `burnout_risk_score`. Al mes siguiente, el 15% del equipo de ventas dominante renuncia (picos en `attrition_rate`). La empresa debe pagar liquidaciones, volver a reclutar y esperar el *ramp-up*, causando una crisis de ingresos en el próximo trimestre.
