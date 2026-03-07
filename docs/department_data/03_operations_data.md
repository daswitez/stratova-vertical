# Requirements de Datos: Departamento de Operaciones y Cadena de Suministro (Operations / Supply Chain Agent)

Este documento estructura el modelo de datos para las áreas de Operaciones y Supply Chain. En nuestro Digital Twin empresarial, este agente define el límite físico o digital de lo que la empresa es capaz de entregar, balanceando el costo marginal contra el nivel de servicio.

## 1. Estado Interno (Digital Twin - MongoDB)

### 1.1. Capacidad y Producción (Production Node)
*   **`max_production_capacity_units`**: El límite duro de producción por mes (aplica a físicos o a tickets de soporte en digital).
*   **`current_production_units`**: Nivel actual operando.
*   **`capacity_utilization_rate`**: `current / max` (Si pasa del 95%, los costos por fallos o sobretiempos explotan).
*   **`average_process_time_hours`**: Tiempo promedio para completar un ciclo de producción/servicio.
*   **`uptime_percentage`**: 99.9% en SaaS o días sin paradas en fábricas.
*   **`capex_requirements`**: Inversión en capital (servidores comprados, maquinaria) necesaria para aumentar el `max_production_capacity_units`.

### 1.2. Gestión de Inventarios (Inventory Node)
*(Nota: Para empresas SaaS puras, el "inventario" se modela como "capacidad ociosa de servidores computacionales")*.
*   **`raw_material_inventory_value`**: Materia prima en bodega.
*   **`work_in_progress_value` (WIP)**: Productos a medio hacer.
*   **`finished_goods_inventory`**: Productos listos para venta.
*   **`inventory_holding_cost_rate`**: Costo de almacenar (seguros, obsolescencia, espacio físico).
*   **`stockout_events_count`**: Veces que Marketing vendió algo que Operaciones no tenía (impacta el NPS y genera quejas).

### 1.3. Proveedores y Logística (Vendor Management Node)
*   **`supplier_lead_time_days`**: Cuánto tarda el proveedor B2B en entregarnos insumos desde la orden de compra.
*   **`supplier_reliability_score` (0-100)**: Probabilidad de que el proveedor entregue tarde o defectuoso.
*   **`shipping_cost_per_unit`**: Costo logístico de última milla al cliente.
*   **`return_rate`**: Porcentaje de productos devueltos por defectos (Logística inversa).

---

## 2. Variables Macroeconómicas y de Mercado (Reality Model)

El Agente de Operaciones es extremadamente sensible a disrupciones geopolíticas y variaciones en materias primas.

### 2.1. Costos de Energía y Commodities
*   **Precios Spot del Petróleo / Gas (Brent, WTI):**
    *   **Dato Real:** CME Group o EIA API.
    *   **Impacto:** Para empresas logísticas (Amazon-like simuladas), un alza en el crudo destruye el margen bruto (`shipping_cost_per_unit` sube) a menos que trasladen el precio al cliente (lo cual baja la demanda de Marketing).
*   **Índice de Materias Primas Industriales:**
    *   **Dato Real:** S&P GSCI (Goldman Sachs Commodity Index).
    *   **Impacto:** Afecta a empresas manufactureras aumentando el valor del `raw_material_inventory` inicial y subiendo los COGS a futuro.

### 2.2. Riesgo en la Cadena de Suministro Global
*   **Índice de Presión de la Cadena de Suministro (GSCPI):**
    *   **Dato Real:** Global Supply Chain Pressure Index (FED de NY).
    *   **Impacto:** Si la simulación inyecta un evento "Bloqueo de Canal de Suez" o "Pandemia", este índice se dispara. El Reality Engine aumenta el `supplier_lead_time_days` en un 300%. La startup se queda sin `finished_goods`, no puede facturar y entra en crisis de caja.
*   **Costos de Flete Marítimo/Aéreo:**
    *   **Dato Real:** Freightos Baltic Index (FBX).
    *   **Impacto:** Subidas abruptas del contenedor reducen los márgenes o fuerzan el "Nearshoring" (cambio a proveedores locales más caros pero seguros).

### 2.3. Resiliencia de Infraestructura Digital (Para SaaS)
*   **Costo Promedio Constante de Cloud Computing (AWS/GCP/Azure):**
    *   **Dato Real:** Precios históricos de cómputo en la nube.
    *   **Impacto:** Si hay escasez de chips (GPUs para IA), los costos de servidor se disparan.

---

## 3. Lógica de Simulación y Disparadores (Triggers)

*   **Trigger del "Cuello de Botella" (Bottleneck):** Si Marketing triplica las ventas con una súper campaña, pero Operaciones tenía el `max_production_capacity_units` fijo (porque el Agente Financiero denegó el presupuesto para abrir otra fábrica / contratar más servidores), la demanda no se puede satisfacer.
*   **Efecto:** El sistema registra un "Stockout". Las ventas se bloquean, el `customer_churn_rate` (CX Agent) se eleva masivamente por promesas incumplidas, y el dinero gastado en la campaña de Marketing se desperdicia, causando pérdidas reales.
*   **Trigger de Proveedor Caído:** El Motor de Realidad probabilísticamente "quiebra" a un proveedor clave asiático de la simulada basándose en fallas históricas (RAG de reportes de crisis). Operaciones se queda sin stock en 45 días obligando al usuario a pivotar a emergencias (pagando Flete Aéreo en lugar de Marítimo, destruyendo el margen).
