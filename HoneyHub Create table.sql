USE HoneyHub;

CREATE TABLE USERS (
    user_ID INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    date_of_birth DATE,
    location VARCHAR(255),
    gender ENUM('M', 'F', 'Other') NOT NULL,
    phoneNR VARCHAR(20),
    stylepreference VARCHAR(255)
);

CREATE TABLE SOCIAL_MEDIAS (
    social_ID VARCHAR(50),
    user_ID INT NOT NULL,
    type VARCHAR(50),
    NRfollower INT,
    PRIMARY KEY (social_ID, user_ID),
    FOREIGN KEY (user_ID) REFERENCES USERS(user_ID) ON DELETE CASCADE
);

CREATE TABLE ARTISANS (
    artisan_ID INT,
    artisan_name VARCHAR(255) NOT NULL,
    PRIMARY KEY (artisan_ID),
    FOREIGN KEY (artisan_ID) REFERENCES USERS(user_ID) ON DELETE CASCADE
);

CREATE TABLE CUSTOMERS (
    customer_ID INT,
    nail_size VARCHAR(50),
    PRIMARY KEY (customer_ID),
    FOREIGN KEY (customer_ID) REFERENCES USERS(user_ID) ON DELETE CASCADE
);

CREATE TABLE USER_UPLOADS (
    upload_ID INT AUTO_INCREMENT PRIMARY KEY,
    user_ID INT NOT NULL,
    image BLOB,
    description VARCHAR(255),
    FOREIGN KEY (user_ID) REFERENCES USERS(user_ID) ON DELETE CASCADE
);

CREATE TABLE COLLECTIONS (
    collection_ID INT AUTO_INCREMENT PRIMARY KEY,
    collection_name VARCHAR(255) NOT NULL
);

CREATE TABLE PRODUCTS (
    product_ID INT AUTO_INCREMENT PRIMARY KEY,
    product_name VARCHAR(255) NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    size VARCHAR(50),
    collection_ID INT NOT NULL,
    artisan_ID INT NOT NULL,
    FOREIGN KEY (collection_ID) REFERENCES COLLECTIONS(collection_ID),
    FOREIGN KEY (artisan_ID) REFERENCES ARTISANS(artisan_ID)
);

CREATE TABLE CUSTOM_PRODUCTS (
    custom_product_ID INT AUTO_INCREMENT PRIMARY KEY,
    product_ID INT NOT NULL,
    FOREIGN KEY (product_ID) REFERENCES PRODUCTS(product_ID)
);

CREATE TABLE CUSTOM_DESIGN_RELATIONS (
    customer_product_ID INT NOT NULL,
    upload_ID INT NOT NULL,
    artisan_ID INT NOT NULL,
    design_date DATE NOT NULL,
    status VARCHAR(255) NOT NULL,
    PRIMARY KEY (customer_product_ID, upload_ID, artisan_ID),
    FOREIGN KEY (customer_product_ID) REFERENCES CUSTOM_PRODUCTS(custom_product_ID),
    FOREIGN KEY (upload_ID) REFERENCES USER_UPLOADS(upload_ID),
    FOREIGN KEY (artisan_ID) REFERENCES ARTISANS(artisan_ID)
);

CREATE TABLE SUPPLIERS (
    supplier_ID INT AUTO_INCREMENT PRIMARY KEY,
    supplier_name VARCHAR(255) NOT NULL,
    phoneNR VARCHAR(20),
    email VARCHAR(255)
);

CREATE TABLE ACCESSORIES (
    accessory_ID INT AUTO_INCREMENT PRIMARY KEY,
    accessory_name VARCHAR(255) NOT NULL,
    price DECIMAL(10, 2),
    product_ID INT NOT NULL,
    supplier_ID INT NOT NULL,
    FOREIGN KEY (product_ID) REFERENCES PRODUCTS(product_ID),
    FOREIGN KEY (supplier_ID) REFERENCES SUPPLIERS(supplier_ID)
);

CREATE TABLE WISHLISTS (
    wishlist_ID INT AUTO_INCREMENT,
    customer_ID INT NOT NULL,
    PRIMARY KEY (wishlist_ID, customer_ID),
    FOREIGN KEY (customer_ID) REFERENCES CUSTOMERS(customer_ID)
);


CREATE TABLE SHOPPINGCARTS (
    cart_ID INT AUTO_INCREMENT,
    customer_ID INT NOT NULL,
    PRIMARY KEY (cart_ID, customer_ID),
    FOREIGN KEY (customer_ID) REFERENCES CUSTOMERS(customer_ID)
);


CREATE TABLE WISHLISTS_PRODUCTS (
    wishlist_ID INT,
    customer_ID INT,
    product_ID INT,
    PRIMARY KEY (wishlist_ID, customer_ID, product_ID),
    FOREIGN KEY (wishlist_ID) REFERENCES WISHLISTS(wishlist_ID),
    FOREIGN KEY (customer_ID) REFERENCES CUSTOMERS(customer_ID),
    FOREIGN KEY (product_ID) REFERENCES PRODUCTS(product_ID)
);


CREATE TABLE SHOPPINGCARTS_PRODUCTS (
    cart_ID INT,
    customer_ID INT,
    product_ID INT,
    quantity INT NOT NULL,
    PRIMARY KEY (cart_ID, customer_ID, product_ID),
    FOREIGN KEY (cart_ID) REFERENCES SHOPPINGCARTS(cart_ID),
    FOREIGN KEY (customer_ID) REFERENCES CUSTOMERS(customer_ID),
    FOREIGN KEY (product_ID) REFERENCES PRODUCTS(product_ID)
);


CREATE TABLE STORES (
    store_ID INT AUTO_INCREMENT PRIMARY KEY,
    store_name VARCHAR(255) NOT NULL,
    phoneNR VARCHAR(20),
    address VARCHAR(255) NOT NULL
);

-- The ON DELETE SET NULL for manager_ID ensures that when a manager is deleted, employees
-- that were managed by that manager will not be deleted.alter
CREATE TABLE EMPLOYEES (
    employee_ID INT AUTO_INCREMENT PRIMARY KEY,
    employee_name VARCHAR(255) NOT NULL,
    email VARCHAR(255),
    contract VARCHAR(255),
    phoneNR VARCHAR(20),
    store_ID INT NOT NULL,
    manager_ID INT NULL,
    FOREIGN KEY (store_ID) REFERENCES STORES(store_ID),
    FOREIGN KEY (manager_ID) REFERENCES EMPLOYEES(employee_ID) ON DELETE SET NULL
);


CREATE TABLE ORDERS (
    order_ID INT AUTO_INCREMENT PRIMARY KEY,
    date_time DATETIME NOT NULL,
    customer_ID INT NOT NULL,
    employee_ID INT NOT NULL,
    store_ID INT NOT NULL,
    FOREIGN KEY (customer_ID) REFERENCES CUSTOMERS(customer_ID),
    FOREIGN KEY (employee_ID) REFERENCES EMPLOYEES(employee_ID),
    FOREIGN KEY (store_ID) REFERENCES STORES(store_ID)
);

CREATE TABLE SHIPPINGS (
    shipping_ID INT AUTO_INCREMENT PRIMARY KEY,
    shipping_date DATETIME NOT NULL,
    address VARCHAR(255) NOT NULL,
    customer_ID INT NOT NULL,
    order_ID INT NOT NULL,
    FOREIGN KEY (customer_ID) REFERENCES CUSTOMERS(customer_ID),
    FOREIGN KEY (order_ID) REFERENCES ORDERS(order_ID)
);

-- Here payment_ID is the PK of the relation and also the FK referring to ORDERS,
-- This design assumes that an order will have an associated payment record created 
-- immediately, and the payment_ID will match the order_ID. Strong coupling between two.

CREATE TABLE PAYMENTS (
    payment_ID INT NOT NULL,
    date_time DATETIME NOT NULL,
    payment_type VARCHAR(50) NOT NULL,
    total_amount DECIMAL(10, 2) NOT NULL,
    customer_ID INT NOT NULL,
    PRIMARY KEY (payment_ID),
    FOREIGN KEY (payment_ID) REFERENCES ORDERS(order_ID),
    FOREIGN KEY (customer_ID) REFERENCES CUSTOMERS(customer_ID)
);


CREATE TABLE FEEDBACKS (
    feedback_ID INT AUTO_INCREMENT,
    customer_ID INT NOT NULL,
    order_ID INT NOT NULL,
    comment TEXT,
    ranking INT,
    PRIMARY KEY (feedback_ID, customer_ID, order_ID),
    FOREIGN KEY (customer_ID) REFERENCES CUSTOMERS(customer_ID),
    FOREIGN KEY (order_ID) REFERENCES ORDERS(order_ID)
);


CREATE TABLE ORDER_ITEMS (
    item_ID INT NOT NULL,
    order_ID INT NOT NULL,
    product_ID INT NOT NULL,
    quantity INT NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    PRIMARY KEY (item_ID, order_ID),
    FOREIGN KEY (order_ID) REFERENCES ORDERS(order_ID),
    FOREIGN KEY (product_ID) REFERENCES PRODUCTS(product_ID)
);


CREATE TABLE INVENTORY_ITEMS (
    inventory_ID INT NOT NULL,
    store_ID INT NOT NULL,
    product_ID INT NOT NULL,
    quantity INT NOT NULL,
    PRIMARY KEY (inventory_ID, store_ID),
    FOREIGN KEY (store_ID) REFERENCES STORES(store_ID),
    FOREIGN KEY (product_ID) REFERENCES PRODUCTS(product_ID)
);

