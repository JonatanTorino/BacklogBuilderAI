---
name: rf-desglose-tasks
description: >
  Genera el desglose de Tasks hijas de una User Story para Azure DevOps,
  derivando actividades de Development (principio de Responsabilidad Unica),
  Testing (una por cada AC), Requirements (dudas del Scope Doc), Documentation
  y Deployment (desde la Definition of Done del equipo). Usar este skill cuando
  el usuario mencione "desglose de tasks", "generar tasks", "tareas de la US",
  "descomponer user story en tasks", "tasks hijas", "actividades de la US",
  "cargar tasks en ADO" o necesite el paso posterior a la tarjeta de User Story.
---

# Skill: desglose-tasks

## Descripcion

Genera el listado de Tasks hijas de una User Story en formato Markdown, listas para revision del equipo y posterior carga en Azure DevOps. Combina el Documento de Alcance, los Acceptance Criteria y la Definition of Done para producir un desglose completo y trazable.

## Cuando invocar

Invocar este skill cuando el usuario mencione:

- "desglose de tasks"
- "generar tasks"
- "tareas de la US"
- "descomponer user story en tasks"
- "tasks hijas"
- "actividades de la user story"
- "cargar tasks en ADO"
- Cualquier referencia a generar el listado de trabajo posterior a la tarjeta de US

## Instrucciones

1. **Identificar los insumos**:
   - Solicitar la ruta del directorio con los archivos del pipeline.
   - Identificar el archivo **Stage 04** (TarjetaUS) — contiene los Acceptance Criteria.
   - Identificar el archivo **Stage 03** (ScopeDoc) — contiene requisitos funcionales, solucion, riesgos.
   - Si no estan claros, preguntar al usuario.

2. **Leer los archivos del directorio** con Glob + Read para todos los `.md` `.txt` `.pu` `.puml` `.mmd` relevantes del pipeline.

3. **Leer la Definition of Done**: Leer `./references/DOD_Details.md` (incluida en este skill).

4. **Leer el prompt de desglose**: Leer `./Prompt-Desglose-Tasks.md` (relativo a este skill).

5. **Fase 1 — Preview de Development**: Extraer los componentes de Development del Scope Doc (Sec.4 y Sec.6). Presentar borrador numerado (D-01, D-02...) con alcance, justificacion de Responsabilidad Unica y estimacion tentativa. Esperar confirmacion antes de continuar.

6. **Fase 1.5 — Preview de Requirements**: Una vez confirmado Development, extraer los candidatos a Tasks de Requirements de Sec.10 (Riesgos e Incertidumbres). Presentar borrador numerado (R-01, R-02...) con origen y accion propuesta. Esperar que el usuario indique cuales incluir.

7. **Fase 2 — Generar el desglose completo de Tasks**: Con ambas confirmaciones, aplicar el prompt para producir el listado completo con:
   - Titulo, Activity, Original Estimate, Remaining y Description por cada Task.
   - Trazabilidad a AC-## y DOD integrada en las descripciones.
   - Tabla resumen al inicio del documento.

7. **Guardar el output** con la convencion:

   ```text
   YYYYMMDD.05.DesgloseTasksUS.[Topico].md
   ```

   En el mismo directorio de los insumos.

8. **Confirmar al usuario** que el desglose esta listo para revision del equipo.

## Output esperado

Archivo Markdown con el desglose completo de Tasks, incluyendo tabla resumen y detalle individual por Task.

Nombre de ejemplo: `20260328.05.DesgloseTasksUS.EDocGBL.md`
