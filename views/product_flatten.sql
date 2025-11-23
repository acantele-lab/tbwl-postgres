-- View: public.product_flatten

-- DROP VIEW public.product_flatten;

CREATE OR REPLACE VIEW public.product_flatten
 AS
 SELECT p.sku,
    p.model_id,
    spv.shopify_variant_image AS product_image,
    s.supplier_name,
    p.product_title AS title,
    b.brand_name AS brand,
    p.weekly_live_date,
    p.create_date::date AS sku_create_date,
    p.product_description,
    p.is_fake,
    po.is_consignment,
    spv.create_date::date AS sku_posting_date,
    spv.shopify_variant_price AS current_price_chf,
    COALESCE(spv.shopify_variant_initial_price, spv.shopify_variant_price) AS initial_price_chf,
    p.starting_price_chf AS app_initial_price_chf,
    p.current_price_chf AS app_current_price_chf,
    p.previous_price_chf,
    p.price_reduction_date,
    poi.po_item_cost_net_vat_chf AS cost_net_vat_chf,
    spv.shopify_variant_unit AS shopify_stock_units,
    recent_prices.recent_comparable_price_chf AS retail_price_chf,
    col.collection_name,
    c.product_category AS category,
    sc.product_subcategory AS subcategory,
    psh.product_shape,
    m.material,
    co.colour,
    hwco.hw_colour,
    ps.product_size,
    pm.width_cm,
    pm.height_cm,
    pm.depth_cm,
    pm.handle_drop_cm,
    pm.shoulder_drop_cm,
    ic.item_condition,
    p.exterior_condition,
    p.inside_condition,
    p.hardware_condition,
    p.accessory,
    spv.shopify_variant_id,
    sp.shopify_product_id,
    'https://tabitabags.ch/products/'::text || sp.shopify_product_handle AS shopify_product_url,
    sp.shopify_product_status,
    sp.gsc_clicks_l90d,
    sp.gsc_impressions_l90d,
    sp.gsc_ctr_l90d,
    sp.gsc_position_l90d,
    sp.gsc_last_update,
    sp.main_collection_id,
    sp.main_collection_title,
    sp.redirected,
    bs.branded_size,
    sp.shopify_product_tags,
    spv.shopify_variant_image_list AS product_image_list,
    p.is_available_tvb,
    sma.inventory_type_id
   FROM product p
     LEFT JOIN shopify_product_variant spv ON p.sku = spv.shopify_variant_sku
     LEFT JOIN shopify_product sp ON sp.shopify_product_id = spv.shopify_product_id
     LEFT JOIN colour co ON p.colour_id = co.colour_id
     LEFT JOIN hardware_colour hwco ON p.hw_colour_id = hwco.hw_colour_id
     LEFT JOIN product_model pm ON p.model_id = pm.model_id
     LEFT JOIN brand b ON pm.brand_id = b.brand_id
     LEFT JOIN supplier s ON p.supplier_id = s.supplier_id
     LEFT JOIN product_category c ON pm.product_category_id = c.product_category_id
     LEFT JOIN product_category_google cg ON c.product_category_google_id = cg.product_category_google_id
     LEFT JOIN product_subcategory sc ON pm.product_subcategory_id = sc.product_subcategory_id
     LEFT JOIN item_condition ic ON p.item_condition_id = ic.item_condition_id
     LEFT JOIN material m ON pm.material_id = m.material_id
     LEFT JOIN product_size ps ON p.product_size_id = ps.product_size_id
     LEFT JOIN collection col ON pm.collection_id = col.collection_id
     LEFT JOIN product_shape psh ON pm.product_shape_id = psh.product_shape_id
     LEFT JOIN purchase_order_item poi ON p.sku = poi.sku
     LEFT JOIN purchase_order po ON poi.po_id = po.po_id
     LEFT JOIN ( SELECT cp.model_id,
            max(cp.comparable_price_chf) AS recent_comparable_price_chf
           FROM competitor_price cp
             JOIN ( SELECT competitor_store.competitor_store_id
                   FROM competitor_store
                  WHERE competitor_store.is_second_hand = false) cs ON cp.competitor_store_id = cs.competitor_store_id
          WHERE (cp.price_date IN ( SELECT max(competitor_price.price_date) AS max
                   FROM competitor_price
                  WHERE competitor_price.competitor_store_id = cp.competitor_store_id AND competitor_price.model_id = cp.model_id))
          GROUP BY cp.model_id) recent_prices ON pm.model_id = recent_prices.model_id
     LEFT JOIN branded_size bs ON pm.branded_size_id = bs.branded_size_id
     LEFT JOIN ( SELECT stock_manual_adjustment.sku,
            stock_manual_adjustment.inventory_type_id,
            row_number() OVER (PARTITION BY stock_manual_adjustment.sku ORDER BY stock_manual_adjustment.stock_adjustment_date DESC) AS rn
           FROM stock_manual_adjustment
          WHERE stock_manual_adjustment.stock_manual_adjustment_reason_id = 1) sma ON p.sku = sma.sku AND sma.rn = 1;

ALTER TABLE public.product_flatten
    OWNER TO adriano;

GRANT INSERT, SELECT, UPDATE, DELETE ON TABLE public.product_flatten TO ac_user;
GRANT ALL ON TABLE public.product_flatten TO adriano;
GRANT ALL ON TABLE public.product_flatten TO postgres;
GRANT SELECT ON TABLE public.product_flatten TO read_user;
GRANT INSERT, SELECT, UPDATE, DELETE ON TABLE public.product_flatten TO role_tbwl_crud;
GRANT SELECT ON TABLE public.product_flatten TO role_tbwl_read;
GRANT SELECT ON TABLE public.product_flatten TO user_n8n_crud;
