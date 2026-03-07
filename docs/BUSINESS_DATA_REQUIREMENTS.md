# Requisitos de Datos y Fuentes Estructurales para core-platform

Basado en la arquitectura CoreSim AI inter-agente y el motor probabilístico del simulador empresarial, a continuación se recopilan todos los **campos de estado interno útiles** requeridos por los agentes y las **fuentes de datos macroeconómicos / históricos reales** necesarios para el "Reality Model".

## 1. Agente Financiero (Finance Agent)
El agente encargado de ROI, *runway*, NPV (Valor Presente Neto), *cash flow* y salud financiera global.

### Campos Internos (Estado en MongoDB)
*   **Treasury & Cash Flow:** `current_balance`, `monthly_burn_rate`, `runway_months`.
*   **Income Statement:** `monthly_revenue`, `cogs` (Cost of Goods Sold), `gross_margin`, `ebitda`, `net_income`.
*   **Balance Sheet:** `total_assets`, `total_liabilities`, `equity`, `debt_ratio`.

### Datos Reales/Históricos Necesarios (Reality Model)
*   **Inflación (IPC):** Afecta el poder adquisitivo y ajuste de salarios.
*   **Tasas de Interés (Interest Rates):** Determina el costo de deuda corporativa (e.g., tasas de la FED o BCE).
*   **Tipos de Cambio (FX):** Crucial para multi-nacionales o importadores de *supply chain*.
*   **Rendimiento de Bonos Corporativos:** Para cálculo de costo de capital (WACC).
*   **Fuentes sugeridas:** 
    *   **FRED API** (Federal Reserve Economic Data).
    *   **Alpha Vantage** o **Yahoo Finance API**.
    *   **Banco Mundial (World Bank API)**.

---

## 2. Agente de Mercado y Marketing (Marketing Agent)
Encargado de analizar CAC, demanda objetivo, canales y segmentación.

### Campos Internos (Estado en MongoDB)
*   **Presupuesto (Budget):** `allocated_marketing_budget`, `spend_to_date`.
*   **Métricas de Adquisición:** `expected_cac`, `target_leads`, `conversion_rate`, `cpm_estimates`.
*   **Segmentación:** `target_demographic`, `channel_distribution` (TikTok, Meta Ads, B2B, etc.).

### Datos Reales/Históricos Necesarios (Reality Model)
*   **Tendencias de Consumidor y Sentimiento:** Índice de confianza del consumidor.
*   **Benchmarks de CAC por Industria:** Promedios de mercado actuales sobre cuánto cuesta adquirir un cliente en B2B SaaS vs. B2C E-commerce.
*   **Interés de Búsqueda:** Para simular estacionalidad o hype sobre un producto.
*   **Fuentes sugeridas:**
    *   **Google Trends API** (o similar) para hype y volumen de búsquedas.
    *   **Statista API / Reportes de HubSpot DB** (vectorizados vía `PgVector`) para CAC promedios.
    *   **Index de Sentimiento del Consumidor de U.of Michigan**.

---

## 3. Agente de Operaciones (Operations Agent)
Supervisa la capacidad empresarial, cuellos de botella (bottlenecks) y tiempos.

### Campos Internos (Estado en MongoDB)
*   **Capacidad:** `production_capacity_units`, `current_load_percentage`.
*   **Eficiencia:** `average_process_time`, `bottleneck_node`.
*   **Mantenimiento:** `downtime_rate`, `operational_cost_per_unit`.

### Datos Reales/Históricos Necesarios (Reality Model)
*   **Costos de Energía:** Petróleo, electricidad, gas natural (afectan OPEX).
*   **Índice de Precios del Productor (PPI):** Refleja presión inflacionaria sobre los procesos.
*   **Fuentes sugeridas:**
    *   **Bloomberg Data / EIA API** (Energy Information Administration).

---

## 4. Agente de Recursos Humanos (HR Agent)
Gestiona el *headcount*, la política salarial, tiempo de contratación y talento.

### Campos Internos (Estado en MongoDB)
*   **Estructura:** `total_headcount`, `open_requisitions`, `org_chart_complexity`.
*   **Costos:** `average_salary_band`, `payroll_tax_rate`, `benefits_cost`.
*   **Desempeño:** `attrition_rate` (rotación), `time_to_fill_days`, `productivity_index`.

### Datos Reales/Históricos Necesarios (Reality Model)
*   **Tasa de Desempleo (Desglosada por sector):** A menor desempleo tecnológico, mayor tiempo y costo de contratar talento.
*   **Crecimiento Salarial Real:** Tendencias de salarios en el mercado.
*   **Dinamismo Laboral:** Tendencias de trabajo remoto y renuncias masivas.
*   **Fuentes sugeridas:**
    *   **Bureau of Labor Statistics (BLS API)** para EE.UU.
    *   **Eurostat API** para Europa.
    *   **LinkedIn Economic Graph** o plataformas de datos laborales como Glassdoor/Payscale (Scraping/Reportes Vectorizados).

---

## 5. Agente de Cadena de Suministro (Supply Chain Agent)
Evaluación de lead times, proveedores e inventario para entrega de bienes/servicios.

### Campos Internos (Estado en MongoDB)
*   **Inventario:** `raw_material_stock`, `finished_goods_inventory`, `holding_costs`.
*   **Proveedores:** `supplier_reliability_score`, `average_lead_time_days`.

### Datos Reales/Históricos Necesarios (Reality Model)
*   **Costos Logísticos Globales:** Costo de contenedores (Shanghai a LA, etc.).
*   **Precios de Materias Primas:** Metales, semiconductores, madera.
*   **Restricciones Geopolíticas/Climáticas:** Retrasos en puertos.
*   **Fuentes sugeridas:**
    *   **Freightos Baltic Index (FBX)** (Logística global).
    *   **Trading Economics API** (Materias Primas).

---

## 6. Agente Legal y Compliance (Legal Agent)
Limita la exposición al riesgo legal, viabilidad regulatoria multi-país y privacidad.

### Campos Internos (Estado en MongoDB)
*   **Compliance Status:** `gdpr_compliant`, `soc2_ready`, `pending_lawsuits`.
*   **Estructura Coporativa:** `incorporated_region`, `intellectual_property_count`.

### Datos Reales/Históricos Necesarios (Reality Model)
*   **Corpus de Leyes Reales:** Texto profundo sobre leyes laborales, de consumo civil e impuestos locales.
*   **Casos Históricos de Sanciones:** Para la DB Vectorial ("Startup X multada por Y en 2023").
*   **Fuentes sugeridas:**
    *   **EUR-Lex** (Normativas Europeas).
    *   **Bases de Datos de Reguladores (SEC, FTC, CNMC)** procesadas e inyectadas crudas a **PgVector** para RAG.

---

## 7. Otros Agentes (R&D, Riesgo Comercial y TI)

*   **R&D (Research & Development):** 
    *   *Campos internos:* `rd_budget`, `project_timeline`, `feature_backlog`.
    *   *Datapoints reales:* Patentes aprobadas históricas, ciclo de hype de tecnologías (Gartner).
*   **Riesgo (Risk Agent):** 
    *   *Campos internos:* `risk_exposure_matrix`, `insurance_premiums`.
    *   *Datapoints reales:* Índices de riesgo geopolítico (VIX), frecuencias de quiebras en el sector.
*   **Experiencia (CX Agent):**
    *   *Campos internos:* `nps_score`, `churn_rate`, `customer_support_tickets`.
    *   *Datapoints reales:* Benchmarks sectoriales de Net Promoter Score y retención mensual de SaaS equivalentes.

---

## 💡 Estrategia de Obtención Tecnológica

Dado que la plataforma **Simulation Engine** usa "Reality Model" potenciado por IA y RAG (`PgVector`):
1. **Datos de Alta Volatilidad (Bolsa, Monedas, Inflación actual):** Deben consultarse mediante APIs en tiempo de ejecución o mediante jobs CRON diarios que inyecten a PostgreSQL (`Alpha Vantage`, `FRED`).
2. **Datos Estructurales y Cualitativos (CASOS DE USO, Leyes, Patrones de marketing):** No necesitan API en tiempo real. Se deben pre-computar recopilando PDFs, reportes anuales (McKinsey, Statista) y leyes oficiales, transformándolos en embeddings asíncronamente y guardándolos en **PgVector**. Esto permite que DeepSeek compare simétricamente "Lanzamiento de Producto X" con casos de éxito/fracaso de la realidad.
