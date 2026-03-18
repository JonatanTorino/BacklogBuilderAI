# Skill: resumen-accionables

## Descripción

Genera uno o más documentos desde una transcripción procesada, según lo que pida el usuario:

- **Resumen de reunión**: resumen ejecutivo, narrativo, participantes, decisiones.
- **Action items**: lista priorizada de tareas con responsables.
- **Reunión con accionables** (por defecto): fusión de los dos anteriores en un único documento Markdown.

## Cuándo invocar

Invocar este skill cuando el usuario mencione:
- "resumir reunión"
- "resumen ejecutivo"
- "resumen de reunión"
- "action items"
- "accionables"
- "resumen con accionables"
- "reunión con accionables"
- "generar resumen"

## Instrucciones

### Paso 1: Identificar los insumos

- Solicitar al usuario la ruta del archivo de transcripción (`.txt` limpio preferentemente; si es `.vtt`, sugerir invocar primero `preprocesar-fuentes`).
- Preguntar el **nombre del tópico** para el archivo de salida (ej: `ReunionKickoff`).

### Paso 2: Detectar el tipo de output solicitado

Analizar el pedido del usuario para determinar qué generar:

- **Solo resumen**: si el usuario pide "solo resumen", "resumen de reunión", "resumen ejecutivo" sin mencionar accionables.
  → Usar únicamente `./Prompt-Resumen-Reunion.md`

- **Solo action items**: si el usuario pide "solo action items", "solo accionables", "elementos de acción".
  → Usar únicamente `./Prompt-action-items.md`

- **Reunión con accionables** (caso por defecto): si el usuario pide "con accionables", "reunión completa", o no especifica.
  → Usar ambos prompts y fusionar en un único documento.

### Paso 3: Leer el contenido de la transcripción

Leer el archivo de transcripción con el Read tool.

### Paso 4: Generar los documentos solicitados

**Para resumen**: Leer `./Prompt-Resumen-Reunion.md` y aplicarlo sobre la transcripción.

**Para action items**: Leer `./Prompt-action-items.md` y aplicarlo sobre la transcripción.

**Para reunión con accionables**: Aplicar ambos prompts y combinar los resultados en un único Markdown estructurado con secciones claras.

### Paso 5: Guardar el output

Usar el Write tool con la convención de nombres:

```
YYYYMMDD.00.[Tipo].[Tópico].md
```

- `YYYYMMDD`: fecha actual.
- `[Tipo]`: según lo generado:
  - `ResumenReunion` si solo resumen
  - `ActionItems` si solo action items
  - `ResumenConAccionables` si ambos (por defecto)
- `[Tópico]`: nombre en PascalCase proporcionado por el usuario.
- Guardar en el mismo directorio donde está la transcripción.

### Paso 6: Confirmar al usuario

Informar el nombre y ubicación del archivo generado.

## Output esperado

| Tipo | Contenido | Nombre de ejemplo |
|------|-----------|-------------------|
| Solo resumen | Resumen ejecutivo, participantes, decisiones | `20260318.00.ResumenReunion.ReunionKickoff.md` |
| Solo action items | Lista priorizada de tareas con responsables | `20260318.00.ActionItems.ReunionKickoff.md` |
| Reunión con accionables | Resumen + action items fusionados | `20260318.00.ResumenConAccionables.ReunionKickoff.md` |
