---
name: tarjeta-us
description: >
  Genera la tarjeta de User Story final en formato Markdown lista para Azure DevOps
  (ADO), siguiendo los principios INVEST y BDD. Consolida todos los insumos del
  pipeline (síntesis, fusión, scope doc) y produce título, descripción rol/necesidad/
  valor, y criterios de aceptación en formato Given-When-Then (AC-01, AC-02...).
  Usar este skill cuando el usuario mencione "propuesta de user story", "tarjeta ADO",
  "user story card", "tarjeta US", "generar user story", "crear tarjeta" o
  "aplicar Prompt-Propuesta-UserStory".
---

# Skill: tarjeta-us

## Descripción

Genera la tarjeta de User Story final en el formato requerido para Azure DevOps (ADO), consolidando todos los insumos procesados del pipeline: síntesis, fusión, scope doc y contexto adicional.

## Cuándo invocar

Invocar este skill cuando el usuario mencione:
- "propuesta de user story"
- "tarjeta ADO"
- "user story card"
- "tarjeta US"
- "generar user story"
- "crear tarjeta"
- "aplicar Prompt-Propuesta-UserStory"

## Instrucciones

1. **Identificar los insumos**:
   - Solicitar la ruta del directorio con todos los archivos del pipeline (síntesis, fusión, scope doc, etc.).
   - El skill consolidará todos los `.md` disponibles como contexto.
   - Preguntar el **nombre del tópico** si no se puede inferir.

2. **Leer todos los archivos del directorio** con el Read tool (o Glob + Read para listar y leer cada `.md`/`.txt`).

3. **Leer el prompt de User Story**: Leer `./Prompt-Propuesta-UserStory.md`.

4. **Generar la tarjeta de User Story**: Aplicar el prompt sobre el conjunto de insumos para producir una tarjeta de User Story en **Markdown** con el formato estándar para Azure DevOps:
   - **Título** de la User Story.
   - **Como** [rol] **quiero** [funcionalidad] **para** [beneficio].
   - **Descripción** detallada.
   - **Criterios de Aceptación** (Gherkin o lista numerada).
   - **Notas técnicas** y dependencias.
   - **Definition of Done** si aplica.

5. **Guardar el output** con el Write tool usando la convención:
   ```
   YYYYMMDD.04.TarjetaUS.[Tópico].md
   ```
   - Guardar en el mismo directorio de los insumos.

6. **Confirmar al usuario** que la tarjeta está lista y puede copiarse a Azure DevOps.

## Output esperado

Archivo Markdown con la User Story completa y lista para subir a ADO.

Nombre de ejemplo: `20260318.04.TarjetaUS.VisibilidadUI.md`
