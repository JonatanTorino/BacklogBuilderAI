# Skill: resumen-accionables

## Descripción

Genera un resumen ejecutivo de una reunión junto con sus action items (accionables), a partir de una transcripción procesada. Combina el resumen narrativo y los puntos de acción en un único documento Markdown.

## Cuándo invocar

Invocar este skill cuando el usuario mencione:
- "resumir reunión"
- "resumen con accionables"
- "action items"
- "resumen ejecutivo de reunión"
- "generar resumen"

## Instrucciones

1. **Identificar los insumos**:
   - Solicitar al usuario la ruta del archivo de transcripción (`.txt` limpio o `.vtt`).
   - Si el archivo es `.vtt`, aplicar primero el skill `clean-vtt` para obtener el `.txt`.
   - Preguntar el **nombre del tópico** para el archivo de salida (ej: `ReunionKickoff`).

2. **Leer el contenido de la transcripción** con el Read tool.

3. **Aplicar el Prompt de Resumen**: Leer `Prompts/Prompt-Resumen-Reunion.md` y usarlo como instrucción sobre el contenido de la transcripción para generar el resumen ejecutivo.

4. **Aplicar el Prompt de Action Items**: Leer `Prompts/Prompt-action-items.md` y usarlo sobre la misma transcripción para extraer los accionables.

5. **Fusionar en un único documento**: Combinar el resumen ejecutivo y los action items en un Markdown estructurado con secciones claras.

6. **Guardar el output** con el Write tool usando la convención de nombres:
   ```
   YYYYMMDD.00.ResumenConAccionables.[Tópico].md
   ```
   - `YYYYMMDD`: fecha actual.
   - `[Tópico]`: nombre en PascalCase proporcionado por el usuario.
   - Guardar en el mismo directorio donde está la transcripción.

7. **Confirmar al usuario** el nombre y ubicación del archivo generado.

## Output esperado

Archivo Markdown con:
- **Resumen ejecutivo**: síntesis de los puntos principales de la reunión.
- **Action items**: lista de tareas con responsables y fechas si las hay.

Nombre de ejemplo: `20260318.00.ResumenConAccionables.ReunionKickoff.md`
