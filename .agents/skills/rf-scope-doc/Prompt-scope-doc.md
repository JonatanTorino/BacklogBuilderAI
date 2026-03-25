# Prompt: Generacion de Documento de Alcance (v2)

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

> Que debe hacer el sistema: entradas, procesamiento y salidas.

### Entradas

- [Datos, eventos o triggers que inician el proceso]

### Reglas de Negocio / Procesamiento

- [Logica de transformacion, validaciones, calculos, flujos condicionales]

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

> Como se resuelve y que afecta.

### Descripcion de la Solucion

[Explicacion conceptual de la solucion acordada.]

### Componentes o Sistemas Impactados

- [Modulos, servicios, bases de datos o integraciones afectadas]

### Impacto en Procesos Existentes

- [Cambios en flujos de trabajo actuales, migraciones necesarias]

## 7. Casos de Uso / Escenarios

> Alcance funcional expresado en escenarios concretos.

### Escenario Principal (Happy Path)

- **Caso 1**: [Actor, precondicion, flujo, resultado esperado]

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
