# Requirements de Datos: Departamento de Riesgo y Continuidad de Negocio (Risk & Business Continuity Agent)

El Agente de Riesgo actúa como el evaluador probabilístico de los "What Ifs" catastróficos. Su trabajo es asegurar que la empresa sobreviva a volatilidades extremas (Cisnes Negros) y ayudar al usuario a entender la exposición real de sus decisiones.

## 1. Estado Interno (Digital Twin - MongoDB)

### 1.1. Matriz de Riesgo y Coberturas (Risk Exposure Node)
*   **`current_risk_exposure_matrix_usd`**: Valor total en dólares en riesgo si ocurre el peor escenario (Value at Risk - VaR).
*   **`insurance_coverage_usd`**: Cuánto cubren las pólizas de seguros actuales (Ciberseguridad, Responsabilidad Civil, Interrupción de Negocio).
*   **`insurance_premiums_monthly_cost`**: Costo de mantener los seguros (P&L Hit).
*   **`cash_reserves_percentage`**: % de efectivo total intocable para emergencias (mandatado por políticas internas).

### 1.2. Concentración de Riesgo (Concentration Risk)
*   **`revenue_concentration_top_3_clients`**: % de los ingresos que provienen de los 3 clientes más grandes. Si es > 50%, la pérdida de un cliente es letal.
*   **`supplier_concentration_index`**: Dependencia de un solo proveedor para componentes críticos.
*   **`geo_concentration_index`**: Dependencia de una sola región geográfica para ventas u operaciones.

### 1.3. Resiliencia Financiera (Stress Testing)
*   **`survival_horizon_zero_revenue_days`**: Cuántos días sobrevive la empresa pagando nómina si los ingresos caen mágicamente a $0 (Prueba de estrés ácida).
*   **`debt_default_probability`**: Riesgo de no poder pagar un préstamo (`short_term_debt`) basado en las fluctuaciones de caja previstas.

---

## 2. Variables Macroeconómicas y de Mercado (Reality Model)

El Agente de Riesgo no predice el futuro, pero lee los indicadores de volatilidad inyectados por el Reality Engine para ajustar las primas de seguros y levantar banderas rojas.

### 2.1. Indicadores de Volatilidad y Geopolítica
*   **Índice VIX (CBOE Volatility Index):**
    *   **Dato Real:** Apodado el "Índice del Miedo" de Wall Street.
    *   **Impacto:** Cuando el VIX sube por encima de 30, el Reality Engine aumenta la probabilidad base de *todos* los eventos adversos (clientes que no pagan sus facturas, inversionistas que retiran term sheets).
*   **Índices de Riesgo Geopolítico (GPR):**
    *   **Dato Real:** Eventos globales cuantificados (Guerras comerciales, pandemias, embargos).
    *   **Impacto:** Afecta a `supplier_concentration_index`. Si el 80% de proveedores están en una zona de alto GPR, el Agente de Riesgo fuerza a comprar un *Supply Chain Insurance* o exige pivotar proveedores (aumentando costos operativos).

### 2.2. Riesgo de Crédito Sistémico
*   **Spreads de Bonos de Alto Rendimiento (High Yield Spreads):**
    *   **Dato Real:** Diferencia entre los bonos basura y los bonos del tesoro sin riesgo.
    *   **Impacto:** Si el *spread* se ensancha mucho, los bancos dejan de prestar dinero. Si la startup simulada dependía de renovar un crédito revolvente ese mes, el banco se lo niega simulando un "Credit Crunch".

### 2.3. Eventos de Cisne Negro (Black Swans en Vector DB)
*   **RAG de Desastres Coporativos Históricos:**
    *   **Dato Real:** Datos vectorizados de eventos reales (ej. "Colapso de Silicon Valley Bank en 2023", "Hackeo de Equifax", "Escándalo de WeWork").
    *   **Impacto:** El Reality Engine tira dados estadísticos cada "turno" (mes simulado). Si acierta un Cisne Negro similar, evalúa la `current_risk_exposure_matrix_usd`. Si la startup no estaba cubierta, el evento le borra el 40% del `operating_cash_balance` de un golpe.

---

## 3. Lógica de Simulación y Disparadores (Triggers)

*   **Trigger de "Quiebra en Cadena" (Client Bankruptcies):** El Agente Comercial celebra cerrar un súper cliente por $1M ARR (Aumentando la Concentración de Ingresos). Tres meses después, el Reality Engine inyecta una recesión en el nicho de ese cliente.
    *   **Efecto:** El súper cliente quiebra y deja de pagar. La cuenta `accounts_receivable` se convierte en polvo ($1M en pérdidas incobrables). El `survival_horizon_zero_revenue_days` colapsa. El Agente de Riesgo envía una alerta de Nivel 5: "Insolvencia inminente por concentración de clientes, inicie despidos".
*   **El "Impuesto de Prudencia" (The Prudence Tax):** Si el CEO (Usuario) ignora repetidamente las alertas del Agente de Riesgo para comprar seguros (`insurance_coverage_usd` = $0) con tal de maximizar el EBITDA a corto plazo.
    *   **Efecto:** El Reality Engine penaliza el "Score de Gobernanza" interno de la empresa. En el momento en que el CEO intente levantar una ronda de inversión (Serie A), el Motor simula un *Due Diligence* fallido: los VCs perciben demasiado riesgo moral y tiran la valuación de la empresa a la mitad.
*   **Stress Test Automático:** Cada vez que el usuario quiere aprobar un "StrategicActionProposal" (ej. Comprar un competidor por $5M), el Agente de Riesgo corre un estrés test de Monte Carlo (1000 simulaciones). Si en más del 15% de los escenarios la caja llega a 0 en menos de 6 meses, veta la estrategia con el estado: "Riesgo de Ruina Intolerable".
