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

## Protocolo de Gestión de Scripts

Cada vez que se añada un nuevo script de utilidad a este directorio, se debe considerar su integración con el flujo de trabajo de Gemini:

1.  **Crear Comando Personalizado**: Si el script es de uso frecuente, se recomienda crear un archivo de configuración `.toml` en `.gemini/commands/Util/` (o la ruta correspondiente) para facilitar su ejecución.
2.  **Registro**: Se debe actualizar la sección "Comandos Disponibles" en este archivo para documentar la asociación entre el script y el comando de Gemini.

## Comandos Disponibles

A continuación se listan los comandos personalizados que utilizan los scripts de este directorio:

| Comando                | Script Asociado           | Descripción                                                 |
| :--------------------- | :------------------------ | :---------------------------------------------------------- |
| `/Util/clean-vtt`      | `clean_vtt.py`            | Limpia archivos .vtt eliminando metadatos (versión Python). |
| `/Util/convertir-docx` | `convert_docx_to_text.py` | Convierte archivos .docx a .txt (individual o directorio).  |

## Gestión de Scripts

Siguiendo el protocolo del proyecto, cualquier nuevo script de utilidad (Python) debe ser guardado en este directorio para fomentar la reutilización y el orden.