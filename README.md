# tbwl-postgres

Implementation in TBWL main Postgres DB

## Repository contents
- `queries/public_schema_collection.sql` — bundled SQL to collect schema metadata and key settings for the `public` schema.
- `data/` — captured outputs from running those queries (currently table row estimates).

## How to use
1. Connect to the TBWL Postgres instance with `psql`.
2. Run the statements in `queries/public_schema_collection.sql` (you can copy/paste or `\i` the file).
3. Save each result set to a file under `data/` (e.g., `psql -XAt -F "\t" -c "<query>" > data/public_constraints.tsv`).
4. Commit the new artifacts so the repository tracks the latest schema snapshots.
