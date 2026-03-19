<#
.SYNOPSIS
    Orchestrator for Azure DevOps backlog creation with robust logging.

.DESCRIPTION
    Reads configuration from JSON, executes Create-BacklogFromJSON.ps1, and uses Start-Transcript
    to capture all console output to a timestamped log file in real-time.
    
.PARAMETER BacklogJsonFilePath
    Path to the backlog JSON file to process

.PARAMETER ConfigFilePath
    Path to configuration JSON file. Default: config.json in script folder

.EXAMPLE
    .\Invoke-BacklogCreation.ps1 -BacklogJsonFilePath ".\final_backlog.json"
    
.EXAMPLE
    .\Invoke-BacklogCreation.ps1 -BacklogJsonFilePath ".\final_backlog.json" -ConfigFilePath ".\custom-config.json"

.NOTES
    SECURITY: It is highly recommended NOT to store PAT in config.json.
    Use environment variables or pipeline secrets.
#>

[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [ValidateScript({Test-Path $_ -PathType Leaf})]
    [string]$BacklogJsonFilePath,

    [Parameter(Mandatory = $false)]
    [ValidateScript({Test-Path $_ -PathType Leaf})]
    [string]$ConfigFilePath = (Join-Path $PSScriptRoot "config.json")
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

# MEJORA: Usar un timestamp para el log y definir la ruta al inicio.
$timestamp = Get-Date -Format "yyyyMMdd-HHmmss"

# MEJORA: Guardar logs en carpeta 'Log' con formato: [Nombre BacklogJsonFilePath]-[TimeStamp].log
$logDir = Join-Path $PSScriptRoot "Log"
if (-not (Test-Path $logDir -PathType Container)) {
    New-Item -Path $logDir -ItemType Directory -Force | Out-Null
}

# Extraer solo el nombre del archivo (sin extensión) del BacklogJsonFilePath
$backlogBaseName = [System.IO.Path]::GetFileNameWithoutExtension((Split-Path -Leaf $BacklogJsonFilePath))

$logFileName = "$backlogBaseName-$timestamp.log"
$logFilePath = Join-Path $logDir $logFileName

# MEJORA: Start-Transcript para capturar toda la salida de la consola en tiempo real.
# Esto soluciona el problema de la pérdida de logs en caso de un fallo abrupto.
$transcriptStarted = $false
try {
    Start-Transcript -Path $logFilePath -ErrorAction Stop
    $transcriptStarted = $true
} catch {
    Write-Warning "Could not start transcript. Continuing without logging to file. Error: $($_.Exception.Message)"
}

try {
    Write-Host "`n=== Azure DevOps Backlog Creation Orchestrator ===" -ForegroundColor Cyan
    Write-Host "Timestamp: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')" -ForegroundColor Gray
    Write-Host "Log file will be saved to: $logFilePath" -ForegroundColor Cyan
    
    # Read and parse configuration
    Write-Host "`nReading configuration from: $ConfigFilePath" -ForegroundColor Yellow
    $configContent = Get-Content -Path $ConfigFilePath -Raw -Encoding UTF8
    $config = $configContent | ConvertFrom-Json
    
    # Read backlog JSON to get parentWorkItemId
    Write-Host "`nReading backlog from: $BacklogJsonFilePath" -ForegroundColor Yellow
    $backlogContent = Get-Content -Path $BacklogJsonFilePath -Raw -Encoding UTF8
    $backlog = $backlogContent | ConvertFrom-Json
    
    # Validate required properties in config
    $requiredConfigProperties = @('organizationUrl', 'projectName', 'personalAccessToken', 'areaPath')
    foreach ($prop in $requiredConfigProperties) {
        if (-not $config.PSObject.Properties.Name -contains $prop) {
            throw "Configuration file is missing required property: '$prop'"
        }
    }

    # Validate parentWorkItemId in backlog
    if (-not $backlog.PSObject.Properties.Name -contains 'parentWorkItemId') {
        throw "Backlog file is missing required property: 'parentWorkItemId'"
    }

    # Expand environment variables in PAT if pattern ${env:VAR} exists
    $pat = $config.personalAccessToken
    if ($pat -match '\$\{env:(\w+)\}') {
        $envVarName = $Matches[1]
        $envValue = [Environment]::GetEnvironmentVariable($envVarName)
        if (-not $envValue) {
            throw "Environment variable '$envVarName' is not defined"
        }
        $pat = $envValue
        Write-Host "PAT loaded from environment variable: $envVarName" -ForegroundColor Green
    }
    else {
        Write-Warning "PAT detected as plain text in config.json. Consider using environment variables."
    }
    
    # Prepare parameters for splatting
    $scriptParams = @{
        OrganizationUrl      = $config.organizationUrl
        ProjectName          = $config.projectName
        PersonalAccessToken  = $pat
        BacklogJsonFilePath  = $BacklogJsonFilePath
        ParentWorkItemId     = [int]$backlog.parentWorkItemId  # Changed from config to backlog
        AreaPath            = $config.areaPath
        Verbose             = $VerbosePreference
        InformationAction   = 'Continue'
    }
    
    # Verify main script exists
    $mainScriptPath = Join-Path $PSScriptRoot "Create-BacklogFromJSON.ps1"
    if (-not (Test-Path $mainScriptPath -PathType Leaf)) {
        throw "Main script not found: $mainScriptPath"
    }
    
    Write-Host "`nStarting main script execution..." -ForegroundColor Yellow
    Write-Host "Processing backlog: $BacklogJsonFilePath`n" -ForegroundColor Gray
    
    # MEJORA: Se elimina la captura en variable y el Out-File.
    # Start-Transcript ya está manejando toda la redirección de salida.
    & $mainScriptPath @scriptParams
    
    Write-Host "`n=== Execution completed successfully ===" -ForegroundColor Green
}
catch {
    # Este bloque también será capturado por Start-Transcript.
    Write-Host "`n=== Orchestration Error ===" -ForegroundColor Red
    Write-Error "Critical error: $_.Exception.Message"
    Write-Host "`nStackTrace:" -ForegroundColor Red
    Write-Host $_.ScriptStackTrace -ForegroundColor Red
    
    # Salir con un código de error para que las herramientas de CI/CD puedan detectarlo.
    exit 1
}
finally {
    # MEJORA: Detener el transcript al final, tanto si hay éxito como si hay error.
    if ($transcriptStarted) {
        Write-Host "`nFull log saved at: $logFilePath" -ForegroundColor Cyan
        Stop-Transcript
    }
}