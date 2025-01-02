# Configuración Local AWS con Docker para .NET

Este repositorio proporciona una configuración completa para desarrollar aplicaciones .NET que necesitan interactuar con servicios AWS, permitiendo un entorno de desarrollo local mediante Docker. Incluye configuraciones base y un mock funcional para pruebas, facilitando el desarrollo y las pruebas locales con servicios de AWS. El proyecto incluye un mock funcional para demostrar la integración con S3.

## Descripción

El proyecto está diseñado para resolver el desafío común de desarrollo local cuando se trabaja con servicios AWS. Proporciona una configuración que permite:
- Ejecutar aplicaciones .NET que se conectan a AWS en un entorno Dockerizado
- Autenticarse mediante AWS SSO de forma segura
- Realizar pruebas locales usando el mock incluido
- Mantener consistencia entre diferentes entornos de desarrollo

## Prerrequisitos

Para trabajar con este proyecto, necesitarás tener instalado:

- WSL2 (Windows Subsystem for Linux)  
  [Guía oficial de instalación de WSL](https://learn.microsoft.com/en-us/windows/wsl/install)

- AWS CLI v2  
  [Guía oficial de instalación de AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)

- Docker Desktop 
  [Guía de integración Docker con WSL2](https://docs.docker.com/desktop/setup/install/windows-install/)

### Recomendaciones
  - Se recomienda Ubuntu como distribución Linux
  - La configuración está optimizada para trabajar con WSL2, si trabajas en Windows deberás hacer modificaciones.

## Configuración Inicial

### Paquetes AWS Necesarios

Para habilitar la autenticación SSO en nuestra aplicación .NET, necesitamos agregar los siguientes paquetes:

```bash
dotnet add package AWSSDK.SSOOIDC
dotnet add package AWSSDK.SSO
```
### Configuracion de Permisos carpeta .aws
Nuestra aplicación corre dentro de un contenedor Docker usando el usuario 'app' (UID 1654). Para que este usuario pueda acceder a las credenciales de AWS de nuestro sistema local, necesitamos configurar los permisos adecuados:

```bash
# Instalar ACL si no está instalado
sudo apt-get install acl

# Dar permisos de lectura al usuario app (UID 1654)
setfacl -R -m u:1654:rwx ~/.aws
setfacl -R -m d:u:1654:rwx ~/.aws

# Verificar los permisos configurados
getfacl ~/.aws
```

### Estructura del Proyecto
Nuestro proyecto sigue una estructura clara y modular:

proyecto/
├── src/
│   └── MocWebApi/             
│       ├── Controllers/        
│       │   └── S3Controller.cs 
│       └── Program.cs         
├── docker-compose.yml         
├── Dockerfile                  
└── .env                       

## POC S3

El proyecto incluye un mock que demuestra la interacción con AWS S3. 

### Prueba del POC
1. Inicia los servicios desde la carpeta.
```bash
docker-compose up
```
2. Realiza una petición de prueba
```bash
curl -o archivo-local.png "http://localhost:5000/s3/file?bucketName=tu-bucket&fileName=tu-archivo.png"
```
Parámetros a personalizar:

* archivo-local.png: Nombre con el que se guardará el archivo en tu máquina
* tu-bucket: Nombre de tu bucket S3
* tu-archivo.png: Nombre del archivo dentro del bucket , la extensión será la que tenga tu archivo (puede ser .pdf por ejemplo)
