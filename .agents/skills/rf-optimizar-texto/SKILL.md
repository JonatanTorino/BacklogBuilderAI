---
name: rf-optimizar-texto
description: >
  Refactoriza y optimiza cualquier texto (prompts, emails, documentación, user stories,
  instrucciones, mensajes) eliminando redundancias, ambigüedades y relleno cognitivo.
  Trata el lenguaje natural como código fuente: suprime cortesías vacías, reemplaza
  adjetivos vagos por parámetros concretos, usa verbos de acción directos y delimita
  secciones con marcadores estructurales. Soporta español e inglés.
  Usar este skill siempre que el usuario pida "optimizar", "refactorizar", "mejorar",
  "limpiar" o "condensar" un texto, prompt, email, mensaje o documento. También
  invocar cuando el usuario diga "hace falta mejorar esto", "está muy verboso",
  "simplificá esto", "rewrite this", "clean this up" o pegue un bloque de texto
  pidiendo que quede más claro o directo.
---

## Descripción

Optimiza cualquier texto aplicando principios de ingeniería de prompts: eliminar ruido,
precisar el lenguaje y estructurar el contenido. El resultado es más legible, accionable
y eficiente, sin perder información esencial.

## Cuándo invocar

- El usuario pega un bloque de texto entre triple backticks y pide optimizarlo
- El usuario proporciona la ruta de un archivo y pide optimizarlo
- Frases disparadoras: "optimizá este texto", "refactorizá esto", "está muy verboso",
  "simplificá", "clean this up", "rewrite this", "make this cleaner/shorter/clearer"

## Principios de optimización

Aplicar todos los que correspondan al texto recibido:

### 1. Eliminación de relleno cognitivo
Suprimir sin reemplazar:
- Saludos y cierres de cortesía ("Hola, espero estés bien", "Muchas gracias de antemano")
- Introducciones blandas ("Me gustaría que...", "¿Podrías por favor...?", "I was wondering if...")
- Frases de relleno ("básicamente", "en términos generales", "kind of", "sort of", "just")
- Redundancias verbales ("hacer una revisión de" → "revisar")

### 2. Sustitución de adjetivos vagos por parámetros
Convertir calificativos subjetivos en especificaciones concretas:
- "una respuesta muy detallada" → `Formato: lista técnica, mínimo 5 ítems con ejemplos`
- "algo corto" → `Extensión: máximo 3 oraciones`
- "de buena calidad" → `Criterio: sin errores de lógica, con casos de uso reales`

### 3. Verbos de acción directos
Usar imperativo; eliminar circunloquios:
- "Quiero que intentes analizar" → `Analiza`
- "Sería bueno que pudieras listar" → `Lista`
- "I was hoping you could help me understand" → `Explain`

### 4. Delimitación de secciones
Separar instrucciones, contexto y datos con marcadores:
- `###` para secciones temáticas
- `---` para separar bloques distintos
- `""` o bloques de código para datos/ejemplos literales

### 5. Eliminación de redundancias semánticas
Detectar y fusionar ideas repetidas con distintas palabras. Si dos oraciones dicen
lo mismo, conservar la más precisa y eliminar la otra.

### 6. Densificación de estructura
Convertir párrafos narrativos en listas cuando corresponda. Agrupar ítems relacionados.
Usar jerarquía (títulos, sublistas) si el texto tiene múltiples conceptos independientes.

---

## Instrucciones

### Paso 1: Identificar el modo de entrada

**Modo A — Bloque de texto (triple backticks):**
El usuario pegó el texto directamente. Leer el contenido del bloque.

**Modo B — Ruta de archivo:**
El usuario proporcionó una ruta. Leer el archivo con el tool `Read`.

### Paso 2: Evaluar si el texto necesita optimización

Antes de transformar, analizar el texto. Si el texto ya es conciso, directo y bien
estructurado, informar al usuario con un mensaje breve:

> "Este texto ya está optimizado. No se detectaron redundancias, relleno ni ambigüedades
> significativas."

No forzar cambios cosméticos innecesarios.

### Paso 3: Aplicar los principios de optimización

Aplicar de forma agresiva pero sin perder información esencial:
- Preservar el significado y la intención original
- Si el texto tiene tono formal/informal, mantenerlo a menos que sea el problema
- Si hay términos técnicos o nombres propios, no simplificarlos
- Si el idioma es inglés, optimizar en inglés; si es español, en español; si mezcla, mantener la mezcla

### Paso 4: Entregar el resultado

**Modo A — Bloque de texto:**
Devolver el texto optimizado en un bloque de código markdown (triple backticks).
No incluir explicaciones a menos que el usuario las pida, excepto en estos casos:
- Si se eliminaron más del 30% del contenido original, agregar una nota breve indicando qué se removió y por qué
- Si se detectó un problema estructural importante (ej. ambigüedad de destinatario, instrucciones contradictorias), mencionarlo en una línea

**Modo B — Ruta de archivo:**
Sobreescribir el archivo con el texto optimizado usando el tool `Write` o `Edit`.
Confirmar al usuario con: `✓ Archivo optimizado: <ruta>`
Agregar la misma nota si se eliminó más del 30% del contenido.

---

## Ejemplo

**Input:**
```
Hola! Espero que estés teniendo un buen día. Me gustaría pedirte si podrías ayudarme
a entender qué es un patrón de diseño Singleton porque estoy programando en C# y
la verdad es que no me queda muy claro cómo implementarlo correctamente en mi proyecto.
Si puedes, sería genial que me des una explicación detallada con algún ejemplo.
Muchas gracias!
```

**Output:**
```
Explica el patrón Singleton en C#.
Incluye: definición técnica, implementación thread-safe y 3 errores comunes de uso.
```
