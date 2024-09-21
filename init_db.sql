-- Владелец счёта
CREATE TABLE IF NOT EXISTS account_owners (
    id SERIAL PRIMARY KEY,
    name TEXT
);
 
 
-- Счёт
CREATE TABLE IF NOT EXISTS accounts (
    id SERIAL PRIMARY KEY,
    balance DECIMAL(10,2),
    id_owner INT REFERENCES account_owners(id),
    is_system BOOLEAN
);
 
 
-- Статус счёта
CREATE TABLE IF NOT EXISTS account_statuses (
    id SERIAL PRIMARY KEY,
    name TEXT
);
 
 
-- Платёж операционный
CREATE TABLE IF NOT EXISTS current_payments (
    id SERIAL PRIMARY KEY,
    source_account_id INT REFERENCES accounts(id),
    destination_account_id INT REFERENCES accounts(id),
    payment_date TIMESTAMP,
    amount DECIMAL(10,2)
);
 
 
-- Платёж архивный
CREATE TABLE IF NOT EXISTS archived_payments (
    id SERIAL PRIMARY KEY,
    source_account_id INT REFERENCES accounts(id),
    destination_account_id INT REFERENCES accounts(id),
    payment_date TIMESTAMP,
    amount DECIMAL(10,2)
);
 
 
-- Родительская страница
CREATE TABLE IF NOT EXISTS parent_pages (
    id SERIAL PRIMARY KEY,
    name TEXT
);
 
 
-- Страница сайта
CREATE TABLE IF NOT EXISTS site_pages (
    id SERIAL PRIMARY KEY,
    parent_page_id INT REFERENCES б(id),
    name TEXT
);
 
 
-- Офис банка
CREATE TABLE IF NOT EXISTS bank_offices (
    id SERIAL PRIMARY KEY,
    city TEXT,
    name TEXT,
    total_sales DECIMAL(10,2)
);

