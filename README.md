# Mi Configuración de Fastfetch 🚀
Este repositorio contiene mi configuración personalizada de **Fastfetch**.
![Preview de mi Fastfetch](screenshotExample.png)

## Pre-requisitos
Antes de instalar, asegúrate de tener lo siguiente:
* **Fastfetch**
* **Kitty** 
* **Nerd Fonts**

## ¿Qué hace el instalador?
1. Crea los directorios `~/.config/fastfetch` y `~/.local/bin` en caso no existan.
2. Mueve la carpeta de `logos` y el archivo `config.jsonc` a `~/.config/fastfetch` .
3. Mueve el script `ff-random.sh`  a `~/.local/bin` 
4. Da permisos de ejecución a `ff-random.sh`.
5. Crea el alias `fastzk` en tu `.bashrc` o `.zshrc` automáticamente.

## Qué incluye:
* **Fastzk**: Alias que se usará para ejecutar un fastfetch con logos y colores dinamicos.
* **Configuración fastfetch**: Configuración personalizada que tomo como base a examples/10.jsonc del repo oficial de fastfetch.
* **Logos y colores**: Logos .png y un archivo de colores Hexadecimal que se ubican en `~/.config/fastfetch/logo`.
* **Script**: El script `ff-random.sh` que se encargará de cambiar de imagen y color a los campos del fastfetch.
