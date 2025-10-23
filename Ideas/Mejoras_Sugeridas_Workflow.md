# Ideas de mejoras

## Idea 1: "Prompt de Síntesis Consciente del Historial" (Propuesta del usuario)

**Concepto:** Crear una variante del `prompt-01`, (`Prompt-01-Consciente.md`). Antes de analizar los nuevos insumos, este prompt recibiría como contexto adicional el contenido de todos los archivos `.json` existentes en la carpeta `.BacklogsFile`.

**Beneficios:**

- **Detección de Duplicados/Superposiciones:** Identificar si una nueva solicitud es similar a un refinamiento anterior.
- **Consistencia Arquitectónica:** Proponer soluciones consistentes con la arquitectura ya establecida.
- **Identificación de Dependencias:** Detectar dependencias entre los nuevos insumos y los refinamientos pasados.

## Idea 2: "Generador de Artefactos de Código X++ (Boilerplate)"

**Concepto:** Crear un `Prompt-05-GeneradorCodigoX++.md` que tome una síntesis refinada y genere código base (boilerplate) en X++ para acelerar el prototipado.

**Beneficios:**

- **Aceleración del Prototipado:** Generar automáticamente clases `helper`, `DataContracts`, `enums`, etc.
- **Documentación Viva:** El propio código generado se convierte en la primera versión de la documentación técnica.

## Idea 3: "Prompt de Auto-Revisión de Calidad del Backlog"

**Concepto:** Crear un `Prompt-04-QualityCheck.md` que revise la salida del `prompt-03` y actúe como un "Agile Coach" automatizado.

**Beneficios:**

- **Mejora de la Calidad del Backlog:** Generar insights sobre historias de usuario demasiado grandes, falta de tareas de backend, criterios de aceptación ambiguos, etc.
