markdown
// OUT_OF_SCOPE.md
# Out of Scope

The following items are explicitly NOT included in this build of the
**Senior Supabase Database Architect — Operational Data Foundation**.
The deliverable is a production-ready Supabase (PostgreSQL 15+) schema
with migrations, RLS policies, indexes, seed data, ERD, and a runbook —
nothing more.

This document records intentional exclusions so that scope creep is
visible and future work can be planned deliberately.

---

## Out of Scope

### Application / Service Layer
- **Application code in any language** (Python, TypeScript, Go, Java, etc.)
  for CRUD endpoints, business logic, or API surfaces. The schema is
  consumed directly by Supabase client SDKs or downstream services.
- **Edge Functions with business logic.** `supabase/functions/` is reserved
  for the project skeleton only — no Deno/TypeScript handlers, RPCs, or
  webhooks are authored here.
- **Background workers, job queues, or schedulers** (Celery, Sidekiq,
  pg_cron jobs beyond the migrations themselves, etc.).
- **Caching layer** (Redis, Memcached, in-memory caches, application-level
  response caches).
- **Message brokers / event buses** (Kafka, RabbitMQ, NATS, Pub/Sub).

### Frontend / User Interface
- **Admin dashboards, operator UIs, or end-user applications.**
  Supabase Studio is the only UI surface assumed.
- **Custom React / Vue / Svelte / Next.js frontends.**
- **Design systems, component libraries, or styling.**
- **Mobile clients** (iOS, Android, React Native, Flutter).

### External Integrations
- **Connectors / adapters to source operational systems** (SAP, Salesforce,
  Jira, ServiceNow, Zendesk, NetSuite, Workday, internal ERPs).
- **ETL / ELT pipelines** that backfill this schema from existing systems.
- **CDC pipelines** (Debezium, Airbyte, Fivetran, Hevo) for streaming
  replication from upstream sources.
- **Webhook receivers or outbound integration glue.**
- **Third-party SaaS integrations** beyond Supabase Auth/Storage defaults.

### Data Migration / Backfill
- **Migration of historical data from legacy or parallel systems.**
  Seed data covers representative fixtures only — it does not represent a
  production backfill.
- **Data quality remediation, deduplication, or reconciliation tooling**
  for dirty source data.
- **Archival / purge procedures** for retiring old operational records.

### Hosting, Infrastructure & Deployment
- **Provisioning the Supabase project itself** (organization setup,
  project creation, region selection, billing).
- **Infrastructure-as-Code for cloud resources** (Terraform, Pulumi, CDK).
- **CI/CD pipeline configuration** beyond the SQL migration folder layout
  expected by the Supabase CLI.
- **Container images, Kubernetes manifests, or Helm charts.**
- **Multi-region replication, read-replica topology, or cross-region
  failover.** Single-region Supabase is assumed.
- **Disaster recovery runbooks, RPO/RTO definitions, or failover drills.**
- **Backup verification automation** beyond what `pg_dump` and Supabase's
  built-in PITR provide.

### Security & Compliance Beyond RLS
- **SOC 2, ISO 27001, HIPAA, PCI-DSS, GDPR-DPA, FedRAMP audit work.**
  RLS enforces tenant isolation; regulatory certification is not in scope.
- **Bring-Your-Own-Key (BYOK) encryption-at-rest key management.**
- **Customer-managed HSM or KMS integration.**
- **Advanced authentication features**: SSO/SAML, SCIM provisioning,
  custom MFA flows, passwordless magic-link branding beyond Supabase
  defaults.
- **Penetration testing or formal threat modeling reports.**
- **Data Loss Prevention (DLP), field-level masking, or tokenization
  vaulting.**
- **Detailed audit log shipping to SIEM** (Splunk, Datadog, Elastic).

### Performance & Scale Engineering
- **Load testing, stress testing, or chaos engineering.**
- **Production capacity planning, sizing models, or cost forecasting**
  (FinOps dashboards, Reserved Instance recommendations).
- **Partitioning strategy for petabyte-scale tables** (declarative
  partitioning, time-based or hash-based sharding).
- **Query plan regression testing or automated `EXPLAIN` gates.**
- **Connection pooling tuning beyond Supabase's built-in Supavisor pooler.**
- **Vacuum / autovacuum tuning beyond standard PostgreSQL defaults.**

### Analytics, ML & AI
- **OLAP / data warehouse layer.** This schema is operational
  (OLTP); a downstream warehouse is a separate concern.
- **Materialized views, aggregations, or pre-computed rollups** beyond
  what the runbook's sample queries demonstrate.
- **BI / reporting tool integration** (Metabase, Superset, Looker,
  Mode, Tableau).
- **Machine learning models**, anomaly detection, forecasting, or
  feature stores built on top of this schema.
- **Vector / embedding search** (`pgvector`, semantic search, RAG
  pipelines).
- **LLM-driven summarization or natural-language query interfaces.**

### Operational Concerns Outside Schema Authority
- **On-call rotations, SLO/SLI definitions, error budgets.**
- **Runbooks for application-level incidents** (deploy rollback, feature
  flag toggles).
- **Schema change governance tooling** (Bytebase, Liquibase Enterprise,
  custom approval workflows).
- **Data contracts between producing services and this schema.**

### Documentation Excluded From This Build
- **End-user product documentation** (help center, tutorials for
  consumers of the platform).
- **Marketing or sales collateral.**
- **Architecture Decision Records (ADRs) beyond inline migration
  comments.** The ERD, runbook, and migration guide are the only
  documentation artifacts authored here.
- **API reference docs** — there is no application API surface in scope.

---

## Future Phases

These items are intentionally deferred. They are reasonable next steps
once the operational data foundation is in production and stable, but
they are NOT part of the current build.

### Near-Term (Phase 7+ candidates)
- **Edge Function layer** for validation, transformation, and webhook
  fan-out on event ingestion.
- **CDC streaming pipeline** (Debezium → Kafka → analytics warehouse)
  for real-time downstream consumers.
- **Materialized views and rollup tables** for common reporting
  dimensions (daily / weekly / monthly aggregates).
- **pgvector-backed semantic search** over operational events for
  incident similarity retrieval.
- **Schema change automation** (Bytebase or equivalent) with PR-based
  review and environment promotion.
- **Backfill tooling** to migrate historical records from legacy
  operational systems into this schema.
- **Soft-delete and archival policies** with scheduled cold-storage
  migration of aged rows.
- **Multi-tenant strategy options** (schema-per-tenant vs.
  row-level-tenant with RLS) — current design uses row-level tenancy.
- **Read-only read-replica routing** for analytics workloads off the
  primary.
- **Automated backup verification** (restore-into-staging jobs) and
  documented RPO / RTO targets.

### Longer-Term
- **Vector embeddings + LLM-powered "what changed?" assistants** that
  query the event log semantically.
- **Cross-region active-active topology** for global operators.
- **Bring-Your-Own-Key encryption** with rotation runbooks.
- **Formal SOC 2 / ISO 27001 alignment** with audit-ready controls.
- **Anomaly detection models** trained on the event log + audit trail.
- **Data product marketplace** exposing curated event-sourced views to
  internal teams.

---

## How To Use This Document

- **Before proposing new work:** check this list. If your request is
  here, it is intentionally excluded — escalate before expanding scope.
- **Before planning a future phase:** pick items from *Future Phases*
  and promote them into a new `SPEC.md` and phase plan.
- **If an excluded item is now critical:** raise it as a scope change.
  Do not silently absorb it into an existing phase.

