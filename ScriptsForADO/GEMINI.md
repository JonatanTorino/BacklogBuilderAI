# Azure DevOps Backlog Builder Scripts

## Files and Responsibilities

### Invoke-BacklogCreation.ps1

Script orquestador que gestiona:

- Administración de la configuración
- Configuración y gestión de registros
- Manejo y reporte de errores
- Ejecución del proceso principal de creación del backlog

### Create-BacklogFromJSON.ps1

Implementación principal que:

- Lee la estructura del backlog desde JSON
- Crea elementos de trabajo en Azure DevOps
- Establece relaciones padre-hijo
- Actualiza las rutas de área

### config.json

Archivo de configuración que contiene:

- Configuración de la organización de Azure DevOps
- Detalles del proyecto
- Tokens de autenticación
  - Puede ser el PAT plano sin encriptar `token-secreto`
  - Puede ser una variable local del entorno `env:NombrePAT` para evitar exponerlo en el control de código
- Rutas de área predeterminadas

### final_backlog.json

Archivo de entrada que contiene:

- ID del elemento de trabajo padre (parentWorkItemId)
- Historias de usuario y sus tareas
- Elementos fuera de alcance
