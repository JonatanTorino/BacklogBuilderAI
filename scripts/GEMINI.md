# Scripts

Utilitarios del proyecto organizados por tecnología.

> Para el contexto general del pipeline, ver **`@AGENTS.md`** en la raíz.

---

## Estructura

```
scripts/
├── bash/       ← Scripts de configuración del repositorio (Git Bash / Linux)
├── python/     ← Utilitarios de pre-procesamiento de insumos
└── pwsh/       ← Automatización de Azure DevOps (PowerShell)
```

---

## bash/

Scripts de mantenimiento del repositorio. Requieren Git Bash con `MSYS=winsymlinks:nativestrict`.

| Script | Descripción |
|--------|-------------|
| `ForGitBash_SetupAgentsSkills.sh` | Crea `.agents/skills/` con 7 symlinks nativos trackeados por Git |
| `ForGitBash_LinkReadmeToGemini.sh` | Crea symlinks `README.md → GEMINI.md` en todos los subdirectorios |

---

## python/

Utilitarios de pre-procesamiento invocados por el skill `preprocesar-fuentes`.

| Script | Uso | Descripción |
|--------|-----|-------------|
| `clean_vtt.py` | `python clean_vtt.py "<ruta>"` | Limpia archivos `.vtt`, organiza en `vtt-originales/` y `vtt-limpios/` |
| `convert_docx_to_text.py` | `python convert_docx_to_text.py "<ruta>"` | Convierte `.docx` a `.txt` (archivo o directorio) |
| `fix_names_tmp.py` | `python fix_names_tmp.py "<ruta>"` | Utilitario auxiliar de renombrado |

**Dependencias**: `pip install python-docx`

> Nota: el skill `preprocesar-fuentes` tiene sus propias copias en `skills/preprocesar-fuentes/scripts/`. Los scripts de este directorio son la fuente de referencia para uso manual.

---

## pwsh/

Scripts de automatización para crear backlogs en Azure DevOps desde JSON.

| Archivo | Descripción |
|---------|-------------|
| `Invoke-BacklogCreation.ps1` | Orquestador: gestiona configuración, logging y errores |
| `Create-BacklogFromJSON.ps1` | Implementación: crea work items y relaciones padre-hijo en ADO |
| `config.template.json` | Plantilla de configuración (organización ADO, proyecto, PAT) |
| `final_backlog.template.json` | Plantilla de estructura del backlog de entrada |
| `Log/` | Historial de ejecuciones |
| `CrearLinkGeminiReadme.ps1` | Crea symlinks `README.md → GEMINI.md` (equivalente PowerShell de `ForGitBash_LinkReadmeToGemini.sh`) |

### Uso básico

1. Copiar `config.template.json` como `config.json` y completar con los datos de tu organización ADO.
2. Preparar el backlog JSON siguiendo el formato de `final_backlog.template.json`.
3. Ejecutar: `pwsh Invoke-BacklogCreation.ps1 -ConfigPath config.json -BacklogPath <archivo>.json`

### config.json

Contiene:
- Organización y proyecto de Azure DevOps
- Token de autenticación: PAT plano (`token-secreto`) o variable de entorno (`env:NombrePAT`)
- Ruta de área predeterminada

> `config.json` está en `.gitignore` — nunca commitear credenciales.
