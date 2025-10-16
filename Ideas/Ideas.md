# Mejoras del flujo

## Prompts diferentes propósitos

Crear versiones de prompts para generar deltas/incrementales

- Apoyandose en sintesis previas y backlogs refinados como base de conocimiento, centrarse en generar síntesis solo del delta
- Formatear nombres semánticos que reflejen el estado y versionado del artefacto
- Generar backlog DeltaIn y DeltaOut
- A la última versión del backlog (vigente) insertar el DeltaIn y opcional eliminar el DeltaOut o mover a un nodo movedToOutOfScope con su razón

## Prompt-03

En las Acceptance Criteria

- Mejorar las alternativas de Formato Gherkin (Dado/Cuando/Entonces)
- Agregar un AC##

En las US, dentro de la descripción, agregar DoD

En las Task vincular el DoD con la AC## que corresponda, pudiendo haber más de una Task para una misma AC

## Convención de nombres de archivos para todo el flujo

- `inputs_raw_notes.md`
- `inputs_raw_transcripts.md`
- `synthesis_clarifications.json`
- `synthesis_resolved.json`
- `backlog_draft.json`
- `backlog_final.json`
- `config.project.json`

Esto da trazabilidad clara:
**raw → clarifications → resolved → draft → final → ADO**.

## Actualización de ADO

Posibilidad de actualizar ADO con json de backlog

- Al WI agregar una propiedad
- Propiedad `"action: "Update"` actualiza todos los campos del WIT
- Propiedad `"action: "Remove"` remueve el WIT del backlog
- Remover la propiedad del json luego de procesar el WI

## Versiones de prompts para backlogs tipo

- Desarrollo
  - Incluir documentación técnica fiel de lo construido
  - Incluir reglas de buenas prácticas para los DoD de tareas técnicas
  - Labels
  - Propieades importantes de tablas/relaciones
  - Ejecución del CAR y resolución de warnings
- Refinamiento
  - Incluir documentación diseño de prototipos
