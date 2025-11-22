-- View: public.sales_data_view

-- DROP VIEW public.sales_data_view;

CREATE OR REPLACE VIEW public.sales_data_view
 AS
 WITH order_data AS (
         SELECT so.shopify_order,
            so.shopify_order_id,
            so.so_payment_gateway,
            so.so_value_gross_shipping_store_money,
            so.so_value_gross_discount_store_money,
            so.so_value_tax_store_money,
            so.so_date,
            so.shopify_customer_id,
            so.so_fulfilment_status,
            so.so_financial_status,
            soi.sku,
            soi.so_shopify_line_item_id,
            soi.so_item_value_store_money_gross,
            soi.quantity,
            COALESCE(sor.shopify_refund_quantity * '-1'::integer::numeric, 0::numeric) AS refund_quantity,
            COALESCE(sor.shopify_refund_quantity * '-1'::integer::numeric * soi.so_item_value_store_money_gross, 0::numeric) AS refund_amount,
            c.customer_first_name,
            c.customer_last_name,
            (c.customer_first_name || ' '::text) || c.customer_last_name AS customer_full_name,
            c.customer_type,
            c.country_iso
           FROM sale_order so
             JOIN sale_order_item soi ON so.shopify_order_id = soi.so_shopify_order_id
             LEFT JOIN sale_order_refund sor ON soi.so_shopify_line_item_id = sor.shopify_order_line_item_id
             LEFT JOIN customer c ON so.shopify_customer_id = c.customer_id_shopify
             LEFT JOIN sale_order_deleted d ON so.shopify_order_id = d.shopify_order_id::bigint
          WHERE d.shopify_order_id IS NULL
        ), calculated AS (
         SELECT od.shopify_order,
            od.shopify_order_id,
            od.so_payment_gateway,
            od.so_value_gross_shipping_store_money,
            od.so_value_gross_discount_store_money,
            od.so_value_tax_store_money,
            od.so_date,
            od.shopify_customer_id,
            od.so_fulfilment_status,
            od.so_financial_status,
            od.sku,
            od.so_shopify_line_item_id,
            od.so_item_value_store_money_gross,
            od.quantity,
            od.refund_quantity,
            od.refund_amount,
            od.customer_first_name,
            od.customer_last_name,
            od.customer_full_name,
            od.customer_type,
            od.country_iso,
            od.so_item_value_store_money_gross + od.refund_amount AS net_line_item_value,
            sum(od.so_item_value_store_money_gross + od.refund_amount) OVER (PARTITION BY od.shopify_order_id) AS total_order_value
           FROM order_data od
        ), prorated AS (
         SELECT c.shopify_order,
            c.shopify_order_id,
            c.so_payment_gateway,
            c.so_value_gross_shipping_store_money,
            c.so_value_gross_discount_store_money,
            c.so_value_tax_store_money,
            c.so_date,
            c.shopify_customer_id,
            c.so_fulfilment_status,
            c.so_financial_status,
            c.sku,
            c.so_shopify_line_item_id,
            c.so_item_value_store_money_gross,
            c.quantity,
            c.refund_quantity,
            c.refund_amount,
            c.customer_first_name,
            c.customer_last_name,
            c.customer_full_name,
            c.customer_type,
            c.country_iso,
            c.net_line_item_value,
            c.total_order_value,
            c.so_value_gross_shipping_store_money * (c.net_line_item_value / NULLIF(c.total_order_value, 0::numeric)) AS prorated_shipping,
            c.so_value_gross_discount_store_money * (c.net_line_item_value / NULLIF(c.total_order_value, 0::numeric)) AS prorated_discount,
            c.so_value_tax_store_money * (c.net_line_item_value / NULLIF(c.total_order_value, 0::numeric)) AS prorated_tax
           FROM calculated c
        ), all_orders AS (
         SELECT so.shopify_order_id,
            so.shopify_customer_id,
            so.so_date,
            calc.total_order_value,
                CASE
                    WHEN calc.total_order_value > 0::numeric THEN 1
                    ELSE 0
                END AS valid_order_flag
           FROM sale_order so
             LEFT JOIN ( SELECT calculated.shopify_order_id,
                    sum(calculated.net_line_item_value) AS total_order_value
                   FROM calculated
                  GROUP BY calculated.shopify_order_id) calc ON so.shopify_order_id = calc.shopify_order_id
             LEFT JOIN sale_order_deleted d ON so.shopify_order_id = d.shopify_order_id::bigint
          WHERE d.shopify_order_id IS NULL
        ), valid_orders AS (
         SELECT ao.shopify_order_id,
            ao.shopify_customer_id,
            ao.so_date,
            ao.total_order_value,
            ao.valid_order_flag,
            sum(ao.valid_order_flag) OVER (PARTITION BY ao.shopify_customer_id ORDER BY ao.so_date) AS order_sequence
           FROM all_orders ao
        ), numbered AS (
         SELECT p.shopify_order,
            p.shopify_order_id,
            p.so_payment_gateway,
            p.so_value_gross_shipping_store_money,
            p.so_value_gross_discount_store_money,
            p.so_value_tax_store_money,
            p.so_date,
            p.shopify_customer_id,
            p.so_fulfilment_status,
            p.so_financial_status,
            p.sku,
            p.so_shopify_line_item_id,
            p.so_item_value_store_money_gross,
            p.quantity,
            p.refund_quantity,
            p.refund_amount,
            p.customer_first_name,
            p.customer_last_name,
            p.customer_full_name,
            p.customer_type,
            p.country_iso,
            p.net_line_item_value,
            p.total_order_value,
            p.prorated_shipping,
            p.prorated_discount,
            p.prorated_tax,
            vo.order_sequence
           FROM prorated p
             JOIN valid_orders vo ON p.shopify_order_id = vo.shopify_order_id
        )
 SELECT shopify_order,
    shopify_order_id AS order_id,
    so_date AS order_date,
    shopify_customer_id AS customer_id,
    customer_full_name,
    country_iso,
    so_shopify_line_item_id AS line_item_id,
    sku,
    so_item_value_store_money_gross AS gross_order_line_item_chf,
    refund_amount AS refund_line_item_chf,
    round(prorated_shipping, 0) AS shipping_chf,
    round(prorated_discount * '-1'::integer::numeric, 0) AS discount_chf,
    round(net_line_item_value + prorated_shipping - prorated_discount, 0) AS net_order_gross_tax_chf,
    round(prorated_tax, 0) AS tax_chf,
    round(net_line_item_value + prorated_shipping - prorated_discount - prorated_tax, 0) AS net_order_net_tax_chf,
    order_sequence,
    so_payment_gateway AS payment_gateway,
    customer_type,
    so_fulfilment_status AS fulfilment_status,
    so_financial_status AS financial_status
   FROM numbered n;

ALTER TABLE public.sales_data_view
    OWNER TO postgres;

GRANT INSERT, SELECT, UPDATE, DELETE ON TABLE public.sales_data_view TO ac_user;
GRANT ALL ON TABLE public.sales_data_view TO postgres;
GRANT SELECT ON TABLE public.sales_data_view TO read_user;
GRANT INSERT, SELECT, UPDATE, DELETE ON TABLE public.sales_data_view TO role_tbwl_crud;
GRANT SELECT ON TABLE public.sales_data_view TO role_tbwl_read;
GRANT SELECT ON TABLE public.sales_data_view TO user_n8n_crud;
