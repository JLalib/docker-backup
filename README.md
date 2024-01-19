# docker-backup<br>
## Explicación<br><br>
Script para hacer copias de Seguridad de los contenedores Docker en local y en la nube (OneDrive) con Rclone, y recibir notificación por Telegram adjuntando el log.<br>
<br>
⏭📼 https://bit.ly/3NKeL8K

## Generación e intercambiar de claves para la conexión SSH sin intervención del usuario.

##Ejecutar en el Servidor principal, no cliente/servidor2 ##

ssh-keygen -t rsa

ssh-copy-id user@IP-SERVER

Una vez hecho lo anterior, creamos el Script, que está alojado en mi Github. Os dejo el enlace.

Tenemos que tener cambiar las rutas, los valores, etc acorde a nuestras necesidades. Por ejemplo el token y el id de Telegram. La IP's y rutas de las carpetas, etc.

En el Script está la línea comentando con explicación.

Posteriormente, le damos permisos de ejecución y lo lanzamos.

### Vídeo desarrollo en YouTube<br>
<br>
Enlace al vídeo en YouTube, con más explicación y detalle paso a paso.
<br><br>
https://youtu.be/2RnyWVGaKwQ?si=-xQ_K8jF41qkYs7j
<br><br><p></p>
Rclone en Linux 
<br><br><p></p>
https://www.youtube.com/watch?v=5BXTyhEEejk
