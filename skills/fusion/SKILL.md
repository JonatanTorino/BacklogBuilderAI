---
name: fusion
description: >
  Integra las respuestas del usuario/stakeholders a los gaps identificados en la
  síntesis, produciendo un documento consolidado en Markdown listo para generar el
  Documento de Alcance. Toma el archivo de síntesis anotado, resuelve ambigüedades
  con el nuevo contexto, y cierra o preserva cada pregunta abierta según corresponda.
  Usar este skill cuando el usuario mencione "fusionar", "integrar respuestas",
  "fusion", "incorporar feedback a la síntesis", "continuar después de la síntesis"
  o "aplicar Prompt-02".
---

# Skill: fusion

## Descripción

Integra las respuestas del usuario/stakeholders a los gaps identificados en la síntesis, produciendo un documento consolidado y enriquecido que servirá como base para el Documento de Alcance y la User Story.

## Cuándo invocar

Invocar este skill cuando el usuario mencione:
- "fusionar"
- "integrar respuestas"
- "fusion"
- "incorporar feedback a la síntesis"
- "continuar después de la síntesis"
- "aplicar Prompt-02"

## Instrucciones

1. **Identificar el archivo de síntesis con anotaciones**:
   - Solicitar la ruta del archivo de síntesis que el usuario ya anotó con sus respuestas a los gaps (formato: `YYYYMMDD.01.Sintesis.[Tópico].md`).
   - Si el usuario no proporcionó ruta, preguntar: "¿Cuál es el archivo de síntesis con tus respuestas anotadas?"

2. **Leer el archivo de síntesis anotado** con el Read tool.

3. **Leer el prompt de fusión**: Leer `./Prompt-02-FusionRespuestas.md`.

4. **Ejecutar la fusión**: Aplicar el prompt sobre el documento de síntesis con anotaciones para:
   - Integrar las respuestas a los gaps en el análisis.
   - Resolver ambigüedades usando el nuevo contexto provisto.
   - Producir un documento consolidado y completo en **Markdown** (no JSON).

5. **Guardar el output** con el Write tool usando la convención:
   ```
   YYYYMMDD.02.Fusion.[Tópico].md
   ```
   - Inferir `[Tópico]` del nombre del archivo de síntesis de entrada.
   - Guardar en el mismo directorio.

6. **Confirmar al usuario** que el documento de fusión está listo para continuar con `scope-doc`.

## Output esperado

Archivo Markdown con el análisis consolidado, integrando los insumos originales y las respuestas a los gaps.

Nombre de ejemplo: `20260318.02.Fusion.VisibilidadUI.md`

> **Nota**: El output es Markdown estructurado, NO JSON.
