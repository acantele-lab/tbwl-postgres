-- Table: public.product

-- DROP TABLE IF EXISTS public.product;

CREATE TABLE IF NOT EXISTS public.product
(
    product_id uuid NOT NULL DEFAULT uuid_generate_v4(),
    sku text COLLATE pg_catalog."default" NOT NULL,
    is_label_printed boolean,
    is_product_active boolean,
    is_available_tvb boolean,
    product_description text COLLATE pg_catalog."default",
    hw_colour_id integer,
    supplier_product_code text COLLATE pg_catalog."default",
    supplier_condition_evaluation text COLLATE pg_catalog."default",
    date_code text COLLATE pg_catalog."default",
    accessory text COLLATE pg_catalog."default",
    item_condition_id integer,
    exterior_condition text COLLATE pg_catalog."default",
    inside_condition text COLLATE pg_catalog."default",
    hardware_condition text COLLATE pg_catalog."default",
    inventory_cost_fifo_chf numeric,
    full_cost_average_chf numeric,
    google_drive_folder text COLLATE pg_catalog."default",
    google_drive_folder2 text COLLATE pg_catalog."default",
    starting_price_chf numeric,
    create_date timestamp with time zone,
    update_date timestamp with time zone,
    production_country_id character(3) COLLATE pg_catalog."default",
    supplier_image_folder text COLLATE pg_catalog."default",
    supplier_id integer,
    colour_id integer,
    branded_colour_id integer,
    model_id uuid,
    product_size_id uuid,
    product_title text COLLATE pg_catalog."default",
    weekly_live_date date,
    production_year text COLLATE pg_catalog."default",
    internal_note text COLLATE pg_catalog."default",
    product_print_design text COLLATE pg_catalog."default",
    reference_last_purchase_order text COLLATE pg_catalog."default",
    stone_description text COLLATE pg_catalog."default",
    weight text COLLATE pg_catalog."default",
    sourcing_commission_to integer,
    task_product_photo text COLLATE pg_catalog."default",
    task_wearing_photo text COLLATE pg_catalog."default",
    is_temporary_sku boolean,
    brand_id_temporary integer,
    product_category_id_temporary integer,
    product_subcategory_id_temporary integer,
    collection_id_temporary integer,
    material_id_temporary integer,
    has_model boolean,
    is_fake boolean,
    task_authentication_entrupy text COLLATE pg_catalog."default",
    task_authentication_no_entrupy text COLLATE pg_catalog."default",
    previous_price_chf numeric,
    price_reduction_date timestamp with time zone,
    current_price_chf numeric,
    previous_sku text COLLATE pg_catalog."default",
    repair_cost_chf numeric(10,2) DEFAULT NULL::numeric,
    CONSTRAINT pk_product_id PRIMARY KEY (product_id),
    CONSTRAINT uk_sku UNIQUE (sku),
    CONSTRAINT uk_supplier_code UNIQUE (supplier_product_code, supplier_id),
    CONSTRAINT fk_branded_colour_id FOREIGN KEY (branded_colour_id)
        REFERENCES public.branded_colour (branded_colour_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
        NOT VALID,
    CONSTRAINT fk_colour_id FOREIGN KEY (colour_id)
        REFERENCES public.colour (colour_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
        NOT VALID,
    CONSTRAINT fk_item_condition_id FOREIGN KEY (item_condition_id)
        REFERENCES public.item_condition (item_condition_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
        NOT VALID,
    CONSTRAINT fk_model_id FOREIGN KEY (model_id)
        REFERENCES public.product_model (model_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT fk_product_size_id FOREIGN KEY (product_size_id)
        REFERENCES public.product_size (product_size_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
        NOT VALID,
    CONSTRAINT fk_sourcing_commission_to FOREIGN KEY (sourcing_commission_to)
        REFERENCES public.supplier (supplier_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
        NOT VALID,
    CONSTRAINT fk_supplier_id FOREIGN KEY (supplier_id)
        REFERENCES public.supplier (supplier_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
        NOT VALID,
    CONSTRAINT product_repair_cost_chf_check CHECK (repair_cost_chf >= 0::numeric)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.product
    OWNER to postgres;

REVOKE ALL ON TABLE public.product FROM ac_user;
REVOKE ALL ON TABLE public.product FROM read_user;
REVOKE ALL ON TABLE public.product FROM role_tbwl_crud;
REVOKE ALL ON TABLE public.product FROM role_tbwl_read;
REVOKE ALL ON TABLE public.product FROM user_n8n_crud;

GRANT DELETE, INSERT, SELECT, UPDATE ON TABLE public.product TO ac_user;

GRANT ALL ON TABLE public.product TO postgres;

GRANT SELECT ON TABLE public.product TO read_user;

GRANT DELETE, INSERT, SELECT, UPDATE ON TABLE public.product TO role_tbwl_crud;

GRANT SELECT ON TABLE public.product TO role_tbwl_read;

GRANT SELECT ON TABLE public.product TO user_n8n_crud;

COMMENT ON COLUMN public.product.reference_last_purchase_order
    IS 'To help linking the SKU to related PO';
-- Index: idx_product_active_live

-- DROP INDEX IF EXISTS public.idx_product_active_live;

CREATE INDEX IF NOT EXISTS idx_product_active_live
    ON public.product USING btree
    (weekly_live_date DESC NULLS FIRST)
    TABLESPACE pg_default
    WHERE is_product_active IS TRUE;
-- Index: idx_product_branded_colour_id_fk

-- DROP INDEX IF EXISTS public.idx_product_branded_colour_id_fk;

CREATE INDEX IF NOT EXISTS idx_product_branded_colour_id_fk
    ON public.product USING btree
    (branded_colour_id ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_product_colour_id_fk

-- DROP INDEX IF EXISTS public.idx_product_colour_id_fk;

CREATE INDEX IF NOT EXISTS idx_product_colour_id_fk
    ON public.product USING btree
    (colour_id ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_product_is_active

-- DROP INDEX IF EXISTS public.idx_product_is_active;

CREATE INDEX IF NOT EXISTS idx_product_is_active
    ON public.product USING btree
    (is_product_active ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_product_is_active_weekly

-- DROP INDEX IF EXISTS public.idx_product_is_active_weekly;

CREATE INDEX IF NOT EXISTS idx_product_is_active_weekly
    ON public.product USING btree
    (is_product_active ASC NULLS LAST, weekly_live_date DESC NULLS FIRST)
    TABLESPACE pg_default;
-- Index: idx_product_item_condition_id_fk

-- DROP INDEX IF EXISTS public.idx_product_item_condition_id_fk;

CREATE INDEX IF NOT EXISTS idx_product_item_condition_id_fk
    ON public.product USING btree
    (item_condition_id ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_product_model_id_fk

-- DROP INDEX IF EXISTS public.idx_product_model_id_fk;

CREATE INDEX IF NOT EXISTS idx_product_model_id_fk
    ON public.product USING btree
    (model_id ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_product_product_size_id_fk

-- DROP INDEX IF EXISTS public.idx_product_product_size_id_fk;

CREATE INDEX IF NOT EXISTS idx_product_product_size_id_fk
    ON public.product USING btree
    (product_size_id ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_product_sourcing_commission_to_fk

-- DROP INDEX IF EXISTS public.idx_product_sourcing_commission_to_fk;

CREATE INDEX IF NOT EXISTS idx_product_sourcing_commission_to_fk
    ON public.product USING btree
    (sourcing_commission_to ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_product_supplier_id_fk

-- DROP INDEX IF EXISTS public.idx_product_supplier_id_fk;

CREATE INDEX IF NOT EXISTS idx_product_supplier_id_fk
    ON public.product USING btree
    (supplier_id ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_product_update_date_desc

-- DROP INDEX IF EXISTS public.idx_product_update_date_desc;

CREATE INDEX IF NOT EXISTS idx_product_update_date_desc
    ON public.product USING btree
    (update_date DESC NULLS FIRST)
    TABLESPACE pg_default;
-- Index: idx_product_weekly_live_date_desc

-- DROP INDEX IF EXISTS public.idx_product_weekly_live_date_desc;

CREATE INDEX IF NOT EXISTS idx_product_weekly_live_date_desc
    ON public.product USING btree
    (weekly_live_date DESC NULLS FIRST)
    TABLESPACE pg_default;
-- Index: idx_products_sku

-- DROP INDEX IF EXISTS public.idx_products_sku;

CREATE UNIQUE INDEX IF NOT EXISTS idx_products_sku
    ON public.product USING btree
    (sku COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;

-- Trigger: product_timestamp_trigger

-- DROP TRIGGER IF EXISTS product_timestamp_trigger ON public.product;

CREATE OR REPLACE TRIGGER product_timestamp_trigger
    BEFORE INSERT OR UPDATE 
    ON public.product
    FOR EACH ROW
    EXECUTE FUNCTION public.tf_general_timestamps();

-- Trigger: product_title_trigger

-- DROP TRIGGER IF EXISTS product_title_trigger ON public.product;

CREATE OR REPLACE TRIGGER product_title_trigger
    BEFORE INSERT OR UPDATE 
    ON public.product
    FOR EACH ROW
    EXECUTE FUNCTION public.create_product_title();
