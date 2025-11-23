-- Schema overview for public schema
-- Lists tables with estimated row counts
SELECT
    n.nspname AS schemaname,
    c.relname AS table_name,
    c.reltuples::bigint AS approx_rows
FROM pg_catalog.pg_class c
JOIN pg_catalog.pg_namespace n ON n.oid = c.relnamespace
WHERE c.relkind = 'r'
  AND n.nspname = 'public'
ORDER BY c.relname;

-- Constraints (primary keys, foreign keys, etc.)
SELECT
    conrelid::regclass AS table_name,
    conname AS constraint_name,
    pg_get_constraintdef(c.oid) AS definition
FROM pg_constraint c
JOIN pg_namespace n ON n.oid = c.connamespace
WHERE n.nspname = 'public'
ORDER BY table_name, constraint_name;

-- Index definitions
SELECT
    t.relname AS table_name,
    i.relname AS index_name,
    pg_get_indexdef(ix.indexrelid) AS definition,
    ix.indisunique AS is_unique
FROM pg_index ix
JOIN pg_class t ON t.oid = ix.indrelid
JOIN pg_class i ON i.oid = ix.indexrelid
JOIN pg_namespace n ON n.oid = t.relnamespace
WHERE n.nspname = 'public'
ORDER BY t.relname, i.relname;

-- Views
SELECT schemaname, viewname, definition
FROM pg_views
WHERE schemaname = 'public'
ORDER BY viewname;

-- Materialized views
SELECT schemaname, matviewname, pg_get_viewdef(matviewname::regclass, true) AS definition
FROM pg_matviews
WHERE schemaname = 'public'
ORDER BY matviewname;

-- Functions and procedures
SELECT n.nspname AS schema, p.proname AS function, pg_get_functiondef(p.oid) AS definition
FROM pg_proc p
JOIN pg_namespace n ON n.oid = p.pronamespace
WHERE n.nspname = 'public'
ORDER BY function;

-- Runtime settings (selected)
SHOW shared_buffers;
SHOW work_mem;
SHOW maintenance_work_mem;
SHOW effective_cache_size;
SHOW max_connections;
SHOW random_page_cost;
SHOW effective_io_concurrency;

-- Table statistics health (top dead tuples)
SELECT relname, n_live_tup, n_dead_tup, last_vacuum, last_autovacuum, last_analyze, last_autoanalyze
FROM pg_stat_all_tables
WHERE schemaname = 'public'
ORDER BY n_dead_tup DESC
LIMIT 50;
