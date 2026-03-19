---
name: preparacion-us
description: >
  Skill maestro que orquesta el pipeline completo de BacklogBuilderAI: desde fuentes
  brutas (.vtt, .docx, .txt) hasta la User Story final lista para Azure DevOps.
  Delega en los sub-skills preprocesar-fuentes, resumen-accionables, sintesis, fusion,
  scope-doc y tarjeta-us, con una pausa obligatoria de revisión humana entre la
  síntesis y la fusión. Requiere que los demás skills estén instalados al mismo nivel.
  Usar este skill cuando el usuario mencione "pipeline completo", "preparar user story",
  "crear US desde transcripciones", "flujo completo" o "procesar todo desde las fuentes".
---

# Skill: preparacion-us (Skill Maestro)

## Descripción

Orquesta el pipeline completo de BacklogBuilderAI desde fuentes brutas (transcripciones `.vtt`, documentos `.docx`, textos `.txt`) hasta la User Story final lista para Azure DevOps. Delega en los sub-skills individuales leyendo sus `SKILL.md` por ruta relativa, sin duplicar recursos propios.

## Cuándo invocar

Invocar este skill cuando el usuario mencione:
- "pipeline completo"
- "preparar user story"
- "crear US desde transcripciones"
- "preparacion-us"
- "flujo completo"
- "procesar todo desde las fuentes"

## Prerequisito de instalación

Para que este skill maestro funcione correctamente, los siguientes sub-skills deben estar instalados en el **mismo nivel de directorio** (`../`):

- `preprocesar-fuentes`
- `resumen-accionables`
- `sintesis`
- `fusion`
- `scope-doc`
- `tarjeta-us`

Si se instalan globalmente, instalar todos juntos para preservar la estructura relativa:

```bash
npx skills add ./skills/preprocesar-fuentes -g
npx skills add ./skills/resumen-accionables -g
npx skills add ./skills/sintesis -g
npx skills add ./skills/fusion -g
npx skills add ./skills/scope-doc -g
npx skills add ./skills/tarjeta-us -g
npx skills add ./skills/preparacion-us -g
```

## Pipeline de ejecución

```
[Fuentes brutas: .vtt / .docx / .txt]
        ↓ Paso 1: Pre-procesar fuentes
        ↓ Paso 2: Resumen con accionables
        ↓ Paso 3: Síntesis
        ↓ ⏸ PAUSA — Revisión humana
        ↓ Paso 4: Fusión (tras confirmación)
        ↓ Paso 5: Scope Doc
        ↓ Paso 6: Tarjeta de User Story
```

## Instrucciones

### Paso 0: Recopilar información inicial

Antes de comenzar, solicitar al usuario:
1. **Ruta del directorio de trabajo** que contiene las fuentes brutas.
2. **Nombre del tópico** en PascalCase (ej: `VisibilidadUI`), para nombrar los archivos de salida.
3. Confirmar los tipos de archivos presentes (`.vtt`, `.docx`, `.txt`).

---

### Paso 1: Pre-procesar fuentes

Leer `../preprocesar-fuentes/SKILL.md` y seguir sus instrucciones para procesar los archivos `.vtt` y/o `.docx` del directorio de trabajo.

- Si ya existen archivos `.txt` pre-procesados, este paso puede omitirse.
- Informar al usuario: "Pre-procesamiento completado. Archivos listos: [lista de .txt generados]"

---

### Paso 2: Resumen con accionables

Leer `../resumen-accionables/SKILL.md` y seguir sus instrucciones en modo **"reunión con accionables"** (ambos prompts, documento fusionado).

Guardar como `YYYYMMDD.00.ResumenConAccionables.[Tópico].md` en el directorio de trabajo.

---

### Paso 3: Síntesis

Leer `../sintesis/SKILL.md` y seguir sus instrucciones con todos los `.txt` y `.md` disponibles en el directorio de trabajo (incluyendo el resumen del Paso 2).

Guardar como `YYYYMMDD.01.Sintesis.[Tópico].md` en el directorio de trabajo.

---

### ⏸ PAUSA OBLIGATORIA — Revisión humana

Mostrar al usuario el contenido de la síntesis generada y decir:

> **La síntesis está lista.** Por favor, revisa el documento `YYYYMMDD.01.Sintesis.[Tópico].md` y anota:
> - Respuestas a los gaps identificados.
> - Correcciones o aclaraciones necesarias.
> - Cualquier contexto adicional relevante.
>
> Puedes anotar directamente en el archivo o indicarme tus respuestas aquí.
>
> **Cuando hayas terminado, confirma con "listo para continuar" o "continuar con fusión".**

**Esperar la confirmación del usuario antes de continuar.** No avanzar automáticamente al siguiente paso.

---

### Paso 4: Fusión (tras confirmación)

Leer `../fusion/SKILL.md` y seguir sus instrucciones con el archivo de síntesis anotado por el usuario.

Guardar como `YYYYMMDD.02.Fusion.[Tópico].md` en el directorio de trabajo.

---

### Paso 5: Scope Doc

Leer `../scope-doc/SKILL.md` y seguir sus instrucciones con todos los `.md` disponibles en el directorio de trabajo (especialmente el de fusión).

Guardar como `YYYYMMDD.03.ScopeDoc.[Tópico].md` en el directorio de trabajo.

---

### Paso 6: Tarjeta de User Story

Leer `../tarjeta-us/SKILL.md` y seguir sus instrucciones con todos los `.md` disponibles en el directorio de trabajo.

Guardar como `YYYYMMDD.04.TarjetaUS.[Tópico].md` en el directorio de trabajo.

---

### Paso 7: Confirmación final

Mostrar al usuario un resumen del pipeline completado:

```
Pipeline completado. Archivos generados en [directorio]:

  ✓ YYYYMMDD.00.ResumenConAccionables.[Tópico].md
  ✓ YYYYMMDD.01.Sintesis.[Tópico].md
  ✓ YYYYMMDD.02.Fusion.[Tópico].md
  ✓ YYYYMMDD.03.ScopeDoc.[Tópico].md
  ✓ YYYYMMDD.04.TarjetaUS.[Tópico].md

La tarjeta de User Story está lista para subir a Azure DevOps.
```

## Convención de nomenclatura de archivos de salida

| Etapa | Tipo                    | Ejemplo                                          |
|-------|-------------------------|--------------------------------------------------|
| `00`  | `ResumenConAccionables` | `20260318.00.ResumenConAccionables.MiTópico.md` |
| `01`  | `Sintesis`              | `20260318.01.Sintesis.MiTópico.md`              |
| `02`  | `Fusion`                | `20260318.02.Fusion.MiTópico.md`                |
| `03`  | `ScopeDoc`              | `20260318.03.ScopeDoc.MiTópico.md`              |
| `04`  | `TarjetaUS`             | `20260318.04.TarjetaUS.MiTópico.md`             |

## Notas

- Todos los outputs son archivos **Markdown** (`.md`), no JSON.
- La pausa en el Paso 3 es obligatoria y no debe saltarse.
- Si el usuario ya tiene archivos pre-procesados (`.txt`), el Paso 1 puede omitirse.
- Si ya existe un archivo de síntesis con anotaciones, el pipeline puede iniciarse desde el Paso 4.
- Este skill no tiene recursos propios (scripts ni prompts). Todo lo delega a los sub-skills.
