# Data collection

This directory stores outputs returned from running schema-inspection queries against the `public` schema of the TBWL Postgres database.

Current files:
- `public_table_estimates.tsv`: Estimated row counts per table, provided from the user's query output.
- `catalog_lxc_table.sql`: Full DDL, indexes, and trigger definition for `public.catalog_lxc`.
- `product_table.sql`: Full DDL, indexes, and triggers for `public.product`.
- `product_model_table.sql`: Full DDL, indexes, and triggers for `public.product_model`.

To add more results, run the SQL in `../queries/public_schema_collection.sql` (or segments of it) against the database and save the outputs here with descriptive filenames (for example, `public_constraints.tsv`, `public_indexes.tsv`, etc.).
