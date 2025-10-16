# **Workflow de Transformación de Insumos a Backlog con LLMs**

Este flujo optimizado utiliza una arquitectura de dos LLMs para transformar insumos crudos en un backlog listo para Azure DevOps, priorizando la simplicidad y la calidad del análisis sobre la trazabilidad.

## **Arquitectura del Flujo (6 Etapas)**

### **Etapa 1: Recopilación de Insumos (Manual)**

* **Acción:** Recopilar todos los textos crudos (transcripciones, notas, borradores) de un único producto o funcionalidad.
* **Salida:** Colección de archivos de texto.

### **Etapa 2: Síntesis y Detección de Gaps (Automática - LLM 1)**

* **Acción:** Se alimenta todo el texto crudo al **"LLM de Síntesis"**. Su objetivo es estructurar la información y, crucialmente, identificar ambigüedades y vacíos de información.
* **Salida:** Un único archivo `synthesis_v1.json`.

### **Etapa 3: Clarificación de Gaps (Manual)**

* **Acción:** El analista responsable revisa la sección `clarificationPoints` del archivo `synthesis_v1.json`. Para cada punto, completa la propiedad `"response"` con la respuesta o decisión correspondiente.
* **Salida:** El mismo archivo, ahora llamado `synthesis_with_answers.json`, con las respuestas completadas.

### **Etapa 4: Fusión de Respuestas (Automática - LLM 1)**

* **Acción:** Se vuelve a utilizar el **"LLM de Síntesis"**. Se le proporciona el archivo `synthesis_with_answers.json` con la instrucción de integrar las respuestas dentro de las secciones principales (`keyFeatures`, `constraintsAndExclusions`, etc.) para enriquecerlas.
* **Salida:** Un archivo `synthesis_final.json` limpio, coherente y sin la sección de preguntas, listo para ser usado por el siguiente LLM.

### **Etapa 5: Generación de Propuesta de Backlog (Automática - LLM 2)**

* **Acción:** El `synthesis_final.json` se entrega al **"LLM de Backlog"**. Este modelo, especializado en Agile, transforma la síntesis validada en un backlog estructurado con Historias de Usuario y Tareas.
* **Salida:** Un archivo `proposed_backlog.json`.

### **Etapa 6: Refinamiento Final y Carga (Manual + Script)**

* **Acción:**
    1. **Manual:** El equipo revisa el `proposed_backlog.json`, realiza ajustes finales y valida que no haya duplicados obvios con el backlog existente en ADO.
    2. **Automática:** Se ejecuta un script de PowerShell que lee el archivo `final_backlog.json` y crea los work items en Azure DevOps vía API.
* **Salida:** Work items creados en el backlog de ADO.

---

## **Estructuras JSON Simplificadas**

### **1. `synthesis_v1.json` (Salida de Etapa 2)**

*Inspirado en Gemini y Claude, enfocado en la simplicidad y el análisis de negocio.*

```json
{
  "executiveSummary": "Un párrafo que describe el objetivo principal de la funcionalidad.",
  "keyFeatures": [
    "Capacidad de registrar nuevos usuarios con correo electrónico.",
    "Generación de reportes en formato PDF."
  ],
  "constraintsAndExclusions": [
    "El sistema debe soportar 100 usuarios concurrentes.",
    "La exportación a Excel no se incluirá en esta versión."
  ],
  "clarificationPoints": [
    {
      "insight": "Se menciona la 'integración con pagos' pero no se especifica el proveedor.",
      "question": "¿Qué proveedores de pago se deben soportar en la primera versión?",
      "response": null
    },
    {
      "insight": "No se definen roles de usuario más allá del 'administrador'.",
      "question": "¿Se necesita un rol de 'editor' o 'viewer' con permisos limitados?",
      "response": null
    }
  ]
}
```

### **2. `final_backlog.json` (Salida de Etapa 5 y 6)**

*Inspirado en Gemini, alineado con las prácticas Agile y listo para la API.*

```json
{
  "userStories": [
    {
      "title": "Registro de nuevos usuarios con correo electrónico",
      "description": "Como un usuario nuevo, quiero registrarme en la plataforma usando mi correo y una contraseña, para poder acceder a sus funcionalidades.",
      "acceptanceCriteria": [
        "Dado que no estoy registrado, cuando ingreso un correo válido y una contraseña segura, entonces el sistema crea mi cuenta y me envía un correo de bienvenida.",
        "Dado que intento registrarme con un correo que ya existe, cuando envío el formulario, entonces el sistema me muestra un error indicando que el correo ya está en uso."
      ],
      "definitionOfDone": [
        "Código revisado y mergeado",
        "Pruebas unitarias > 80% coverage",
        "Validación de QA aprobada"
      ],
      "tasks": [
        {
          "title": "Crear el endpoint de API para el registro de usuarios",
          "definitionOfDone": "El endpoint está desplegado en el entorno de desarrollo y documentado en Swagger."
        },
        {
          "title": "Diseñar y construir el formulario de registro en la UI",
          "definitionOfDone": "El componente de UI está creado y validado contra los campos requeridos."
        }
      ]
    }
  ],
  "outOfScope": [
    {
      "topic": "Exportación a Excel",
      "reason": "Excluido explícitamente para la versión inicial."
    }
  ]
}
```

---

## **Prompts Optimizados para el Flujo**

### **Prompt para Etapa 2 (LLM 1 - Síntesis y Detección de Gaps)**

*Combina la claridad de Gemini con el enfoque de negocio de Claude.*

```text
ROL: Actúa como un analista de negocio senior. Tu tarea es analizar un conjunto de textos no estructurados sobre una nueva funcionalidad y producir un resumen claro, identificando áreas que requieren clarificación.

TAREA:
1.  Lee todos los textos proporcionados.
2.  Sintetiza la información en un resumen ejecutivo, una lista de características clave y las restricciones o exclusiones.
3.  Identifica ambigüedades, omisiones o contradicciones. Para cada una, formula un 'insight' (tu observación) y una 'question' (la pregunta concreta para el equipo).

REGLAS:
- No inventes información. Si algo no está claro, crea un 'clarificationPoint'.
- El objetivo es preparar un documento para que un humano lo valide y responda.
- Sé crítico, identifica contradicciones entre documentos

FORMATO DE SALIDA:
Genera únicamente un objeto JSON válido que siga esta estructura exacta. Presta especial atención a incluir la propiedad `"response": null` en cada punto de clarificación.

{
  "executiveSummary": "string",
  "keyFeatures": ["string"],
  "constraintsAndExclusions": ["string"],
  "clarificationPoints": [
    {
      "insight": "string",
      "question": "string",
      "response": null
    }
  ]
}

<<<INSUMOS CRUDOS>>>
{pegar_textos_crudos_aquí}
<<<FIN>>>
```

### **Prompt para Etapa 4 (LLM 1 - Fusión de Respuestas)**

*Un prompt nuevo y específico para la tarea de refinamiento.*

```text
ROL: Actúa como un analista de refinamiento. Has recibido un documento JSON que contiene una síntesis de requerimientos y una serie de preguntas que ya han sido respondidas por el equipo.

TAREA:
1.  Lee el JSON de entrada, prestando atención a las respuestas en la sección `clarificationPoints`.
2.  Modifica y enriquece las secciones `executiveSummary`, `keyFeatures` y `constraintsAndExclusions` integrando la información de esas respuestas.
3.  El objetivo es crear una versión final y coherente de la síntesis que ya no contenga ambigüedades.

REGLAS:
- Las respuestas prevalecen sobre la información original si hay conflicto.
- Una vez que una respuesta ha sido integrada, el punto de clarificación correspondiente debe ser eliminado.
- La salida final NO debe contener la sección `clarificationPoints`.

FORMATO DE SALIDA:
Genera únicamente un objeto JSON válido con la información fusionada y sin la sección de preguntas.

{
  "executiveSummary": "string",
  "keyFeatures": ["string"],
  "constraintsAndExclusions": ["string"]
}

<<<JSON CON RESPUESTAS>>>
{pegar_el_contenido_de_synthesis_with_answers.json_aquí}
<<<FIN>>>
```

### **Prompt para Etapa 5 (LLM 2 - Generación de Backlog)**

*Inspirado en Gemini y DeepSeek, enfocado en la calidad de los artefactos Agile.*

```text
ROL: Actúa como un Product Owner experto y un Tech Lead con experiencia en Agile. Has recibido un documento JSON (`synthesis_final.json`) que es una fuente de verdad, clara y validada, sobre los requerimientos de una funcionalidad.

TAREA:
1.  Transforma las `keyFeatures` en Historias de Usuario bien formadas.
2.  Para cada Historia de Usuario, Sigue formato "Como [rol] quiero [acción] para [beneficio]"
  - Título: Verbo + Objeto + Contexto (sin "Como [rol] quiero...")
  - Acceptance Criteria: Formato Gherkin (Given/When/Then)
  - Definition of Done: Lista verificable
3.  Desglosa cada Historia en `tasks` técnicas accionables, cada una con un `title` y una `definitionOfDone` binaria.
4.  Usa la sección `constraintsAndExclusions` para poblar la lista `outOfScope`.

REGLAS:
- No incluyas tareas de gestión (reuniones, etc.). Enfócate en tareas de desarrollo, diseño o configuración.
- Los criterios de aceptación deben ser verificables.

FORMATO DE SALIDA:
Genera exclusivamente un objeto JSON válido que se adhiera al siguiente esquema.

{
  "userStories": [
    {
      "title": "string",
      "description": "string",
      "acceptanceCriteria": ["string"],
      "definitionOfDone": ["string"],
      "tasks": [
        {
          "title": "string",
          "definitionOfDone": "string"
        }
      ]
    }
  ],
  "outOfScope": [
    {
      "topic": "string",
      "reason": "string"
    }
  ]
}

<<<SÍNTESIS FINAL>>>
{pegar_el_contenido_de_synthesis_final.json_aquí}
<<<FIN>>>
```

---

### **Ventajas de este Flujo Híbrido V3**

* **Pragmático y Simple:** Evita la complejidad de la trazabilidad y los JSON sobrecargados, centrándose en lo esencial.
* **Arquitectura Limpia:** La separación de responsabilidades (Síntesis vs. Backlog) asegura que cada LLM realice una tarea en la que es bueno, mejorando la calidad del resultado.
* **Control Humano Eficaz:** El punto de intervención manual es simple y potente: solo hay que rellenar las respuestas.
* **Orientado a la Acción:** El objetivo es claro: alivianar la carga inicial y generar un backlog "suficientemente bueno" para que el equipo de desarrollo pueda empezar a construir rápidamente.
* **Sin Desarrollo Adicional:** El flujo está diseñado para ser ejecutado usando interfaces de chat existentes, con solo un script final para la automatización de la carga.
