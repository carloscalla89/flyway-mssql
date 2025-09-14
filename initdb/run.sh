#!/bin/sh
set -eu
echo "Esperando a SQL Server (mssql:1433)..."
SQLCMD=/opt/mssql-tools18/bin/sqlcmd; [ -x "$SQLCMD" ] || SQLCMD=/opt/mssql-tools/bin/sqlcmd
i=0
until $SQLCMD -S "mssql,1433" -U sa -P "$MSSQL_SA_PASSWORD" -Q "SELECT 1" >/dev/null 2>&1; do
  i=$((i+1))
  if [ "$i" -ge 60 ]; then
    echo "TIMEOUT esperando SQL"
    exit 1
  fi
  sleep 2
done
DB="${MSSQL_DB_NAME:-DemoDB}"
echo "Creando BD si no existe: ${DB}"
$SQLCMD -S "mssql,1433" -U sa -P "$MSSQL_SA_PASSWORD" -b -Q "
  IF DB_ID('${DB}') IS NULL
  BEGIN
    CREATE DATABASE [${DB}];
    PRINT 'BD creada: ${DB}';
  END
  ELSE
  BEGIN
    PRINT 'BD ya existe: ${DB}';
  END"
