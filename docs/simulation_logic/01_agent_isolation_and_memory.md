# Lógica de Aislamiento de Agentes y Memoria Independiente

Esta documentación detalla el funcionamiento interno y la interacción indirecta de los agentes especializados en Solveria SSSP.

## 1. El Principio de Aislamiento
A diferencia de los enfoques tradicionales multi-agente donde los bots conversan sincrónicamente entre ellos (ej. Agente A llama por API al Agente B), en Solveria **los agentes están completamente aislados**. 

Un agente no requiere saber en qué proceso de pensamiento está el otro. Su única fuente de verdad y comunicación es la **Base de Datos Central (MongoDB / PgVector)**.

## 2. Arquitectura Orientada a Eventos y Estado Compartido
La interacción ocurre porque conviven en el mismo ecosistema de datos:

1. **La Acción (Ej. Marketing):** El usuario o el Agente de Mercado decide lanzar una campaña agresiva en Meta Ads.
2. **Mutación del Estado:** El Agente de Mercado escribe en MongoDB bajo la colección `empresa_state.budgets` que se han consumido $50,000 USD y en `empresa_state.market_expectations` que se espera un incremento del 20% en leads.
3. **Trigger / Evento Auditable:** Este cambio en la Base de Datos dispara un evento (ej. vía Change Streams de MongoDB o Apache Kafka).
4. **Reacción Aislada (Ej. Finanzas):** El Agente Financiero está suscrito a cambios estructurales de presupuesto. Al recibir el evento "Cambio relevante", despierta, lee el nuevo estado unificado, recalculá el Cash-Flow y el Burn Rate de la empresa.

## 3. Emisión de Reportes (Templating & Email)
Los agentes **no escriben notificaciones por todo**, ya que generaría ruido operativo excesivo (fatiga de alertas). Solo despiertan y actúan ante *Cambios Relevantes* pre-definidos por la severidad del evento en el "Modelo de Realidad".

### Flujo de Reportes:
1. **Detección de Umbral:** El Agente Financiero detecta que tras el gasto de Marketing, el Runway de la startup bajó de 6 meses a 2 meses. Es un evento crítico.
2. **Data Fetching:** El agente de Finanzas extrae un JSON completo desde MongoDB.
3. **Llenado de Plantilla:** Se utiliza una plantilla (ej. `.xlsx` generada en Java con Apache POI o una librería similar generada desde JSON) donde se rellenan las hojas de cálculo con el Balance, el P&L (Estado de Resultados) actualizado y los flujos proyectados.
4. **Resumen de la IA:** El mismo agente (LLM) genera un párrafo ejecutivo resumiendo este Excel.
5. **Notificación Push/Email:** El sistema emite un correo al "Director/Usuario" con el asunto: `[ALERTA CRÍTICA FINANZAS] Reducción de Runway por Gasto de Marketing`, adjuntando el `.xlsx`.

## 4. Estructura de Memoria Vectorial
Cada agente mantiene en PgVector/Mongo Atlas Vector Search su propia base de conocimiento corporativa, pero también comparten una memoria episódica global (el registro de todo lo que la empresa "ha vivido" durante la simulación).
