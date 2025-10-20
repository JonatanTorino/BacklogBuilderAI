# Contexto del Workspace: BacklogBuilderAI

## Propósito Principal

Este workspace, denominado **BacklogBuilderAI**, es una herramienta diseñada para automatizar la creación de backlogs en Azure DevOps a partir de insumos no estructurados (como transcripciones, documentos de requisitos o notas).

El flujo de trabajo principal se basa en un pipeline de tres etapas que utiliza Modelos de Lenguaje Grandes (LLMs) para procesar, refinar y estructurar la información, culminando en la generación automática de Work Items a través de scripts de PowerShell.

## Estructura de Carpetas Clave

A continuación se describe el propósito de cada directorio principal:

### `Prompts`

Esta es la carpeta más importante para entender la lógica de transformación. Contiene los prompts que guían a los LLMs en cada etapa del proceso:

1. **`Prompt-01-Sintesis.md`**: Actúa como un analista de negocio. Toma los insumos crudos, los resume y, crucialmente, identifica "gaps" de información o ambigüedades, formulando preguntas claras para que un humano las responda.
2. **`Prompt-02-FusionRespuestas.md`**: Una vez que las preguntas del primer prompt han sido respondidas, este prompt integra las respuestas en el resumen inicial, creando una versión consolidada y validada de los requisitos.
3. **`Prompt-03-GeneraciónBacklog.md`**: Actúa como un Product Owner y Tech Lead. Transforma el resumen validado en un backlog estructurado en formato JSON, con Historias de Usuario, Tareas, Criterios de Aceptación y más.

### `Scripts`

Esta carpeta contiene los scripts de PowerShell que automatizan la carga del backlog a Azure DevOps.

- **`Invoke-BacklogCreation.ps1`**: Es el script orquestador. Lee la configuración (`config.json`) y el archivo de backlog final (`final_backlog.json`) para ejecutar el proceso. También gestiona la creación de logs.
- **`Create-BacklogFromJSON.ps1`**: Es el script principal que se conecta a la API de Azure DevOps. Es idempotente, lo que significa que puede ejecutarse varias veces sin crear duplicados. Lee el JSON y crea las Historias de Usuario y Tareas, enlazándolas correctamente.

### `DocxConverter`

Esta carpeta contiene un script de Python (`convert_docx_to_text.py`) diseñado para convertir archivos `.docx` a formato de texto plano (`.txt`). Es útil para pre-procesar documentos de Word, extrayendo su contenido textual para que pueda ser utilizado como insumo para los prompts de los LLMs. Soporta la conversión de archivos individuales o de todos los archivos `.docx` dentro de un directorio, manejando correctamente caracteres especiales del español con codificación UTF-8.

### `.BacklogsFile` (Work in Progress)

En esta carpeta se almacenan los archivos JSON generados durante las distintas etapas del flujo de prompts. Aquí es donde encontrarás los backlogs listos para ser procesados por los scripts.

### `.TmpFiles`

Este directorio funciona como el punto de entrada del flujo. Aquí es donde se deben colocar los archivos de "insumos" (los textos crudos) que serán procesados por el primer prompt. También se guardan aquí los archivos JSON producidos por los prompts.

### `Ideas`

Un espacio para la experimentación y el brainstorming. Contiene notas y versiones alternativas de prompts que se utilizan para mejorar la herramienta.

## Flujo de Trabajo General

1. **Pre-procesamiento (Opcional)**: Utilizar el script `convert_docx_to_text.py` en la carpeta `DocxConverter` para convertir documentos `.docx` a `.txt` si los insumos iniciales están en formato Word.
2. **Entrada**: Se colocan los documentos de texto crudo (o los `.txt` resultantes del pre-procesamiento) en la carpeta `.TmpFiles`.
3. **Síntesis (LLM)**: Se utiliza `Prompt-01` con los insumos para generar un archivo JSON de síntesis en `.TmpFiles`.
4. **Clarificación (Humano)**: Un analista edita el JSON, respondiendo a las preguntas generadas por el LLM.
5. **Fusión (LLM)**: Se utiliza `Prompt-02` con el JSON completado para obtener una versión final y coherente de los requisitos.
6. **Generación de Backlog (LLM)**: Se utiliza `Prompt-03` con el JSON final para producir un archivo `final_backlog.json` en la carpeta `.BacklogsFile`.
7. **Carga a ADO (Scripts)**: Se ejecuta el script `Invoke-BacklogCreation.ps1`, que lee el `final_backlog.json` de `.BacklogsFile` y crea los work items en Azure DevOps.
