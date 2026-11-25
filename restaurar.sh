#!/usr/bin/env bash
# Restaura en la base de datos un respaldo generado con respaldar.sh.
# Uso, desde la carpeta del proyecto:  ./restaurar.sh ~/respaldos/inventario_AAAA-MM-DD_HHMMSS.sql
# El respaldo recrea la base inventario tal como estaba cuando se genero. La contrasena se toma del contenedor db.
set -euo pipefail
cd "$(dirname "$0")"

if [ "$#" -ne 1 ] || [ ! -s "$1" ]; then
  echo "Uso: $0 ARCHIVO.sql  (el archivo debe existir y no estar vacio)" >&2
  exit 1
fi

docker compose exec -T db sh -c 'mysql -u root -p"$MYSQL_ROOT_PASSWORD" 2>&1 | grep -v "Using a password" || true' < "$1"
echo "Respaldo restaurado: $1"
curl -fsS http://localhost/salud && echo
