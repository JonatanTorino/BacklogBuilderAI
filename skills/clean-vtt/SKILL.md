# Skill: clean-vtt

## Descripción

Limpia archivos VTT (transcripciones de video/audio) eliminando marcas de tiempo, identificadores de bloque y metadatos del formato WebVTT, dejando solo el texto legible de la conversación.

## Cuándo invocar

Invocar este skill cuando el usuario mencione:
- "limpiar VTT"
- "limpiar transcripción"
- "clean vtt"
- "procesar archivo .vtt"
- Archivos con extensión `.vtt`

## Instrucciones

1. **Identificar la ruta del archivo o directorio VTT**:
   - Si el usuario proporcionó una ruta explícita, usarla directamente.
   - Si no, preguntar: "¿Cuál es la ruta del archivo `.vtt` o del directorio que contiene los archivos VTT?"

2. **Ejecutar el script de limpieza** usando el Bash tool:
   ```bash
   python PythonScripts/clean_vtt.py "<ruta>"
   ```
   - Si `<ruta>` es un directorio, el script procesará todos los `.vtt` que encuentre.
   - Si `<ruta>` es un archivo individual `.vtt`, procesará solo ese archivo.

3. **Confirmar el resultado**: Informar al usuario sobre los archivos generados:
   - Los archivos `.txt` limpios se guardan en `vtt-limpios/` (subcarpeta junto a los originales).
   - Los originales `.vtt` se mueven a `vtt-originales/`.

4. **Manejar errores**: Si el script falla, mostrar el error al usuario y sugerir verificar que:
   - Python está instalado y accesible.
   - La ruta proporcionada existe.
   - Los archivos `.vtt` son válidos.

## Output esperado

- Directorio `vtt-limpios/`: contiene los archivos `.txt` con texto limpio.
- Directorio `vtt-originales/`: contiene los `.vtt` originales respaldados.
