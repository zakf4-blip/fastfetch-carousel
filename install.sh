#!/bin/bash
REPO_DIR=$(pwd)
FASTFETCH_CONF="$HOME/.config/fastfetch"
BIN_DIR="$HOME/.local/bin"

echo "Iniciando instalación de configuración..."
echo "Creando directorios..."
mkdir -p "$FASTFETCH_CONF"
mkdir -p "$BIN_DIR"

echo "Moviendo archivos..."

if [ -d "logos" ]; then
    cp -r logos "$FASTFETCH_CONF/"
    echo ">>Carpeta 'logos' se movió a $FASTFETCH_CONF correctamente"
else
    echo ">>Aviso: No se encontró la carpeta 'logos' en el repo."
fi

if [ -f "config.jsonc" ]; then
    cp config.jsonc "$FASTFETCH_CONF/"
    echo ">>Archivo 'config.jsonc' se movió a $FASTFETCH_CONF correctamente"
else
    echo ">>Aviso: No se encontró 'config.jsonc'."
fi

if [ -f "ff-random.sh" ]; then
    cp ff-random.sh "$BIN_DIR/"
    chmod +x "$BIN_DIR/ff-random.sh"
    echo ">>Archivo 'ff-random.sh' se movió a $BIN_DIR y hecho ejecutable."
else
    echo "✗ Error: No se encontró 'ff-random.sh' en el repositorio."
    exit 1
fi

echo ""
echo "Configurando Alias y Auto-ejecución..."
echo ""

# Definir variables para los comandos a agregar
ALIAS_LINE="alias fastzk='$BIN_DIR/ff-random.sh'"

# Crear array de archivos a configurar
SH_FILES=()
[ -f "$HOME/.bashrc" ] && SH_FILES+=("$HOME/.bashrc")
[ -f "$HOME/.zshrc" ] && SH_FILES+=("$HOME/.zshrc")

# Validar que hay archivos para configurar
if [ ${#SH_FILES[@]} -eq 0 ]; then
    echo "✗ Error: No se encontró .bashrc ni .zshrc"
    exit 1
fi

# Configurar cada archivo
for FILE in "${SH_FILES[@]}"; do
    SHELL_NAME=$(basename "$FILE")
    echo "Configurando $SHELL_NAME..."
    
    # Agregar alias y fastzk si no existen
    if ! grep -q "fastzk" "$FILE"; then
        echo "" >> "$FILE"
        echo "$ALIAS_LINE" >> "$FILE"
        echo "fastzk" >> "$FILE"
        echo "  ✓ fastzk agregado"
    else
        echo "  ✓ fastzk ya existe"
    fi
done

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✓ Instalación completada exitosamente"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
