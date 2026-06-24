# Phase 2: Technical Stack

## Phase Goal
Select and justify the technology stack, frameworks, and tools.

## Tech Stack
Database:** Supabase (PostgreSQL 15+), Backend services:** Supabase Edge Functions (Deno) or Python, Migrations:** Supabase CLI / `supabase/migrations/*.sql`, Schema design:** SQL DDL with temporal patterns, Testing:** pgTAP, real seed data, Tooling:** Supabase Studio, psql, pg_dump

## Files to Create

```file:requirements.txt
psycopg2-binary>=2.9.9
sqlalchemy>=2.0.30
alembic>=1.13.1
python-dotenv>=1.0.0
pyyaml>=6.0
pydantic>=2.7.0
pytest>=8.0
pytest-pgtap>=0.2.0

```

```file:.env.example
DATABASE_URL=postgresql+asyncpg://user:pass@localhost/dbname
SECRET_KEY=***replace-with-random-secret***
```

```file:Dockerfile
FROM python:3.11-slim
WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt 2>/dev/null || true
COPY . .
EXPOSE 8000
CMD python -m scripts.migrate
```

```file:docker-compose.yml
version: '3.9'
services:
  api:
    build: .
    ports: ['8000:8000']
    env_file: .env
    depends_on:
      postgres:
        condition: service_healthy
  postgres:
    image: postgres:16-alpine
    environment:
      POSTGRES_DB: appdb
      POSTGRES_USER: appuser
      POSTGRES_PASSWORD: apppassword
    volumes:
      - pgdata:/var/lib/postgresql/data
    healthcheck:
      test: ['CMD-SHELL', 'pg_isready -U appuser']
      interval: 5s
      timeout: 5s
      retries: 5
volumes:
  pgdata:
```

## Done When
- requirements.txt lists all dependencies
- .env.example documents all environment variables
- Dockerfile builds: docker build .
- docker-compose.yml starts all services: docker compose up
