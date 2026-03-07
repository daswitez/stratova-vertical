# Requirements de Datos: Departamento de R&D y Tecnología (R&D / Tech Agent)

El Agente de Investigación y Desarrollo (R&D) y Tecnología es el motor de la innovación. Determina qué productos puede vender Marketing, su calidad, y la infraestructura que soporta a Operaciones. Es una función intensiva en capital y tiempo continuo.

## 1. Estado Interno (Digital Twin - MongoDB)

### 1.1. Portafolio de Productos y Features
*   **`active_products_count`**: Cantidad de productos vivos en el mercado.
*   **`product_technical_debt_score`**: La deuda técnica acumulada (0-100). Si sube de 80, cada nuevo "feature" tarda el triple en programarse y el `product_uptime` baja, lo cual destruye el NPS.
*   **`feature_backlog_size`**: Requisitos que Comercial quiere pero TI aún no construye.
*   **`product_quality_index`**: Un score interno que impacta la tasa de conversión orgánica en Marketing.

### 1.2. Recursos de Desarrollo (Development Resources)
*   **`rd_monthly_budget`**: Presupuesto total asignado a servidores R&D, herramientas y nómina técnica.
*   **`engineering_velocity_points`**: La capacidad de entrega del equipo de ingeniería (basado en el talento reclutado por HR).
*   **`time_to_market_months`**: Meses proyectados para lanzar un producto desde que se aprueba el presupuesto.
*   **`innovation_vs_maintenance_ratio`**: % del tiempo dedicado a crear cosas nuevas vs. arreglar bugs. (Idealmente 70/30. Si es 10/90, la empresa se estanca).

### 1.3. Seguridad y Riesgo Tecnológico
*   **`cybersecurity_posture_score`**: Inversión en seguridad. Si es baja, la probabilidad de un hackeo simulado (Cisne Negro) aumenta drásticamente.
*   **`data_breach_probability`**: Riesgo porcentual de sufrir filtraciones de datos.
*   **`infrastructure_resilience_level`**: Capacidad técnica para absorber picos de tráfico (ej. un video viral de Marketing).

---

## 2. Variables Macroeconómicas y de Mercado (Reality Model)

El Agente Tech interactúa con el ritmo real de avance tecnológico del mundo.

### 2.1. Ciclo de Hype Tecnológico (Gartner Hype Cycle)
*   **Adopción de Nuevas Tecnologías:**
    *   **Dato Real:** Curvas de adopción (ej. Generative AI, Spatial Computing). Vectorizadas desde reportes técnicos vía `PgVector`.
    *   **Impacto:** Si el Agente Estratégico decide invertir el 100% del `rd_monthly_budget` en VR durante el "Trough of Disillusionment" (Valle de la Desilusión), el Reality Engine decreta que Marketing no encontrará mercado (TAM nulo) hasta dentro de 5 años.

### 2.2. Costos de Infraestructura Core (Cloud Pricing)
*   **Precios de Servicios Cloud y Semiconductores:**
    *   **Dato Real:** Precios spot de AWS, costo por token de APIs (OpenAI), escasez de GPUs (Índice de Semiconductores de Philadelphia - SOX).
    *   **Impacto:** Si la empresa simulada es "AI-First", y el costo de inferencia sube un 500% por restricciones globales, el `COGS` (Costo de Ventas) en Finanzas se vuelve insostenible, forzando a R&D a optimizar algoritmos en vez de crear nuevos *features*.

### 2.3. Estacionariedad de la Innovación Competitiva
*   **Velocidad de Funcionalidades de los Competidores (Patent velocity / Feature Parity):**
    *   **Dato Real:** Las bases de datos de RAG contienen "La empresa Y sacó la feature X en 2024".
    *   **Impacto:** Si el Reality Engine detecta que nuestra empresa lleva 2 años sin lanzar una innovación mayor en un mercado de "Fast Movers" (ej. SaaS), el Agente CX reporta un desplome en retención (`churn_rate` se dispara) porque los clientes se van por "obsolescencia tecnológica".

---

## 3. Lógica de Simulación y Disparadores (Triggers)

*   **Trigger de "Deuda Técnica Crítica" (The Refactor Crisis):** Marketing pide lanzar 5 nuevos productos en un año (sobretrabajando al equipo base). R&D lo logra, pero con hacks (código espagueti).
    *   **Efecto:** El `product_technical_debt_score` llega a 95. El próximo mes, el sistema sufre una caída global (Downtime). Las ventas se detienen por 3 días. El Agente CX reporta el peor NPS histórico, y el Agente R&D bloquea *cualquier* iniciativa nueva por 6 meses hasta pagar la deuda técnica (Code Freeze forzado).
*   **Trigger del "Hackeo Catastrófico" (Ransomware):** Finanzas recorta el presupuesto a R&D. R&D despide al equipo de InfoSec y el `cybersecurity_posture_score` baja a "Peligro".
    *   **Efecto:** El Reality Engine tira los dados del riesgo (Monte Carlo). Ocurre un ataque de Ransomware. Los datos de clientes se filtran. El Agente Legal entra en pánico (demandas GDPR aseguradas). El Agente de Marketing pierde toda la confianza del mercado.
*   **Trigger del "Product-Market Fit" Fallido:** R&D pasa 18 meses creando un producto ultra-complejo sin hablar con Marketing. Cuando se lanza, el Reality Engine consulta el RAG y dictamina que "Ese problema ya fue resuelto por la industria hace 1 año". Las ventas son nulas, quemando $2M de presupuesto sin ROI.
