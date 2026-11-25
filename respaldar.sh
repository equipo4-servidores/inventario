#!/usr/bin/env bash
# Respaldo logico de la base de datos inventario (KeyHub MX).
# Uso, desde la carpeta del proyecto:  ./respaldar.sh
# Guarda ~/respaldos/inventario_AAAA-MM-DD_HHMMSS.sql (fuera del proyecto y del volumen)
# y conserva solo los ultimos 7 respaldos. La contrasena se toma de las variables del contenedor db.
set -euo pipefail
cd "$(dirname "$0")"

DESTINO="${RESPALDOS:-$HOME/respaldos}"
CONSERVAR="${CONSERVAR:-7}"
mkdir -p "$DESTINO"
ARCHIVO="$DESTINO/inventario_$(date +%F_%H%M%S).sql"

docker compose exec -T db sh -c 'mysqldump -u root -p"$MYSQL_ROOT_PASSWORD" --databases inventario 2>/dev/null' \
  < /dev/null > "$ARCHIVO"

if [ ! -s "$ARCHIVO" ] || ! grep -q "Dump completed" "$ARCHIVO"; then
  echo "Error: el respaldo quedo vacio o incompleto; revisa que el servicio db este en ejecucion." >&2
  rm -f "$ARCHIVO"
  exit 1
fi
echo "Respaldo creado: $ARCHIVO ($(du -h "$ARCHIVO" | cut -f1))"

# Rotacion: se borran los mas antiguos y quedan los ultimos $CONSERVAR
ls -1t "$DESTINO"/inventario_*.sql | tail -n +"$((CONSERVAR + 1))" | xargs -r rm -f --
echo "Respaldos conservados: $(ls -1 "$DESTINO"/inventario_*.sql | wc -l) (maximo $CONSERVAR)"
