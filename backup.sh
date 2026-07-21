#!/bin/bash
# =====================================================================
# SCRIPT DE RESPALDO - PALOMAZO
# Genera un backup completo de la base de datos MySQL en Railway
# =====================================================================

HOST="thomas.proxy.rlwy.net"
PORT="29334"
USER="root"
PASSWORD="UeSBxJYTfmpNWAYgfPnwLjRiYZxUKYIO"
DATABASE="railway"

BACKUP_DIR="./backups"
mkdir -p $BACKUP_DIR

FECHA=$(date +"%Y%m%d_%H%M%S")
ARCHIVO="$BACKUP_DIR/palomazo_backup_$FECHA.sql"

echo "Iniciando respaldo de la base de datos Palomazo..."

mysqldump \
  -h $HOST \
  -P $PORT \
  -u $USER \
  -p$PASSWORD \
  --single-transaction \
  --routines \
  --triggers \
  --databases $DATABASE \
  > $ARCHIVO

if [ $? -eq 0 ]; then
  echo "✅ Respaldo exitoso: $ARCHIVO"
  echo "Tamaño: $(du -sh $ARCHIVO | cut -f1)"
else
  echo "❌ Error al generar el respaldo"
  exit 1
fi

find $BACKUP_DIR -name "*.sql" -mtime +7 -delete
echo "Backups disponibles:"
ls -lh $BACKUP_DIR