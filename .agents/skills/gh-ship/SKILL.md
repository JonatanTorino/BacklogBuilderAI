---
name: gh-ship
description: >
  Automatiza el flujo completo de git/GitHub: crea una rama, hace commit y push,
  abre un PR con gh-cli, lo mergea eliminando la rama remota, y sincroniza main
  localmente. Usar este skill cuando el usuario pida "crear una rama y enviar los
  cambios a la principal", "crear un branch y enviar los cambios a la principal",
  "hacer branch + commit + push + PR", "ship estos cambios", "subir esto en un PR"
  o cualquier variante que implique empaquetar cambios en una rama y mergearlos a
  main a través de un pull request.
---

# rf-gh-ship — Branch → Commit → Push → PR → Merge → Sync

## Paso 0: Leer el estado actual

Antes de proponer nada, ejecutar:

```bash
git status
git diff --stat
git branch --show-current
```

Con esa información:

- **Rama actual**: si ya se está en una rama distinta a `main`, usarla tal cual.
  Si se está en `main`, hay que crear una rama nueva.
- **Cambios staged vs. unstaged**: detectar qué hay en cada categoría.

## Paso 1: Proponer nombre de rama (solo si se está en main)

Derivar un nombre descriptivo en `kebab-case` a partir de los archivos modificados
y el contenido del diff. Ejemplos:

- Archivos de skills renombrados → `skills/renombrar-prefijo-rf`
- Script de setup nuevo → `feat/setup-claude-skills`
- Fix en SKILL.md → `fix/nombre-skill-preparacion-us`

Presentar la propuesta al usuario y esperar confirmación o corrección antes de
crear la rama.

## Paso 2: Manejar archivos sin stagear

Si `git status` muestra archivos modificados pero sin stagear, preguntar al usuario:

> ¿Qué archivos querés incluir en el commit?
> - **Todo** (`git add -A`)
> - **Solo los ya staged** (continuar sin agregar más)
> - **Selección manual** (el usuario indica qué archivos)

No asumir — esperar respuesta antes de continuar.

## Paso 3: Proponer mensaje de commit

Generar un mensaje de commit conciso (máx. 72 caracteres en la primera línea)
basado en los cambios staged. Seguir el estilo del historial del repo:

```bash
git log --oneline -5
```

Presentar la propuesta y esperar confirmación o corrección.

## Paso 4: Ejecutar branch + commit + push

```bash
# Solo si se estaba en main:
git checkout -b <nombre-rama>

# Stagear lo acordado en Paso 2 (si aplica):
git add -A   # o los archivos seleccionados

# Commit:
git commit -m "<mensaje>"

# Push:
git push --set-upstream origin <nombre-rama>
```

Si el push falla porque la rama ya tiene upstream configurado, usar `git push`.

## Paso 5: Crear el PR

Generar automáticamente el body del PR con un resumen de los cambios (2-4 bullets)
a partir del diff y los archivos tocados.

```bash
gh pr create \
  --base main \
  --title "<mensaje-de-commit>" \
  --body "<body generado>"
```

Incluir al final del body: `🤖 Generated with [Claude Code](https://claude.com/claude-code)`

## Paso 6: Mergear y eliminar rama remota

> GitHub no permite aprobar el propio PR — se mergea directamente.

```bash
gh pr merge <número> --merge --delete-branch
```

## Paso 7: Sincronizar main local

```bash
git checkout main
git pull
```

Confirmar al usuario que el proceso terminó con un resumen de una línea:
rama mergeada, rama remota eliminada, main actualizado.
