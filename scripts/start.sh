#!/bin/sh
set -x

# Replace the statically built BUILT_NEXT_PUBLIC_WEBAPP_URL with run-time NEXT_PUBLIC_WEBAPP_URL
# NOTE: if these values are the same, this will be skipped.
scripts/replace-placeholder.sh "$BUILT_NEXT_PUBLIC_WEBAPP_URL" "$NEXT_PUBLIC_WEBAPP_URL"

# scripts/wait-for-it.sh ${DATABASE_HOST} -- echo "database is up"
echo "Running Prisma migrations..."
npx prisma migrate deploy --schema /calcom/packages/prisma/schema.prisma

echo "Seeding app store..."
npx ts-node --transpile-only /calcom/scripts/seed-app-store.ts

# Railway uses dynamic PORT env variable, default to 3000 if not set
export PORT=${PORT:-3000}
echo "Starting Cal.com on port $PORT..."
yarn --cwd apps/web start -p $PORT
