// supabase/migrations/0001_initial_schema.sql
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

