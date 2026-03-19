# Contexto: Prompts del Sistema

Este directorio alberga los prompts maestros que no tienen un skill equivalente en `skills/`.

> Para el contexto general del pipeline, ver **`@AGENTS.md`** en la raíz.

---

## Prompts disponibles (comandos survivientes)

| Comando | Prompt Asociado | Descripción |
|---------|----------------|-------------|
| `/Prompt/sintesis-consciente` | `Prompt-01-Consciente.md` | Síntesis avanzada que contrasta nuevos insumos con el contexto histórico |
| `/Prompt/backlog` | `Prompt-03-GeneracionBacklog.md` | Genera un backlog completo (funcional y refinamiento) desde la síntesis final |
| `/Prompt/backlog-spliteado` | `Prompt-04-GeneracionBacklogSpliteado.md` | Genera backlogs específicos (solo funcionales o solo refinamiento) |
| `/Prompt/adicionar-tareas` | `Prompt-05-AdicionarTareasAuxiliares.md` | Adiciona tareas auxiliares (QA, Doc) a un backlog funcional existente |
| `/Prompt/adr` | `Prompt-ADR-Generator.md` | Genera registros de decisiones de arquitectura (ADR) desde transcripciones |
| `/Prompt/alcance` | `Prompt-Alcance-Funcional.md` | Genera Documentos de Alcance Funcional desde transcripciones |
| `/Prompt/manual-doc` | `Prompt-manual-doc.md` | Genera un Manual de Usuario desde transcripciones |
| `/Prompt/limpiar-vtt` | `Prompt-Limpieza-VTT.md` | Limpia metadatos técnicos de archivos de transcripción `.vtt` (vía prompt, sin script) |
| `/Prompt/resumen-conciso` | `Prompt-Resumen-Conciso.md` | Genera resúmenes ultra-concisos (Objetivo, Accionables, Pendientes) |

---

## Prompts migrados a skills

Los siguientes prompts ya no están en este directorio. Ahora viven co-localizados dentro de sus skills en `skills/`:

| Prompt eliminado | Skill equivalente |
|-----------------|-------------------|
| `Prompt-01-Sintesis.md` | `skills/sintesis/` |
| `Prompt-02-FusionRespuestas.md` | `skills/fusion/` |
| `Prompt-Resumen-Reunion.md` | `skills/resumen-accionables/` |
| `Prompt-action-items.md` | `skills/resumen-accionables/` |
| `Prompt-scope-doc.md` | `skills/scope-doc/` |
| `Prompt-Propuesta-UserStory.md` | `skills/tarjeta-us/` |

---

## Protocolo de Gestión de Prompts

Cuando se añada un nuevo prompt sin skill equivalente:

1. Crear el archivo `.md` en este directorio.
2. Crear el comando `.toml` en `.gemini/commands/Prompt/`.
3. Actualizar la tabla de "Prompts disponibles" en este archivo.
