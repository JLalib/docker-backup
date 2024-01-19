#!/bin/bash
# # # # # # # # # # # # # # # # # # # # # # # #
#                Configuración                #
#       ./sh by Genbyte | Bilal Jebari        #
#      https://www.youtube.com/@genbyte       #
# # # # # # # # # # # # # # # # # # # # # # # #
# Directorio del que se va a realizar una copia de seguridad
source_dir="RUTA-ABSOLUTA-CARPETA-DOCKER"
# Directorio en el que se deben guardar las copias de seguridad
backup_dir="RUTA-ABSOLUTA-CARPETA-BACKUP-LOCAL"
# Número de copias de seguridad a conservar
keep_backups=10
# Fecha y hora actuales
current_datetime=$(date +"%Y-%m-%d_%H-%M-%S")
# Nombre del archivo de copia de seguridad - Backup-Archiv
backup_filename="${current_datetime}-backup.tar"
# Información del servidor de destino
remote_user="USUARIO-REMOTO"
remote_server="IP-SERVER-REMOTO"
remote_dir="RUTA-ABSOLUTA-CARPETA-BACKUP-REMOTO"
# # # # # # # # # # # # # # # # # # # # # # # #
#           Configuración Telegram            #
# # # # # # # # # # # # # # # # # # # # # # # #
key="KEY-BOT-TELEGRAM"
userid="ID-USUARIO-TELEGRAM"
date="$(date "+%d %b %Y %H:%M")"
mensaje="Se ha terminado la copia de los containers Docker %F0%9F%93%82 en local y en la nube ${date} %F0%9F%93%86"
url="https://api.telegram.org/bot$key/sendMessage"
urlD="https://api.telegram.org/bot$key/sendDocument"
# # # # # # # # # # # # # # # # # # # # # # # #
#        Configuración OneDrive rclone        #
# # # # # # # # # # # # # # # # # # # # # # # # 
remote_dir_cloud="RUTA-CARPETA:RCLONE-CLOUD"
remote_dir_log="RUTA-CARPETA-RCLONE-LOGS"
current_datetime_log=$(date +"%Y-%m-%d")
log=$"--log-file=${remote_dir_log}/logDockerSync${current_datetime_log}.txt"
# # # # # # # # # # # # # # # # # # # # # # # #
#           Fin de la configuración           #
# # # # # # # # # # # # # # # # # # # # # # # #
# # # # # #     Comienzo Script     # # # # # #
echo "Backup Docker ${current_datetime} en marcha..." 
remote_target="${remote_user}@${remote_server}"
backup_fullpath="${backup_dir}/${backup_filename}" 
# Parar contenedores Docker
docker stop $(docker ps --filter "status=running" -aq)
# Crear el archivo de respaldo
tar -cpf "${backup_fullpath}" "${source_dir}"
# Arrancar el contenedor Docker | Puedes usar docker start NOMBRE-CONTAINER1 NOMBRE-CONTAINER2
docker start $(docker ps --filter "status=exited" -aq)
# Comprimir el archivo de copia de seguridad
gzip "${backup_fullpath}"
backup_fullpath="${backup_fullpath}.gz"
# Copie la copia de seguridad al servidor de destino usando SCP sin contraseña
scp "${backup_fullpath}" "${remote_target}:$remote_dir"
# Elimine las copias de seguridad locales más antiguas con `find`
find "$backup_dir" -type f -name "*-backup.tar.gz" -mtime +$keep_backups -exec rm {} \;
# Elimine copias de seguridad remotas más antiguas con `find`
ssh "${remote_target}" "find ${remote_dir} -type f -name '*-backup.tar.gz' -mtime +$keep_backups -exec rm {} \;"
# Copiar los Backups en a nube. | rclone sync para sincronizar.
sudo rclone copy ${backup_dir} ${remote_dir_cloud} -v $log
#Envío aviso fin copia por mensaje Telegram con el Log
curl -s -X POST $url -d chat_id=$userid -d text="$mensaje"
#Envío fichero log por Telegram
sudo curl -X  POST $urlD -F chat_id=$userid -F document=@"${remote_dir_log}/logDockerSync${current_datetime_log}.txt" 

# Mensaje fin tarea Backup
echo "Se ha creado la copia de seguridad: ${backup_fullpath} y copiado a  ${remote_target} ."
# # # # # # #    Final Script    # # # # # # #