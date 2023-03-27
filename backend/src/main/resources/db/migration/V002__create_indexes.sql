CREATE INDEX product_id_pkey ON product (id);
CREATE INDEX product_order_id_product_id_idx ON product (order_id, product_id);
CREATE INDEX orders_id_idx ON orders (id);
CREATE INDEX order_product_id_pkey ON order_product (id);
CREATE INDEX order_product_quantity_idx ON order_product (quantity);
CREATE INDEX order_product_product_id_quantity_idx ON order_product (product_id, quantity);
CREATE INDEX order_product_order_id_idx ON order_product (order_id);
