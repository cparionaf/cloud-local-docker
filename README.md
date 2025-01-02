# Cloud Local Docker
[English](#aws-local-configuration-with-docker-for-net) | [Español](#configuración-local-aws-con-docker-para-net)

# AWS Local Configuration with Docker for .NET

This repository provides a complete configuration for developing .NET applications that need to interact with AWS services, enabling a local development environment using Docker. It includes base configurations and a functional mock for testing, facilitating local development and testing with AWS services. The project includes a functional mock to demonstrate integration with S3.

## Description

The project is designed to solve the common challenge of local development when working with AWS services. It provides a configuration that allows:
- Run .NET applications that connect to AWS in a Dockerized environment.
- Securely authenticate using AWS SSO
- Perform local testing using the included mock
- Maintain consistency between different development environments

## Prerequisites

To work with this project, you will need to have installed:

- WSL2 (Windows Subsystem for Linux).  
  [Official WSL installation guide](https://learn.microsoft.com/en-us/windows/wsl/install)

- AWS CLI v2  
  [Official AWS CLI Installation Guide](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)

- Docker Desktop 
  [Docker with WSL2 Integration Guide](https://docs.docker.com/desktop/setup/install/windows-install/)

### Recommendations
  - Ubuntu is recommended as Linux distribution
  - The configuration is optimized to work with WSL2, if you work on Windows you will need to make modifications.

### Initial Configuration

### AWS Packages Needed

To enable SSO authentication in our .NET application, we need to add the following packages:

```bash
dotnet add package AWSSDK.SSOOIDC
dotnet add package AWSSDK.SSO
```
### .aws folder permissions settings
Our application runs inside a Docker container using the user 'app' (UID 1654). In order for this user to access the AWS credentials of our local system, we need to configure the appropriate permissions:

```bash
# Install ACL if not already installed
sudo apt-get install acl

# Give read permissions to user app (UID 1654)
setfacl -R -m u:1654:rwx ~/.aws
setfacl -R -m d:u:1654:rwx ~/.aws

# Verify the configured permissions
getfacl ~/.aws
```

### Project Structure
Our project follows a clear and modular structure:
```
project/
├── src/
│   └── MocWebApi/             
│       ├── Controllers/        
│       │   └── S3Controller.cs 
│       └── Program.cs         
├── docker-compose.yml         
├── Dockerfile                  
└── .env                                         
```
## POC S3

The project includes a mock that demonstrates the interaction with AWS S3. 

### POC Test
1. Start the services from the folder.
```bash
docker-compose up
```
2. Make a test request
```bash
curl -o file-local.png “http://localhost:5000/s3/file?bucketName=tu-bucket&fileName=tu-archivo.png”
```
Parameters to customize:

* file-local.png: Name under which the file will be saved on your machine.
* tu-bucket: Name of your S3 bucket
* your-file.png: Name of the file inside the bucket, the extension will be the one your file has (it can be .pdf for example).


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
```
proyecto/
├── src/
│   └── MocWebApi/             
│       ├── Controllers/        
│       │   └── S3Controller.cs 
│       └── Program.cs         
├── docker-compose.yml         
├── Dockerfile                  
└── .env                       
```
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
