# Workflow de Transformación de Insumos a Backlog con LLMs

Este directorio contiene los prompts optimizados para transformar insumos crudos (documentos de texto, transcripciones, notas) en un backlog estructurado para Azure DevOps. El proceso está diseñado para ser ejecutado en tres etapas secuenciales, cada una con su propio prompt especializado.

## Estructura del Flujo

### 1. Síntesis de Insumos (`Prompt-01-Sintesis.md`)

El primer prompt actúa como un analista de negocio senior, procesando textos no estructurados para:

- Analizar si los insumos contienen uno o múltiples tópicos.
- Generar un resumen ejecutivo cohesivo.
- Extraer características clave y restricciones.
- Identificar gaps de información (ambigüedades, omisiones, **spikes de investigación**, **flujos alternativos no definidos**).
- Proponer reuniones de seguimiento para temas complejos.

**Salida**: Un documento JSON estructurado que incluye `executiveSummary`, `keyFeatures`, `constraintsAndExclusions`, `openQuestions` (con `answer: null`), y `followUpMeetings`.

### 2. Fusión de Respuestas (`Prompt-02-FusionRespuestas.md`)

El segundo prompt actúa como un analista de refinamiento senior, procesando el documento de síntesis anterior y:

- Analiza si el input contiene uno o múltiples tópicos para enfocar el análisis.
- Integra las respuestas proporcionadas a las `openQuestions`.
- Enriquece las secciones principales con la nueva información validada.
- **Si una respuesta es ambigua, refina la pregunta para una nueva iteración.**
- Mantiene los gaps de información pendientes, incluyendo aquellos que requieren más refinamiento.
- Preserva las propuestas de reuniones de seguimiento (`followUpMeetings`).

**Salida**: Un documento JSON refinado que mantiene la misma estructura pero con información validada y una lista actualizada de gaps pendientes.

### 3. Generación de Backlog (`Prompt-03-GeneraciónBacklog.md`)

El tercer prompt combina los roles de Product Owner y Tech Lead para:

- Transformar `keyFeatures` en Historias de Usuario funcionales.
- Crear Historias de Refinamiento específicas para los gaps pendientes (`openQuestions` y `followUpMeetings`).
- Generar tareas técnicas detalladas para cada historia.
- Incluir tareas obligatorias de documentación y revisión.
- Documentar elementos fuera de alcance basados en `constraintsAndExclusions`.

**Salida**: Un backlog estructurado en formato JSON listo para ser importado a Azure DevOps, incluyendo tanto historias funcionales como de refinamiento.

## Características Clave del Flujo

- **Separación de Responsabilidades**: Cada prompt está optimizado para una tarea específica.
- **Gestión de Gaps Iterativa**: Identificación temprana y seguimiento de puntos que requieren clarificación, con soporte para refinamiento en múltiples pasos.
- **Flexibilidad**: Soporta tanto análisis de tópico único como múltiples tópicos relacionados.
- **Trazabilidad**: Mantiene visibilidad de elementos pendientes y decisiones tomadas.

## Uso del Flujo

1. **Etapa de Síntesis**:

   ```bash
   # Usar Prompt-01-Sintesis.md con los insumos crudos
   # Resultado: synthesis_v1.json
   ```

2. **Etapa de Refinamiento**:

   ```bash
   # Completar respuestas en el campo 'answer' de 'openQuestions' en synthesis_v1.json
   # Usar Prompt-02-FusionRespuestas.md
   # Resultado: synthesis_final.json (puede contener nuevas o refinadas 'openQuestions')
   ```

3. **Etapa de Generación de Backlog**:

   ```bash
   # Usar Prompt-03-GeneraciónBacklog.md con synthesis_final.json
   # Resultado: final_backlog.json listo para Azure DevOps
   ```

## Consideraciones

- Los prompts están diseñados para ser usados secuencialmente.
- Cada etapa requiere validación humana antes de proceder.
- El proceso mantiene un balance entre automatización y control humano.
- Los formatos JSON están estandarizados para asegurar compatibilidad entre etapas.
