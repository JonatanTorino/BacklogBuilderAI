# Skill: preparacion-us (Skill Maestro)

## Descripción

Orquesta el pipeline completo de BacklogBuilderAI desde fuentes brutas (transcripciones `.vtt`, documentos `.docx`, textos `.txt`) hasta la User Story final lista para Azure DevOps. Coordina todos los skills individuales en secuencia, con una pausa intermedia para revisión humana de la síntesis.

## Cuándo invocar

Invocar este skill cuando el usuario mencione:
- "pipeline completo"
- "preparar user story"
- "crear US desde transcripciones"
- "preparacion-us"
- "flujo completo"
- "procesar todo desde las fuentes"

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

Listar todos los archivos en el directorio de trabajo usando Glob.

**Para cada `.vtt` encontrado:**
- Ejecutar el skill `clean-vtt`:
  ```bash
  python PythonScripts/clean_vtt.py "<ruta_directorio>"
  ```
- Los `.txt` limpios quedan en `vtt-limpios/`.

**Para cada `.docx` encontrado:**
- Ejecutar el skill `convert-docx`:
  ```bash
  python PythonScripts/convert_docx_to_text.py "<ruta_directorio>"
  ```
- Los `.txt` quedan junto a los originales.

Informar al usuario: "Pre-procesamiento completado. Archivos listos: [lista de .txt generados]"

---

### Paso 2: Resumen con accionables

Para cada transcripción procesada (`.txt` en `vtt-limpios/` o junto a los originales):

1. Leer el contenido del `.txt`.
2. Leer `Prompts/Prompt-Resumen-Reunion.md` y `Prompts/Prompt-action-items.md`.
3. Generar resumen ejecutivo + action items.
4. Guardar como `YYYYMMDD.00.ResumenConAccionables.[Tópico].md` en el directorio de trabajo.

---

### Paso 3: Síntesis

1. Leer todos los archivos `.txt` y `.md` disponibles en el directorio de trabajo (incluyendo los resúmenes del Paso 2).
2. Leer `Prompts/Prompt-01-Sintesis.md`.
3. Generar la síntesis en Markdown asumiendo el rol de Analista de Negocio.
4. Guardar como `YYYYMMDD.01.Sintesis.[Tópico].md` en el directorio de trabajo.

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

Una vez que el usuario confirme:

1. Leer el archivo de síntesis con las anotaciones del usuario (`YYYYMMDD.01.Sintesis.[Tópico].md`).
2. Leer `Prompts/Prompt-02-FusionRespuestas.md`.
3. Integrar las respuestas a los gaps y generar el documento consolidado en Markdown.
4. Guardar como `YYYYMMDD.02.Fusion.[Tópico].md` en el directorio de trabajo.

---

### Paso 5: Scope Doc

1. Leer todos los archivos `.md` en el directorio de trabajo (especialmente el de fusión).
2. Leer `Prompts/Prompt-scope-doc.md`.
3. Generar el Documento de Alcance Funcional en Markdown.
4. Guardar como `YYYYMMDD.03.ScopeDoc.[Tópico].md` en el directorio de trabajo.

---

### Paso 6: Tarjeta de User Story

1. Leer todos los archivos `.md` en el directorio de trabajo.
2. Leer `Prompts/Prompt-Propuesta-UserStory.md`.
3. Generar la tarjeta de User Story completa en Markdown, lista para Azure DevOps.
4. Guardar como `YYYYMMDD.04.TarjetaUS.[Tópico].md` en el directorio de trabajo.

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
