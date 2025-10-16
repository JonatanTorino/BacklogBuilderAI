ROL: Actúa como un Product Owner experto y un Tech Lead con experiencia en Agile. Has recibido un documento JSON (`synthesis_final`) que es una fuente de verdad, clara y validada, sobre los requerimientos de una funcionalidad.

TAREA:

1. Transforma las `keyFeatures` en Historias de Usuario bien formadas.
2. Para cada Historia de Usuario, Sigue formato "Como [rol] quiero [acción] para [beneficio]"
   - Título: Verbo + Objeto + Contexto (sin "Como [rol] quiero...")
   - Acceptance Criteria: Formato Gherkin (Dado/Cuando/Entonces)
   - Definition of Done: Lista verificable
3. Desglosa cada Historia en `tasks` técnicas accionables, cada una con un `title` y una `definitionOfDone` binaria.
4. Usa la sección `constraintsAndExclusions` para poblar la lista `outOfScope`.

REGLAS:

- No incluyas tareas de gestión (reuniones, etc.). Enfócate en tareas de desarrollo, diseño o configuración.
- Los criterios de aceptación deben ser verificables.

ACLARACION DE CONTEXTO:
Ya hicimos este trabajo de síntesis previamente y armamos un backlog. Te voy a pasar el resultado generado en la iteración anterior que fue revisado y ajustado.
El siguiente es el orden temporal de las archivos generado:

- `Backlog.LicenseManagment.00.json` posee la versión base del backlog, que fue revisado y ajustado.
- `synthesis_final.Gemini.v2.json` posee la síntesis nueva con diferencias sobre control de usuarios por cantidad de licencias.

OBEJETIVO PRINCIPAL:
Quiero dos json de salida, producto de la comparación de las diferencias sobre control de usuarios por cantidad de licencias. No podes modificar ni crear valores 'ADO_ID' ya que sirven de clave identificación única.

- Uno json con el delta del backlog con el incremental de las capacidades que encuentres de las diferencias de la versión base con la nueva `synthesis_final`.
- Otro json con las userStories movidas al nodo outOfScope como producto de la remoción ante redundancias sobre control de licencias por usuario ya que en el json DELTA prevalece lo que viene de la versión.

FORMATO DE SALIDA:
Genera exclusivamente un objeto JSON válido que se adhiera al siguiente esquema.

```json
{
  "userStories": [
    {
      "title": "string",
      "description": "string",
      "acceptanceCriteria": ["string"],
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
```
