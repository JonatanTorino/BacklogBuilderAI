# Contexto: Prompts del Sistema

Este directorio alberga los prompts maestros que guían a los LLMs en cada etapa del pipeline de **BacklogBuilderAI**.

## Flujo Principal
1.  **`Prompt-01-Sintesis.md`**: Analista de Negocio. Sintetiza insumos y detecta gaps.
2.  **`Prompt-02-FusionRespuestas.md`**: Analista de Refinamiento. Integra respuestas humanas a los gaps.
3.  **`Prompt-03-GeneracionBacklog.md`**: Product Owner / Tech Lead. Genera el backlog funcional y de refinamiento.

## Variantes y Utilidades
- **`Prompt-01-Consciente.md`**: Versión avanzada de síntesis con contexto histórico.
- **`Prompt-04-GeneracionBacklogSpliteado.md`**: Generación separada de historias funcionales vs refinamiento.
- **`Prompt-ADR-Generator.md`**: Generador de registros de decisiones de arquitectura.
- **`Prompt-Limpieza-VTT.md`**: Utilidad para limpiar transcripciones.
- **`Prompt-Resumen-Transcripcion.md`**: Generador de resúmenes de reuniones.
