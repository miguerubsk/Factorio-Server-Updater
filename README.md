# Factorio Server Updater

Este script automatiza la actualización de un servidor dedicado de Factorio en Linux. Gestiona la descarga de la última versión del servidor, realiza copias de seguridad, corrige permisos y maneja errores para garantizar un proceso de actualización seguro y confiable.

## Características

- **Copia de seguridad automática** antes de actualizar el servidor.
- **Restauración de backups** en caso de fallo.
- **Gestión de permisos** para evitar problemas de acceso.
- **Descarga e instalación automática** de la última versión estable de Factorio.
- **Manejo de errores** con reintentos y restauración en caso de fallo.
- **Gestión de logs** para seguimiento de actualizaciones.

## Requisitos

- Sistema operativo: Linux con systemd.
- Permisos de superusuario (sudo) para ciertas acciones.
- `wget` instalado para descargar el servidor de Factorio.

## Instalación

1. Clona este repositorio o descarga el script manualmente:
   ```sh
   git clone https://github.com/miguerubsk/Factorio-Server-Updater.git
   cd Factorio-Server-Updater
   ```
2. Asegúrate de que el script tiene permisos de ejecución:
   ```sh
   chmod +x factorio-server-updater.sh
   ```
3. Configura las variables de entorno si deseas personalizar las rutas:
   ```sh
   export FACTORIO_DIR="/ruta/a/factorio"
   export BACKUP_DIR="/ruta/a/backups"
   export LOGS_DIR="/ruta/a/logs"
   ```

## Uso

Para ejecutar el script manualmente:
```sh
./factorio-server-updater.sh
```

Para programar actualizaciones automáticas con cron, edita tu crontab:
```sh
crontab -e
```
Y añade una línea como esta para ejecutarlo diariamente a las 3 AM:
```sh
0 3 * * * /ruta/a/factorio-server-updater.sh >> /ruta/a/logs/update.log 2>&1
```

## Funcionamiento del Script

1. **Detiene el servidor** de Factorio.
2. **Realiza una copia de seguridad** del estado actual.
3. **Gestiona backups**, eliminando los más antiguos.
4. **Descarga la última versión** del servidor de Factorio.
5. **Extrae los archivos** y corrige permisos.
6. **Reinicia el servidor** y verifica su estado.

## Mantenimiento y Solución de Problemas

- Si el script falla, revisa los logs en `$LOGS_DIR/factorio_update_YYYYMMDD.log`.
- Puedes restaurar manualmente la última copia de seguridad:
  ```sh
  tar -xzf /var/backups/factorio_ultima_backup.tar.gz -C /opt/factorio
  ```
- Asegúrate de que `systemctl` puede gestionar el servicio de Factorio.

## Licencia

Este proyecto se distribuye bajo la licencia GPL-3.0. Consulta el archivo `LICENSE` para más detalles.

## Autor

Creado por **miguerubsk**. Contribuciones y mejoras son bienvenidas.

