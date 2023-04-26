#echo off

SET DB_USER=postgres
SET DB_PASSWORD=password
SET DB_NAME=newsletter
SET DB_PORT=5432
SET DB_HOST=localhost
SET SKIP_DOCKER=%1

sqlx -V

IF %ERRORLEVEL% NEQ 0 (
    echo "Error: sqlx is not installed"
    echo "Use:"
    echo "cargo install --version="~0.6" sqlx-cli --no-default-features --features rustls,postgres"
)

psql -V

IF %ERRORLEVEL% NEQ 0 (
    echo "Error: psql is not installed"
)

if %SKIP_DOCKER% == false (
    docker run ^
    -e POSTGRES_USER=%DB_USER% ^
    -e POSTGRES_PASSWORD=%DB_PASSWORD% ^
    -e POSTGRES_DB=%DB_NAME% ^
    -p %DB_PORT%:5432 ^
    -d postgres ^
    postgres -N 1000
)

echo "postgres is up and running on port %DB_PORT%, running migrations now"

SET DATABASE_URL=postgres://%DB_USER%:%DB_PASSWORD%@%DB_HOST%:%DB_PORT%/%DB_NAME%
sqlx database create
sqlx migrate run

echo "Postgres has migrated, ready to go"

