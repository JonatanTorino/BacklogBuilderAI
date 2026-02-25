# Contexto: Prompts del Sistema

Este directorio alberga los prompts maestros que guían a los LLMs en cada etapa del pipeline de **BacklogBuilderAI**.

## Flujo Principal
1.  **`Prompt-01-Sintesis.md`**: Analista de Negocio. Sintetiza insumos y detecta gaps.
2.  **`Prompt-02-FusionRespuestas.md`**: Analista de Refinamiento. Integra respuestas humanas a los gaps.
3.  **`Prompt-03-GeneracionBacklog.md`**: Product Owner / Tech Lead. Genera el backlog funcional y de refinamiento.

## Variantes y Utilidades
- **`Prompt-01-Consciente.md`**: Versión avanzada de síntesis con contexto histórico.
- **`Prompt-04-GeneracionBacklogSpliteado.md`**: Generación separada de historias funcionales vs refinamiento.
- **`Prompt-Alcance-Funcional.md`**: Generador de documentos de alcance funcional desde transcripciones.
- **`Prompt-ADR-Generator.md`**: Generador de registros de decisiones de arquitectura.
- **`Prompt-Limpieza-VTT.md`**: Utilidad para limpiar transcripciones.
- **`Prompt-Resumen-Reunion.md`**: Generador de resúmenes de reuniones.
- **`Prompt-action-items.md`**: Generador de reportes de Action Items.
- **`Prompt-manual-doc.md`**: Generador de Manuales de Usuario.
- **`Prompt-scope-doc.md`**: Generador de Documentos de Alcance.

## Protocolo de Gestión de Prompts

Cada vez que se añada un nuevo archivo de prompt a este directorio, se debe seguir el siguiente protocolo:

1.  **Crear Comando Personalizado**: Se debe crear un archivo de configuración `.toml` en la ruta `.gemini/commands/Prompt/`.
2.  **Configuración del Comando**: El archivo `.toml` debe definir un comando que automatice el uso del nuevo prompt, utilizando las herramientas disponibles (como `read_file`, `write_file`, etc.) para procesar los insumos correspondientes.
3.  **Registro**: Se debe actualizar la sección "Comandos Disponibles" en este archivo (`Prompts/GEMINI.md`) para reflejar la asociación entre el nuevo comando y el prompt.

## Comandos Disponibles

A continuación se listan los comandos personalizados existentes y su prompt asociado:

| Comando | Prompt Asociado | Descripción |
| :--- | :--- | :--- |
| `/Prompt/sintesis` | `Prompt-01-Sintesis.md` | Analiza insumos, sintetiza requisitos y detecta gaps. |
| `/Prompt/sintesis-consciente` | `Prompt-01-Consciente.md` | Síntesis avanzada que contrasta nuevos insumos con el contexto histórico. |
| `/Prompt/fusion` | `Prompt-02-FusionRespuestas.md` | Integra respuestas humanas a los gaps identificados en la síntesis. |
| `/Prompt/backlog` | `Prompt-03-GeneracionBacklog.md` | Genera un backlog completo (funcional y refinamiento) desde la síntesis final. |
| `/Prompt/backlog-spliteado` | `Prompt-04-GeneracionBacklogSpliteado.md` | Genera backlogs específicos (solo funcionales o solo refinamiento). |
| `/Prompt/adicionar-tareas` | `Prompt-05-AdicionarTareasAuxiliares.md` | Adiciona tareas auxiliares (QA, Doc) a un backlog funcional existente. |
| `/Prompt/adr` | `Prompt-ADR-Generator.md` | Genera registros de decisiones de arquitectura (ADR) desde transcripciones. |
| `/Prompt/alcance` | `Prompt-Alcance-Funcional.md` | Genera Documentos de Alcance Funcional desde transcripciones. |
| `/Prompt/limpiar-vtt` | `Prompt-Limpieza-VTT.md` | Limpia metadatos técnicos de archivos de transcripción .vtt. |
| `/Prompt/resumen-reunion` | `Prompt-Resumen-Reunion.md` | Genera resúmenes ejecutivos de reuniones desde transcripciones. |
| `/Prompt/resumen-conciso` | `Prompt-Resumen-Conciso.md` | Genera resúmenes ultra-concisos (Objetivo, Accionables, Pendientes). |
| `/Prompt/action-items` | `Prompt-action-items.md` | Genera un reporte de elementos de acción (Action Items) desde transcripciones. |
| `/Prompt/manual-doc` | `Prompt-manual-doc.md` | Genera un Manual de Usuario desde transcripciones. |
| `/Prompt/scope-doc` | `Prompt-scope-doc.md` | Genera un Documento de Alcance desde transcripciones. |
