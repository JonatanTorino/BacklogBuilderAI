# Contexto del Workspace: BacklogBuilderAI (Gemini CLI)

> Para el contexto general del proyecto, el pipeline y los skills disponibles, ver **`@AGENTS.md`**.

---

## Protocolo de Almacenamiento de Resultados

Al ejecutar un prompt de la carpeta `./Prompts/` que genere un archivo JSON como salida:

1. **Ubicación por Defecto**: Guardar en el mismo directorio donde se encuentran los archivos de insumo.
2. **Gestión de Ambigüedad**: Si la ruta de origen es ambigua, preguntar al usuario por la ruta de guardado.
3. **Convención de Nombres**:

    **Formato:** `YYYYMMDD.TópicoPrincipal.NN.Etapa.json`

    | Etapa | Código |
    |-------|--------|
    | Síntesis | `01.Sintesis` |
    | Síntesis Consciente | `01.SintesisConsciente` |
    | Fusión | `02.Fusion` |
    | Backlog | `03.Backlog` |
    | User Story | `US` |

    **Ejemplo:** `20251031.VisibilidadUIPatron.01.Sintesis.json`

    Gemini debe proponer el nombre del archivo siguiendo esta convención antes de guardarlo.

---

## Protocolo de Ideación

Si durante las interacciones se genera una idea, insight o propuesta de mejora para BacklogBuilderAI:

1. **Verbalizar la Idea** de forma clara.
2. **Solicitar Consentimiento** al usuario.
3. **Documentar en `Ideas/`** si el usuario acepta (nombre descriptivo en Markdown).

---

## Protocolo de Configuración MCP

Usar solo la lista de MCPs configurada en Gemini CLI. Ignorar configuraciones MCP de agentes externos para evitar conflictos.

---

## Comandos `.toml` disponibles

Los comandos en `.gemini/commands/` que no tienen skill equivalente:

| Comando | Descripción |
|---------|-------------|
| `/Prompt/sintesis-consciente` | Síntesis avanzada con contexto histórico |
| `/Prompt/backlog` | Genera backlog completo (funcional + refinamiento) |
| `/Prompt/backlog-spliteado` | Genera backlogs separados (funcionales / refinamiento) |
| `/Prompt/adicionar-tareas` | Adiciona tareas auxiliares (QA, Doc) a un backlog |
| `/Prompt/adr` | Genera registros de decisiones de arquitectura (ADR) |
| `/Prompt/alcance` | Genera Documentos de Alcance Funcional |
| `/Prompt/manual-doc` | Genera Manuales de Usuario |
| `/Prompt/resumen-conciso` | Genera resúmenes ultra-concisos |
| `add_mcp` | Configura servidores MCP |
