-- View: public.product_model_flattened

-- DROP VIEW public.product_model_flattened;

CREATE OR REPLACE VIEW public.product_model_flattened
 AS
 SELECT pm.model_id,
    pm.model_title,
        CASE
            WHEN pm.product_model_image ~~* 'http%'::text THEN pm.product_model_image
            ELSE spv_fallback.shopify_variant_image
        END AS model_image_url,
    pm.model_descriptive_title,
    b.brand_name,
    col.collection_name,
    psh.product_shape,
    c.product_category AS category,
    sc.product_subcategory AS subcategory,
    bs.branded_size,
    m.material,
    bm.branded_material,
    pm.width_cm,
    pm.height_cm,
    pm.depth_cm,
    pm.handle_drop_cm,
    pm.shoulder_drop_cm,
    recent_prices.recent_comparable_price_chf AS retail_price_chf
   FROM product_model pm
     LEFT JOIN brand b ON pm.brand_id = b.brand_id
     LEFT JOIN collection col ON pm.collection_id = col.collection_id
     LEFT JOIN product_shape psh ON pm.product_shape_id = psh.product_shape_id
     LEFT JOIN product_category c ON pm.product_category_id = c.product_category_id
     LEFT JOIN product_subcategory sc ON pm.product_subcategory_id = sc.product_subcategory_id
     LEFT JOIN branded_size bs ON pm.branded_size_id = bs.branded_size_id
     LEFT JOIN material m ON pm.material_id = m.material_id
     LEFT JOIN branded_material bm ON pm.branded_material_id = bm.branded_material_id
     LEFT JOIN ( SELECT cp.model_id,
            max(cp.comparable_price_chf) AS recent_comparable_price_chf
           FROM competitor_price cp
             JOIN ( SELECT competitor_store.competitor_store_id
                   FROM competitor_store
                  WHERE competitor_store.is_second_hand = false) cs ON cp.competitor_store_id = cs.competitor_store_id
          WHERE cp.price_date IS NOT NULL
          GROUP BY cp.model_id) recent_prices ON pm.model_id = recent_prices.model_id
     LEFT JOIN LATERAL ( SELECT spv.shopify_variant_image
           FROM product p
             JOIN shopify_product_variant spv ON p.sku = spv.shopify_variant_sku
          WHERE p.model_id = pm.model_id AND spv.shopify_variant_image IS NOT NULL
          ORDER BY p.create_date DESC
         LIMIT 1) spv_fallback ON true
  WHERE pm.is_temporary IS DISTINCT FROM true;

ALTER TABLE public.product_model_flattened
    OWNER TO adriano;

GRANT ALL ON TABLE public.product_model_flattened TO adriano;
GRANT INSERT, SELECT, UPDATE, DELETE ON TABLE public.product_model_flattened TO role_tbwl_crud;
GRANT SELECT ON TABLE public.product_model_flattened TO role_tbwl_read;
