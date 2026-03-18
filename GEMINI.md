# Contexto del Workspace: BacklogBuilderAI

**BacklogBuilderAI** automatiza la creación de backlogs en Azure DevOps desde insumos no estructurados.

## Estructura de Contexto
Para detalles específicos, consulta el archivo `GEMINI.md` en cada subdirectorio:

- **`Prompts/GEMINI.md`**: Lógica de transformación y prompts del LLM.
- **`ScriptsForADO/GEMINI.md`**: Automatización de PowerShell para Azure DevOps.
- **`PythonScripts/GEMINI.md`**: Herramientas de pre-procesamiento de datos.
- **`Ideas/GEMINI.md`**: Banco de ideas y mejoras futuras.
- **`KnowledgeBase/GEMINI.md`**: Archivo de backlogs y documentos de síntesis.

## Directorios de Trabajo
- `.TmpFiles/`: Espacio de trabajo temporal para insumos y salidas intermedias.

## Protocolos de Interacción con Gemini

### Protocolo de Almacenamiento de Resultados

Al ejecutar un prompt de la carpeta `./Prompts/` que genere un archivo JSON como salida, se deben seguir estas reglas:

1. **Ubicación por Defecto**: El archivo resultante debe guardarse en el mismo directorio donde se encuentran los archivos de insumo (`NUEVOS_INSUMOS`).
2. **Gestión de Ambigüedad**: Si la ruta de origen es ambigua (múltiples carpetas de insumo), se debe preguntar explícitamente al usuario por la ruta de guardado.
3. **Convención de Nombres**: Para estandarizar los nombres de los archivos, se seguirá la siguiente convención:

    **Formato:** `YYYYMMDD.TópicoPrincipal.NN.Etapa.json`

    **Componentes:**
    - `YYYYMMDD`: Representa la fecha de creación como año (YYYY) mes (MM) día (DD).
    - `NN.Etapa`: Un prefijo numérico y una palabra clave que identifican la etapa del flujo.
        - `01.Sintesis`: Para la salida de `Prompt-01-Sintesis.md`.
        - `01.SintesisConsciente`: Para la salida de `Prompt-01-Consciente.md`.
        - `02.Fusion`: Para la salida de `Prompt-02-FusionRespuestas.md`.
        - `03.Backlog`: Para la salida de `Prompt-03-GeneracionBacklog.md`.
        - `US`: Para la tarjeta de propuesta de User Story generada por `Prompt-Propuesta-UserStory.md`.
    - `TópicoPrincipal`: Tres (3) palabras clave extraídas del tópico principal de la síntesis, unidas en formato `PascalCase` (sin espacios ni puntos).

    **Ejemplos:**
    - `20251031.VisibilidadUIPatron.01.Sintesis.json`
    - `20251031.VisibilidadUIPatron.01.SintesisConsciente.json`
    - `20251102.FactoriaLicenciasPersistencia.02.Fusion.json`
    - `20251103.MaestroLicenciasUsuario.03.Backlog.json`

    Gemini debe proponer el nombre del archivo siguiendo esta convención antes de guardarlo.

### Protocolo de Ideación

Si durante nuestras interacciones se genera una nueva idea, insight o propuesta de mejora para el flujo de trabajo de **BacklogBuilderAI**, Gemini debe seguir estos pasos:

1. **Verbalizar la Idea**: Exponer la idea o insight de forma clara al usuario.
2. **Solicitar Consentimiento**: Preguntar al usuario si desea que la idea sea documentada.
3. **Documentar en la Carpeta `Ideas`**: Si el usuario está de acuerdo, crear un nuevo archivo Markdown (`.md`) en la carpeta `Ideas/`. El nombre del archivo debe ser descriptivo y resumir el contenido de la idea (ej: `Mejora_Cache_Prompts.md`).

### Protocolo de Configuración MCP (Model Context Protocol)

El objetivo es usar la lista de MCPs que posee GEMINI. Por consiguiente, la consola de Gemini CLI debe ignorar cualquier configuración de MCP proveniente de archivos de configuración de agentes externos que no sean el propio GEMINI CLI, evitando conflictos y garantizando que solo se utilicen las herramientas designadas.

---

## Skills de Claude Code

Los componentes clave del pipeline están empaquetados como **Claude Code Skills** en la carpeta `skills/`. Permiten que colaboradores invoquen cada etapa del flujo sin conocer los comandos subyacentes.

### Skills disponibles

| Skill | Directorio | Descripción |
|-------|-----------|-------------|
| `clean-vtt` | `skills/clean-vtt/` | Limpia archivos VTT (transcripciones) |
| `convert-docx` | `skills/convert-docx/` | Convierte `.docx` a `.txt` |
| `resumen-accionables` | `skills/resumen-accionables/` | Genera resumen ejecutivo + action items |
| `sintesis` | `skills/sintesis/` | Sintetiza insumos y detecta gaps (Analista de Negocio) |
| `fusion` | `skills/fusion/` | Integra respuestas humanas a los gaps |
| `scope-doc` | `skills/scope-doc/` | Genera Documento de Alcance Funcional |
| `tarjeta-us` | `skills/tarjeta-us/` | Genera tarjeta de User Story para Azure DevOps |
| `preparacion-us` | `skills/preparacion-us/` | **Skill maestro**: orquesta el pipeline completo |

### Instalación global

```bash
npx skills add ./skills/clean-vtt -g
npx skills add ./skills/convert-docx -g
npx skills add ./skills/resumen-accionables -g
npx skills add ./skills/sintesis -g
npx skills add ./skills/fusion -g
npx skills add ./skills/scope-doc -g
npx skills add ./skills/tarjeta-us -g
npx skills add ./skills/preparacion-us -g
```

### Convención de nomenclatura de outputs

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

> **Nota**: Todos los outputs de los skills son Markdown (`.md`), no JSON.
