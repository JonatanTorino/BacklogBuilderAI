# Contexto del Workspace: BacklogBuilderAI

**BacklogBuilderAI** automatiza la creación de backlogs en Azure DevOps desde insumos no estructurados (transcripciones de reuniones, documentos de diseño, notas).

---

## Pipeline de transformación

```
Insumos brutos (.vtt / .docx / .txt)
        ↓  [preprocesar-fuentes]
Transcripciones limpias (.txt)
        ↓  [resumen-accionables]  ← opcional
Resumen ejecutivo + action items (.md)
        ↓  [sintesis]
Síntesis de requisitos + gaps (.md)
        ↓  [fusion]               ← si hay gaps que responder
Síntesis consolidada (.md)
        ↓  [scope-doc]
Documento de Alcance Funcional (.md)
        ↓  [tarjeta-us]
Tarjeta de User Story para Azure DevOps (.md)
```

El skill `preparacion-us` orquesta el pipeline completo delegando en los sub-skills anteriores.

---

## Skills disponibles

Los skills están en `skills/` (fuente de verdad) y también en `.agents/skills/` como symlinks.

| Skill | Directorio | Descripción |
|-------|-----------|-------------|
| `preprocesar-fuentes` | `skills/preprocesar-fuentes/` | Limpia `.vtt` y convierte `.docx` a `.txt` |
| `resumen-accionables` | `skills/resumen-accionables/` | Genera resumen de reunión, action items, o ambos |
| `sintesis` | `skills/sintesis/` | Sintetiza insumos y detecta gaps (Analista de Negocio) |
| `fusion` | `skills/fusion/` | Integra respuestas humanas a los gaps |
| `scope-doc` | `skills/scope-doc/` | Genera Documento de Alcance Funcional |
| `tarjeta-us` | `skills/tarjeta-us/` | Genera tarjeta de User Story para Azure DevOps |
| `preparacion-us` | `skills/preparacion-us/` | **Skill maestro**: orquesta el pipeline completo |

---

## Convención de nomenclatura de outputs

Todos los outputs son Markdown (`.md`), no JSON.

```
YYYYMMDD.[etapa].[tipo].[Tópico].md
```

| Etapa | Tipo | Ejemplo |
|-------|------|---------|
| `00` | `ResumenConAccionables` | `20260318.00.ResumenConAccionables.MiTópico.md` |
| `01` | `Sintesis` | `20260318.01.Sintesis.VisibilidadUI.md` |
| `02` | `Fusion` | `20260318.02.Fusion.VisibilidadUI.md` |
| `03` | `ScopeDoc` | `20260318.03.ScopeDoc.VisibilidadUI.md` |
| `04` | `TarjetaUS` | `20260318.04.TarjetaUS.VisibilidadUI.md` |

---

## Estructura de contexto adicional

- **`Prompts/GEMINI.md`**: Prompts del pipeline que no tienen skill equivalente.
- **`scripts/GEMINI.md`**: Scripts de utilidad organizados por tecnología (bash, python, pwsh).
- **`Ideas/GEMINI.md`**: Banco de ideas y mejoras futuras.
- **`KnowledgeBase/GEMINI.md`**: Archivo de backlogs y documentos de síntesis.

---

## Directorios de trabajo

- `skills/`: Fuente de verdad de los skills (Claude Code los lee aquí).
- `.agents/skills/`: Symlinks a `skills/` para Gemini CLI y otras herramientas compatibles.
- `.TmpFiles/`: Espacio de trabajo temporal para insumos y salidas intermedias.

---

## Prerrequisitos de entorno

- **Python 3.x** con el paquete `python-docx` instalado (`pip install python-docx`).
- Los scripts Python de `scripts/python/` son la referencia manual; el skill `preprocesar-fuentes` tiene sus propias copias en `skills/preprocesar-fuentes/scripts/`.
