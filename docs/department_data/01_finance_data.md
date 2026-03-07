# Requirements de Datos: Departamento de Finanzas (Finance Agent)

Este documento detalla los requerimientos de datos exhaustivos para el Agente Financiero dentro del motor de simulación empresarial. El objetivo es modelar con alta fidelidad la realidad económica Corporativa, permitiendo escenarios de *runway*, levantamiento de capital, insolvencia y rentabilidad.

## 1. Estado Interno (Digital Twin - MongoDB)

El perfil financiero de la empresa simulada requiere un conjunto profundo de variables actualizables asíncronamente.

### 1.1. Liquidez y Caja (Treasury)
*   **`operating_cash_balance`**: Efectivo disponible para operaciones diarias (liquidez inmediata).
*   **`restricted_cash`**: Efectivo retenido como garantía bancaria o requisitos regulatorios.
*   **`short_term_investments`**: Bonos del tesoro, depósitos a plazo fácilmente liquidables.
*   **`monthly_burn_rate_avg`**: Promedio móvil de quema de caja de los últimos 3 meses.
*   **`runway_months`**: `(operating_cash_balance + short_term_investments) / monthly_burn_rate_avg`.

### 1.2. Estado de Resultados (P&L - Income Statement)
*   **Ingresos (Revenue):**
    *   **`mrr` (Monthly Recurring Revenue):** Para modelos SaaS o suscripción.
    *   **`one_off_sales`**: Ventas transaccionales directas.
    *   **`net_revenue`**: Ingresos brutos menos devoluciones y descuentos.
*   **Costos Directos (COGS):**
    *   **`cost_of_materials`**: Insumos directos.
    *   **`hosting_and_infrastructure`**: Costos de servidores (ej. AWS) escalables por volumen.
    *   **`direct_labor`**: Salarios del personal directamente ligado a producción.
*   **Gastos Operativos (OPEX):**
    *   **`sales_and_marketing_expense`**: Gasto en ads, nómina de ventas, eventos.
    *   **`rd_expense`**: Investigación y desarrollo, nómina de ingeniería.
    *   **`g_and_a_expense`** (General & Admin): Alquileres, honorarios legales, nómina administrativa.
*   **Márgenes y Rentabilidad:**
    *   **`gross_margin_percentage`**: `(net_revenue - COGS) / net_revenue`.
    *   **`ebitda`**: Earnings Before Interest, Taxes, Depreciation, and Amortization.
    *   **`net_income`**: Beneficio o pérdida neta final del período.

### 1.3. Balance General (Balance Sheet)
*   **Activos (Assets):**
    *   **`accounts_receivable`**: Dinero que los clientes deben a la empresa (riesgo de no pago).
    *   **`inventory_value`**: Valor contable del inventario en almacén.
    *   **`ppe_value`** (Property, Plant, and Equipment): Activos fijos depreciables.
*   **Pasivos (Liabilities):**
    *   **`accounts_payable`**: Dinero que la empresa debe a proveedores.
    *   **`short_term_debt`**: Préstamos bancarios a pagar en menos de 12 meses.
    *   **`long_term_debt`**: Bonos corporativos o préstamos a más de 1 año.
    *   **`deferred_revenue`**: Pago adelantado por servicios no prestados (ej. suscripciones anuales cobradas upfront).
*   **Patrimonio (Equity):**
    *   **`retained_earnings`**: Ganancias acumuladas no distribuidas a accionistas.
    *   **`paid_in_capital`**: Dinero inyectado por VCs o fundadores.
    *   **`company_valuation_estimate`**: Valoración estimada actual basada en múltiplos (ej. 10x ARR).

### 1.4. Estructura de Capital (Cap Table)
*   **`founder_equity_percentage`**
*   **`investor_equity_percentage`**
*   **`employee_option_pool`**
*   **`cost_of_equity` (Ke)**: Rendimiento exigido por los accionistas.
*   **`wacc` (Weighted Average Cost of Capital)**: Costo promedio ponderado de capital, clave para evaluar nuevos proyectos (NPV).

---

## 2. Variables Macroeconómicas y de Mercado (Reality Model)

El entorno financiero *real* que el Motor de Simulación inyecta para afectar los cálculos del Agente. El Agente Financiero debe recalcular sus previsiones si estos indicadores cambian bruscamente.

### 2.1. Indicadores de Tasas e Inflación
*   **Tasa Libre de Riesgo (Risk-Free Rate):**
    *   **Dato Real:** Rendimiento de los Bonos del Tesoro de EE.UU. a 10 años (Treasury Yield 10Y).
    *   **Impacto:** Define el costo base del dinero. Si sube, el WACC de la startup sube, haciendo que proyectos a largo plazo pierdan valor (NPV baja). El financiamiento VC se seca.
*   **Tasa de Referencia Bancaria:**
    *   **Dato Real:** Tasa SOFR (Secured Overnight Financing Rate) o Tasa FED.
    *   **Impacto:** Afecta directamente el costo del `short_term_debt` si los créditos son de tasa variable.
*   **Inflación (Índice de Precios al Consumidor - IPC):**
    *   **Dato Real:** Consumer Price Index (YoY y MoM).
    *   **Impacto:** Presiona a RRHH para subir salarios (`OPEX` sube), encarece `COGS` e incita a subir precios (afectando la demanda).

### 2.2. Indicadores de Acceso a Capital (Venture Capital & Debt)
*   **Múltiplos de Valoración por Industria (SaaS Multiples, E-commerce Multiples):**
    *   **Dato Real:** Reportes de múltiplos EV/Revenue de índices como *Bessemer Cloud Index*.
    *   **Impacto:** Si el Agente Estratégico decide pedir una Serie A, el Agente Financiero usa estos múltiplos reales para establecer la valuación premoney y la dilución de los fundadores.
*   **Índice de Volatilidad (VIX):**
    *   **Dato Real:** CBOE Volatility Index.
    *   **Impacto:** A mayor VIX (miedo de mercado), las rondas de inversión toman un 50% más de tiempo en cerrarse, o los inversores exigen "Liquidation Preferences" hostiles.

### 2.3. Tipos de Cambio (FX) y Materias Primas
*   **Pares de Divisas:** (ej. EUR/USD, USD/MXN).
    *   **Impacto:** Si la empresa cobra en Euros pero paga infraestructura web en Dólares, una fortaleza del Dólar erosiona los márgenes automáticamente.

---

## 3. Lógica de Simulación y Disparadores (Triggers)

El Agente Financiero (IA + Sistema Basado en Reglas) monitoriza el estado constantemente y reacciona de la siguiente manera:

*   **Trigger de Quema de Caja:** Si alguna acción de otro agente (ej. Marketing gasta $100k extra) hace que el `runway_months` baje a < 3 meses, el Agente Financiero genera una alerta crítica (Email / Slack de simulación) solicitando:
    1. Reducción de Headcount (Despidos).
    2. Activación de deuda a corto plazo (Venture Debt con altas tasas de interés).
*   **Trigger de Dilución de Cuentas por Cobrar:** Si el Agente Comercial vende mucho B2B a "Net 90" (pago a 90 días), el `accounts_receivable` sube, las Ventas suben, pero el `operating_cash_balance` cae. El Agente Financiero debe advertir sobre una posible crisis de insolvencia a pesar de ser rentables en papel ("Cash is King").
*   **Auditoría de Inversión (Due Diligence):** Cuando el usuario humano decide levantar capital, el Reality Engine examina el `gross_margin_percentage` y el `ebitda` del Agente Financiero, los compara contra los *Benchmarks* reales del vector y determina la probabilidad de éxito de la ronda de inversión.
