# Idea: Implementación de Skills Especializados para Refinamiento y Alcance

Este documento propone la evolución del flujo de **BacklogBuilderAI** mediante el uso de **Skills**, permitiendo que la IA asuma roles expertos para refinar requerimientos, definir alcances precisos y maximizar la reutilización de capacidades estándar.

## Concepto

El objetivo es permitir que Gemini CLI active "modos expertos" según la necesidad del proyecto, mejorando la calidad del backlog al aplicar conocimientos específicos de una plataforma o dominio, asegurando que las soluciones propuestas sean eficientes y sigan las mejores prácticas de la industria.

## Caso de Ejemplo: Skill D365FO (Refinamiento y Alcance)

Como prueba de concepto, se plantea un skill enfocado en **Dynamics 365 Finance & Operations (D365FO)** para ayudar a definir características y alcances al construir funcionalidades de productos montados en este ERP.

### 1. Definición de Características y Alcance

Ayudar a delimitar qué funcionalidades deben construirse y cuáles pueden resolverse mediante configuración estándar. El skill debe:

- Analizar si el requerimiento puede ser cubierto total o parcialmente por capacidades estándar del sistema (ej. Workflows, Alertas, Configurator).
- Sugerir configuraciones funcionales antes de proponer personalizaciones de código.

### 2. Extensibilidad y Reutilización

Orientar la definición técnica hacia la reutilización y extensión de objetos estándar:

- Identificar puntos de extensión (Events, Chain of Command) que minimicen el impacto en el core del ERP.
- Recomendar el uso de Frameworks estándar (ej. SysOperation, NumberSeq, Data Entities) para mantener la consistencia del sistema y facilitar actualizaciones futuras (Evergreen).

## Beneficios Esperados

- **Reducción de Deuda Técnica**: Menos personalizaciones innecesarias al aprovechar mejor el estándar del producto.
- **Backlogs de Alta Calidad**: Historias de usuario con criterios de aceptación alineados a la realidad técnica de la plataforma.
- **Eficiencia en el Desarrollo**: Fomentar la reutilización de componentes existentes, acelerando los tiempos de implementación.
