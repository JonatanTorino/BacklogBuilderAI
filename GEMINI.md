# Contexto del Workspace: BacklogBuilderAI

## Propósito Principal

Este workspace, denominado **BacklogBuilderAI**, es una herramienta diseñada para automatizar la creación de backlogs en Azure DevOps a partir de insumos no estructurados (como transcripciones, documentos de requisitos o notas).

El flujo de trabajo principal se basa en un pipeline de tres etapas que utiliza Modelos de Lenguaje Grandes (LLMs) para procesar, refinar y estructurar la información, culminando en la generación automática de Work Items a través de scripts de PowerShell.

## Estructura de Carpetas Clave

A continuación se describe el propósito de cada directorio principal:

### `Prompts`

Esta es la carpeta más importante para entender la lógica de transformación. Contiene los prompts que guían a los LLMs en cada etapa del proceso:

1. **`Prompt-01-Sintesis.md`**: Actúa como un analista de negocio. Toma los insumos crudos, los resume y, crucialmente, identifica "gaps" de información (ambigüedades, omisiones, spikes de investigación, etc.), formulando preguntas claras en una estructura `openQuestions`.
2. **`Prompt-02-FusionRespuestas.md`**: Una vez que las preguntas han sido respondidas, este prompt integra las respuestas claras en el resumen. Si una respuesta es ambigua, refina la pregunta original, permitiendo un proceso de clarificación iterativo.
3. **`Prompt-03-GeneraciónBacklog.md`**: Actúa como un Product Owner y Tech Lead. Transforma el resumen refinado (que aún puede contener preguntas abiertas) en un backlog estructurado en formato JSON, creando tanto Historias de Usuario funcionales como Historias de Refinamiento para los gaps pendientes.

### `ScriptsForADO`

Esta carpeta contiene los scripts de PowerShell que automatizan la carga del backlog a Azure DevOps.

- **`Invoke-BacklogCreation.ps1`**: Es el script orquestador. Lee la configuración (`config.json`) y el archivo de backlog final (`final_backlog.json`) para ejecutar el proceso. También gestiona la creación de logs.
- **`Create-BacklogFromJSON.ps1`**: Es el script principal que se conecta a la API de Azure DevOps. Es idempotente, lo que significa que puede ejecutarse varias veces sin crear duplicados. Lee el JSON y crea las Historias de Usuario y Tareas, enlazándolas correctamente.

### `DocxConverter`

Esta carpeta contiene un script de Python (`convert_docx_to_text.py`) diseñado para convertir archivos `.docx` a formato de texto plano (`.txt`). Es útil para pre-procesar documentos de Word, extrayendo su contenido textual para que pueda ser utilizado como insumo para los prompts de los LLMs. Soporta la conversión de archivos individuales o de todos los archivos `.docx` dentro de un directorio, manejando correctamente caracteres especiales del español con codificación UTF-8.

### `KnowledgeBase/.BacklogsFile` (Work in Progress)

Este directorio contiene los **backlogs finales** en formato JSON, listos para ser consumidos por los scripts de PowerShell y cargados en Azure DevOps. Cada archivo representa un conjunto de historias de usuario, tareas y elementos fuera de alcance para una funcionalidad o épica específica.

### `KnowledgeBase/.SynthesisArchive` (Work in Progress)

Este directorio archiva los **documentos de síntesis y fusión** intermedios generados por el prompt del LLM (`Prompt-02-FusionRespuestas.md`). Estos archivos JSON capturan el análisis inicial, la identificación de gaps de información y el refinamiento posterior con las respuestas del usuario.

### `KnowledgeBase/ScopeDocuments`

Este directorio almacena los **documentos de alcance** en formato Markdown. Estos documentos se generan a partir de los archivos de síntesis/fusión (`.json`) y sirven como una descripción legible por humanos del resumen ejecutivo, las características clave y las restricciones acordadas antes de la generación del backlog.

### `.TmpFiles`

Este directorio funciona como repositorio de archivos temporales de trabajo en progreso. Aquí es donde se deben colocar los archivos de "insumos" (los textos crudos) que serán procesados por el primer prompt. También se guardan aquí los archivos JSON producidos por los prompts.

### `Ideas`

Un espacio para la experimentación y el brainstorming. Contiene notas y versiones alternativas de prompts que se utilizan para mejorar la herramienta.

## Flujo de Trabajo General

1. **Pre-procesamiento (Opcional)**: Utilizar el script `convert_docx_to_text.py` en la carpeta `DocxConverter` para convertir documentos `.docx` a `.txt` si los insumos iniciales están en formato Word.
2. **Entrada**: Se colocan los documentos de texto crudo (o los `.txt` resultantes del pre-procesamiento) en la carpeta `.TmpFiles`.
3. **Síntesis (LLM)**: Se utiliza `Prompt-01` con los insumos para generar un archivo JSON de síntesis en `.TmpFiles`.
4. **Clarificación (Humano)**: Un analista edita el JSON, rellenando el campo `"answer"` dentro de los objetos del array `openQuestions`.
5. **Fusión (LLM)**: Se utiliza `Prompt-02` con el JSON completado para obtener una versión refinada de los requisitos. El resultado es un nuevo JSON que integra las respuestas claras y mantiene las preguntas que necesitan más clarificación.
6. **Generación de Backlog (LLM)**: Se utiliza `Prompt-03` con el JSON refinado para producir un archivo `final_backlog.json` en la carpeta `.BacklogsFile`. Una vez usado, el archivo JSON de fusión de entrada se mueve a la carpeta `KnowledgeBase/.SynthesisArchive/`. Adicionalmente, se usa este mismo JSON para crear un documento de alcance en formato Markdown y guardarlo en `KnowledgeBase/ScopeDocuments/`.
7. **Carga a ADO (Scripts)**: Se ejecuta el script `Invoke-BacklogCreation.ps1`, que lee el `final_backlog.json` de `.BacklogsFile` y crea los work items en Azure DevOps.

---

## Protocolos de Interacción con Gemini

### Protocolo de Almacenamiento de Resultados

Al ejecutar un prompt de la carpeta `./Prompts/` que genere un archivo JSON como salida, se deben seguir estas reglas:

1. **Ubicación por Defecto**: El archivo resultante debe guardarse en el mismo directorio donde se encuentran los archivos de insumo (`NUEVOS_INSUMOS`).
2. **Gestión de Ambigüedad**: Si la ruta de origen es ambigua (múltiples carpetas de insumo), se debe preguntar explícitamente al usuario por la ruta de guardado.
3. **Convención de Nombres**: Para estandarizar los nombres de los archivos, se seguirá la siguiente convención:

    **Formato:** `YYYYMMDD.TópicoPrincipal.NN.Etapa.json`

    **Componentes:**
    - `YYYYMMDD`: Representa la fecha de creación como año (YYYY) mes (MM) día (DD).
    - `NN.Etapa`: Un prefijo numérico y una palabra clave que identifican la etapa del flujo.
        - `01.Sintesis`: Para la salida de `Prompt-01-Sintesis.md`.
        - `01.SintesisConsciente`: Para la salida de `Prompt-01-Consciente.md`.
        - `02.Fusion`: Para la salida de `Prompt-02-FusionRespuestas.md`.
        - `03.Backlog`: Para la salida de `Prompt-03-GeneracionBacklog.md`.
    - `TópicoPrincipal`: Tres (3) palabras clave extraídas del tópico principal de la síntesis, unidas en formato `PascalCase` (sin espacios ni puntos).

    **Ejemplos:**
    - `20251031.VisibilidadUIPatron.01.Sintesis.json`
    - `20251031.VisibilidadUIPatron.01.SintesisConsciente.json`
    - `20251102.FactoriaLicenciasPersistencia.02.Fusion.json`
    - `20251103.MaestroLicenciasUsuario.03.Backlog.json`

    Gemini debe proponer el nombre del archivo siguiendo esta convención antes de guardarlo.

### Protocolo de Ideación

Si durante nuestras interacciones se genera una nueva idea, insight o propuesta de mejora para el flujo de trabajo de **BacklogBuilderAI**, Gemini debe seguir estos pasos:

1. **Verbalizar la Idea**: Exponer la idea o insight de forma clara al usuario.
2. **Solicitar Consentimiento**: Preguntar al usuario si desea que la idea sea documentada.
3. **Documentar en la Carpeta `Ideas`**: Si el usuario está de acuerdo, crear un nuevo archivo Markdown (`.md`) en la carpeta `Ideas/`. El nombre del archivo debe ser descriptivo y resumir el contenido de la idea (ej: `Mejora_Cache_Prompts.md`).
