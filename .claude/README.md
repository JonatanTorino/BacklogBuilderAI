# Setup: Skills para Claude Code

Al clonar el repositorio, el symlink `.claude/skills` puede no funcionar correctamente
en Windows — git lo clona como un archivo de texto en lugar de un enlace simbólico.

Claude Code necesita `.claude/skills/` para descubrir los skills del proyecto,
que viven en `.agents/skills/`.

## Cómo repararlo

Ejecutar **una sola vez** desde la raíz del repositorio:

### PowerShell (recomendado)

Requiere **Developer Mode** activo *o* terminal como **Administrador**:

```powershell
powershell -ExecutionPolicy Bypass -File scripts\pwsh\Setup-ClaudeSkills.ps1
```

### Git Bash

Requiere terminal como **Administrador**:

```bash
MSYS=winsymlinks:nativestrict bash scripts/bash/ForGitBash_SetupAgentsSkills.sh
```
