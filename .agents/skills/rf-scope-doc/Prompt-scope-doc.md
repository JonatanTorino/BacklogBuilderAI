# Prompt: Generacion de Documento de Alcance (v3)

Eres un analista funcional experto. Tu tarea es generar un **Documento de Alcance Funcional** en formato Markdown a partir de los insumos proporcionados (transcripciones procesadas, sintesis, fusion u otros documentos de contexto).

Debes analizar el contenido de todos los insumos, identificar las definiciones clave, consolidar la informacion y estructurarla siguiendo estrictamente el template de abajo.

---

## Reglas de Generacion

1. **Formato**: Usa Markdown estandar. No inventes sintaxis.
2. **Estilo**: Prioriza la estructura y el contenido claro sobre el estilo visual (Estructura sobre Estilo).
3. **Contenido Faltante**: Si una seccion no tiene informacion en los insumos, indica "No especificado en la reunion" o "TBD", pero manten la seccion.
4. **Control de Cambios**: Genera una primera entrada en la tabla con la fecha de hoy, la version 1.0 y como autor "AI Assistant".
5. **Fuente**: Cita los archivos de origen en los metadatos.
6. **Flujo logico**: El documento sigue el flujo: Por que -> Para quien -> Que -> Como -> Como se valida -> Que no -> Que puede fallar.
7. **Concisión y no-redundancia**: Cada dato debe aparecer **una sola vez** en la seccion que mejor le corresponda. Si un concepto aplica a mas de una seccion, desarrollarlo en la seccion principal y en las demas solo referenciarlo (ej: "ver seccion 4"). Nunca repetir el mismo flujo, restriccion o decision en multiples secciones.

---

## Guia de diferenciacion entre secciones

Las siguientes secciones tienden a solaparse. Usa esta guia para decidir donde va cada cosa:

| Concepto | Seccion correcta | NO repetir en |
|----------|-------------------|---------------|
| Flujo paso a paso del proceso | **4. Requisitos Funcionales** (Reglas de Negocio) | 6 ni 7 |
| Decision de diseño / alternativas descartadas | **6. Solucion Propuesta** | 4 ni 8 |
| Componentes/sistemas afectados | **6. Solucion Propuesta** (Componentes Impactados) | 4 |
| Restricciones tecnicas, normativas o de arquitectura | **8. Restricciones** | 6 (Impacto en Procesos) |
| Trade-offs aceptados | **8. Restricciones** | 6 ni 10 |
| Escenarios concretos (happy path, alternativos, excepciones) | **7. Casos de Uso** | 4 |
| Gaps o puntos no desarrollados | **10. Riesgos** | 7 (Alternativos) |

**Reglas clave**:
- **Seccion 4 vs 7**: La seccion 4 describe el flujo **generico** del sistema. La seccion 7 describe **escenarios concretos** con actor, precondicion y resultado. Los casos de uso en seccion 7 deben referenciar el flujo de seccion 4 (ej: "Flujo segun seccion 4"), no re-describirlo.
- **Seccion 6 vs 8**: La seccion 6 explica **que se construye y por que** (decision de solucion). La seccion 8 lista **las limitaciones que enmarcan** esa solucion. No duplicar restricciones como "impacto en procesos" en seccion 6 si ya estan en seccion 8.
- **Seccion 8 vs 10**: La seccion 8 son **certezas** (restricciones confirmadas, dependencias conocidas). La seccion 10 son **incertidumbres** (riesgos, preguntas abiertas). Si algo es una restriccion firme, va en 8; si es un riesgo potencial, va en 10. No duplicar.

---

## Template del Documento de Alcance

```markdown
# Documento de Alcance: [Nombre del Proyecto/Modulo]

**Fecha de Creacion**: {{fecha_actual}}
**Fuentes**: [Lista de archivos procesados]

## 1. Control de Cambios

| Fecha | Version | Autor | Descripcion del Cambio |
|-------|---------|-------|------------------------|
| {{fecha_actual}} | 1.0 | AI Assistant | Creacion inicial basada en insumos procesados. |

## 2. Contexto y Objetivo

> Por que se necesita este cambio y que se busca lograr.

### Problema u Oportunidad de Negocio

[Descripcion del problema o la oportunidad que motiva este requerimiento. El "por que" fundamental.]

### Objetivo Esperado

[Resultado medible o verificable que se busca alcanzar con la implementacion.]

### Alcance del Documento

[Que cubre este documento en particular y en que contexto se enmarca.]

## 3. Interesados y Roles

> Quienes participan, deciden o se ven afectados.

| Rol | Nombre / Area | Participacion |
|-----|---------------|---------------|
| [ej: Product Owner] | [Nombre o area] | Aprueba |
| [ej: Usuario final] | [Nombre o area] | Consulta |

## 4. Requisitos Funcionales

> Que debe hacer el sistema: entradas, procesamiento y salidas. Esta es la UNICA seccion donde se describe el flujo paso a paso.

### Entradas

- [Datos, eventos o triggers que inician el proceso]

### Reglas de Negocio / Procesamiento

- [Flujo paso a paso. Esta es la fuente unica del flujo; las secciones 6 y 7 deben referenciar aqui, no repetirlo.]

### Salidas

- [Resultados esperados: reportes, notificaciones, cambios de estado]

### Formatos y Restricciones de Datos

- [Tipos, rangos, formatos especificos mencionados]

## 5. Requisitos No Funcionales

> Restricciones de calidad relevantes para este alcance.

- **Rendimiento**: [Tiempos de respuesta, volumenes esperados]
- **Seguridad / Permisos**: [Roles, accesos, datos sensibles]
- **Usabilidad**: [Expectativas de UX si aplica]
- **Compatibilidad**: [Navegadores, dispositivos, integraciones]

## 6. Solucion Propuesta e Impacto

> Como se resuelve y que afecta. Foco en la DECISION de diseño y alternativas descartadas. No re-describir el flujo (ya esta en seccion 4). Restricciones van en seccion 8.

### Descripcion de la Solucion

[Explicacion conceptual de la solucion acordada. Incluir alternativas descartadas y por que.]

### Componentes Impactados

- [Lista concisa de modulos, servicios o integraciones afectadas. No re-explicar que hace cada uno si ya se cubrio en seccion 4.]

## 7. Casos de Uso / Escenarios

> Escenarios concretos con actor y resultado. Para el flujo de procesamiento, referenciar seccion 4 en lugar de re-describirlo.

### Escenario Principal (Happy Path)

- **Caso 1**: [Actor, precondicion, referencia al flujo de seccion 4, resultado esperado]

### Escenarios Alternativos y de Excepcion

- **Alternativo 1**: [Descripcion de variante o camino alternativo]
- **Excepcion 1**: [Que pasa si algo falla o no se cumple una precondicion]

## 8. Supuestos, Restricciones y Dependencias

> Condiciones que enmarcan y limitan el alcance.

### Supuestos

- [Condiciones que se asumen verdaderas, ej: "El servicio X ya estara migrado"]

### Restricciones

- [Limitaciones tecnicas, presupuestarias, temporales o normativas]

### Dependencias

- [Otros equipos, sistemas, entregables o decisiones de las que depende este alcance]

## 9. Fuera de Alcance

> Lo que explicitamente NO se incluye en este requerimiento.

- [Funcionalidades o caracteristicas que se decidieron excluir y por que]

## 10. Riesgos e Incertidumbres

> Lo que puede fallar o aun no se sabe.

### Riesgos Identificados

| Riesgo | Probabilidad | Impacto | Mitigacion Propuesta |
|--------|-------------|---------|----------------------|
| [Descripcion] | Alta/Media/Baja | Alto/Medio/Bajo | [Accion sugerida] |

### Preguntas Abiertas / TBD

- [Puntos que requieren definicion o validacion antes de avanzar]

## 11. Glosario (opcional)

> Terminos de dominio o tecnicos que puedan ser ambiguos.

| Termino | Definicion |
|---------|-----------|
| [Termino] | [Definicion en contexto del proyecto] |
```

---

**Instrucciones finales**:

- Rellena los campos entre corchetes `[...]` con la informacion extraida de los insumos.
- Reemplaza `{{fecha_actual}}` con la fecha de hoy.
- Si una seccion no tiene informacion disponible, mantenla con "TBD" o "No especificado".
- Prioriza completar las secciones 2, 4 y 7 ya que son las mas criticas para la generacion posterior de historias de usuario.
- **Revision anti-redundancia (obligatoria antes de entregar)**: Revisa el documento completo y verifica que ningun concepto, restriccion, decision o flujo aparezca desarrollado en mas de una seccion. Si detectas duplicacion, conserva el contenido en la seccion principal segun la guia de diferenciacion y reemplaza las repeticiones por una referencia (ej: "ver seccion 4").
