# Requirements de Datos: Departamento de Customer Experience (CX Agent)

El Agente de Experiencia del Cliente (CX) es el guardián de la retención. Traduce los esfuerzos de todos los demás departamentos en la probabilidad de que un cliente se quede, compre más, o recomiende el producto.

## 1. Estado Interno (Digital Twin - MongoDB)

### 1.1. Métricas de Satisfacción
*   **`nps_score` (Net Promoter Score):** Rango de -100 a +100.
*   **`csat_score` (Customer Satisfaction Score):** Escala de 1 a 5 basada en interacciones recientes.
*   **`ces_score` (Customer Effort Score):** Qué tan difícil es usar el producto o resolver un problema.
*   **`customer_health_score`**: Índice compuesto (basado en uso de producto, tickets de soporte y encuestas).

### 1.2. Operaciones de Soporte (Support Operations)
*   **`open_support_tickets_count`**: Volumen actual de quejas/problemas.
*   **`average_resolution_time_hours`**: Tiempo promedio para cerrar un ticket.
*   **`first_response_time_minutes`**: Tiempo crítico para apaciguar al cliente.
*   **`support_headcount_capacity`**: Cuántos tickets puede manejar el equipo basándose en datos de RRHH.

### 1.3. Retención y Expansión (Retention Node)
*   **`gross_revenue_retention` (GRR):** Porcentaje de ingresos retenidos sin contar expansiones (Máx 100%).
*   **`net_revenue_retention` (NRR):** Incluye *upsells* y expansiones (Puede ser > 100%).
*   **`churn_rate_monthly`**: Porcentaje de clientes perdidos mes a mes.
*   **`organic_referral_rate`**: Cuántos clientes nuevos llegan recomendados (baja el CAC de Marketing).

---

## 2. Variables Macroeconómicas y de Mercado (Reality Model)

El Agente de CX responde a los estándares de la industria. Lo que hoy es "Excelente", mañana es "El Mínimo Esperado".

### 2.1. Benchmarks de la Industria (RAG from Vector DB)
*   **NPS y Churn Promedio por Sector:**
    *   **Dato Real:** Reportes anuales de Retently o Zendesk CX Trends.
    *   **Impacto:** Si la empresa simulada es de Telecomunicaciones (NPS promedio real = 31) lograr un NPS de 40 es un éxito masivo. Pero si es un B2B SaaS (NPS promedio = 40+), un 31 causa alertas de abandono.

### 2.2. Expectativas de Tiempo de Respuesta
*   **Estándares de Soporte al Consumidor:**
    *   **Dato Real:** Datos vectorizados sobre los SLAs esperados por el mercado.
    *   **Impacto:** Si el `first_response_time_minutes` simulado es de 24 horas, pero el mercado asume respuestas por Chatbot en 5 minutos, el `ces_score` (esfuerzo del cliente) colapsa, disparando el Churn de manera exponencial ante cualquier bug mínimo soltado por R&D.

### 2.3. Sensibilidad al Precio (Price Elasticity of Demand)
*   **Inflación vs. Percepción de Valor:**
    *   **Dato Real:** IPC (Índice de Precios al Consumidor).
    *   **Impacto:** Si la startup aplica un *Price Hik* (Aumento de precios) del 20% en medio de una economía en recesión inyectada por el Reality Engine, el Agente de CX debe modelar una fuga inmediata de los usuarios en el cuartil de ingresos más bajos, superando violentamente las proyecciones estáticas del Agente Financiero.

---

## 3. Lógica de Simulación y Disparadores (Triggers)

*   **Trigger de "Escala Rota" (The Support Avalanche):** Marketing lanza una campaña viral ("Freemium Tier"). Entran 100,000 usuarios nuevos en 1 semana. El producto tiene bugs (`product_quality_index` bajo reportado por R&D).
    *   **Efecto:** Se generan 10,000 tickets de soporte. El `support_headcount_capacity` es para 500. El `average_resolution_time_hours` pasa de 2 horas a 14 días. El NPS cae a -50.
    *   **Consecuencia en Finanzas:** El `churn_rate` se dispara en el mes 2. El CAC de esos 100k usuarios no se recupera nunca, destruyendo LTV y forzando una revisión del modelo *freemium*.
*   **Trigger del "Efecto Red Positivo" (Negative Churn):** El equipo R&D libera una integración clave (ej. Integración fluida con Salesforce). El Reality Engine dictamina en su RAG que esta *feature* es altamente valorada en el nicho Enterprise.
    *   **Efecto:** El Agente CX reporta un aumento en el `customer_health_score`. El equipo de Customer Success cierra la venta de *Up-Sells* masivamente, logrando un `Net Revenue Retention` de 120%. Finanzas reporta a los Inversores (Usuario) que la startup es candidata a Unicornio debido a sus unit economics superiores.
