# Template de Registro de Decisiones de Arquitectura (ADR)
# Architecture Decision Record

Este directorio (`docs/architecture/decision_records/`) almacenará el historial inmutable de las decisiones drásticas de diseño. Cada vez que cambiemos un paradigma (por ejemplo, pasar de MySQL a Postgres, usar WebSockets en vez de SSE o elegir Redis para Rate Limiting), se debe crear un archivo numerado aquí.

## Estructura Base de un ADR (.md)

Cada nuevo archivo debe llamarse `ADR-XXX_titulo_corto.md` (Ej: `ADR-001_usar_pgvector_para_rag.md`) y contener este formato exacto:

```markdown
# ADR-000: [Título de la Decisión]

**Fecha:** YYYY-MM-DD
**Estado:** [Propuesto | Aceptado | Rechazado | Deprecado | Reemplazado por ADR-XXX]
**Autores/Aprobadores:** [Tu Nombre / Equipo Arquitectura]

## 1. Contexto y Problema
[Describe el contexto actual. ¿Qué problema técnico o de negocio estamos intentando resolver? ¿Por qué la solución actual ya no es suficiente?]

## 2. Decisión Tomada
[Describe claramente qué opción tecnológica, patrón o herramienta se ha elegido para solucionar el problema].

## 3. Justificación (¿Por qué?)
[Enumera los motivos técnicos o de negocio que llevaron a esta decisión. ¿Qué alternativas se descartaron y por qué (costo, curva de aprendizaje, latencia, soporte)?]

## 4. Consecuencias (Trade-offs)
- **Positivas:** [Ej. Aumenta la velocidad de lectura en un 300%].
- **Negativas / Riesgos:** [Ej. Añade complejidad al CD/CI, requiere aprender una nueva tecnología].

## 5. Referencias
- [Links a documentación, issues de GitHub, pruebas de concepto].
```

---

## Índice Actual de Decisiones (A actualizar)

- **ADR-001:** Transición de Simulación Matemática Determinista a Simulación Dual IA con DeepSeek. *(Estado: Aceptado)*.
- **ADR-002:** Segregación de BD: PostgreSQL (Identity), MongoDB (Estado Eventos), PgVector (RAG), Redis (Memoria Corta). *(Estado: Aceptado)*.
- **ADR-003:** Comunicación Asíncrona Aislada entre Agentes utilizando MongoDB Change Streams en lugar de API REST directa. *(Estado: Aceptado)*.
