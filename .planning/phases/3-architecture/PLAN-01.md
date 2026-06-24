# Phase 3: Architecture

## Phase Goal
Design the system architecture including API, data flow, and integrations.

## Files to Create

```file:supabase/migrations/0001_initial_schema.sql
-- 0001_initial_schema.sql
-- Core operational data tables with temporal/causal support.

CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pgcrypto";

CREATE TABLE sources (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  name TEXT NOT NULL UNIQUE,
  kind TEXT NOT NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE events (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  source_id UUID NOT NULL REFERENCES sources(id),
  event_type TEXT NOT NULL,
  occurred_at TIMESTAMPTZ NOT NULL,
  recorded_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  subject_type TEXT NOT NULL,
  subject_id UUID NOT NULL,
  payload JSONB NOT NULL DEFAULT '{}'::jsonb,
  caused_by_event_id UUID REFERENCES events(id)
);

CREATE INDEX idx_events_subject ON events(subject_type, subject_id, occurred_at);
CREATE INDEX idx_events_occurred ON events(occurred_at);
CREATE INDEX idx_events_caused_by ON events(caused_by_event_id);

CREATE TABLE entities (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  kind TEXT NOT NULL,
  attributes JSONB NOT NULL DEFAULT '{}'::jsonb,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);
```

```file:supabase/migrations/0002_rls_policies.sql
-- Row-level security for tenant isolation.
ALTER TABLE events ENABLE ROW LEVEL SECURITY;
ALTER TABLE entities ENABLE ROW LEVEL SECURITY;
CREATE POLICY service_role_all ON events FOR ALL TO service_role USING (true);
CREATE POLICY service_role_all ON entities FOR ALL TO service_role USING (true);
```

```file:scripts/migrate.py
"""Apply Supabase migrations in order."""
import os
from pathlib import Path
import psycopg2

MIGRATIONS_DIR = Path(__file__).parent.parent / 'supabase' / 'migrations'

def run_migrations():
    conn = psycopg2.connect(os.environ['DATABASE_URL'])
    cur = conn.cursor()
    for sql_file in sorted(MIGRATIONS_DIR.glob('*.sql')):
        cur.execute(sql_file.read_text())
    conn.commit()
    cur.close()
    conn.close()

if __name__ == '__main__':
    run_migrations()
    print('All migrations applied.')
```

```file:docs/schema.md
# Schema Overview
- **sources**: external systems producing events
- **events**: append-only log with causal links
- **entities**: current state derived from events

## Temporal queries
Point-in-time: `SELECT * FROM events WHERE occurred_at <= '...'`

## Causal trace
`WITH RECURSIVE chain AS (...) SELECT * FROM chain`
```

## Done When
- python -m scripts.migrate applies all migrations cleanly
- docs/schema.md describes temporal/causal patterns
