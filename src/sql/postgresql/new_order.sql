-- PostgreSQL Table Creation
-- @created    March 18, 2004
-- @version    $Id$
-- This schema represents an Order Entry System.
-- REQUIRES: new_product.sql
-- REQUIRES: new_project.sql
-- REQUIRES: new_quote.sql

-- Each order can have a status, which changes as the order is completed
-- Example: Pending, In Progress, Cancelled, Rejected, Completed
CREATE TABLE lookup_order_status (
  code SERIAL PRIMARY KEY,
  description VARCHAR(300) NOT NULL,
  default_item BOOLEAN DEFAULT false,
  level INTEGER DEFAULT 0,
	enabled BOOLEAN DEFAULT true
);

-- Each order has a type which defines the flow of product to/from customer
-- Example: New, Change, Upgrade/Downgrade, Disconnect, Move, Refund, Suspend, Unsuspend, Re-Run
CREATE TABLE lookup_order_type (
  code SERIAL PRIMARY KEY,
  description VARCHAR(300) NOT NULL,
  default_item BOOLEAN DEFAULT false,
  level INTEGER DEFAULT 0,
	enabled BOOLEAN DEFAULT true
);

-- Each order has terms in which the order was placed
CREATE TABLE lookup_order_terms (
  code SERIAL PRIMARY KEY,
  description VARCHAR(300) NOT NULL,
  default_item BOOLEAN DEFAULT false,
	level INTEGER DEFAULT 0,
	enabled BOOLEAN DEFAULT true
);

-- Each order has a type of origination
-- Example: Online, Email, Incoming Phone Call, Outgoing Phone Call, Mail
CREATE TABLE lookup_order_source (
  code SERIAL PRIMARY KEY,
  description VARCHAR(300) NOT NULL,
  default_item BOOLEAN DEFAULT false,
	level INTEGER DEFAULT 0,
	enabled BOOLEAN DEFAULT true
);

-- The details of an order are listed
CREATE TABLE order_entry (
  order_id SERIAL PRIMARY KEY,
  parent_id INT REFERENCES order_entry(order_id),
  org_id INTEGER NOT NULL REFERENCES organization(org_id),
  quote_id INTEGER REFERENCES quote_entry(quote_id),
  sales_id INTEGER REFERENCES access(user_id),
  orderedby INTEGER REFERENCES contact(contact_id),
  billing_contact_id INTEGER REFERENCES contact(contact_id),
  source_id INTEGER REFERENCES lookup_order_source(code),
  grand_total FLOAT,
  -- order status
  status_id INTEGER REFERENCES lookup_order_status(code),
  status_date TIMESTAMP(3) DEFAULT CURRENT_TIMESTAMP,
  contract_date TIMESTAMP(3) DEFAULT NULL,
  expiration_date TIMESTAMP(3) DEFAULT NULL,
  -- order terms and type
  order_terms_id INTEGER REFERENCES lookup_order_terms(code),
  order_type_id INTEGER REFERENCES lookup_order_type(code),
  description VARCHAR(2048),
  notes TEXT NULL,
  -- record status
  entered TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  enteredby INT NOT NULL REFERENCES access(user_id),
  modified TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  modifiedby INT NOT NULL REFERENCES access(user_id)
);

-- Each order can contain multiple products
CREATE TABLE order_product (
  item_id SERIAL PRIMARY KEY,
  order_id INTEGER NOT NULL REFERENCES order_entry(order_id),
  product_id INTEGER NOT NULL REFERENCES product_catalog(product_id),
  -- pricing and quantity of base product
  quantity INTEGER NOT NULL DEFAULT 0,
  msrp_currency INTEGER REFERENCES lookup_currency(code),
  msrp_amount FLOAT NOT NULL DEFAULT 0,
  price_currency INTEGER REFERENCES lookup_currency(code),
  price_amount FLOAT NOT NULL DEFAULT 0,
  recurring_currency INTEGER REFERENCES lookup_currency(code),
  recurring_amount FLOAT NOT NULL DEFAULT 0,
  recurring_type INTEGER REFERENCES lookup_recurring_type(code),
  extended_price FLOAT NOT NULL DEFAULT 0,
  total_price FLOAT NOT NULL DEFAULT 0,
  -- order item status
  status_id INTEGER REFERENCES lookup_order_status(code),
  status_date TIMESTAMP(3) DEFAULT CURRENT_TIMESTAMP
);

-- Each order_product has a status, as the status changes,
-- the previous status is stored here for reference and tracking
CREATE TABLE order_product_status (
  order_product_status_id SERIAL PRIMARY KEY,
  order_id INTEGER NOT NULL REFERENCES order_entry(order_id),
  item_id INTEGER NOT NULL REFERENCES order_product(item_id),
  status_id INTEGER REFERENCES lookup_order_status(code),
  -- record keeping
  entered TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  enteredby INT NOT NULL REFERENCES access(user_id),
  modified TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  modifiedby INT NOT NULL REFERENCES access(user_id)
);

-- Each product can have configurable options
CREATE TABLE order_product_options (
  order_product_option_id SERIAL PRIMARY KEY,
  item_id INTEGER NOT NULL REFERENCES order_product(item_id),
  product_option_id INTEGER NOT NULL REFERENCES product_option_map(product_option_id),
  quantity INTEGER NOT NULL DEFAULT 0,
  price_currency INTEGER REFERENCES lookup_currency(code),
  price_amount FLOAT NOT NULL DEFAULT 0,
  recurring_currency INTEGER REFERENCES lookup_currency(code),
  recurring_amount FLOAT NOT NULL DEFAULT 0,
  recurring_type INTEGER REFERENCES lookup_recurring_type(code),
  extended_price FLOAT NOT NULL DEFAULT 0,
  total_price FLOAT NOT NULL DEFAULT 0,
  status_id INTEGER REFERENCES lookup_order_status(code)
);

CREATE TABLE order_product_option_boolean (
	order_product_option_id INTEGER REFERENCES order_product_options(order_product_option_id),
	value BOOLEAN NOT NULL
);

CREATE TABLE order_product_option_float (
	order_product_option_id INTEGER REFERENCES order_product_options(order_product_option_id),
	value FLOAT NOT NULL
);

CREATE TABLE order_product_option_timestamp (
	order_product_option_id INTEGER REFERENCES order_product_options(order_product_option_id),
	value TIMESTAMP(3) NOT NULL
);

CREATE TABLE order_product_option_integer (
	order_product_option_id INTEGER REFERENCES order_product_options(order_product_option_id),
	value INTEGER NOT NULL
);

CREATE TABLE order_product_option_text (
	order_product_option_id INTEGER REFERENCES order_product_options(order_product_option_id),
	value TEXT NOT NULL
);

-- Example: Billing, Shipping
CREATE TABLE lookup_orderaddress_types (
	code SERIAL PRIMARY KEY,
  description VARCHAR(300) NOT NULL,
  default_item BOOLEAN DEFAULT false,
  level INTEGER DEFAULT 0,
	enabled BOOLEAN DEFAULT true
);

CREATE TABLE order_address (
	address_id SERIAL PRIMARY KEY,
	order_id INT NOT NULL REFERENCES order_entry(order_id),
	address_type INT REFERENCES lookup_orderaddress_types(code),
	addrline1 VARCHAR(300),
	addrline2 VARCHAR(300),
	addrline3 VARCHAR(300),
	city VARCHAR(300),
	state VARCHAR(300),
	country VARCHAR(300),
	postalcode VARCHAR(40),
	-- record keeping
	entered TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
	enteredby INT NOT NULL REFERENCES access(user_id),
  modified TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  modifiedby INT NOT NULL REFERENCES access(user_id)
);

-- The method in which a payment is made
-- Example: Credit Card, EFT, Cash, Check, Money Order
CREATE TABLE lookup_payment_methods (
	code SERIAL PRIMARY KEY,
  description VARCHAR(300) NOT NULL,
  default_item BOOLEAN DEFAULT false,
  level INTEGER DEFAULT 0,
	enabled BOOLEAN DEFAULT true
);

-- Example: Visa, Master Card, Discover, American Express

CREATE SEQUENCE lookup_creditcard_type_code_seq;
CREATE TABLE lookup_creditcard_types (
  code INTEGER DEFAULT nextval('lookup_creditcard_type_code_seq') NOT NULL PRIMARY KEY,
  description VARCHAR(300) NOT NULL,
  default_item BOOLEAN DEFAULT false,
  level INTEGER DEFAULT 0,
	enabled BOOLEAN DEFAULT true
);

CREATE TABLE order_payment (
	payment_id SERIAL PRIMARY KEY,
	order_id INT NOT NULL REFERENCES order_entry(order_id),
	payment_method_id INT NOT NULL REFERENCES lookup_payment_methods(code),
	payment_amount FLOAT,
  authorization_ref_number VARCHAR(30),
  authorization_code VARCHAR(30),
  authorization_date TIMESTAMP(3),
	-- record keeping
	entered TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
	enteredby INT NOT NULL REFERENCES access(user_id),
  modified TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  modifiedby INT NOT NULL REFERENCES access(user_id)
);

CREATE TABLE payment_creditcard (
	creditcard_id SERIAL PRIMARY KEY,
	payment_id INT NOT NULL REFERENCES order_payment(payment_id),
	-- credit card information
	card_type INT REFERENCES lookup_creditcard_types(code),
	card_number VARCHAR(300),
	card_security_code VARCHAR(10),
	expiration_month INT,
	expiration_year INT,
  name_on_card VARCHAR(300),
  company_name_on_card VARCHAR(300),
	-- record keeping
	entered TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
	enteredby INT NOT NULL REFERENCES access(user_id),
  modified TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  modifiedby INT NOT NULL REFERENCES access(user_id)
);

CREATE TABLE payment_eft (
	bank_id SERIAL PRIMARY KEY,
	payment_id INT NOT NULL REFERENCES order_payment(payment_id),
	-- bank details
	bank_name VARCHAR(300),
	routing_number VARCHAR(300),
	account_number VARCHAR(300),
	name_on_account VARCHAR(300),
  company_name_on_account VARCHAR(300),
	-- record keeping
	entered TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
	enteredby INT NOT NULL REFERENCES access(user_id),
  modified TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  modifiedby INT NOT NULL REFERENCES access(user_id)
);

-- List of products created by the ordering of a product
CREATE TABLE customer_product (
  customer_product_id SERIAL PRIMARY KEY,
  org_id INTEGER NOT NULL REFERENCES organization(org_id),
  order_id INTEGER REFERENCES order_entry(order_id),
  order_item_id INTEGER REFERENCES order_product(item_id),
  description VARCHAR(2048),
  status_id INTEGER REFERENCES lookup_order_status(code),
  status_date TIMESTAMP(3) DEFAULT CURRENT_TIMESTAMP,
  entered TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  enteredby INT NOT NULL REFERENCES access(user_id),
  modified TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP, 
  modifiedby INT NOT NULL REFERENCES access(user_id),
  enabled BOOLEAN DEFAULT true
);

-- Some products get returned or are finished being used
CREATE TABLE customer_product_history (
  history_id SERIAL PRIMARY KEY,
  customer_product_id INTEGER NOT NULL REFERENCES customer_product(customer_product_id),
  org_id INTEGER NOT NULL REFERENCES organization(org_id),
  order_id INTEGER REFERENCES order_entry(order_id),
  product_start_date TIMESTAMP(3),
  product_end_date TIMESTAMP(3),
  entered TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  enteredby INT NOT NULL REFERENCES access(user_id),
  modified TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP, 
  modifiedby INT NOT NULL REFERENCES access(user_id)
);