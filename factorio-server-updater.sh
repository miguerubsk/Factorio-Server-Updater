#!/bin/bash

# Comenzamos a contar el tiempo de ejecución
START_TIME=$(date +%s)

# Trap para asegurarse de que los permisos se corrigen y el tiempo se muestra incluso si ocurre un error
trap 'fix_permissions; show_execution_time' EXIT

#Comprobamos si es usuario root
if [ "$(id -u)" -ne 0 ]; then
    SUDO="sudo"
else
    SUDO=""
fi

# Definir las rutas
FACTORIO_DIR=""
BACKUP_DIR=""
LOGS_DIR=""
MODS_DIR="$FACTORIO_DIR/mods"
SETTINGS_FILE="$FACTORIO_DIR/data/server-settings.json"

#Definir usuario
USER=""

# Función para imprimir mensajes con marca de tiempo
log_message() {
    echo "$(date +'%Y-%m-%d %H:%M:%S') - $1" >> "$LOGS_DIR/factorio_update_$(date +'%Y%m%d').log"
    echo "$(date +'%Y-%m-%d %H:%M:%S') - $1"
}

#Función para corregir permisos
fix_permissions() {
    log_message "Cambiando la propiedad de los archivos y directorios al usuario miguerubsk..."
    
    ${SUDO} chown -R $USER:$USER "$FACTORIO_DIR"
    ${SUDO} chown -R $USER:$USER "$BACKUP_DIR"
    ${SUDO} chown -R $USER:$USER "$LOGS_DIR"
    
    log_message "Propiedad cambiada correctamente al usuario miguerubsk."
}

# Función para calcular y mostrar el tiempo de ejecución
show_execution_time() {
    END_TIME=$(date +%s)
    EXECUTION_TIME=$((END_TIME - START_TIME))
    log_message "Tiempo total de ejecución: $((EXECUTION_TIME / 60)) minutos y $((EXECUTION_TIME % 60)) segundos."
}

# Función para manejar errores
handle_error() {
    log_message "ERROR: $1"
    log_message "Tratando de reiniciar el servicio"
    
    if ! ${SUDO} systemctl start factorio.service; then
        log_message "No se pudo reiniciar el servicio, procediendo a restaurar la última copia de seguridad..."
        restore_backup
        log_message "Intentando iniciar el servicio nuevamente..."
        
        if ! ${SUDO} systemctl start factorio.service; then
            log_message "ERROR CRÍTICO: No se pudo iniciar el servicio después de restaurar la copia de seguridad."
            exit 1
        fi
    fi
}

# Función para restaurar la última copia de seguridad
restore_backup() {
    log_message "Intentando restaurar la última copia de seguridad..."
    
    # Buscar la copia de seguridad más reciente
    LAST_BACKUP=$(ls -t "$BACKUP_DIR"/factorio_*.tar.gz 2>/dev/null | head -1)
    
    if [ -z "$LAST_BACKUP" ] || [ ! -f "$LAST_BACKUP" ]; then
        log_message "ERROR: No se encontró una copia de seguridad válida. No se puede restaurar."
        exit 1
    fi
    
    log_message "Restaurando desde $LAST_BACKUP..."
    
    # Eliminar el directorio de instalación actual si existe
    if [ -d "$FACTORIO_DIR" ]; then
        rm -rf "$FACTORIO_DIR"/* || handle_error "Error al eliminar el directorio actual de Factorio"
    fi
    
    if [ ! -d "$FACTORIO_DIR" ]; then
        log_message "El directorio del servidor no existe, lo creamos: $FACTORIO_DIR"
        if ! mkdir -p "$FACTORIO_DIR"; then
            log_message "No se pudo crear el directorio del servidor"
        fi
    fi
    
    # Extraer la copia de seguridad
    if ! tar -xzf "$LAST_BACKUP" -C "$FACTORIO_DIR"; then
        log_message "Error al restaurar la copia de seguridad"
        exit 1
    fi
    
    log_message "Restauración completada correctamente."
}

# Función para gestionar copias de seguridad y mantener un máximo de 2
manage_backups() {
    log_message "Gestionando copias de seguridad..."
    BACKUP_FILES=($(ls -t "$BACKUP_DIR"/factorio_*.tar.gz 2>/dev/null))
    BACKUP_COUNT=${#BACKUP_FILES[@]}
    if [ "$BACKUP_COUNT" -gt 2 ]; then
        DELETE_COUNT=$((BACKUP_COUNT - 2))
        log_message "Eliminando $DELETE_COUNT copias de seguridad antiguas..."
        for ((i=BACKUP_COUNT-1; i>=2; i--)); do
            rm -f "${BACKUP_FILES[i]}"
        done
    fi
}

# Delimitador de inicio con información relevante
log_message "=============================================================================================="
log_message "Iniciando el script de actualización de Factorio..."
log_message "Directorio de Factorio: $FACTORIO_DIR"
log_message "Directorio de Backups: $BACKUP_DIR"
log_message "Usuario actual: $(whoami)"
log_message "Fecha y hora: $(date)"

# Comprobamos si las rutas existen
if [ ! -d "$FACTORIO_DIR" ]; then
    handle_error "El directorio de Factorio no existe: $FACTORIO_DIR"
fi

if [ ! -d "$BACKUP_DIR" ]; then
    log_message "El directorio de backups no existe, lo creamos: $BACKUP_DIR"
    if ! mkdir -p "$BACKUP_DIR"; then
        handle_error "No se pudo crear el directorio de backups"
    fi
fi

# Detener el servicio de Factorio
log_message "Deteniendo el servidor de Factorio..."
${SUDO} systemctl stop factorio.service || handle_error "Error al detener el servicio factorio.service"

# Hacer una copia de seguridad de los archivos
log_message "Haciendo copia de seguridad de los archivos..."
BACKUP_PATH="$BACKUP_DIR/factorio_$(date +%Y%m%d_%H%M%S).tar.gz"
tar -czf "$BACKUP_PATH" -C "$FACTORIO_DIR" . || handle_error "Error al hacer la copia de seguridad de Factorio en $BACKUP_PATH"
log_message "Copia de seguridad completada: $BACKUP_PATH"

# Gestionar copias de seguridad
manage_backups

#Comprobamos que exista el comando wget y lo instalamos si no es así
if ! command -v wget &> /dev/null; then
    log_message "wget no está instalado. Instalando..."
    ${SUDO} apt update && ${SUDO} apt install -y wget || handle_error "No se pudo instalar wget"
fi

# Descargar la última versión de Factorio
log_message "Descargando la última versión de Factorio..."
cd "$FACTORIO_DIR" || handle_error "Error al acceder al directorio de Factorio"
wget -q https://factorio.com/get-download/stable/headless/linux64 -O factorio.tar.xz || handle_error "Error al descargar la última versión de Factorio"

# Extraer la nueva versión
log_message "Extrayendo los archivos..."
tar -xf factorio.tar.xz --strip-components=1 || handle_error "Error al extraer el archivo factorio.tar.xz"

# Verificar que el binario principal existe
if [ ! -f "$FACTORIO_DIR/bin/x64/factorio" ]; then
    handle_error "Error: El binario de Factorio no existe después de la extracción."
elif [ ! -x "$FACTORIO_DIR/bin/x64/factorio" ]; then
    log_message "El binario principal no tiene permisos de ejecución, corrigiendo..."
    chmod +x "$FACTORIO_DIR/bin/x64/factorio"
fi

# Eliminar el archivo comprimido
log_message "Eliminando el archivo comprimido..."
rm -f factorio.tar.xz || handle_error "Error al eliminar el archivo comprimido factorio.tar.xz"

# Iniciar el servicio de Factorio
log_message "Iniciando el servidor de Factorio..."
${SUDO} systemctl start factorio.service || handle_error "Error al iniciar el servicio factorio.service"

log_message "Actualización completada."