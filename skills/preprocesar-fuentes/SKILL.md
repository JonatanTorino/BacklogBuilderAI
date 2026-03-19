---
name: preprocesar-fuentes
description: >
  Convierte archivos de transcripción y documentos Word a texto plano (.txt) listo
  para el pipeline de BacklogBuilderAI. Detecta automáticamente el tipo de archivo
  y ejecuta el script correcto: archivos .vtt (transcripciones de Teams/Zoom) los
  limpia con clean_vtt.py; archivos .docx los convierte con convert_docx_to_text.py.
  Usar este skill siempre que el usuario mencione "preprocesar", "limpiar VTT",
  "clean vtt", "convertir DOCX", "convertir Word", "docx a texto", "procesar archivos
  fuente", o cuando haya archivos .vtt o .docx que preparar antes del análisis.
---

# Skill: preprocesar-fuentes

## Descripción

Detecta el tipo de archivo(s) de entrada y ejecuta el script correcto para convertirlos en texto plano (`.txt`) listo para el pipeline de BacklogBuilderAI:

- `.vtt` → `scripts/clean_vtt.py` → genera `.txt` limpio en `vtt-limpios/`
- `.docx` → `scripts/convert_docx_to_text.py` → genera `.txt` junto al original
- Directorio mixto → procesa cada tipo con su script correspondiente

## Cuándo invocar

Invocar este skill cuando el usuario mencione:
- "preprocesar"
- "limpiar VTT"
- "clean vtt"
- "convertir DOCX"
- "convertir Word"
- "docx a texto"
- "procesar archivos fuente"
- Archivos con extensión `.vtt` o `.docx`

## Prerequisitos

- Python instalado y accesible en el PATH.
- Para archivos `.docx`: librería `python-docx` instalada (`pip install python-docx`).

## Instrucciones

1. **Identificar la ruta de entrada**:
   - Si el usuario proporcionó una ruta explícita (archivo o directorio), usarla directamente.
   - Si no, preguntar: "¿Cuál es la ruta del archivo o directorio que contiene los archivos a preprocesar?"

2. **Detectar qué tipos de archivos hay**:
   - Si es un archivo individual, detectar su extensión.
   - Si es un directorio, listar los archivos con Glob para ver qué extensiones hay (`.vtt`, `.docx`).

3. **Procesar archivos `.vtt`** (si los hay):
   - Ejecutar usando el Bash tool, con la ruta al script co-localizado:
     ```bash
     python "<ruta_skill>/scripts/clean_vtt.py" "<ruta>"
     ```
   - Los `.txt` limpios se guardan en `vtt-limpios/` (subcarpeta junto a los originales).
   - Los `.vtt` originales se mueven a `vtt-originales/`.

4. **Procesar archivos `.docx`** (si los hay):
   - Ejecutar usando el Bash tool, con la ruta al script co-localizado:
     ```bash
     python "<ruta_skill>/scripts/convert_docx_to_text.py" "<ruta>"
     ```
   - Los `.txt` se generan en el mismo directorio que los `.docx` originales.

5. **Confirmar el resultado**: Informar al usuario los archivos `.txt` generados y sus ubicaciones.

6. **Manejar errores**: Si un script falla, mostrar el error al usuario y verificar:
   - Python está instalado y accesible.
   - La ruta proporcionada existe.
   - Para `.docx`: `python-docx` está instalado.

## Output esperado

- **Para `.vtt`**:
  - `vtt-limpios/`: archivos `.txt` con texto limpio (nombre: `<base>_limpio.txt`).
  - `vtt-originales/`: `.vtt` originales respaldados.
- **Para `.docx`**:
  - Archivos `.txt` en el mismo directorio que los `.docx`, con el mismo nombre base.
