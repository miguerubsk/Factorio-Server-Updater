<!-- Improved compatibility of back to top link: See: https://github.com/othneildrew/Best-README-Template/pull/73 -->
<a id="readme-top"></a>
<!--
*** Thanks for checking out the Best-README-Template. If you have a suggestion
*** that would make this better, please fork the repo and create a pull request
*** or simply open an issue with the tag "enhancement".
*** Don't forget to give the project a star!
*** Thanks again! Now go create something AMAZING! :D
-->



<!-- PROJECT SHIELDS -->
<!--
*** I'm using markdown "reference style" links for readability.
*** Reference links are enclosed in brackets [ ] instead of parentheses ( ).
*** See the bottom of this document for the declaration of the reference variables
*** for contributors-url, forks-url, etc. This is an optional, concise syntax you may use.
*** https://www.markdownguide.org/basic-syntax/#reference-style-links
-->

<!--
[![Contributors][contributors-shield]][contributors-url]
[![Forks][forks-shield]][forks-url]
[![Stargazers][stars-shield]][stars-url]
[![Issues][issues-shield]][issues-url]
[![project_license][license-shield]][license-url]
-->

[Contribuidores][contributors-url]
[Forks][forks-url]
[Stargazers][stars-url]
[Problemas][issues-url]
[Licencia][license-url]


<!-- PROJECT LOGO -->
<br />
<div align="center">
  <a href="https://github.com/miguerubsk/Factorio-Server-Updater">
   <img src="https://i.redd.it/cxd6h865itp71.png" alt="Logo" width="80" height="80">
  </a>

<h3 align="center">Actualizador de Factorio</h3>

  <p align="center">
    <br />
    <a href="https://github.com/miguerubsk/Factorio-Server-Updater/discussions"><strong>Explora las discusiones »</strong></a>
    <br />
    <a href="https://github.com/miguerubsk/Factorio-Server-Updater/issues/new?labels=bug&template=bug-report---.md">Reporta un Error</a>
    &middot;
    <a href="https://github.com/miguerubsk/Factorio-Server-Updater/issues/new?labels=enhancement&template=feature-request---.md">Pide una función</a>
  </p>
</div>



<!-- TABLE OF CONTENTS -->
<details>
  <summary>Índice</summary>
  <ol>
    <li>
      <a href="#sobre-el-proyecto">Sobre el proyecto</a>
      <ul>
        <li><a href="#hecho-con">Hecho con</a></li>
      </ul>
    </li>
    <li>
      <a href="#empezando">Empezando</a>
      <ul>
        <li><a href="#prerrequisitos">Prerrequisitos</a></li>
        <li><a href="#instalación">Instalación</a></li>
      </ul>
    </li>
    <li><a href="#uso">Uso</a></li>
    <li><a href="#flujo-del-programa">Flujo del programa</a></li>
    <li><a href="#contribuyendo">Contribuyendo</a></li>
    <li><a href="#licencia">Licencia</a></li>
    <li><a href="#contacto">Contacto</a></li>
    <li><a href="#acknowledgments">Acknowledgments</a></li>
  </ol>
</details>



<!-- ABOUT THE PROJECT -->
## Sobre el proyecto

<!--[![Product Name Screen Shot][product-screenshot]](https://example.com)-->

Actualiza tu servidor de factorio más facil que nunca con este script automático que gestiona copias de seguridad y es perfectamente usable con crontab.

<p align="right">(<a href="#readme-top">back to top</a>)</p>



### Hecho con

 ![Bash][Bash.com]

<p align="right">(<a href="#readme-top">back to top</a>)</p>



<!-- GETTING STARTED -->
## Empezando

Para poner en funcionamiento una copia local, sigue estos sencillos pasos de ejemplo.

### Prerrequisitos

* El servidor de Factorio debe estar configurado como un servicio. Ejemplo:
 `/etc/systemd/system/factorio.service`
  ```ini
  [Unit]
  Description=Factorio Headless Server
  After=network.target

  [Service]
  Type=simple
  User=factorio
  ExecStart=/opt/factorio/bin/x64/factorio --start-server-load-latest --server-settings /opt/factorio/data/server-settings.json
  Restart=always
  RestartSec=3
  StandardOutput=append:journal
  StandardError=append:journal

  [Install]
  WantedBy=multi-user.target
  ```
  Para más información puedes consultar [este](https://gist.github.com/othyn/e1287fd937c1e267cdbcef07227ed48c) tutorial de [Othlyn](https://gist.github.com/othyn).
* Asegurate de sustituir las rutas y usuarios, por ejemplo:
  ```sh
    ...
    FACTORIO_DIR="/opt/factorio"
    BACKUP_DIR="/var/backups"
    LOGS_DIR="/var/log/factorio"
    ...
    USER="factorio"
    ...
  ```

### Instalación

1. No hace falta instalación.
2. Clona el repositorio
   ```sh
   git clone https://github.com/miguerubsk/Factorio-Server-Updater.git
   ```
3. Asegurate de sustituir las rutas y usuarios al principio del script
4. Dale permisos de ejecución:
   ```sh
   chmod +x ./Factorio-Server-Updater/factorio-server-updater.sh
   ```
5. Puedes "instalarlo" en tu sistema linux copiandolo a tu carpeta de ejecutables:
   ```sh
   cp factorio-server-updater.sh /usr/bin/factorio-server-updater
   chmod +x /usr/bin/factorio-server-updater
   ```

<p align="right">(<a href="#readme-top">back to top</a>)</p>



<!-- USAGE EXAMPLES -->
## Uso

Simplemente ejecuta el script:
```sh
   factorio-server-updater
```

## Flujo del programa:
1. Inicio
2. Verificar si el usuario es root
3. Definir rutas y usuario
4. Verificar existencia de directorios y crearlos si es necesario
5. Detener el servicio de Factorio
6. Realizar una copia de seguridad y gestionar copias antiguas
7. Verificar e instalar wget si es necesario
8. Descargar y extraer la última versión de Factorio
9. Verificar el binario principal y asignar permisos si es necesario
10. Eliminar archivos temporales
11. Iniciar el servicio de Factorio
12. Corregir permisos
13. Mostrar tiempo de ejecución
14. Fin

Si el programa falla en cualquiera de los pasos, primero intentará restablecer el servicio con los archivos existentes, si falla, intentará restaurar la última copia de seguridad y volverá a intentar reiniciar el servicio.


<!-- CONTRIBUTING -->
## Contribuyendo

Las contribuciones son lo que hace que la comunidad de código abierto sea un lugar increíble para aprender, inspirar y crear. Cualquier contribución que hagas es **muy apreciada**.

Si tienes alguna sugerencia que pueda mejorar esto, crea un fork del repositorio y una solicitud de incorporación de cambios. También puedes abrir un problema con la etiqueta "mejora". ¡No olvides darle una estrella al proyecto! ¡Gracias de nuevo!

1. Bifurcar el proyecto
2. Crea tu rama de funciones (`git checkout -b feature/AmazingFeature`)
3. Confirme sus cambios (`git commit -m 'Add some AmazingFeature'`)
4. Empujar hacia la rama (`git push origin feature/AmazingFeature`)
5. Abrir una solicitud de extracción

<p align="right">(<a href="#readme-top">back to top</a>)</p>

### Principales colaboradores:

<a href="https://github.com/miguerubsk/Factorio-Server-Updater/graphs/contributors">
  <img src="https://contrib.rocks/image?repo=miguerubsk/Factorio-Server-Updater" alt="contrib.rocks image" />
</a>



<!-- LICENSE -->
## Licecia

Distributed under the GPL-3.0 license. See `LICENSE` for more information.

<p align="right">(<a href="#readme-top">back to top</a>)</p>



<!-- CONTACT -->
## Contacto

Miguerubsk - [@migueru98](https://twitter.com/migueru98) - miguerubsk@gmail.com

Enlace: [https://github.com/miguerubsk/Factorio-Server-Updater](https://github.com/miguerubsk/Factorio-Server-Updater)

<p align="right">(<a href="#readme-top">back to top</a>)</p>



<!-- ACKNOWLEDGMENTS -->
## Acknowledgments

* []()
* []()
* []()

<p align="right">(<a href="#readme-top">back to top</a>)</p>



<!-- MARKDOWN LINKS & IMAGES -->
<!-- https://www.markdownguide.org/basic-syntax/#reference-style-links -->
[contributors-shield]: https://img.shields.io/github/contributors/othneildrew/Best-README-Template.svg?style=for-the-badge
[contributors-url]: https://github.com/miguerubsk/Factorio-Server-Updater/graphs/contributors
[forks-shield]: https://img.shields.io/github/forks/othneildrew/Best-README-Template.svg?style=for-the-badge
[forks-url]: https://github.com/miguerubsk/Factorio-Server-Updater/network/members
[stars-shield]: https://img.shields.io/github/stars/othneildrew/Best-README-Template.svg?style=for-the-badge
[stars-url]: https://github.com/miguerubsk/Factorio-Server-Updater/stargazers
[issues-shield]: https://img.shields.io/github/stars/othneildrew/Best-README-Template.svg?style=for-the-badge
[issues-url]: https://github.com/miguerubsk/Factorio-Server-Updater/issues
[license-shield]: https://img.shields.io/github/stars/othneildrew/Best-README-Template.svg?style=for-the-badge
[license-url]: https://github.com/miguerubsk/Factorio-Server-Updater/blob/master/LICENSE
[linkedin-shield]: https://img.shields.io/badge/-LinkedIn-black.svg?style=for-the-badge&logo=linkedin&colorB=555
[linkedin-url]: https://linkedin.com/in/linkedin_username
[product-screenshot]: images/screenshot.png
[Next.js]: https://img.shields.io/badge/next.js-000000?style=for-the-badge&logo=nextdotjs&logoColor=white
[Next-url]: https://nextjs.org/
[React.js]: https://img.shields.io/badge/React-20232A?style=for-the-badge&logo=react&logoColor=61DAFB
[React-url]: https://reactjs.org/
[Vue.js]: https://img.shields.io/badge/Vue.js-35495E?style=for-the-badge&logo=vuedotjs&logoColor=4FC08D
[Vue-url]: https://vuejs.org/
[Angular.io]: https://img.shields.io/badge/Angular-DD0031?style=for-the-badge&logo=angular&logoColor=white
[Angular-url]: https://angular.io/
[Svelte.dev]: https://img.shields.io/badge/Svelte-4A4A55?style=for-the-badge&logo=svelte&logoColor=FF3E00
[Svelte-url]: https://svelte.dev/
[Laravel.com]: https://img.shields.io/badge/Laravel-FF2D20?style=for-the-badge&logo=laravel&logoColor=white
[Laravel-url]: https://laravel.com
[Bootstrap.com]: https://img.shields.io/badge/Bootstrap-563D7C?style=for-the-badge&logo=bootstrap&logoColor=white
[Bootstrap-url]: https://getbootstrap.com
[JQuery.com]: https://img.shields.io/badge/jQuery-0769AD?style=for-the-badge&logo=jquery&logoColor=white
[JQuery-url]: https://jquery.com 
[Bash.com]: https://upload.wikimedia.org/wikipedia/commons/thumb/8/82/Gnu-bash-logo.svg/1920px-Gnu-bash-logo.svg.png
