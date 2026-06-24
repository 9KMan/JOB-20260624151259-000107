// supabase/migrations/0002_rls_policies.sql
-- 0002_rls_policies.sql
-- Row-level security for tenant isolation.

ALTER TABLE events ENABLE ROW LEVEL SECURITY;
ALTER TABLE entities ENABLE ROW LEVEL SECURITY;

CREATE POLICY service_role_all ON events
  FOR ALL
  TO service_role
  USING (true)
  WITH CHECK (true);

CREATE POLICY service_role_all ON entities
  FOR ALL
  TO service_role
  USING (true)
  WITH CHECK (true);

