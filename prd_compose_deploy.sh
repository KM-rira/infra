#!/usr/bin/env bash
set -e

echo "🔄 Pull latest images..."
docker compose pull

echo "🐘 Start postgres, redis first..."
docker compose up -d postgres redis

echo "⏳ Waiting for PostgreSQL to be ready..."
until docker compose exec -T postgres pg_isready -U "$POSTGRES_USER" -d "$POSTGRES_DB" > /dev/null 2>&1; do
  sleep 2
  echo "⏳ waiting for postgres..."
done

echo "⏳ Waiting for Redis to be ready..."
until docker compose exec -T redis redis-cli ping | grep -q PONG; do
  sleep 2
  echo "⏳ waiting for redis..."
done

echo "🚀 Recreate app services..."
docker compose up -d --no-deps --force-recreate growry linkhub hono-note-backend

echo "🛠 Running DB init script..."
docker compose exec -T growry npm run db:init

echo "📦 Status:"
docker compose ps

echo "📜 Logs:"
docker compose logs --tail=50
