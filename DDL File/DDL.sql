CREATE SCHEMA store;
Use store;

CREATE TABLE User (

	user_id INT(5) PRIMARY KEY,

	username VARCHAR(30),

	password VARCHAR(50),

	full_name VARCHAR(50),

	address VARCHAR(50),

	email VARCHAR(50),

	phone BIGINT(10)

);



CREATE TABLE CreditCard (

	credit_card_number BIGINT(16) PRIMARY KEY,

	holder_name VARCHAR(30),

	expiration_date VARCHAR(5)

);



CREATE TABLE Users_Has_CreditCard (

	user_id INT(5),

	credit_card_number BIGINT(16),

	PRIMARY KEY (user_id, credit_card_number)

);



CREATE TABLE Product (

	product_id INT(5) PRIMARY KEY,

	product_name VARCHAR(30),

	description text

);



CREATE TABLE Options (

	option_id INT(5) PRIMARY KEY,

	option_name VARCHAR(30)

);



CREATE TABLE Products_Has_Options (

	product_id INT(5),

	option_id INT(5),

	quantity INT(4),

	price REAL,

	on_sale BOOLEAN,

	specs text(50),

	PRIMARY KEY(product_id, option_id)

);



CREATE TABLE Orders (

	order_id INT(5) PRIMARY KEY,

	total_item INT(5),

	shipping_fee REAL,

	tax REAL,

	total_cost REAL,

	order_date DATE,

	delivery_date DATE,

	ship_name VARCHAR(50),

	ship_address VARCHAR(50),

	tracking_number text,

	delivery_status boolean

);



CREATE TABLE Orders_Has_Products (

	order_id INT(5),

	product_id INT(5),

	option_id INT(5),

	quantity INT(5),

	PRIMARY KEY (order_id, product_id, option_id)

);



CREATE TABLE Orders_Paid_CreditCard (

	credit_card_number BIGINT(16),

	order_id INT(5),

	PRIMARY KEY (credit_card_number, order_id)

);



CREATE TABLE Orders_Placed_User (

	user_id INT(5),

	order_id INT(5),

	PRIMARY KEY (user_id, order_id)

);



CREATE TABLE ShoppingCart (

	shopping_cart_id INT(5) PRIMARY KEY,

	status BOOLEAN

);



CREATE TABLE Cart_Belongs_User (

	user_id INT(5),

	shopping_cart_id INT(5),

	PRIMARY KEY (user_id, shopping_cart_id)

);



CREATE TABLE Carts_Has_Products (

	shopping_cart_id INT(5),

	product_id INT(5),

	option_id INT(5),

	quantity INT(5),

	PRIMARY KEY (shopping_cart_id, product_id, option_id)

);

CREATE TABLE Category (

	category_id INT(5) PRIMARY KEY,

	category_name VARCHAR(50)

);

CREATE TABLE Products_Belong_Category (

	product_id INT(5),

	category_id INT(5) NULL,

	PRIMARY KEY(product_id)

);

CREATE TABLE Vendor (

	vendor_id INT(5) PRIMARY KEY,

	vendor_name VARCHAR (30),

	vendor_phone INT(10),

	vendor_email VARCHAR(30)

);

CREATE TABLE Products_Sold_Vendor (

	vendor_id INT(5) NULL,

	product_id INT(5),

	PRIMARY KEY (product_id)

);



##Foreign keys, ORACLE DB.

-- products_sold_vendor (vendor_id, product_id)

--      each product should exist in the product table and if a product is deleted, we dont need to worry about the vendor anymore.

ALTER TABLE products_sold_vendor ADD CONSTRAINT FK_product_id FOREIGN KEY (product_id) REFERENCES Product(product_id) ON DELETE CASCADE;

--      each vendor should exist in the vendor table and if a vendor is delete, omit the vendor id in the respective products.

ALTER TABLE products_sold_vendor ADD CONSTRAINT FK_vendor_id FOREIGN KEY (vendor_id) REFERENCES Vendor(vendor_id) ON DELETE SET NULL;

-- users_has_creditcard (user_id, credit_card_number)

--      user with credit cards must exist in the users table, and if a user is deleted, delete the associated credit card.

ALTER TABLE users_has_creditcard ADD CONSTRAINT FK_users_has_creditcard_user FOREIGN KEY (user_id) REFERENCES User(user_id) ON DELETE CASCADE;

--      every associated credit card must exist in the credit card table, and if a credit card is deleted, delete the association.

ALTER TABLE users_has_creditcard ADD CONSTRAINT FK_users_has_creditcard_creditcard FOREIGN KEY (credit_card_number) REFERENCES CreditCard(credit_card_number) ON DELETE CASCADE;

-- orders_has_products (order_id, product_id, option_id, quantity)

--      every order id must exist in the order table, and if an order is deleted, delete all related products.

ALTER TABLE orders_has_products ADD CONSTRAINT FK_orders_has_products_order FOREIGN KEY (order_id) REFERENCES Orders(order_id) ON DELETE CASCADE;

--      every product with option should exist in the product options table, and if delted, reject.

ALTER TABLE orders_has_products ADD CONSTRAINT FK_orders_has_products_products_has_options FOREIGN KEY (product_id, option_id) REFERENCES products_has_options(product_id, option_id);

-- orders_paid_creditcard (credit_card_number, order_id)

--      every creditcard must exist in the credit card table, and if delted, reject.

ALTER TABLE orders_paid_creditcard ADD CONSTRAINT FK_orders_paid_creditcard_creditcard FOREIGN KEY (credit_card_number) REFERENCES CreditCard(credit_card_number);

--      every order should be in the oders table, and if deleted from the orders table, delete the associated creditcard.

ALTER TABLE orders_paid_creditcard ADD CONSTRAINT FK_orders_paid_creditcard_order FOREIGN KEY (order_id) REFERENCES Orders(order_id) ON DELETE CASCADE;

-- orders_placed_user (user_id, order_id)

--      every user that placed an order should be a registered user(in the user table), and if the user got deleted, reject here.

ALTER TABLE orders_placed_user ADD CONSTRAINT FK_order_places_user_user FOREIGN KEY (user_id) REFERENCES User(user_id);

--      every order associated with a user must exist in the order table, if deleted from order table, delelete the association with the user.

ALTER TABLE orders_placed_user ADD CONSTRAINT FK_order_places_user_order FOREIGN KEY (order_id) REFERENCES Orders(order_id) ON DELETE CASCADE;

-- cart_belongs_user (user_id, shopping_cart_id)

--      every user that has a shopping cart must exist in the user table, and if deleted from user table, delete the association with a shopping cart.

ALTER TABLE cart_belongs_user ADD CONSTRAINT FK_cart_belongs_user FOREIGN KEY (user_id) REFERENCES User(user_id) ON DELETE CASCADE;

-- cart_has_products (shopping_cart_id, product_id, option_id, quantity)

--      every shopping cart with products must exist in the shoppingcart table, and if shoppingcart is deleted, delete association with products.

ALTER TABLE carts_has_products ADD CONSTRAINT FK_cart_has_product_shoppincart FOREIGN KEY (shopping_cart_id) REFERENCES ShoppingCart(shopping_cart_id) ON DELETE CASCADE;

--      every product in any shopping cart must exist in the products with options table, and if deleted, remove from the shopping cart.

ALTER TABLE carts_has_products ADD CONSTRAINT FK_cart_has_product_products_has_options FOREIGN KEY (product_id, option_id) REFERENCES products_has_options(product_id, option_id) ON DELETE CASCADE;

-- products_belong_category (product_id, category_id)

--      every product should exist in the product table, and if delete, delete the category association.

ALTER TABLE products_belong_category ADD CONSTRAINT FK_product_belongs_category_product FOREIGN KEY (product_id) REFERENCES Product(product_id) ON DELETE CASCADE;

--      every associated category must exist in the category table, and if deleted, omit the product category.

ALTER TABLE products_belong_category ADD CONSTRAINT FK_product_belongs_category_category FOREIGN KEY (category_id) REFERENCES Category(category_id) ON DELETE SET NULL;

-- products_has_options(product_id, option_id, price, specs, onsale, quantity)

--      every product with options must exist in the products table, if deleted, delete its options.

ALTER TABLE products_has_options ADD CONSTRAINT FK_product_has_options_product FOREIGN KEY (product_id) REFERENCES Product(product_id) ON DELETE CASCADE;




##checks

-- Entity sets relations:

-- User (user_id, username, password, full_name, address, email, phone)

--      every user should have a unique username and email

--      unique(username, email)

ALTER TABLE User ADD CONSTRAINT user_uniques UNIQUE (username, email);

-- Product (product_id, product_name, price, on_sale, specs, description)

--      names of products should be unique.

--      unique(productname)

ALTER TABLE Product ADD CONSTRAINT product_unique UNIQUE (product_name);

-- Option(option_id, description)

-- Order (order_id, total_item, shipping_fee, tax, total_cost, order_date, delivery_date, ship_name, ship_address, tracking_number, delivery_status)

--      total item must bigger that 0

--      check(total_item > 0)

ALTER TABLE Orders ADD CONSTRAINT order_total_item_check CHECK (total_item > 0);

-- ShoppingCart (shopping_cart_id, status)

--      the status of the shopping cart should empty or not empty

--      check(status = "empty" or status = "not empty")

ALTER TABLE ShoppingCart ADD CONSTRAINT shopping_cart_check CHECK (status = “empty” or status = “notempty”);



-- Category (category_id, category_name)

--      unique(category_name)

ALTER TABLE Category ADD CONSTRAINT category_unique UNIQUE (category_name);



-- Relationships relations:

-- products_sold_vendor (vendor_id, product_id)

--      each product is sold by one vendor only.

--      unique(product_id)

ALTER TABLE products_sold_vendor ADD CONSTRAINT product_sold_vendor_unique UNIQUE (product_id);

-- users_has_creditcard (user_id, credit_card_number)

--      each use has one creditcarf only.

--      unique(user_id)

ALTER TABLE users_has_creditcard ADD CONSTRAINT users_has_creditcard_unique UNIQUE (user_id);



-- orders_has_products (order_id, product_id, option_id, quantity)

--      check (quantity > 0)

ALTER TABLE orders_has_products ADD CONSTRAINT order_has_product_check CHECK (quantity > 0);

-- orders_paid_creditcard (credit_card_number, order_id)

--      orders are paid by one creditcard only.

--      unique(order_id)

ALTER TABLE orders_paid_creditcard ADD CONSTRAINT orders_paid_creditcard_unique UNIQUE (order_id);

-- orders_placed_user (user_id, order_id)

--      orders are palces by one user

--      unique(order_id)

ALTER TABLE orders_placed_user ADD CONSTRAINT orders_placed_user_unique UNIQUE (order_id);

-- cart_belongs_user (user_id, shopping_cart_id)

--      users have one shopping cart only.

--      unique(shoppin_cart_id)

ALTER TABLE cart_belongs_user ADD CONSTRAINT cart_belongs_user_unique UNIQUE (shopping_cart_id);



-- cart_has_products (shopping_cart_id, product_id, option_id, quantity)

--      quantity must be more that 0

--      check(quantity > 0)

ALTER TABLE carts_has_products ADD CONSTRAINT cart_quantity_check CHECK(quantity > 0);



-- products_belong_category (product_id, category_id)

--      products can belongs to one category only.

--      unique(product_id)

ALTER TABLE products_belong_category ADD CONSTRAINT products_belong_category_uniqes UNIQUE (product_id);



-- products_has_options(product_id, option_id, price, specs, onsale, quantity)

--      check(quantity >= 0)

ALTER TABLE products_has_options ADD CONSTRAINT quantity_check CHECK(quantity > 0);



##indexes

-- the index for sale attribute

CREATE INDEX saleIn ON products_has_options(on_sale);



##triggers

