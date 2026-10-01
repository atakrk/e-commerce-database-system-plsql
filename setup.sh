#!/usr/bin/env bash
# Applies the one-time SYS grants and runs the project's SQL scripts, in
# order, against the oracle-db container started by docker-compose.yml.
# Safe to re-run; only needed once per fresh database volume.
set -euo pipefail

cd "$(dirname "$0")"

if [ -f .env ]; then
  set -a
  source .env
  set +a
fi

: "${ORACLE_PASSWORD:?Set ORACLE_PASSWORD in .env}"
: "${APP_USER:=ecommerce}"
: "${APP_USER_PASSWORD:?Set APP_USER_PASSWORD in .env}"

echo "Applying one-time SYS grants..."
docker exec -i oracle-db sqlplus -s "sys/${ORACLE_PASSWORD}@//localhost:1521/FREEPDB1" as sysdba <<SQL
GRANT EXECUTE ON dbms_crypto TO ${APP_USER};
CREATE OR REPLACE DIRECTORY ORDER_HISTORY_DIR AS '/tmp';
GRANT READ, WRITE ON DIRECTORY ORDER_HISTORY_DIR TO ${APP_USER};
SQL

for f in Structure.sql procedure-function.sql Package.sql Population.sql Test.sql; do
  echo "=== Running $f ==="
  docker exec -i oracle-db sqlplus -s "${APP_USER}/${APP_USER_PASSWORD}@//localhost:1521/FREEPDB1" < "$f"
done

echo "Done."
