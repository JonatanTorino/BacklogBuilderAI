# Skill: scope-doc

## Descripción

Genera el Documento de Alcance Funcional a partir de los insumos procesados (síntesis, fusión y otros documentos de contexto), definiendo el alcance, objetivos, restricciones y criterios de aceptación del producto o feature.

## Cuándo invocar

Invocar este skill cuando el usuario mencione:
- "scope document"
- "documento de alcance"
- "alcance funcional"
- "generar scope doc"
- "aplicar Prompt-scope-doc"

## Instrucciones

1. **Identificar los insumos**:
   - Solicitar la ruta del directorio con los archivos procesados (típicamente el archivo de fusión `YYYYMMDD.02.Fusion.[Tópico].md` y otros documentos de contexto disponibles).
   - Preguntar el **nombre del tópico** si no se puede inferir del directorio.

2. **Leer todos los archivos relevantes** con el Read tool (fusión, síntesis, o cualquier otro `.md`/`.txt` disponible en la ruta).

3. **Leer el prompt de scope doc**: Leer `./Prompt-scope-doc.md`.

4. **Generar el Documento de Alcance**: Aplicar el prompt sobre los insumos para producir un documento estructurado en **Markdown** que incluya:
   - Objetivo del producto/feature.
   - Alcance funcional (qué está incluido y qué no).
   - Usuarios y roles involucrados.
   - Restricciones y dependencias.
   - Criterios de aceptación de alto nivel.

5. **Guardar el output** con el Write tool usando la convención:
   ```
   YYYYMMDD.03.ScopeDoc.[Tópico].md
   ```
   - Guardar en el mismo directorio de los insumos.

6. **Confirmar al usuario** que el Scope Doc está listo para la generación de la User Story.

## Output esperado

Archivo Markdown con el Documento de Alcance Funcional completo.

Nombre de ejemplo: `20260318.03.ScopeDoc.VisibilidadUI.md`
