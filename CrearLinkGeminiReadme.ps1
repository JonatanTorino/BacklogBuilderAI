# Configuracion inicial
$repositoryPath = "C:\Repos\JonatanTorino\BacklogBuilderAI"

# 1. Navega al repositorio
Set-Location $repositoryPath

# 2. Configura Git para symlinks
git config core.symlinks true

# 3. Busca todas las carpetas que contienen GEMINI.md
$geminiFiles = Get-ChildItem -Path $repositoryPath -Filter "GEMINI.md" -Recurse -File

# 4. Para cada GEMINI.md encontrado, crea un README.md symlink
foreach ($geminiFile in $geminiFiles) {
    $directoryPath = $geminiFile.DirectoryName
    $readmePath = Join-Path $directoryPath "README.md"
    
    Write-Host "Encontrado: $($geminiFile.FullName)" -ForegroundColor Cyan
    
    # Si ya existe README.md, evalua que hacer
    if (Test-Path $readmePath) {
        $existingReadme = Get-Item $readmePath
        
        # Si ya es un symlink que apunta a GEMINI.md, saltarlo
        if ($existingReadme.LinkType -eq "SymbolicLink" -and $existingReadme.Target -eq "GEMINI.md") {
            Write-Host "  Symlink ya existe y es correcto" -ForegroundColor Gray
            continue
        }
        
        Write-Host "  Eliminando README.md existente..." -ForegroundColor Yellow
        Remove-Item $readmePath -Force
    }
    
    # Crea el symlink
    try {
        Push-Location $directoryPath
        New-Item -ItemType SymbolicLink -Path "README.md" -Target "GEMINI.md" -ErrorAction Stop
        Write-Host "  Symlink creado: README.md -> GEMINI.md" -ForegroundColor Green
        Pop-Location
    }
    catch {
        Write-Host "  Error: $($_.Exception.Message)" -ForegroundColor Red
        Pop-Location
    }
}

# 5. Resumen
Write-Host "=== Symlinks creados ===" -ForegroundColor Magenta
Get-ChildItem -Path $repositoryPath -Filter "README.md" -Recurse -File | 
    Where-Object { $_.LinkType -eq "SymbolicLink" } |
    ForEach-Object {
        $relativePath = $_.FullName.Replace($repositoryPath, ".")
        Write-Host "$relativePath -> $($_.Target)" -ForegroundColor Green
    }

# 6. Git add
git add .
Write-Host "Ejecuta: git commit -m 'Add README-GEMINI symlinks' && git push" -ForegroundColor Yellow