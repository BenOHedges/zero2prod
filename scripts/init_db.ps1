$DB_USER = "postgres"
$DB_PASSWORD = "password"
$DB_NAME = "newsletter"
$DB_PORT = "5432"
$DB_HOST = "localhost"
$SKIP_DOCKER = $args[0]

if (-not (Get-Command sqlx -ErrorAction SilentlyContinue)) {
    Write-Host "Error: sqlx is not installed"
    Write-Host "Use:"
    Write-Host "cargo install --version=`"~0.6`" sqlx-cli --no-default-features --features rustls,postgres"
}

if (-not (Get-Command psql -ErrorAction SilentlyContinue)) {
	Write-Host "Error: psql is not installed"
}

if ($SKIP_DOCKER -eq "false") {
    docker run `
    -e POSTGRES_USER=${DB_USER} `
    -e POSTGRES_PASSWORD=${DB_PASSWORD} `
    -e POSTGRES_DB=${DB_NAME} `
    -p ${DB_PORT}:5432 `
    -d postgres `
    postgres -N 1000
}

Write-Host "postgres SHOULD be up and running on port $DB_PORT, attempting to run migrations now"

$env:DATABASE_URL = "postgres://${DB_USER}:${DB_PASSWORD}@${DB_HOST}:${DB_PORT}/${DB_NAME}"
sqlx database create
sqlx migrate run

Write-Host "Postgres has migrated, ready to go"
