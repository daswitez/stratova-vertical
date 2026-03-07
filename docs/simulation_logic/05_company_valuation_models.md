# Modelos de Valoración de la Empresa y Simulación del Precio de la Acción

Para que el simulador sea una herramienta de decisión ejecutiva real (Especialmente en escenarios de Startups, M&A en Holdings y Competencias Universitarias), la "Puntuación Final" no puede ser un número arbitrario. Debe reflejar la **Valoración de la Empresa (Valuation)** o el **Precio por Acción (Stock Price)**.

Dado que hemos definido un modelo multi-agente rico en datos, el cálculo del valor de la empresa debe ser una función que integre los resultados (outputs) de todos los departamentos, penalizados o potenciados por el contexto macroeconómico.

---

## 1. Simulación Dinámica del Precio de la Acción (Stock Price Valuation)

Para modelar dinámicamente el precio de la acción, el **Reality Engine** debe calcular el *Enterprise Value (EV)* y transformarlo a *Equity Value* para luego dividirlo por el número de acciones en circulación. No usaremos un solo modelo rígido, sino un enfoque híbrido dependiendo del ciclo de vida de la empresa simulada.

### A. La Fórmula Composite de Valoración (Solveria Composite Valuation)

La fórmula pondera tres metodologías financieras clásicas, ajustadas por los *scores* de los Agentes No-Financieros (Riesgo, HR, Legal).

#### Componente 1: Valoración por Múltiplos (Relative Valuation)
*Ideal para Startups en etapa de Crecimiento (Growth) o SaaS B2B.*
*   **Base (Agente Financiero):** `Annualized Recurring Revenue (ARR)` o `EBITDA`.
*   **Múltiplo de Mercado (Reality Engine - Macro):** Se extrae vía API/PgVector el múltiplo actual del sector (Ej. "Software B2B Cloud = 8x ARR", "Retail = 12x EBITDA").
*   **Ajuste por Crecimiento (Agente de Marketing):** Si el crecimiento (YoY Growth Rate) de nuestra startup simulada es del 100% (el doble del mercado), el múltiplo base de 8x se incrementa (premium) a 12x. Si se estanca, se castiga a 4x.
*   **Cálculo:** `Base_Valor = ARR * Múltiplo_Ajustado`

#### Componente 2: Flujos de Caja Descontados (DCF - Discounted Cash Flow)
*Ideal para Empresas Maduras (Holdings) con flujos predecibles.*
*   **Flujos Futuros (Agente Financiero + Marketing):** Proyección de Cash Flow libre para los próximos 5 años (simulados estadísticamente).
*   **Tasa de Descuento / WACC (Reality Engine + Agente de Riesgo):** 
    *   La *Risk-Free Rate* actual (Ej. 4% Bonos del Tesoro EE.UU).
    *   **PENALIZACIÓN DEL AGENTE DE RIESGO:** Si el Agente Legal reporta demandas pendientes, o el Agente de Riesgo reporta alta `geo_concentration_index`, la "Prima de Riesgo" sube drásticamente (ej. del +5% al +15%).
*   **Impacto:** Un WACC alto destruye la valoración DCF. Esto obliga al usuario a no solo buscar ventas, sino a **mitigar el riesgo**.

### B. Síntesis y Precio de la Acción

1.  **Enterprise Value (EV):** Peso de 60% Múltiplos + 40% DCF (ajustable por industria).
2.  **Equity Value:** `EV - Deuda Total (Agente Financiero) + Efectivo (Agente Financiero)`.
3.  **Precio de la Acción (Stock Price):** `Equity Value / shares_outstanding`.

---

## 2. Los Modificadores Intangibles (El impacto real de los otros Agentes en la Acción)

En el mundo real, los mercados de valores sobre-reaccionan a las noticias (Sentimiento). El Reality Engine aplica un **"Sentiment Multiplier" (0.5x a 1.5x)** al Precio de la Acción calculado, basado en los demás departamentos:

1.  **CX Agent (Experiencia):** Si el `NPS` cae de 50 a -10 (ej. Crisis de soporte), el motor aplica un modificador de -15% a las proyecciones futuras, tumbando la acción el mismo "trimestre simulado".
2.  **R&D Agent (Innovación):** Si la empresa lanza un producto revolucionario antes que la competencia y es adoptado, el sistema inyecta un "Hype Premium" temporal (+20% a la acción) que debe ser sostenido con ventas reales luego.
3.  **HR Agent (Cultura):** Huelgas o un `attrition_rate` sostenido > 25% anual se traduce financieramente en "riesgo de ejecución operativa", subiendo el WACC y bajando la valoración un 10%.
4.  **Legal Agent (Scandals):** Si el Reality Engine detona un Cisne Negro legal (ej. "Filtración de Datos"), la acción recibe un "Gap Down" inmediato de -25% (simulando pánico del mercado), antes siquiera de que Finanzas pague las multas.

**El usuario aprende así que maximizar ventas arruinando la satisfacción del empleado o violando leyes reduce el precio de sus acciones por el incremento masivo de riesgo sistémico.**

---

## 3. Modelos de Evaluación Alternativos ("Win Conditions")

El Precio de la Acción es la métrica principal para corporaciones públicas simuladas o para calcular el ROI de un Venture Capital. Sin embargo, Solveria debe ofrecer otros marcos de evaluación (Rúbricas), especialmente útiles en Competencias Universitarias o perfiles altruistas.

### A. Evaluación "Híper-Crecimiento" (Silicon Valley Model)
*   **Métrica Estrella:** Dominio de Mercado (Market Share) y Crecimiento Mensual (MoM Growth).
*   **Regla:** Sobrevivir quemando caja. No importa si el `Net Income` es -$50M, siempre y cuando el LTV/CAC sea > 3 y el `Market Share` crezca a doble dígito mensual.
*   **Caso de Uso:** Simular el nacimiento de Uber u OpenAI.

### B. Evaluación "Bootstrapped / SME" (Rentabilidad Sostenible)
*   **Métrica Estrella:** Retorno sobre el Capital Invertido (ROIC) y *Cash Flow Positivo*.
*   **Regla:** Crecimiento financiado 100% por los propios clientes. El Agente Financiero es la máxima autoridad.
*   **Caso de Uso:** Pequeñas y medianas empresas o agencias donde la dilución de acciones mediante inversores externos está bloqueada en la configuración.

### C. Evaluación de Sostenibilidad / ESG (Environmental, Social, and Governance)
*   **Métrica Estrella:** El "ESG Impact Score".
*   **Regla:** El éxito financiero no basta.
    *   *Governance (Legal/Risk Agents):* Auditorías limpias, transparencia, políticas justas.
    *   *Social (HR/CX Agents):* Cero *burnout*, 50% de diversidad, salarios por encima del mercado, NPS altísimo.
    *   *Environment (Operations Agent):* Emisiones de carbono de la cadena de suministro minimizadas.
*   **Penalización:** El simulador inyecta un "Carbon Tax" o prohíbe ventas institucionales si el Score ESG es bajo. Una alta puntuación ESG baja el costo de deuda corporativa (Green Bonds).

### D. La Rúbrica de la "Bancarrota Esquivada" (Turnaround Model)
*   **Métrica Estrella:** Supervivencia (Meses fuera del *Default* crediticio).
*   **Regla:** El usuario hereda una empresa simulada ya en llamas (Deuda altísima, moral nula de HR, NPS destructivo). El éxito es llegar al Mes 12 sin que el Agente Legal declare insolvencia Capítulo 11.
*   **Caso de Uso:** Entrenamiento avanzado de gestión de crisis (Restructuring).
