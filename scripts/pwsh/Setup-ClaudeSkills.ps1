# Setup-ClaudeSkills.ps1
# Crea el symlink .claude\skills apuntando a .agents\skills
# Ejecutar desde la raíz del repositorio, como Administrador o con Developer Mode activo.

$repoRoot = Split-Path -Parent $MyInvocation.MyCommand.Path | Split-Path -Parent

$link   = Join-Path $repoRoot ".claude\skills"
$target = Join-Path $repoRoot ".agents\skills"

if (Test-Path $link) {
    Write-Host "Ya existe: $link — omitido"
} else {
    New-Item -ItemType SymbolicLink -Path $link -Target $target | Out-Null
    Write-Host "Symlink creado: .claude\skills -> .agents\skills"
}
