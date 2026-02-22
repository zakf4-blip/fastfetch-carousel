#!/bin/bash
# Carrusel de imágenes + colores dinámicos para fastfetch
# Autor: zaku0 | github.com//tu-repo

LOGO_DIR="$HOME/.config/fastfetch/logos"
CURRENT_LOGO="$LOGO_DIR/current.png"
COUNTER_FILE="$LOGO_DIR/.counter"
COLORES_FILE="$LOGO_DIR/colores.conf"
CONFIG_FILE="$HOME/.config/fastfetch/config.jsonc"
TOTAL_IMAGES=18

# ── Contador ──────────────────────────────────────────────
if [[ -f "$COUNTER_FILE" ]]; then
    COUNTER=$(cat "$COUNTER_FILE")
else
    COUNTER=0
fi

NEXT=$(( (COUNTER % TOTAL_IMAGES) + 1 ))
echo "$NEXT" > "$COUNTER_FILE"

# ── Symlink a la imagen actual ─────────────────────────────
ln -sf "$LOGO_DIR/${NEXT}.png" "$CURRENT_LOGO"

# ── Leer colores para esta imagen ──────────────────────────
COLOR_LINE=$(grep -v '^\s*#' "$COLORES_FILE" | awk -v img="$NEXT" '$1 == img {print}')

if [[ -z "$COLOR_LINE" ]]; then
    echo "[ff-random] Advertencia: no se encontraron colores para la imagen $NEXT en colores.conf"
    fastfetch --config "$CONFIG_FILE"
    exit 0
fi

C1=$(echo "$COLOR_LINE" | awk '{print $2}')
C2=$(echo "$COLOR_LINE" | awk '{print $3}')
C3=$(echo "$COLOR_LINE" | awk '{print $4}')
C4=$(echo "$COLOR_LINE" | awk '{print $5}')

# ── Modificar los keyColor en config.jsonc ─────────────────
CURRENT_COLORS=($(grep '"keyColor"' "$CONFIG_FILE" | grep -oP '#[0-9a-fA-F]{6}' | awk '!seen[$0]++'))

OLD_C1="${CURRENT_COLORS[0]}"
OLD_C2="${CURRENT_COLORS[1]}"
OLD_C3="${CURRENT_COLORS[2]}"
OLD_C4="${CURRENT_COLORS[3]}"

# Validar que los 4 colores existen y no están vacíos
if [[ -z "$OLD_C1" || -z "$OLD_C2" || -z "$OLD_C3" || -z "$OLD_C4" ]]; then
    echo "[ff-random] Error: no se pudieron leer los 4 keyColors actuales del config."
    echo "  Colores encontrados: ${CURRENT_COLORS[*]}"
    fastfetch --config "$CONFIG_FILE"
    exit 1
fi

# Reemplazar en el archivo
sed -i \
    -e "s/${OLD_C1}/${C1}/gI" \
    -e "s/${OLD_C2}/${C2}/gI" \
    -e "s/${OLD_C3}/${C3}/gI" \
    -e "s/${OLD_C4}/${C4}/gI" \
    "$CONFIG_FILE"

# ── Ejecutar fastfetch ─────────────────────────────────────
fastfetch --config "$CONFIG_FILE"
