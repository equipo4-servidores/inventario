# Sistema de Inventario Tecnológico
Organización: KeyHub MX
Equipo 3, Servidores II, Universidad de Sonora

Inventario de lotes de componentes para teclados mecánicos (switches, keycaps, PCB, carcasas, placas,
estabilizadores y kits). Corre con Docker Compose en tres servicios:

| Servicio | Imagen | Función |
|---|---|---|
| nginx | nginx:1.28-alpine | Proxy inverso; único puerto publicado (80) |
| app | unisonsrv2eq4/inventario-app:1.0 (Docker Hub) | Aplicación Flask con Gunicorn; ruta /salud |
| db | mysql:8.4 | Base de datos inventario, volumen inventario_datos_mysql |

## Requisitos
- Docker Engine y Docker Compose (plugin `docker compose`)
- Git
- Al menos 4 GB de RAM y 10 GB libres en disco

## Recrear el sistema en otro servidor
1. Clonar el repositorio y entrar a la carpeta (el nombre `inventario` no se cambia):
   ```bash
   git clone https://github.com/equipo4-servidores/inventario.git
   cd inventario
   ```
2. Crear el archivo `.env` a partir del ejemplo y cambiar las contraseñas:
   ```bash
   cp .env.example .env
   nano .env
   ```
   `.env` nunca se sube al repositorio (está en `.gitignore`).
3. Levantar los servicios (la primera vez descarga las imágenes y MySQL ejecuta `db/init.sql`):
   ```bash
   docker compose up -d
   docker compose ps
   ```
   Esperar a que `db` aparezca como `healthy`.
4. (Opcional) Restaurar un respaldo para recuperar los datos reales:
   ```bash
   ./restaurar.sh ~/respaldos/inventario_AAAA-MM-DD_HHMMSS.sql
   ```
5. Verificar:
   ```bash
   curl http://localhost/salud
   ```
   Debe responder `"estado":"ok"`. Desde otra computadora, abrir `http://IP-del-servidor` en el navegador.

## Respaldo y recuperación
- `./respaldar.sh`: genera `~/respaldos/inventario_FECHA.sql` con mysqldump y conserva los últimos 7.
- `./restaurar.sh ARCHIVO.sql`: carga un respaldo en la base de datos y consulta `/salud`.

Los respaldos se guardan fuera del proyecto y del volumen, y se copia uno a otra computadora con `scp`.

## Validación automática
El `Jenkinsfile` define el pipeline `validar-inventario` (Jenkins, Pipeline script from SCM, rama `*/main`):
archivos del proyecto, credenciales protegidas, estructura de Compose, historial en Git y sistema disponible
(`curl http://nginx/salud`). Jenkins se ejecuta en un contenedor conectado a la red `inventario_red_interna`:
```bash
docker run -d --name jenkins -p 8080:8080 -v jenkins_home:/var/jenkins_home --network inventario_red_interna jenkins/jenkins:lts
```

## Versiones
- `v1.0`: cierre de la Práctica 13.
- `v1.0-final`: versión que se entrega y evalúa.
