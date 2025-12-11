# PythonScripts

Este directorio actúa como una librería de utilidades en Python para el pre-procesamiento y manipulación de insumos en el proyecto **BacklogBuilderAI**.

## Contenido

### 1. `convert_docx_to_text.py`
Convierte documentos de Word (`.docx`) a texto plano (`.txt`).
- **Uso**: `python convert_docx_to_text.py "/ruta/al/archivo_o_directorio"`
- **Dependencias**: `python-docx`

### 2. `clean_vtt.py`
Limpia archivos de transcripción en formato WebVTT (`.vtt`). Elimina metadatos, timestamps y IDs, conservando solo el diálogo formateado por orador.
- **Uso**: Se ejecuta sobre un directorio predefinido (actualmente configurado para `.TmpFiles\FE`).
- **Salida**: Genera archivos `*_limpio.txt`.


## Gestión de Scripts

Siguiendo el protocolo del proyecto, cualquier nuevo script de utilidad (Python) debe ser guardado en este directorio para fomentar la reutilización y el orden.