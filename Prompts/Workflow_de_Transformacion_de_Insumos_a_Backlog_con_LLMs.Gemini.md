# **Workflow de Transformación de Insumos a Backlog con LLMs**

Este flujo optimizado utiliza una arquitectura de LLMs para transformar insumos crudos en un backlog listo para Azure DevOps, priorizando la calidad del análisis y permitiendo un refinamiento iterativo.

## **Arquitectura del Flujo (6 Etapas)**

### **Etapa 1: Recopilación de Insumos (Manual)**

* **Acción:** Recopilar todos los textos crudos (transcripciones, notas, borradores) de un único producto o funcionalidad.
* **Salida:** Colección de archivos de texto.

### **Etapa 2: Síntesis y Detección de Gaps (Automática - LLM 1)**

* **Acción:** Se alimenta todo el texto crudo al **"LLM de Síntesis"** (Prompt-01). Su objetivo es estructurar la información e identificar ambigüedades, omisiones, spikes de investigación y flujos alternativos no definidos.
* **Salida:** Un único archivo `synthesis_v1.json`.

### **Etapa 3: Clarificación de Gaps (Manual)**

* **Acción:** El analista responsable revisa la sección `openQuestions` del archivo `synthesis_v1.json`. Para cada punto, completa la propiedad `"answer"` con la respuesta o decisión correspondiente.
* **Salida:** El mismo archivo, ahora llamado `synthesis_with_answers.json`, con las respuestas completadas.

### **Etapa 4: Fusión de Respuestas y Refinamiento (Automática - LLM 1)**

* **Acción:** Se vuelve a utilizar el **"LLM de Fusión"** (Prompt-02). Se le proporciona el archivo `synthesis_with_answers.json`. El LLM integra las respuestas claras y, si una respuesta es ambigua, refina la pregunta para la siguiente iteración.
* **Salida:** Un archivo `synthesis_final.json` que contiene la información enriquecida y una lista actualizada de las `openQuestions` que aún requieren clarificación.

### **Etapa 5: Generación de Propuesta de Backlog (Automática - LLM 2)**

* **Acción:** El `synthesis_final.json` se entrega al **"LLM de Backlog"** (Prompt-03). Este modelo transforma la síntesis en un backlog estructurado, creando Historias de Usuario funcionales a partir de `keyFeatures` e Historias de Refinamiento a partir de las `openQuestions` y `followUpMeetings` pendientes.
* **Salida:** Un archivo `proposed_backlog.json`.

### **Etapa 6: Refinamiento Final y Carga (Manual + Script)**

* **Acción:**
    1. **Manual:** El equipo revisa el `proposed_backlog.json` y realiza ajustes finales.
    2. **Automática:** Se ejecuta un script de PowerShell que lee el archivo `final_backlog.json` y crea los work items en Azure DevOps.
* **Salida:** Work items creados en el backlog de ADO.

---

## **Estructuras JSON Clave**

### **1. `synthesis_v1.json` (Salida de Etapa 2)**

```json
{
  "topic": "Gestión de Usuarios",
  "executiveSummary": "Un párrafo que describe el objetivo principal de la funcionalidad.",
  "keyFeatures": [
    "Capacidad de registrar nuevos usuarios con correo electrónico.",
    "Generación de reportes en formato PDF."
  ],
  "constraintsAndExclusions": [
    "El sistema debe soportar 100 usuarios concurrentes.",
    "La exportación a Excel no se incluirá en esta versión."
  ],
  "openQuestions": [
    {
      "context": "Integración de pagos",
      "question": "Se menciona la 'integración con pagos' pero no se especifica el proveedor. ¿Qué proveedores de pago se deben soportar en la primera versión?",
      "answer": null
    },
    {
      "context": "Roles de usuario",
      "question": "No se definen roles de usuario más allá del 'administrador'. ¿Se necesita un rol de 'editor' o 'viewer' con permisos limitados?",
      "answer": null
    }
  ],
  "followUpMeetings": [
    {
      "proposedTopic": "Análisis de la arquitectura de microservicios para reportes",
      "goal": "Definir la estrategia de comunicación y los contratos de datos entre servicios."
    }
  ]
}
```

---

## **Prompts Optimizados para el Flujo**

### **Prompt para Etapa 2 (LLM 1 - Síntesis y Detección de Gaps)**

```text
# Tarea: Síntesis de Insumos y Detección de Gaps

ROL: Actúa como un analista de negocio senior. Tu tarea es analizar un conjunto de textos no estructurados, producir un resumen claro e identificar áreas que requieren clarificación, incluyendo spikes técnicos y flujos no definidos.

TAREA:
1.  Lee todos los textos proporcionados.
2.  Sintetiza la información en un resumen ejecutivo, una lista de características clave y las restricciones o exclusiones.
3.  **Análisis de Gaps**: Identifica proactivamente ambigüedades, omisiones, contradicciones, spikes de investigación y flujos alternativos no definidos.
4.  Formula cada gap identificado como un objeto dentro del array `openQuestions`.
5.  Para temas complejos, crea una propuesta de reunión en `followUpMeetings`.

FORMATO DE SALIDA:
Genera únicamente un objeto JSON válido que siga esta estructura exacta.

{
  "topic": "string",
  "executiveSummary": "string",
  "keyFeatures": ["string"],
  "constraintsAndExclusions": ["string"],
  "openQuestions": [
    {
      "context": "string",
      "question": "string",
      "answer": null
    }
  ],
  "followUpMeetings": [
    {
      "proposedTopic": "string",
      "goal": "string"
    }
  ]
}

<<<INSUMOS CRUDOS>>>
{pegar_textos_crudos_aquí}
<<<FIN>>>
```

### **Prompt para Etapa 4 (LLM 1 - Fusión de Respuestas)**

```text
# Tarea: Fusión de Respuestas y Refinamiento de Síntesis

ROL: Actúa como un analista de refinamiento senior. Tu tarea es procesar un documento de síntesis, integrar las respuestas proporcionadas y generar un único documento final, consolidado y listo para la siguiente etapa.

TAREA:
1.  **Fusión de Información**: Enriquece las secciones `executiveSummary`, `keyFeatures` y `constraintsAndExclusions` integrando la información de solo aquellos `openQuestions` que contengan un valor NO NULO en `"answer"`.
2.  **Gestión de Preguntas Abiertas (Gaps)**:
    *   **Integración**: Si la `answer` es clara, integra la información y elimina la pregunta.
    *   **Iteración por Ambigüedad**: Si la `answer` es ambigua, modifica la `question` para reflejar la necesidad de mayor clarificación y resetea su `answer` a `null`.
    *   **Preservación**: Mantén todas las `openQuestions` que originalmente tenían `answer: null` y aquellas que requieren iteración.

FORMATO DE SALIDA:
Genera únicamente un objeto JSON válido con la información fusionada y la lista de gaps actualizada.

{
  "executiveSummary": "string",
  "keyFeatures": ["string"],
  "constraintsAndExclusions": ["string"],
  "openQuestions": [/* ... */],
  "followUpMeetings": [/* ... */]
}

<<<JSON CON RESPUESTAS>>>
{pegar_el_contenido_de_synthesis_with_answers.json_aquí}
<<<FIN>>>
```

### **Prompt para Etapa 5 (LLM 2 - Generación de Backlog)**

```text
ROL: Actúa como un Product Owner experto y un Tech Lead con experiencia en Agile. Has recibido un documento JSON (`synthesis_final.json`) que es la fuente de verdad sobre los requerimientos y los Gaps de información pendientes.

TAREAS:
1.  **Historias Funcionales**: Transforma las `keyFeatures` en Historias de Usuario funcionales.
2.  **Historias de Refinamiento**: Analiza las secciones `openQuestions` y `followUpMeetings` y crea Historias de Usuario de tipo "Refinamiento" para resolver estos Gaps.
3.  Para cada historia, genera `acceptanceCriteria` y desglosa en `tasks` técnicas o de discovery.

FORMATO DE SALIDA:
Genera exclusivamente un objeto JSON válido que se adhiera al esquema de backlog.

{
  "userStories": [/* ... */],
  "outOfScope": [/* ... */]
}

<<<SÍNTESIS FINAL>>>
{pegar_el_contenido_de_synthesis_final.json_aquí}
<<<FIN>>>
```
