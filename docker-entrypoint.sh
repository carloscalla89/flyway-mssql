#!/usr/bin/env bash
set -euo pipefail

# Arranca SQL Server en background
/opt/mssql/bin/sqlservr & 
MSSQL_PID_BG=$!

# Espera a que SQL acepte conexiones
echo "Esperando a que SQL Server esté listo..."
for i in {1..60}; do
  if /opt/mssql-tools18/bin/sqlcmd -S localhost -U sa -P "${MSSQL_SA_PASSWORD}" -C -Q "SELECT 1" &>/dev/null; then
    echo "SQL Server listo."
    break
  fi
  sleep 2
  if ! kill -0 "$MSSQL_PID_BG" 2>/dev/null; then
    echo "El proceso de SQL Server terminó inesperadamente." >&2
    exit 1
  fi
done

# Ejecuta scripts de inicialización si existen
INIT_DIR="/docker-entrypoint-initdb.d"
if [ -d "$INIT_DIR" ]; then
  echo "Ejecutando scripts de inicialización en ${INIT_DIR}..."
  shopt -s nullglob
  for f in "$INIT_DIR"/*; do
    case "$f" in
      *.sql)
        echo ">> Ejecutando SQL: $(basename "$f")"
        /opt/mssql-tools18/bin/sqlcmd -S localhost -U sa -P "${MSSQL_SA_PASSWORD}" -C -i "$f"
        ;;
      *.sql.gz)
        echo ">> Ejecutando SQL (gz): $(basename "$f")"
        gunzip -c "$f" | /opt/mssql-tools18/bin/sqlcmd -S localhost -U sa -P "${MSSQL_SA_PASSWORD}" -C
        ;;
      *.sh)
        echo ">> Ejecutando script shell: $(basename "$f")"
        bash "$f"
        ;;
      *)
        echo ">> Omitido (extensión no soportada): $(basename "$f")"
        ;;
    esac
  done
  echo "Inicialización completada."
else
  echo "No hay directorio de inicialización (${INIT_DIR}); avanzando."
fi

# Mantén el proceso principal en foreground
wait "$MSSQL_PID_BG"
