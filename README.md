<a id="readme-top"></a>

[![GPLV3 License][license-shield]][license-url]



<!-- PROJECT LOGO -->
<br />
<div align="center">
  <a href="https://github.com/MrAsieru/GarraioMapaIrekia">
    <img src="readme/icono.svg" alt="Logo" width="80" height="80">
  </a>

  <h3 align="center">GarraioMapaIrekia</h3>

  <p align="center">
    Aplicación web para visualizar información de transporte público sobre un mapa
  </p>
</div>

<!-- ABOUT THE PROJECT -->
## Sobre la aplicación

GarraioMapaIrekia permite la visualización de datos de transporte público sobre un mapa, además de ofrecer distinto tipo de información repartida por las múltiples páginas. Algunas de las funcionalidades son:

- Mostrar paradas, líneas, y posiciones sobre el mapa.
- Información acerca de cada agencia, línea, parada, y viaje.
- Información en tiempo real sobre las agencias que lo permiten.
- Cálculo de trayectos mediante transporte público.

![GIF de la aplicación en Bilbao](readme/bilbao.gif)

<p align="right">(<a href="#readme-top">volver al inicio</a>)</p>



## Tecnologías

Esta aplicación se ha construido con las siguientes tecnologías:

* [![Python][Python]][Python-url]
* [![Docker][Docker]][Docker-url]
* [![Angular][Angular]][Angular-url]
* [![Map libre gl js][Maplibre]][Maplibre-url]
* [![MongoDB][MongoDB]][MongoDB-url]
* [![FASTApi][FASTApi]][FASTApi-url]
* [![OpenTripPlanner][OpenTripPlanner]][OpenTripPlanner-url]

<p align="right">(<a href="#readme-top">volver al inicio</a>)</p>



<!-- GETTING STARTED -->
## Instalación

### Descargar código fuente

El primer paso que realizar es descargar los archivos necesarios, que se encuentran en la página [_releases_](https://github.com/MrAsieru/GarraioMapaIrekia/releases) de este repositorio bajo el nombre `GarraioMapaIrekia-vx.y-with-submodules.zip`. También se puede mediante el comando clone, utilizando la opción `--recurse-submodules`:
```bash
git clone --recurse-submodules https://github.com/MrAsieru/GarraioMapaIrekia.git
```

### Descargar datos de OpenStreetMap
También es necesario descargar los datos de OpenStreetMap necesarios para la navegación. Estos se almacenan en uno o más archivos con formato `PBF` y se pueden obtener con distintos métodos. El más fácil es mediante páginas como [Geofabrik](http://download.geofabrik.de/) que producen extractos automáticos divididos en niveles administrativos. Por ejemplo, para descargar los datos de Euskadi, se utilizaría este archivo: http://download.geofabrik.de/europe/spain/pais-vasco-latest.osm.pbf. Una vez obtenidos los archivos necesarios, se deben guardar en la carpeta `osm`.

### Configurar contenido

Para establecer qué contenido se quiere utilizar en la aplicación se cuenta con dos archivos: `config.json` y `feeds.json`. Si se incluyen muchos operadores se recomienda no calcular las posiciones, por el tiempo que necesita.

#### feeds.json
Desde este archivo se establecen los feeds que se quieren usar y sus fuentes de datos. De manera predeterminada la aplicación cuenta con un archivo `feeds.json` que cuenta con todos los operadores de Euskadi. El archivo JSON cuenta con una lista de objetos que siguen el siguiente formato (* son obligatorios):

- **idFeed (*):** El identificador único del feed. Debido a las operaciones que se realizan en la aplicación solo se permiten nombres con caracteres alfanuméricos y guion '-' para separar palabras.
- **nombre (*):** El nombre del feed, sin restricción de caracteres.
- **fuentes (*):** Lista de diferentes fuentes para obtener el feed, cada fuente sigue el siguiente formato:
  - **tipo (*):** El tipo de fuente. Valores posibles: `HTTP`, `ETAG` o `NAP_MITMA`. [Tipos disponibles](#tipos-fuentes-de-datos)
  - **url:** La URL desde la que se puede obtener el feed. (Solo tipo `HTTP` y `ETAG`)
  - **conjuntoDatoId:** El identificador del conjunto en la API de NAP MITMA. Se puede obtener desde la URL del conjunto. Por ejemplo, el valor para [Bizkaibus](https://nap.mitma.es/Files/Detail/1061) es `1061`. (Solo tipo `NAP_MITMA`)
  - **atribucion (*):** El texto necesario para atribuir los datos.
  - **urlAtribucion (*):** La URL necesaria en la atribución.
- **tiempoReal:** Lista de los feeds de tiempo real que se suministra para este feed. Los elementos de la lista son URLs  de tipo string.
- **calcularPosiciones:** Establece si se quieren generar posiciones de este feed. De manera predeterminada se considera que sí.

<a id="tipos-fuentes-de-datos"></a>
Existen 3 tipos de fuentes de datos:
- **HTTP:** Sirve para cualquier feed que se suministre sin necesidad de llave API a través de una ruta HTTP. Para comprobar si hubo cambios es necesario descargar el feed completo.
- **ETAG:** Existen varias fuentes de datos que ofrecen la etiqueta etag al suministrar los feed. De esta forma, añadiendo a la cabecera de la petición el último valor etag conocido, es posible evitar la descarga completa si el contenido no ha cambiado. Así, se puede reducir la cantidad de datos descargados frente al uso del tipo HTTP.
- **NAP\_MITMA:** Para feeds obtenidos desde el [Punto de Acceso Nacional de Transporte Multimodal](https://nap.mitma.es/) del MITMA.

#### config.json
El archivo almacena la siguiente información:
- **napMitmaApiKey:** La llave API para acceder al servicio NAP MITMA.
- **calcularPosiciones:** La elección general de si se quieren generar las posiciones. Si se marca que no, prevalece sobre la elección de cada feed. La existencia de esta opción se debe a la gran cantidad de tiempo necesario para calcular las posiciones. Como ejemplo, el cálculo de los operadores de Euskadi que lo permiten puede durar alrededor de 3 o 4 horas.

### Acceso a la aplicación
Al descargar el código, la aplicación está configurada para acceder desde el ordenador en la que se aloja, es decir, de manera local a través de localhost. Si se quiere instalar en un servidor se recomienda configurarlo utilizando un dominio web, aunque también es posible hacerlo mediante dirección IP. Además, si se utiliza un dominio web, es posible implementar TLS para realizar las conexiones de manera cifrada. A continuación, se muestran 4 configuraciones diferentes de acceso a la aplicación: [Acceso local (localhost)](#acceso-local-localhost), [Acceso mediante IP](#acceso-mediante-ip), [Acceso mediante dominio web](#acceso-mediante-dominio-web), y [Acceso mediante dominio web y TLS](#acceso-mediante-dominio-web-y-tls).

#### Acceso local (localhost)
Es la configuración predeterminada de la aplicación. Si se han realizado cambios y se quiere volver a esta configuración es necesario realizar cambios en los siguientes archivos.

- **docker-compose.yml:**
  - **nginx.ports:**
    - `80:80`
    - `81:81`
  - **nginx.volumes:**
    - `./nginx/nginx-ip.conf:/etc/nginx/nginx.conf`
- **api/api/main.py:**
  - **ORIGEN\_WEB:** `http://localhost`
- **web/src/environments/environment.prod.ts:**
  - **apiBaseUrl:** `http://localhost:81/api`
  - **websocketBaseUrl:** `ws://localhost:81/api`
  - **tilesUrl:** `http://localhost:81/tile`

#### Acceso mediante IP
Para mostrar los cambios necesarios se utilizará `1.2.3.4` como IP de ejemplo. Los cambios son los siguientes:

- **docker-compose.yml:**
  - **nginx.ports:**
    - `80:80`
    - `81:81`
  - **nginx.volumes:**
    - `./nginx/nginx-ip.conf:/etc/nginx/nginx.conf`
- **api/api/main.py:**
  - **ORIGEN\_WEB:** `http://1.2.3.4`
- **web/src/environments/environment.prod.ts:**
  - **apiBaseUrl:** `http://1.2.3.4:81/api`
  - **websocketBaseUrl:** `ws://1.2.3.4:81/api`
  - **tilesUrl:** `http://1.2.3.4:81/tile`
#### Acceso mediante dominio web
Para mostrar los cambios necesarios se utilizará `ejemplo.com` como dominio de ejemplo. Los cambios son los siguientes:

- **docker-compose.yml:**
  - **nginx.ports:**
    - `80:80`
  - **nginx.volumes:** 
    - `./nginx/nginx-dominio.conf:/etc/nginx/nginx.conf`
- **nginx/nginx-dominio.conf:** Reemplazar `ejemplo.com` por el dominio raíz deseado.
- **api/api/main.py:**
  - **ORIGEN\_WEB:** `http://www.ejemplo.com`
- **web/src/environments/environment.prod.ts:**
  - **apiBaseUrl:** `http://ejemplo.com/api`
  - **websocketBaseUrl:** `ws://ejemplo.com/api`
  - **tilesUrl:** `http://ejemplo.com/tile`
    
#### Acceso mediante dominio web y TLS
Para mostrar los cambios necesarios se utilizará **ejemplo.com** como dominio de ejemplo. El certificado del servidor debe tener el nombre `ejemplo.com.cert` y la clave privada `ejemplo.com.private.key`, ambos archivos deben estar en la carpeta `ssl`.

- **docker-compose.yml:**
  - **nginx.ports:**
    - `80:80`
    - `443:443`
  - **nginx.volumes:**
    - `./nginx/nginx-ssl.conf:/etc/nginx/nginx.conf`
    - `./ssl:/etc/ssl:ro`
- **nginx/nginx-ssl.conf:** Reemplazar `ejemplo.com` por el dominio raíz deseado.
- **api/api/main.py:**
  - **ORIGEN\_WEB:** `https://www.ejemplo.com`
- **web/src/environments/environment.prod.ts:**
  - **apiBaseUrl:** `https://ejemplo.com/api`
  - **websocketBaseUrl:** `wss://ejemplo.com/api`
  - **tilesUrl:** `https://ejemplo.com/tile`
    
### Contraseña de MongoDB
Antes de iniciar el servidor, se recomienda establecer las contraseñas de los 3 usuarios de MongoDB que se utilizan en la base de datos. Dentro de la carpeta `mongodb` se encuentran 3 archivos: `root.env`, `server.env` y `api.env`. Dentro se encuentran las definiciones de las variables que contienen las contraseñas, se recomienda cambiar las contraseñas predeterminadas por otras nuevas.

### Iniciar servidor
Una vez configurado, se puede iniciar el servidor mediante Docker. Si es la primera vez o se ha realizado algún cambio dentro de las carpetas `server`, `api` o `web`, es necesario compilar las imágenes Docker utilizando el siguiente comando:  
```bash
docker compose build
```

Finalmente, para iniciar el servidor se utiliza el siguiente comando:
```bash
docker compose up -d
```

Dependiendo de la cantidad de operadores y si se calculan o no las posiciones los datos del servidor pueden estar listos en 15-60 minutos sin cálculo de posiciones, o de 30 minutos a 4 horas si se realizan los cálculos. Los pasos que se realizan cada vez que se inicia el servidor son:

- Actualizar archivos GTFS
- Guardar información en la base de datos
- Generar teselas de mapa
- Generar posiciones de vehículos

De manera predeterminada los datos se renuevan cada día a las 2 de la madrugada (UTC), y se realizan de nuevo los anteriores pasos. Este intervalo se puede configurar desde el archivo `crontab` en la carpeta `server`.

### Añadir o eliminar feeds
Si se necesita añadir o eliminar feeds mientras el servidor está en marcha, solamente es necesario realizar los cambios necesarios en los archivos `feeds.json` o `config.json`, y ejecutar el siguiente comando:
```bash
docker container restart server
```

Automáticamente, el servidor realiza los cambios necesarios.

<p align="right">(<a href="#readme-top">volver al inicio</a>)</p>

<!-- LICENCIA  -->
## Licencia

Este proyecto se distribuye bajo la licencia GNU General Public License v3.0. [Más información](LICENSE)

<p align="right">(<a href="#readme-top">volver al inicio</a>)</p>

<!-- MARKDOWN LINKS & IMAGES -->
<!-- https://www.markdownguide.org/basic-syntax/#reference-style-links -->
[license-shield]: https://img.shields.io/badge/License-GPLv3-blue.svg?style=for-the-badge
[license-url]: https://github.com/MrAsieru/GarraioMapaIrekia/blob/main/LICENSE

[Python]: https://img.shields.io/badge/Python-3776AB?style=for-the-badge&logo=python&logoColor=white
[Python-url]: https://www.python.org/

[Docker]: https://img.shields.io/badge/Docker-1d63ed?style=for-the-badge&logo=Docker&logoColor=white
[Docker-url]: https://www.docker.com/

[Angular]: https://img.shields.io/badge/Angular-DD0031?style=for-the-badge&logo=angular&logoColor=white
[Angular-url]: https://angular.io/

[Maplibre]: https://img.shields.io/badge/Maplibre%20GL%20JS-blue?style=for-the-badge&logo=Maplibre
[Maplibre-url]: https://maplibre.org/

[MongoDB]: https://img.shields.io/badge/MongoDB-023430?style=for-the-badge&logo=Mongodb
[MongoDB-url]: https://www.mongodb.com/

[FastAPI]: https://img.shields.io/badge/FastAPI-019587?style=for-the-badge&logo=FastAPI&logoColor=white
[FastAPI-url]: https://fastapi.tiangolo.com/

[OpenTripPlanner]: https://img.shields.io/badge/OpenTripPlanner-2179bf?style=for-the-badge
[OpenTripPlanner-url]: https://www.opentripplanner.org/