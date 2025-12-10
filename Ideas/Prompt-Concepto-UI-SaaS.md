# Rol
Actúa como un Diseñador de Producto Senior y Experto en UX/UI especializado en aplicaciones SaaS modernas y herramientas de productividad impulsadas por IA.

# Contexto
Estamos diseñando la interfaz para **BacklogBuilderAI**, una herramienta que transforma insumos no estructurados en backlogs estructurados. Queremos evolucionar la herramienta actual (basada en scripts) hacia una aplicación web completa estilo SaaS.

# Objetivo
Diseñar el flujo de usuario y la interfaz visual para una aplicación web que permita a los usuarios cargar información cruda, visualizar su procesamiento por IA y generar entregables de valor.

# Requerimientos Funcionales y de Flujo

## 1. Módulo de Ingesta (Input)
El usuario debe tener una forma intuitiva y unificada de cargar sus fuentes de información.
- **Área de "Drag & Drop"**: Debe ser el punto focal de la pantalla de inicio.
- **Formatos Soportados**:
    - **Audio/Video**: Archivos de reuniones, grabaciones de voz. (Requiere indicación visual de transcripción).
    - **Documentos Word (.docx)**: **CRÍTICO**. El sistema debe ser capaz de recibir archivos .docx e indicar claramente que se están transformando automáticamente a texto plano (.txt) para su procesamiento.
    - **Archivos de Texto (.txt)**: Carga directa.
- **Feedback de Carga**: Indicadores claros de "Subiendo", "Validando formato", "Listo para procesar".

## 2. Visualización del Procesamiento (La "Magia")
Evitar las "cajas negras". El usuario debe ver que la IA está trabajando, aumentando la confianza en el resultado.
- **Pipeline Visual**: Mostrar el progreso paso a paso.
    - Ejemplo para .docx: "Convirtiendo documento..." -> "Analizando texto..." -> "Identificando historias de usuario...".
    - Ejemplo para Audio: "Transcribiendo..." -> "Sintetizando..." -> "Generando estructura...".
- **Estado 'En Vivo'**: Logs simplificados o visualizaciones de ondas/texto apareciendo que den sensación de actividad.

## 3. Configuración de la Transformación
Una vez procesado el insumo (o durante la configuración), el usuario debe poder elegir qué "lente" usar para la transformación:
- **Generación de Backlog**: El flujo principal. Crear Historias de Usuario, Criterios de Aceptación y Tareas.
- **Resumen Ejecutivo**: Sintetizar los puntos clave (ideal para managers).
- **Mapas Mentales**: Visualizar la estructura o jerarquía de los temas tratados.
- **Detección de Tareas (Action Items)**: Extraer compromisos y fechas de una reunión.
- **ADR (Architecture Decision Records)**: Generar registros de decisiones arquitectónicas usando el template de Michael Nygard, con metadata adicional de fecha y participantes después del título.

## 4. Resultados y Exportación
- **Vista Previa**: Editor rico donde el usuario puede refinar el resultado de la IA antes de finalizar.
- **Exportación Flexible**:
    - Conexión directa a Azure DevOps (para backlogs).
    - Descarga en JSON, Markdown, PDF.
    - Copiar al portapapeles.

# Guías de Estilo (UI/UX)
- **Estilo Visual**: Moderno, "Clean SaaS", uso de Glassmorphism sutil, soporte nativo para Dark Mode.
- **Paleta de Colores**: Profesional pero vibrante (ej. acentos en azules eléctricos o violetas IA sobre fondos neutros).
- **Tipografía**: Sans-serif, altamente legible (Inter, Roboto, o similar).
- **Interacción**: Micro-interacciones suaves al pasar el mouse, transiciones fluidas entre estados. La app debe sentirse rápida y reactiva.