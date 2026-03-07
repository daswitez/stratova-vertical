# Requirements de Datos: Departamento Legal y Compliance (Legal Agent)

El Agente Legal actúa como el guardián o "Guardrail" del resto de los agentes. Su función no es maximizar el valor directamente, sino evitar eventos de "Cisne Negro" (quiebra por demandas, multas regulatorias catastróficas o pérdida de propiedad intelectual).

## 1. Estado Interno (Digital Twin - MongoDB)

### 1.1. Perfil Corporativo y Propiedad Intelectual
*   **`jurisdiction_of_incorporation`**: País/Estado base (ej. Delaware, UK, España). Define bajo qué leyes opera el Motor de Realidad.
*   **`corporate_structure`**: LLC, C-Corp, Holding.
*   **`patents_owned_count`**: Número de patentes activas (protege a R&D y permite monopolio temporal simulado).
*   **`trademarks_registered`**: Marcas registradas.
*   **`ip_vulnerability_score`**: Riesgo de que la tecnología principal sea clonada legalmente por competidores.

### 1.2. Riesgo Regulatorio y Compliance (Compliance Node)
*   **`data_privacy_compliance_status`**: Booleano o nivel de madurez (GDPR, CCPA).
*   **`financial_compliance_status`**: SOX (Ley Sarbanes-Oxley), SOC2, PCI-DSS (dependiendo del sector).
*   **`labor_law_compliance_score`**: Nivel de cumplimiento de leyes laborales locales (contratos, horas extra).
*   **`pending_lawsuits_count`**: Demandas activas (drenan recursos y reputación).
*   **`estimated_legal_liability_usd`**: Dinero reservado por Finanzas para pagar posibles juicios perdidos.

### 1.3. Contratos y Obligaciones
*   **`active_enterprise_contracts`**: Acuerdos con SLAs (Service Level Agreements) rígidos.
*   **`average_contract_lock_in_months`**: Tiempo que los clientes no pueden irse legalmente.
*   **`contract_breach_risk_percentage`**: Probabilidad de que Operaciones falle un SLA, desencadenando multas contractuales.

---

## 2. Variables Macroeconómicas y de Mercado (Reality Model)

El entorno legal no es una API numérica simple; depende del procesamiento de lenguaje natural (RAG) sobre leyes reales y la "temperatura" política del momento.

### 2.1. Corpus Legal y "Case Law" (Motor RAG con PgVector)
*   **Actualizaciones Regulatorias:**
    *   **Dato Real:** Textos crudos de la SEC, FTC, Comisión Europea (ej. *AI Act*, Demandas Antimonopolio).
    *   **Impacto:** Si la empresa simulada es una "Red Social" y Europa aprueba una nueva ley de privacidad estricta en el Motor de Realidad, el Agente Legal alerta inmediatamente que el `data_privacy_compliance_status` pasó a "Fallo Critico". Obliga a Finanzas y R&D a gastar $500k en adaptar el software o enfrentar multas del 4% del Revenue.
*   **Resolutivo de Juicios de la Industria (Precedentes):**
    *   **Dato Real:** Scraping pasivo de resoluciones (ej. "Epic Games vs Apple").
    *   **Impacto:** El Reality Engine busca embeddings similares a nuestro modelo de negocio para inyectar riesgos latentes que el usuario no había considerado.

### 2.2. Temperatura Política y Aranceles
*   **Geopolítica y Barreras Comerciales:**
    *   **Dato Real:** Alertas arancelarias (ej. "Nuevos aranceles del 25% a acero Chino" del USTR).
    *   **Impacto:** Si Operaciones simulaba traer servidores de China, el Agente Legal (conectado al macroentorno) intercepta la orden de importación y advierte del costo catastrófico oculto.

### 2.3. Costos de Litigio (Litigation Costs)
*   **Tarifas de Firmas de Abogados Tier 1:**
    *   **Dato Real:** El costo promedio por hora de honorarios legales corporativos en jurisdicciones top (Nueva York, Londres).
    *   **Impacto:** Los juicios largos son "sumideros de caja". Si la startup entra en litigio, el Agente Financiero debe crear una retención de capital masiva.

---

## 3. Lógica de Simulación y Disparadores (Triggers)

*   **Trigger de "Auditoría Fallida" (Due Diligence Check):** El CEO (Usuario) pide al Agente Estratégico vender la empresa a un holding por $50M. El Reality Engine ejecuta el "Due Diligence". Descubre que el `labor_law_compliance_score` es bajísimo porque RRHH clasificó mal a 100 empleados como "contratistas". La venta se cae y la valoración baja un 30%.
*   **Trigger del "Incumplimiento de SLA" (Operaciones vs. Legal):** Operaciones sufre un apagón (`uptime` cae a 98%). El Agente Legal escanea los `active_enterprise_contracts` y calcula automáticamente que la empresa debe $1.2M en reembolsos obligatorios a clientes B2B, inyectando un castigo directo al P&L del Agente Financiero.
*   **El "Veto" Legal (Guardrail Function):** Marketing quiere lanzar una campaña agresiva haciendo web scraping de datos de menores de edad. El Agente Legal evalúa la acción contra el corpus GDPR, calcula una probabilidad de multa del 95% y emite un veto (bloqueo automático) o exige aprobación manual explícita del usuario asumiendo el riesgo penal.
