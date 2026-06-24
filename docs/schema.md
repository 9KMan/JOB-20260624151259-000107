markdown
// docs/schema.md
# Schema Overview

This document describes the operational data schema used by the platform. The schema is event-sourced: every change to operational state is recorded as an immutable event, and current state is materialized from that event log.

## Tables

- **sources** — External systems that produce events. Each source has a stable `name` (unique) and a `kind` (e.g. `crm`, `billing`, `support`).
- **events** — Append-only log of everything that happened. Each event is tied to a `source`, typed by `event_type`, stamped with both `occurred_at` (when it happened in the source system) and `recorded_at` (when we captured it), and points at the subject it acts on (`subject_type` + `subject_id`). The `payload` carries event-specific data, and `caused_by_event_id` optionally links to the upstream event that triggered this one.
- **entities** — Current state derived from events. Each row represents a materialized entity with a `kind` and a JSONB `attributes` blob.

## Temporal Queries

The schema supports both point-in-time and range queries over operational history.

### Point-in-time

Return everything we knew about a subject as of a given moment:

