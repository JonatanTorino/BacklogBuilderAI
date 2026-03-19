#!/bin/bash

# Forzar a Git Bash a usar enlaces simbólicos nativos de Windows
export MSYS=winsymlinks:nativestrict

echo "--- Configurando Repositorio ---"
git config core.symlinks true

echo "--- Limpiando archivos ---"
find . -name "README.md" -type f -exec git rm -f {} \; 2>/dev/null
find . -name "README.md" -type f -exec rm -f {} \;

echo "--- Creando nuevos enlaces simbólicos nativos ---"
# El comando ahora fallará si no puede crear un link REAL
find . -name "GEMINI.md" -execdir ln -sv GEMINI.md README.md \;

echo ""
echo "--- Registrando en Git ---"
git add .

echo "--- Verificando modo (Buscando 120000) ---"
git ls-files -s | grep "README.md"

# Comprobar si existe el modo 120000 en la salida
if git ls-files -s | grep "README.md" | grep -q "120000"; then
    echo "¡LOGRADO! Git ha detectado los Symlinks correctamente."
else
    echo "Sigue apareciendo como 100644. Intenta ejecutar: export MSYS=winsymlinks:nativestrict manualmente y vuelve a correr el script."
fi