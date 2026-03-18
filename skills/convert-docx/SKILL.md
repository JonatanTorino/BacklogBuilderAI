# Skill: convert-docx

## Descripción

Convierte archivos `.docx` (Microsoft Word) a texto plano `.txt`, facilitando su uso como insumos en el pipeline de BacklogBuilderAI.

## Cuándo invocar

Invocar este skill cuando el usuario mencione:
- "convertir Word"
- "convertir DOCX"
- "docx a texto"
- "pasar Word a texto"
- Archivos con extensión `.docx`

## Instrucciones

1. **Identificar la ruta del archivo o directorio**:
   - Si el usuario proporcionó una ruta explícita al `.docx` o a un directorio con varios `.docx`, usarla.
   - Si no, preguntar: "¿Cuál es la ruta del archivo `.docx` o del directorio que contiene los archivos Word?"

2. **Ejecutar el script de conversión** usando el Bash tool:
   ```bash
   python PythonScripts/convert_docx_to_text.py "<ruta>"
   ```
   - Si `<ruta>` es un directorio, procesará todos los `.docx` encontrados.
   - Si `<ruta>` es un archivo individual, procesará solo ese archivo.

3. **Confirmar el resultado**: Informar al usuario sobre los archivos `.txt` generados, que quedan en el mismo directorio que los originales.

4. **Manejar errores**: Si el script falla, mostrar el error y verificar:
   - Python y la librería `python-docx` están instalados.
   - La ruta existe y los archivos son `.docx` válidos.

## Output esperado

- Archivos `.txt` generados en el mismo directorio que los `.docx` originales.
- Un archivo `.txt` por cada `.docx` procesado, con el mismo nombre base.
