# Diagrama de Interacción Dual de IA (Flujo Basado en Eventos)

Este diagrama ilustra paso a paso cómo interactúa el bando corporativo (Agentes Predictivos) con el Mercado (Motor de Realidad) de forma totalmente asíncrona a través de un estado central (MongoDB), utilizando **DeepSeek** como motor cognitivo.

```mermaid
sequenceDiagram
    autonumber
    
    %% Definición de Participantes con estilos claros y de alto contraste
    actor User as Usuario / Estratega
    
    box #e3f2fd "AI Predictor (Agentes Corporativos - Aislados)"
    participant Ag_Mkt as Agente Marketing
    participant Ag_Fin as Agente Finanzas
    end
    
    box #ffecb3 "Estado Central & Eventos"
    participant Mongo as MongoDB (Estado)
    participant Bus as Event Bus / Triggers
    end
    
    box #f3e5f5 "Reality Simulation Engine (El Mercado)"
    participant Reality as Modelo de Realidad
    participant VectorDB as PgVector (Mercado)
    end
    
    box #e8f5e9 "Provider"
    participant DeepSeek as DeepSeek API
    end

    %% Secuencia de Eventos
    Note over User, Ag_Mkt: Fase 1: La Decisión del Predictor
    User->>Ag_Mkt: "Lanzar campaña en TikTok por $50k USD"
    Ag_Mkt->>DeepSeek: Prompt: Estimar ROI proyectado para la campaña
    DeepSeek-->>Ag_Mkt: Respuesta: "Excelente idea, ROI esperado del 120%"
    Ag_Mkt->>Mongo: Escribe Acción: 'Lanzamiento Campaña' (Status: Pendiente de Entorno)
    
    Note over Mongo, Bus: Fase 2: El Trigger Asíncrono
    Mongo-->>Bus: Emite Evento: Nueva Acción Estratégica
    
    Note over Bus, Reality: Fase 3: Evaluación de la Realidad contra Acción
    Bus->>Reality: Wake Up: Evaluar 'Lanzamiento Campaña'
    Reality->>VectorDB: RAG Search: Contexto actual de TikTok, CAC, Competencia
    VectorDB-->>Reality: Retorna: "Saturación alta, CAC subió 40% este Q"
    Reality->>DeepSeek: Prompt Adversario: Usando este contexto, calcula resultado real de la acción
    DeepSeek-->>Reality: Respuesta: "Fracaso relativo. Solo 30% conversión lograda"
    
    Note over Reality, Mongo: Fase 4: Impacto en Estado / Mutación
    Reality->>Mongo: Escribe Resultado Real: 'Pérdida de Presupuesto, Ingresos Menores' (Update Docs)
    
    Note over Mongo, Ag_Fin: Fase 5: Reacción de Agentes Aislados
    Mongo-->>Bus: Emite Evento: Estado Financiero Alterado (Caída de Caja)
    Bus->>Ag_Fin: Wake Up Crítico: Analizar nuevo Estado
    Ag_Fin->>Mongo: Lee JSON completo del P&L
    Mongo-->>Ag_Fin: Retorna Data
    Ag_Fin->>Ag_Fin: Rellena Plantilla Excel (.xlsx) con nuevo Flujo de Caja
    Ag_Fin->>DeepSeek: Prompt: Resume este json para un email de alerta corta
    DeepSeek-->>Ag_Fin: Respuesta: "Alerta: Runway bajó a 2 meses por sobrecosto en marketing"
    
    Note over Ag_Fin, User: Fase 6: Notificación Asíncrona
    Ag_Fin->>User: Envía Email Automático con .xlsx adjunto y Resumen AI
```

## Explicación Visual del Flujo

1. **Aislamiento Absoluto:** Observa que el *Agente de Marketing* y el *Agente de Finanzas* nunca cruzan una flecha entre sí. No se hablan por API.
2. **El "Predictor" (Mentira Corporativa):** El Agente de Marketing, usando su propio conocimiento, cree que la campaña será un existo total (Paso 3).
3. **El "Reality Engine" (El Golpe de Realidad):** Se despierta asíncronamente solo cuando hay una Inyección a la Base de Datos. Consulta su Vector DB externa y descubre que el mercado está en peores condiciones. Aplasta el hiper-optimismo de Marketing simulando métricas reales frustrantes (Paso 9).
4. **Respuesta Basada en Eventos:** Finanzas dormía hasta que el Motor de Realidad arruinó los números en la Base de Datos. Solo cuando el *Event Bus* detecta una caída de caja, Finanzas despierta para avisar al humano, generando el Excel directamente sin intervención (Paso 16 y 17).
