# DocxConverter

Este directorio contiene herramientas para la conversión de documentos `.docx` a texto plano (`.txt`). Su propósito principal es facilitar el pre-procesamiento de insumos para los Modelos de Lenguaje Grandes (LLMs) en el proyecto BacklogBuilderAI, asegurando que el texto esté en un formato fácilmente consumible.

## Script Principal

-   `convert_docx_to_text.py`: Un script de Python que extrae el contenido textual de archivos `.docx` y lo guarda como `.txt`. Está diseñado para manejar correctamente caracteres especiales del español y utiliza codificación UTF-8 sin BOM.

## Instalación de Dependencias

Para que el script funcione, necesitas instalar la librería `python-docx`. Puedes hacerlo usando pip:

```bash
pip install python-docx
```

## Uso

El script `convert_docx_to_text.py` puede ser utilizado para convertir un archivo `.docx` individual o todos los archivos `.docx` dentro de un directorio.

### Convertir un archivo individual

```bash
python convert_docx_to_text.py "/ruta/a/tu/archivo.docx"
```

### Convertir todos los archivos en un directorio

```bash
python convert_docx_to_text.py "/ruta/a/tu/directorio/"
```

El archivo `.txt` resultante se creará en el mismo directorio que el archivo `.docx` original, con el mismo nombre base pero con la extensión `.txt`.
