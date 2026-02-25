#!/usr/bin/env bash

# ──1. Rutas de Archivos y Recursos necesarios ───────────────
LOGO_DIR="$HOME/.config/fastfetch/logos"
COLORES_FILE="$LOGO_DIR/colores.conf"
CONFIG_TEMPLATE="$HOME/.config/fastfetch/config.jsonc" 
CONFIG_RUN="$HOME/.config/fastfetch/config_run.jsonc"  # Archivo volátil generado para evitar corromper la configuración original
COUNTER_FILE="$LOGO_DIR/.counter.txt"  # Persistencia del índice para saber qué imagen sigue en la próxima ejecución

# ──2. Lógica de imagen ──────────────────────────────────────
IMAGES=("$LOGO_DIR"/[0-9]*.png)  # Filtra archivos que inician con números [1,2,..9]. para ignorar a 'current.png' y otros archivos de texto
TOTAL_IMAGES=${#IMAGES[@]}       # Obtiene el tamaño del array (cantidad de imágenes válidas encontradas)
[[ -f "$COUNTER_FILE" ]] && read -r COUNTER < "$COUNTER_FILE" || COUNTER=0 # Lee el último índice guardado; si no existe, inicia en 0

NEXT=$(( (COUNTER % TOTAL_IMAGES) + 1 )) # Cálculo aritmético para rotar las imágenes de forma cíclica (del 1 al total)
echo "$NEXT" > "$COUNTER_FILE"           # Actualiza el archivo de texto con el nuevo número de turno

ln -sf "$LOGO_DIR/${NEXT}.png" "$LOGO_DIR/current.png" # Crea un enlace simbólico que apunta a la imagen activa del ciclo

# ──3. Leer colores ──────────────────────────────────────────
# Extraemos los 4 colores de una sola vez de "colores.conf"
read -r _ C1 C2 C3 C4 < <(grep -E "^$NEXT\s" "$COLORES_FILE") # Busca la línea que inicia con el número de imagen y asigna sus colores a las variables

if [[ -z "$C4" ]]; then
    echo "[ff-random] Error: Colores insuficientes en colores.conf para la imagen $NEXT"
    fastfetch --config "$CONFIG_TEMPLATE"
    exit 1
fi

# ──4. Reemplazo Colores ──────────────────────────────────────
# Reemplazamos las etiquetas únicas (%%CX%%) por los valores hexadecimales 
sed -e "s/%%C1%%/${C1}/g" \
    -e "s/%%C2%%/${C2}/g" \
    -e "s/%%C3%%/${C3}/g" \
    -e "s/%%C4%%/${C4}/g" \
    "$CONFIG_TEMPLATE" > "$CONFIG_RUN" # Redirige el resultado del procesamiento a un nuevo archivo JSON

# ──5. Ejecutar ──────────────────────────────────────────────
fastfetch --config "$CONFIG_RUN" # Lanza fastfetch utilizando la configuración modificada, que se genero de la sección "4. Reemplazo Colores"
