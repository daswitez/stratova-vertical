# Requirements de Datos: Departamento de Marketing y Ventas (Marketing Agent)

Este documento define la estructura de datos para el Agente de Marketing y Ventas. Su función es predecir la demanda, optimizar el Costo de Adquisición de Clientes (CAC) y modelar el comportamiento del usuario a través del embudo de ventas (funnel).

## 1. Estado Interno (Digital Twin - MongoDB)

### 1.1. Funnel de Adquisición (Sales Funnel)
*   **`total_impressions`**: Visualizaciones totales de campañas publicitarias.
*   **`website_visitors`**: Tráfico bruto captado o `top_of_funnel_leads`.
*   **`marketing_qualified_leads` (MQLs)**: Usuarios que mostraron interés inicial.
*   **`sales_qualified_leads` (SQLs)**: Usuarios listos para ser contactados por el equipo comercial.
*   **`active_customers`**: Clientes que pagan (o DAU/MAU dependiendo del modelo).
*   **Tasas de Conversión por Etapa:**
    *   `ctr` (Click-Through Rate): Impresiones a Visitantes.
    *   `visitor_to_mql_rate`
    *   `mql_to_sql_rate`
    *   `close_rate` (SQL a Cliente).

### 1.2. Economía Unitaria (Unit Economics)
*   **`cac` (Customer Acquisition Cost):** `(Gasto total en Ventas y Marketing) / (Nuevos clientes adquiridos)`.
*   **`arpu` (Average Revenue Per User):** Ingreso medio mensual por usuario.
*   **`ltv` (Customer Lifetime Value):** `ARPU * (1 / Churn Rate) * Gross Margin`.
*   **Relación LTV:CAC:** La métrica dorada (ideal 3:1 o superior).
*   **`payback_period_months`**: Meses para recuperar el CAC (`CAC / (ARPU * Gross Margin)`).

### 1.3. Presupuesto y Canales (Channel Mix)
*   **`total_marketing_budget`**: Presupuesto total asignado por Finanzas.
*   **Desglose por Canal (Spend & ROI expected):**
    *   `social_media_spend` (Meta, TikTok, LinkedIn).
    *   `search_engine_spend` (Google Ads).
    *   `content_marketing_spend` (SEO, Blogs).
    *   `outbound_sales_spend` (Cold Calling, Eventos).
*   **Costos por Canal:**
    *   `cpc_avg` (Costo por Click).
    *   `cpm_avg` (Costo por mil impresiones).
    *   `cpl_avg` (Costo por Lead).

### 1.4. Fidelización y Producto (Product-Led Growth Variables)
*   **`churn_rate_monthly`**: Porcentaje de clientes que cancelan cada mes.
*   **`nps` (Net Promoter Score):** Satisfacción (-100 a 100).
*   **`k_factor` (Viralidad):** Promedio de nuevos usuarios invitados por cada usuario existente (crítico para apps B2C).

---

## 2. Variables Macroeconómicas y de Mercado (Reality Model)

El Agente de Marketing depende fuertemente de externalidades para predecir si una campaña será exitosa o si el CAC se disparará.

### 2.1. Costos de Publicidad Globales
*   **Tendencias de CPM/CPC por Plataforma:**
    *   **Dato Real:** Fluctuaciones históricas (ej. en Q4, durante el Black Friday, los CPMs en Meta suben un 30-50%).
    *   **Impacto:** El Reality Engine debe penalizar el ROI esperado si la simulación cae en temporada alta de anuncios, aumentando el CAC real contra el CAC proyectado por el Agente.

### 2.2. Sentimiento y Demanda del Consumidor
*   **Índice de Confianza del Consumidor (CCI):**
    *   **Dato Real:** OECD Consumer Confidence Index.
    *   **Impacto:** En modelos B2C (ej. venta minorista), una caída en la confianza del consumidor baja drásticamente la tasa de conversión (`visitor_to_mql_rate`), requiriendo más gasto para lograr las mismas ventas.
*   **Tendencias de Búsqueda (Google Trends API):**
    *   **Dato Real:** Volumen relativo de búsquedas sobre el problema que la startup resuelve.
    *   **Impacto:** Define el tamaño del mercado direccionable (TAM) orgánico. Si el producto es "Crypto Wallet" y estamos en Crypto Winter, el interés cae a cero, haciendo que el SEO y el Inbound colapsen.

### 2.3. Competencia (Competitor RAG Data)
*   **Saturación del Mercado y Gasto Competitivo (Share of Voice):**
    *   **Dato Real:** Reportes de la industria sobre la agresividad publicitaria de competidores (inmersos vía embeddings en Vector DB).
    *   **Impacto:** Si un competidor "levanta" una Serie B publicando en TechCrunch, el "Reality Model" inyecta ruido en nuestros propios canales, bajando nuestro CTR temporalmente.

---

## 3. Lógica de Simulación y Disparadores (Triggers)

*   **Trigger de "Burn Rate" de Marketing:** Si el agente gasta agresivamente el presupuesto en un canal (ej. YouTube Ads) pero el *Reality Engine* determina mediante `PgVector` que el nicho de audiencia seleccionado (ej. "Ingenieros de software B2B") no convierte en YouTube, el `CPL` se dispara y se quema presupuesto sin generar SQLs.
*   **Efecto Cascada hacia Finanzas:** Si el `Churn Rate` sube anómalamente un +5% (quizás por una actualización mala detectada por el Agente de IT), el LTV cae en picada. El Agente de Marketing reporta que el ratio LTV:CAC bajó a 1:1 (el peor escenario). El Agente de Finanzas despierta y corta el presupuesto de inmediato para preservar el *Runway*.
*   **Fricción de Fuerza de Ventas (Capacity Limit):** Si Marketing genera 5,000 MQLs con una campaña viral pero Recursos Humanos mantiene un equipo de ventas de solo 2 Account Executives, se crea un *bottleneck*. El Realism Engine desploma el `mql_to_sql_rate` simulando leads abandonados, demostrando la necesidad de alinear agentes.
