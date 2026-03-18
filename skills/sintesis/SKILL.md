# Skill: sintesis

## Descripción

Sintetiza múltiples insumos (transcripciones, documentos, resúmenes) desde la perspectiva de un Analista de Negocio, identificando requerimientos, patrones y gaps de información que requieren clarificación antes de proceder.

## Cuándo invocar

Invocar este skill cuando el usuario mencione:
- "sintetizar"
- "analizar insumos"
- "detectar gaps"
- "síntesis de requerimientos"
- "hacer la síntesis"
- "aplicar Prompt-01"

## Instrucciones

1. **Identificar los insumos**:
   - Solicitar al usuario la ruta del directorio con los archivos a sintetizar (`.txt`, `.md`).
   - Preguntar el **nombre del tópico** para el archivo de salida (ej: `VisibilidadUI`).

2. **Leer todos los archivos de insumo** con el Read tool (o listar el directorio con Glob y leer cada uno).

3. **Leer el prompt de síntesis**: Leer `Prompts/Prompt-01-Sintesis.md` para obtener las instrucciones del rol Analista de Negocio.

4. **Ejecutar la síntesis**: Aplicar el prompt sobre el conjunto de insumos leídos, asumiendo el rol de Analista de Negocio. La síntesis debe:
   - Identificar requerimientos funcionales y no funcionales detectados.
   - Detectar gaps, ambigüedades o información faltante.
   - Formular preguntas específicas para cada gap.
   - Estructurar el output en **Markdown** (no JSON).

5. **Guardar el output** con el Write tool usando la convención:
   ```
   YYYYMMDD.01.Sintesis.[Tópico].md
   ```
   - Guardar en el mismo directorio de los insumos.

6. **Informar al usuario** que la síntesis está lista y que debe:
   - Revisar el documento.
   - Anotar respuestas a los gaps directamente en el archivo (o en un archivo separado).
   - Confirmar cuando esté listo para continuar con el paso de fusión.

## Output esperado

Archivo Markdown con:
- **Resumen ejecutivo** del tópico analizado.
- **Requerimientos identificados** (funcionales y no funcionales).
- **Gaps detectados** con preguntas concretas para el usuario/stakeholders.

Nombre de ejemplo: `20260318.01.Sintesis.VisibilidadUI.md`

> **Nota**: El output es Markdown estructurado, NO JSON.
