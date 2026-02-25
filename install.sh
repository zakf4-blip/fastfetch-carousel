#!/bin/bash

REPO_DIR=$(pwd)
FASTFETCH_CONF="$HOME/.config/fastfetch"
BIN_DIR="$HOME/.local/bin"

echo ">>Iniciando instalación de configuración..."

echo "Creando directorios..."
mkdir -p "$FASTFETCH_CONF"
mkdir -p "$BIN_DIR"

echo ">>Moviendo archivos..."

if [ -d "logo" ]; then
    cp -r logo "$FASTFETCH_CONF/"
    echo ">>Carpeta 'logo' se movio a $FASTFETCH_CONF"
else
    echo "Aviso: No se encontró la carpeta 'logo' en el repo."
fi

if [ -f "config.jsonc" ]; then
    cp config.jsonc "$FASTFETCH_CONF/"
    echo ">>Archivo 'config.jsonc' se movio a $FASTFETCH_CONF."
else
    echo "Aviso: No se encontró 'config.jsonc'."
fi

if [ -f "ff-random.sh" ]; then
    cp ff-random.sh "$BIN_DIR/"
    chmod +x "$BIN_DIR/ff-random.sh"
    echo "Archivo 'ff-random.sh' se movio a $BIN_DIR y hecho ejecutable."
else
    echo "Error: No se encontró 'ff-random.sh' en el repositorio."
fi

# 4. Configurar Alias y Auto-ejecución de ff-random.sh
SH_FILES=()
[ -f "$HOME/.bashrc" ] && SH_FILES+=("$HOME/.bashrc")
[ -f "$HOME/.zshrc" ] && SH_FILES+=("$HOME/.zshrc")

ALIAS_LINE="alias fastzk='ff-random.sh'"
EXEC_LINE="ff-random.sh"

for FILE in "${SH_FILES[@]}"; do
    echo "Configurando $(basename "$FILE")..."
    
    # Agregar alias fastzk si no existe
    if ! grep -q "$ALIAS_LINE" "$FILE"; then
        echo -e "\n# Alias para Fastfetch personalizado\n$ALIAS_LINE" >> "$FILE"
        echo "   - Alias agregado."
    fi

    # Agregar ejecución de ff-random.sh al final si no existe
    if ! grep -q "$EXEC_LINE" "$FILE"; then
        echo "$EXEC_LINE" >> "$FILE"
        echo "   - Ejecución automática de ff-random.sh agregada al final."
    fi
done

echo "Instalación completada Reinicia tu terminal o ejecuta 'source ~/.zshrc' (o .bashrc)."
