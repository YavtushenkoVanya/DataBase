PRAGMA foreign_keys = ON;

-- =====================
-- DROP (перезапуск без помилок)
-- =====================
DROP TABLE IF EXISTS audit_log;
DROP TABLE IF EXISTS return_items;
DROP TABLE IF EXISTS returns;
DROP TABLE IF EXISTS shipment_events;
DROP TABLE IF EXISTS shipments;
DROP TABLE IF EXISTS payment_transactions;
DROP TABLE IF EXISTS payments;
DROP TABLE IF EXISTS invoice_items;
DROP TABLE IF EXISTS invoices;
DROP TABLE IF EXISTS order_items;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS cart_items;
DROP TABLE IF EXISTS carts;
DROP TABLE IF EXISTS product_reviews;
DROP TABLE IF EXISTS product_tags;
DROP TABLE IF EXISTS tags;
DROP TABLE IF EXISTS stock_movements;
DROP TABLE IF EXISTS warehouse_stock;
DROP TABLE IF EXISTS warehouses;
DROP TABLE IF EXISTS supplier_products;
DROP TABLE IF EXISTS suppliers;
DROP TABLE IF EXISTS product_prices;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS brands;
DROP TABLE IF EXISTS categories;
DROP TABLE IF EXISTS user_roles;
DROP TABLE IF EXISTS roles;
DROP TABLE IF EXISTS addresses;
DROP TABLE IF EXISTS users;

-- =====================
-- USERS / ROLES
-- =====================
CREATE TABLE users (
  user_id INTEGER PRIMARY KEY,
  full_name TEXT NOT NULL,
  email TEXT UNIQUE NOT NULL,
  city TEXT NOT NULL
);

CREATE TABLE roles (
  role_id INTEGER PRIMARY KEY,
  name TEXT UNIQUE NOT NULL
);

CREATE TABLE user_roles (
  user_id INTEGER,
  role_id INTEGER,
  PRIMARY KEY (user_id, role_id),
  FOREIGN KEY (user_id) REFERENCES users(user_id),
  FOREIGN KEY (role_id) REFERENCES roles(role_id)
);

CREATE TABLE addresses (
  address_id INTEGER PRIMARY KEY,
  user_id INTEGER,
  city TEXT,
  street TEXT,
  FOREIGN KEY (user_id) REFERENCES users(user_id)
);

-- =====================
-- CATALOG
-- =====================
CREATE TABLE categories (
  category_id INTEGER PRIMARY KEY,
  name TEXT UNIQUE NOT NULL
);

CREATE TABLE brands (
  brand_id INTEGER PRIMARY KEY,
  name TEXT UNIQUE NOT NULL
);

CREATE TABLE products (
  product_id INTEGER PRIMARY KEY,
  category_id INTEGER,
  brand_id INTEGER,
  name TEXT NOT NULL,
  FOREIGN KEY (category_id) REFERENCES categories(category_id),
  FOREIGN KEY (brand_id) REFERENCES brands(brand_id)
);

CREATE TABLE product_prices (
  product_id INTEGER,
  price REAL NOT NULL,
  FOREIGN KEY (product_id) REFERENCES products(product_id)
);

CREATE TABLE tags (
  tag_id INTEGER PRIMARY KEY,
  name TEXT UNIQUE
);

CREATE TABLE product_tags (
  product_id INTEGER,
  tag_id INTEGER,
  PRIMARY KEY (product_id, tag_id),
  FOREIGN KEY (product_id) REFERENCES products(product_id),
  FOREIGN KEY (tag_id) REFERENCES tags(tag_id)
);

CREATE TABLE product_reviews (
  review_id INTEGER PRIMARY KEY,
  product_id INTEGER,
  user_id INTEGER,
  rating INTEGER CHECK (rating BETWEEN 1 AND 5),
  FOREIGN KEY (product_id) REFERENCES products(product_id),
  FOREIGN KEY (user_id) REFERENCES users(user_id)
);

-- =====================
-- SUPPLIERS / WAREHOUSE
-- =====================
CREATE TABLE suppliers (
  supplier_id INTEGER PRIMARY KEY,
  name TEXT
);

CREATE TABLE supplier_products (
  supplier_id INTEGER,
  product_id INTEGER,
  PRIMARY KEY (supplier_id, product_id),
  FOREIGN KEY (supplier_id) REFERENCES suppliers(supplier_id),
  FOREIGN KEY (product_id) REFERENCES products(product_id)
);

CREATE TABLE warehouses (
  warehouse_id INTEGER PRIMARY KEY,
  city TEXT
);

CREATE TABLE warehouse_stock (
  warehouse_id INTEGER,
  product_id INTEGER,
  qty INTEGER,
  PRIMARY KEY (warehouse_id, product_id),
  FOREIGN KEY (warehouse_id) REFERENCES warehouses(warehouse_id),
  FOREIGN KEY (product_id) REFERENCES products(product_id)
);

CREATE TABLE stock_movements (
  movement_id INTEGER PRIMARY KEY,
  product_id INTEGER,
  qty INTEGER,
  FOREIGN KEY (product_id) REFERENCES products(product_id)
);

-- =====================
-- ORDERS
-- =====================
CREATE TABLE carts (
  cart_id INTEGER PRIMARY KEY,
  user_id INTEGER,
  FOREIGN KEY (user_id) REFERENCES users(user_id)
);

CREATE TABLE cart_items (
  cart_id INTEGER,
  product_id INTEGER,
  qty INTEGER,
  PRIMARY KEY (cart_id, product_id),
  FOREIGN KEY (cart_id) REFERENCES carts(cart_id),
  FOREIGN KEY (product_id) REFERENCES products(product_id)
);

CREATE TABLE orders (
  order_id INTEGER PRIMARY KEY,
  user_id INTEGER,
  status TEXT,
  FOREIGN KEY (user_id) REFERENCES users(user_id)
);

CREATE TABLE order_items (
  order_id INTEGER,
  product_id INTEGER,
  qty INTEGER,
  PRIMARY KEY (order_id, product_id),
  FOREIGN KEY (order_id) REFERENCES orders(order_id),
  FOREIGN KEY (product_id) REFERENCES products(product_id)
);

-- =====================
-- PAYMENTS / SHIPPING
-- =====================
CREATE TABLE payments (
  payment_id INTEGER PRIMARY KEY,
  order_id INTEGER,
  amount REAL,
  FOREIGN KEY (order_id) REFERENCES orders(order_id)
);

CREATE TABLE payment_transactions (
  txn_id INTEGER PRIMARY KEY,
  payment_id INTEGER,
  FOREIGN KEY (payment_id) REFERENCES payments(payment_id)
);

CREATE TABLE shipments (
  shipment_id INTEGER PRIMARY KEY,
  order_id INTEGER,
  carrier TEXT,
  FOREIGN KEY (order_id) REFERENCES orders(order_id)
);

CREATE TABLE shipment_events (
  event_id INTEGER PRIMARY KEY,
  shipment_id INTEGER,
  status TEXT,
  FOREIGN KEY (shipment_id) REFERENCES shipments(shipment_id)
);

-- =====================
-- RETURNS / AUDIT
-- =====================
CREATE TABLE returns (
  return_id INTEGER PRIMARY KEY,
  order_id INTEGER,
  FOREIGN KEY (order_id) REFERENCES orders(order_id)
);

CREATE TABLE return_items (
  return_id INTEGER,
  product_id INTEGER,
  qty INTEGER,
  PRIMARY KEY (return_id, product_id),
  FOREIGN KEY (return_id) REFERENCES returns(return_id),
  FOREIGN KEY (product_id) REFERENCES products(product_id)
);

CREATE TABLE audit_log (
  audit_id INTEGER PRIMARY KEY,
  entity TEXT,
  action TEXT
);

-- =====================
-- DATA
-- =====================
INSERT INTO roles VALUES (1,'ADMIN'),(2,'MANAGER'),(3,'CUSTOMER');
INSERT INTO users VALUES (1,'Іван Явтушенко','ivan@gmail.com','Полтава');
INSERT INTO user_roles VALUES (1,1),(1,2),(1,3);
INSERT INTO addresses VALUES (1,1,'Полтава','Соборності');

INSERT INTO categories VALUES (1,'Ноутбуки');
INSERT INTO brands VALUES (1,'Lenovo');
INSERT INTO products VALUES (1,1,1,'Lenovo IdeaPad 3');
INSERT INTO product_prices VALUES (1,19999);
INSERT INTO tags VALUES (1,'budget');
INSERT INTO product_tags VALUES (1,1);
INSERT INTO product_reviews VALUES (1,1,1,5);

INSERT INTO suppliers VALUES (1,'TechSupplier');
INSERT INTO supplier_products VALUES (1,1);
INSERT INTO warehouses VALUES (1,'Полтава');
INSERT INTO warehouse_stock VALUES (1,1,10);
INSERT INTO stock_movements VALUES (1,1,10);

INSERT INTO carts VALUES (1,1);
INSERT INTO cart_items VALUES (1,1,1);

INSERT INTO orders VALUES (1,1,'PAID');
INSERT INTO order_items VALUES (1,1,1);

INSERT INTO payments VALUES (1,1,19999);
INSERT INTO payment_transactions VALUES (1,1);

INSERT INTO shipments VALUES (1,1,'NOVA_POSHTA');
INSERT INTO shipment_events VALUES (1,1,'SHIPPED');

INSERT INTO returns VALUES (1,1);
INSERT INTO return_items VALUES (1,1,1);

INSERT INTO audit_log VALUES (1,'orders','INSERT');

-- VIEW ДЛЯ ПОКАЗУ
CREATE VIEW v_orders AS
SELECT o.order_id, u.full_name, o.status, p.amount
FROM orders o
JOIN users u ON u.user_id=o.user_id
JOIN payments p ON p.order_id=o.order_id;

SELECT * FROM v_orders;

