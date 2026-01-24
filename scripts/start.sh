#!/bin/sh
set -ex

echo "========================================"
echo "Cal.com Container Startup"
echo "========================================"
echo "Start time: $(date)"

# Replace the statically built BUILT_NEXT_PUBLIC_WEBAPP_URL with run-time NEXT_PUBLIC_WEBAPP_URL
# NOTE: if these values are the same, this will be skipped.
echo "[1/4] Replacing URL placeholders..."
scripts/replace-placeholder.sh "$BUILT_NEXT_PUBLIC_WEBAPP_URL" "$NEXT_PUBLIC_WEBAPP_URL"

# Check database connectivity before proceeding
echo "[2/4] Checking database connection..."
if [ -z "$DATABASE_URL" ]; then
    echo "ERROR: DATABASE_URL is not set!"
    exit 1
fi

# Extract host and port from DATABASE_URL for connectivity check
# DATABASE_URL format: postgresql://user:password@host:port/database
DB_HOST=$(echo "$DATABASE_URL" | sed -n 's|.*@\([^:/]*\).*|\1|p')
DB_PORT=$(echo "$DATABASE_URL" | sed -n 's|.*:\([0-9]*\)/.*|\1|p')
DB_PORT=${DB_PORT:-5432}

echo "Checking connectivity to database at $DB_HOST:$DB_PORT..."
if command -v nc > /dev/null 2>&1; then
    timeout 30 sh -c "until nc -z $DB_HOST $DB_PORT; do echo 'Waiting for database...'; sleep 2; done" || {
        echo "ERROR: Cannot connect to database at $DB_HOST:$DB_PORT after 30 seconds"
        exit 1
    }
    echo "Database is reachable!"
else
    echo "WARNING: nc not available, skipping connectivity check"
fi

echo "[3/4] Running Prisma migrations..."
npx prisma migrate deploy --schema /calcom/packages/prisma/schema.prisma || {
    echo "ERROR: Prisma migration failed!"
    exit 1
}
echo "Migrations completed successfully!"

echo "[4/4] Seeding app store..."
npx ts-node --transpile-only /calcom/scripts/seed-app-store.ts || {
    echo "WARNING: App store seeding failed (non-fatal)"
}
echo "Seeding completed!"

# Railway uses dynamic PORT env variable, default to 3000 if not set
export PORT=${PORT:-3000}
echo "========================================"
echo "Starting Cal.com on port $PORT..."
echo "Ready time: $(date)"
echo "========================================"
yarn --cwd apps/web start -p $PORT
