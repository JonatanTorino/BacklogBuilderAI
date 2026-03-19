#!/bin/bash

# Forzar a Git Bash a usar enlaces simbólicos nativos de Windows
export MSYS=winsymlinks:nativestrict

echo "--- Configurando Repositorio ---"
git config core.symlinks true

echo "--- Creando directorio .agents/skills/ ---"
mkdir -p .agents/skills

echo "--- Creando symlinks a skills/ ---"
ln -sfv ../../skills/preprocesar-fuentes  .agents/skills/preprocesar-fuentes
ln -sfv ../../skills/resumen-accionables  .agents/skills/resumen-accionables
ln -sfv ../../skills/sintesis             .agents/skills/sintesis
ln -sfv ../../skills/fusion               .agents/skills/fusion
ln -sfv ../../skills/scope-doc            .agents/skills/scope-doc
ln -sfv ../../skills/tarjeta-us           .agents/skills/tarjeta-us
ln -sfv ../../skills/preparacion-us       .agents/skills/preparacion-us

echo "--- Registrando en Git ---"
git add .agents/

echo "--- Verificando (buscando modo 120000) ---"
git ls-files -s | grep ".agents/skills"
if git ls-files -s | grep ".agents/skills" | grep -q "120000"; then
    echo "¡LOGRADO! Git detectó los symlinks correctamente."
else
    echo "Falló. Verificar que MSYS=winsymlinks:nativestrict está activo."
fi
