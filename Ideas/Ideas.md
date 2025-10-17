# Mejoras del flujo

## Prompts diferentes propósitos

Crear versiones de prompts para generar deltas/incrementales

- Apoyandose en sintesis previas y backlogs refinados como base de conocimiento, centrarse en generar síntesis solo del delta
- Formatear nombres semánticos que reflejen el estado y versionado del artefacto
- Generar backlog DeltaIn y DeltaOut
- A la última versión del backlog (vigente) insertar el DeltaIn y opcional eliminar el DeltaOut o mover a un nodo movedToOutOfScope con su razón

## Joinear Síntesis

A veces puedo hacer varios intentos de generar síntesis

- usando multiples archivos con multiples tópicos y extrayendo un tópico solo
- usando un solo archivo con un solo tópico
- En ambos casos suelen tener gaps entre estas síntesis que sirven para complementarse generando una síntesis más rica

Crear un prompt que permita unificar estás versiones de síntesis en una más completa.

## Prompt-03

1. Para las Historias de usuario (funcionales)
   - Analizar si por el tamaño de tareas técnicas accionables es necesario separar en capas (Datos, Clases, Interfaz grafica)
   - Si no se justifica el nivel de separación, agrupar en tareas que delimiten un progreso por las acciones que estén altamente relacionadas por depenencias en común
2. En las Acceptance Criteria de las Historias de usuario (funcionales)
   - Agregar un AC## por cada criterio de aceptación
   - Mejorar las alternativas de Formato Gherkin (Dado/Cuando/Entonces)
3. En las Task
   - Vincular el Defintion Of Done con el AC## que corresponda, pudiendo haber más de una Task para una misma AC##

## Actualización de ADO

Posibilidad de actualizar ADO con json de backlog

- Al WI agregar una propiedad
- Propiedad `"action: "Update"` actualiza todos los campos del WIT
- Propiedad `"action: "Remove"` remueve el WIT del backlog
- Remover la propiedad del json luego de procesar el WI

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

## Versiones de prompts para backlogs tipo

- Desarrollo
  - Incluir documentación técnica fiel de lo construido
  - Incluir reglas de buenas prácticas para los DoD de tareas técnicas
  - Labels
  - Propieades importantes de tablas/relaciones
  - Ejecución del CAR y resolución de warnings
- Refinamiento
  - Incluir documentación diseño de prototipos
