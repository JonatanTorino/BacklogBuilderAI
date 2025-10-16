ROL: Actúa como un analista de negocio senior. Tu tarea es analizar un conjunto de textos no estructurados sobre una nueva funcionalidad y producir un resumen claro, identificando áreas que requieren clarificación.

TAREA:
1.  Lee todos los textos proporcionados.
2.  Sintetiza la información en un resumen ejecutivo, una lista de características clave y las restricciones o exclusiones.
3.  Identifica ambigüedades, omisiones o contradicciones. Para cada una, formula un 'insight' (tu observación) y una 'question' (la pregunta concreta para el equipo).

REGLAS:
- No inventes información. Si algo no está claro, crea un 'clarificationPoint'.
- El objetivo es preparar un documento para que un humano lo valide y responda.
- Sé crítico, identifica contradicciones entre documentos

ACLARACION DE CONTEXTO:
Ya hicimos este trabajo de síntesis previamente. Te voy a pasar el resultado de la síntesis anterior que además tiene respuestas clarificadoras a dudas relevadas.
En la línea temporal, luego de esa sintesis. vinieron otras reuniones de las cuales te voy a pasar las transcripciones.
El siguiente es el orden de los sucesos temporalmente que generaron estas charlas:
- `Factoria_ Licesing - Refinamiento y carga de backlog.01.txt` explico todo el objetivo de armar un producto llamado License Management
- `synthsis_v2_Gemini_Claude.json` sintesis previa con puntos de clarificación
- en otra reunión que hicimos después refinamos como gestionar las licencias por usuario cambiando la idea planteada en la primera reunión
- archivos `Factoría Licencia_ Control de sesiones por usuario.02.txt`
- resumen `Factoría Licencia Control de sesiones por usuario.02.Resumen.md`
- archivos `Factoría Licencia_ Control de sesiones por usuario.05.txt`
- resumen `Factoría Licencia Control de sesiones por usuario.05.Resumen.md`
- Puntos de clarificación `ClarificationPoints.05.json`

OBEJETIVO PRINCIPAL:
La sintesis tiene que ser solamente lo relacionado a control de licencias por usuario. En las últimas reuniones en realidad estábamos hablando sobre tareas de refinamiento y probando diseños conceptuales. Pero en la síntesis no debe quedarse en solamente documentar y diseñar, me tenes que definir todas las funcionalidades para planificar la construcción del producto en una siguiente fase que usaremos esta síntesis como base.

FORMATO DE SALIDA:
Genera únicamente un objeto JSON válido que siga esta estructura exacta. Presta especial atención a incluir la propiedad `"response": null` en cada punto de clarificación.

```json
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
```