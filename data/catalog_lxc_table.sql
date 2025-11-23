-- Table: public.catalog_lxc

-- DROP TABLE IF EXISTS public.catalog_lxc;

CREATE TABLE IF NOT EXISTS public.catalog_lxc
(
    sku_id text COLLATE pg_catalog."default" NOT NULL,
    handle text COLLATE pg_catalog."default",
    title text COLLATE pg_catalog."default",
    brand text COLLATE pg_catalog."default",
    location text COLLATE pg_catalog."default",
    fulfillment text COLLATE pg_catalog."default",
    condition text COLLATE pg_catalog."default",
    colour text COLLATE pg_catalog."default",
    type_of_material text COLLATE pg_catalog."default",
    materials text COLLATE pg_catalog."default",
    width numeric,
    height numeric,
    depth numeric,
    hand_drop numeric,
    shoulder_drop numeric,
    country_of_origin text COLLATE pg_catalog."default",
    year_of_manufacture text COLLATE pg_catalog."default",
    serial_no text COLLATE pg_catalog."default",
    inclusions text COLLATE pg_catalog."default",
    comments_on_condition text COLLATE pg_catalog."default",
    subcategory text COLLATE pg_catalog."default",
    body_html text COLLATE pg_catalog."default",
    product_category text COLLATE pg_catalog."default",
    type text COLLATE pg_catalog."default",
    published boolean,
    variant_grams integer,
    variant_inventory_qty integer,
    variant_inventory_policy text COLLATE pg_catalog."default",
    variant_fulfillment_service text COLLATE pg_catalog."default",
    variant_price numeric,
    variant_compare_at_price numeric,
    variant_requires_shipping boolean,
    variant_taxable boolean,
    variant_barcode text COLLATE pg_catalog."default",
    image_src text COLLATE pg_catalog."default",
    image_position text COLLATE pg_catalog."default",
    image_alt_text text COLLATE pg_catalog."default",
    gift_card boolean,
    seo_title text COLLATE pg_catalog."default",
    seo_description text COLLATE pg_catalog."default",
    variant_weight_unit text COLLATE pg_catalog."default",
    variant_tax_code text COLLATE pg_catalog."default",
    create_date timestamp with time zone,
    update_date timestamp with time zone,
    is_active boolean DEFAULT true,
    posting_status text COLLATE pg_catalog."default" DEFAULT 'to_be_checked'::text,
    tbwl_shopify_product_id bigint,
    tbwl_posted_at timestamp with time zone,
    rejection_reason text COLLATE pg_catalog."default",
    tbwl_colour_id integer,
    tbwl_branded_colour_id integer,
    tbwl_hw_colour_id integer,
    tbwl_production_country_id character(2) COLLATE pg_catalog."default",
    tbwl_stone_description text COLLATE pg_catalog."default",
    tbwl_weight text COLLATE pg_catalog."default",
    tbwl_product_print_design text COLLATE pg_catalog."default",
    tbwl_product_model_id uuid,
    tbwl_condition_ranking_id numeric,
    tbwl_ext_description text COLLATE pg_catalog."default",
    tbwl_inside_description text COLLATE pg_catalog."default",
    tbwl_hw_description text COLLATE pg_catalog."default",
    review_notes text COLLATE pg_catalog."default",
    tbwl_price_chf numeric,
    row_hash text COLLATE pg_catalog."default",
    last_seen_at timestamp with time zone DEFAULT now(),
    previous_posting_status character varying(50) COLLATE pg_catalog."default",
    CONSTRAINT lxc_catalog_pkey PRIMARY KEY (sku_id),
    CONSTRAINT uq_hash UNIQUE NULLS NOT DISTINCT (row_hash)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.catalog_lxc
    OWNER to adriano;

REVOKE ALL ON TABLE public.catalog_lxc FROM role_tbwl_crud;
REVOKE ALL ON TABLE public.catalog_lxc FROM role_tbwl_read;

GRANT ALL ON TABLE public.catalog_lxc TO adriano;

GRANT DELETE, INSERT, UPDATE, SELECT ON TABLE public.catalog_lxc TO role_tbwl_crud;

GRANT SELECT ON TABLE public.catalog_lxc TO role_tbwl_read;
-- Index: catalog_lxc_sku_id_uidx

-- DROP INDEX IF EXISTS public.catalog_lxc_sku_id_uidx;

CREATE UNIQUE INDEX IF NOT EXISTS catalog_lxc_sku_id_uidx
    ON public.catalog_lxc USING btree
    (sku_id COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_catalog_lxc_performance

-- DROP INDEX IF EXISTS public.idx_catalog_lxc_performance;

CREATE INDEX IF NOT EXISTS idx_catalog_lxc_performance
    ON public.catalog_lxc USING btree
    (variant_inventory_qty ASC NULLS LAST, published ASC NULLS LAST, type COLLATE pg_catalog."default" ASC NULLS LAST, posting_status COLLATE pg_catalog."default" ASC NULLS LAST, create_date DESC NULLS FIRST)
    TABLESPACE pg_default;

-- Trigger: lxc_catalog_timestamp_trigger

-- DROP TRIGGER IF EXISTS lxc_catalog_timestamp_trigger ON public.catalog_lxc;

CREATE OR REPLACE TRIGGER lxc_catalog_timestamp_trigger
    BEFORE INSERT OR UPDATE 
    ON public.catalog_lxc
    FOR EACH ROW
    EXECUTE FUNCTION public.tf_general_timestamps();
