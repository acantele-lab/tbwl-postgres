-- Table: public.product_model

-- DROP TABLE IF EXISTS public.product_model;

CREATE TABLE IF NOT EXISTS public.product_model
(
    model_label_cid text COLLATE pg_catalog."default",
    model_label_cvsm text COLLATE pg_catalog."default",
    brand_id integer,
    collection_id integer,
    model_title text COLLATE pg_catalog."default",
    model_descriptive_title text COLLATE pg_catalog."default",
    product_category_id integer,
    product_subcategory_id integer,
    product_shape_id integer,
    model_version_id integer,
    edition_id integer,
    material_id integer,
    width_cm numeric,
    height_cm numeric,
    depth_cm numeric,
    handle_drop_cm numeric,
    shoulder_drop_cm numeric,
    branded_size_id integer,
    pattern_id integer,
    branded_material_id integer,
    create_date timestamp with time zone,
    update_date timestamp with time zone,
    brand_product_code text COLLATE pg_catalog."default",
    product_model_image text COLLATE pg_catalog."default",
    model_id uuid NOT NULL DEFAULT uuid_generate_v4(),
    model_description text COLLATE pg_catalog."default",
    has_collection boolean,
    complement_size_id integer,
    total_lenght_cm numeric,
    decorative_element_width_cm numeric,
    decorative_element_height_cm numeric,
    is_reversible boolean,
    way_no integer,
    is_temporary boolean,
    relevant_accessory_status text COLLATE pg_catalog."default",
    is_precious boolean,
    has_stone boolean,
    organizer_size_is_checked boolean,
    CONSTRAINT pk_model_id PRIMARY KEY (model_id),
    CONSTRAINT fk_brand_id FOREIGN KEY (brand_id)
        REFERENCES public.brand (brand_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT fk_branded_material_id FOREIGN KEY (branded_material_id)
        REFERENCES public.branded_material (branded_material_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT fk_branded_size_id FOREIGN KEY (branded_size_id)
        REFERENCES public.branded_size (branded_size_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT fk_collection_id FOREIGN KEY (collection_id)
        REFERENCES public.collection (collection_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT fk_edition_id FOREIGN KEY (edition_id)
        REFERENCES public.edition (edition_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT fk_material_id FOREIGN KEY (material_id)
        REFERENCES public.material (material_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT fk_model_size FOREIGN KEY (complement_size_id)
        REFERENCES public.complement_size (complement_size_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
        NOT VALID,
    CONSTRAINT fk_model_version_id FOREIGN KEY (model_version_id)
        REFERENCES public.model_version (model_version_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT fk_pattern_id FOREIGN KEY (pattern_id)
        REFERENCES public.pattern (pattern_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT fk_product_category_id FOREIGN KEY (product_category_id)
        REFERENCES public.product_category (product_category_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT fk_product_shape_id FOREIGN KEY (product_shape_id)
        REFERENCES public.product_shape (product_shape_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT fk_product_subcategory_id FOREIGN KEY (product_subcategory_id)
        REFERENCES public.product_subcategory (product_subcategory_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.product_model
    OWNER to postgres;

REVOKE ALL ON TABLE public.product_model FROM ac_user;
REVOKE ALL ON TABLE public.product_model FROM read_user;
REVOKE ALL ON TABLE public.product_model FROM role_tbwl_crud;
REVOKE ALL ON TABLE public.product_model FROM role_tbwl_read;
REVOKE ALL ON TABLE public.product_model FROM user_n8n_crud;

GRANT DELETE, INSERT, SELECT, UPDATE ON TABLE public.product_model TO ac_user;

GRANT ALL ON TABLE public.product_model TO postgres;

GRANT SELECT ON TABLE public.product_model TO read_user;

GRANT DELETE, INSERT, SELECT, UPDATE ON TABLE public.product_model TO role_tbwl_crud;

GRANT SELECT ON TABLE public.product_model TO role_tbwl_read;

GRANT SELECT ON TABLE public.product_model TO user_n8n_crud;

COMMENT ON COLUMN public.product_model.model_label_cid
    IS 'Short definition of model, assumed to be immutable and with unique code';

COMMENT ON COLUMN public.product_model.way_no
    IS 'Number of ways, used for bags for example.';
-- Index: idx_product_model_brand_id_fk

-- DROP INDEX IF EXISTS public.idx_product_model_brand_id_fk;

CREATE INDEX IF NOT EXISTS idx_product_model_brand_id_fk
    ON public.product_model USING btree
    (brand_id ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_product_model_branded_material_id_fk

-- DROP INDEX IF EXISTS public.idx_product_model_branded_material_id_fk;

CREATE INDEX IF NOT EXISTS idx_product_model_branded_material_id_fk
    ON public.product_model USING btree
    (branded_material_id ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_product_model_branded_size_id_fk

-- DROP INDEX IF EXISTS public.idx_product_model_branded_size_id_fk;

CREATE INDEX IF NOT EXISTS idx_product_model_branded_size_id_fk
    ON public.product_model USING btree
    (branded_size_id ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_product_model_collection_id_fk

-- DROP INDEX IF EXISTS public.idx_product_model_collection_id_fk;

CREATE INDEX IF NOT EXISTS idx_product_model_collection_id_fk
    ON public.product_model USING btree
    (collection_id ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_product_model_complement_size_id_fk

-- DROP INDEX IF EXISTS public.idx_product_model_complement_size_id_fk;

CREATE INDEX IF NOT EXISTS idx_product_model_complement_size_id_fk
    ON public.product_model USING btree
    (complement_size_id ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_product_model_edition_id_fk

-- DROP INDEX IF EXISTS public.idx_product_model_edition_id_fk;

CREATE INDEX IF NOT EXISTS idx_product_model_edition_id_fk
    ON public.product_model USING btree
    (edition_id ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_product_model_material_id_fk

-- DROP INDEX IF EXISTS public.idx_product_model_material_id_fk;

CREATE INDEX IF NOT EXISTS idx_product_model_material_id_fk
    ON public.product_model USING btree
    (material_id ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_product_model_model_version_id_fk

-- DROP INDEX IF EXISTS public.idx_product_model_model_version_id_fk;

CREATE INDEX IF NOT EXISTS idx_product_model_model_version_id_fk
    ON public.product_model USING btree
    (model_version_id ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_product_model_pattern_id_fk

-- DROP INDEX IF EXISTS public.idx_product_model_pattern_id_fk;

CREATE INDEX IF NOT EXISTS idx_product_model_pattern_id_fk
    ON public.product_model USING btree
    (pattern_id ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_product_model_product_category_id_fk

-- DROP INDEX IF EXISTS public.idx_product_model_product_category_id_fk;

CREATE INDEX IF NOT EXISTS idx_product_model_product_category_id_fk
    ON public.product_model USING btree
    (product_category_id ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_product_model_product_shape_id_fk

-- DROP INDEX IF EXISTS public.idx_product_model_product_shape_id_fk;

CREATE INDEX IF NOT EXISTS idx_product_model_product_shape_id_fk
    ON public.product_model USING btree
    (product_shape_id ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_product_model_product_subcategory_id_fk

-- DROP INDEX IF EXISTS public.idx_product_model_product_subcategory_id_fk;

CREATE INDEX IF NOT EXISTS idx_product_model_product_subcategory_id_fk
    ON public.product_model USING btree
    (product_subcategory_id ASC NULLS LAST)
    TABLESPACE pg_default;

-- Trigger: model_title_trigger

-- DROP TRIGGER IF EXISTS model_title_trigger ON public.product_model;

CREATE OR REPLACE TRIGGER model_title_trigger
    BEFORE INSERT OR UPDATE 
    ON public.product_model
    FOR EACH ROW
    EXECUTE FUNCTION public.create_model_title();

-- Trigger: product_model_deletion_trigger

-- DROP TRIGGER IF EXISTS product_model_deletion_trigger ON public.product_model;

CREATE OR REPLACE TRIGGER product_model_deletion_trigger
    AFTER DELETE
    ON public.product_model
    FOR EACH ROW
    EXECUTE FUNCTION public.log_general_deletion();

-- Trigger: product_model_timestamp_trigger

-- DROP TRIGGER IF EXISTS product_model_timestamp_trigger ON public.product_model;

CREATE OR REPLACE TRIGGER product_model_timestamp_trigger
    BEFORE INSERT OR UPDATE 
    ON public.product_model
    FOR EACH ROW
    EXECUTE FUNCTION public.tf_general_timestamps();

-- Trigger: update_product_titles_trigger

-- DROP TRIGGER IF EXISTS update_product_titles_trigger ON public.product_model;

CREATE OR REPLACE TRIGGER update_product_titles_trigger
    AFTER UPDATE 
    ON public.product_model
    FOR EACH ROW
    EXECUTE FUNCTION public.update_product_titles_on_model_change();
