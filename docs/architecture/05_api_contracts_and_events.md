# Estrategia de Contratos API y Eventos Asíncronos

**Solveria SSSP** pasa de ser un monolito simple a una red de agentes independientes (Microservicios Hexagonales). Cuando un Agente Financiero necesita un dato del IAM, o el Mercado necesita avisarle a todos que el dólar subió, lo hacen a través de fronteras bien definidas.

Esta guía documenta cómo nos aseguramos de que esas fronteras no se rompan y causen incidentes en producción.

---

## 1. Contratos Síncronos (REST API + Pact)

Cuando existe una comunicación HTTP/REST síncrona (ej. El `ai-service` va al `iam-service` a preguntar "Este token JWT, ¿es válido y le pertenece a un administrador?").

- **Consumer-Driven Contracts:** Usamos **Pact** para Spring Boot.
  - El "Consumidor" (quien hace la petición, ej. `ai-service`) escribe un Unit Test simulando lo que espera del Servidor (IAM).
  - Este test genera un JSON (El Contrato).
  - El "Proveedor" (IAM) lee ese contrato durante su build de Maven y el framework se auto-dispara contra sí mismo para garantizar que su controlador sigue devolviendo exactamente el JSON (campos, enteros, booleanos) que el otro servicio esperaba.

**Regla de Oro:** Ningún microservicio puede hacer deploy a producción si rompe un contrato pactado previamente.

---

## 2. Comunicación Asíncrona (Event Bus & Change Streams)

El gran diferenciador de **Solveria** es que los agentes reaccionan pasivamente a eventos. La comunicación asíncrona es la columna vertebral de la **Simulación Dual**.

### El Patrón Event-Driven

No usamos peticiones REST para decirle al Agente de Finanzas "Por favor revisa el balance de la empresa".
Utilizamos la estrategia de **Change Data Capture (CDC) / Event Sourcing:**

1.  **Emisor:** Un Agente o un Humano inyecta un documento a **MongoDB** (Ej. `"id": 12, "action": "Marketing Campaign launch", "budget_used": 50000`).
2.  **Broker / Stream:**
    - Opción A (Local): **MongoDB Change Streams**. Un hilo bloqueante de Java escucha inserciones en la colección `decisions`.
    - Opción B (Scale AWS): **Amazon EventBridge** / **Kafka**. La inserción en mongo gatilla una lambda o un tópico de Kafka.
3.  **Consumidor (Aislado):** El *Reality Engine* (`simulation-service`) está escuchando el tópico. Cuando llega el evento, extrae la data, simula el fracaso o éxito con **DeepSeek** + **PgVector**, y vuelve a insertar el nuevo estado financiero en la Base de Datos.
4.  **Segundo Consumidor:** Esto gatilla un evento `FinancialStateMutatedEvent`. El *Agente de Finanzas* lo atrapa, genera el Excel de resultados y manda el correo al usuario humano.

### Estructura del Evento (Standard Cloudevents)

Todos los JSON gatillados asíncronamente deben respetar la especificación *CloudEvents* o una variante estandarizada de la empresa:

```json
{
  "eventId": "f47ac10b-58cc-4372-a567-0e02b2c3d479",
  "eventType": "company.finance.cashflow.mutated",
  "timestamp": "2026-03-03T20:45:00Z",
  "tenantId": "univ-harv-001",
  "simulationId": "sim-2026-s1",
  "payload": {
    "previous_cash": 100000,
    "new_cash": 50000,
    "trigger_agent": "Reality_Engine"
  }
}
```

**Regla de Oro del Event Bus:** Los publicadores (Publishers) NUNCA saben quién es el consumidor de sus eventos. Simplemente tiran el pan al río. Y los Listeners (Subscribers) NUNCA pueden enviar un "HTTP 200 OK" de vuelta al publicador; su única respuesta es efectuar su trabajo de forma silenciosa e independiente.
