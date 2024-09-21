-- Владелец счёта
CREATE TABLE IF NOT EXISTS account_owners (
    id SERIAL PRIMARY KEY,
    name TEXT NOT NULL
);

-- Счёт
CREATE TABLE IF NOT EXISTS accounts (
    id SERIAL PRIMARY KEY,
    balance DECIMAL(10, 2) NOT NULL CHECK (balance >= 0),
    id_owner INT NOT NULL REFERENCES account_owners(id) ON DELETE CASCADE,
    is_system BOOLEAN NOT NULL DEFAULT FALSE
);

-- Статус счёта
CREATE TABLE IF NOT EXISTS account_statuses (
    id SERIAL PRIMARY KEY,
    name TEXT NOT NULL
);

-- Платёж операционный
CREATE TABLE IF NOT EXISTS current_payments (
    id SERIAL PRIMARY KEY,
    source_account_id INT NOT NULL REFERENCES accounts(id) ON DELETE CASCADE,
    destination_account_id INT NOT NULL REFERENCES accounts(id) ON DELETE CASCADE,
    payment_date TIMESTAMP NOT NULL DEFAULT NOW(),
    amount DECIMAL(10, 2) NOT NULL CHECK (amount > 0)
);

-- Платёж архивный
CREATE TABLE IF NOT EXISTS archived_payments (
    id SERIAL PRIMARY KEY,
    source_account_id INT NOT NULL REFERENCES accounts(id) ON DELETE CASCADE,
    destination_account_id INT NOT NULL REFERENCES accounts(id) ON DELETE CASCADE,
    payment_date TIMESTAMP NOT NULL DEFAULT NOW(),
    amount DECIMAL(10, 2) NOT NULL CHECK (amount > 0)
);

-- Родительская страница
CREATE TABLE IF NOT EXISTS parent_pages (
    id SERIAL PRIMARY KEY,
    name TEXT NOT NULL
);

-- Страница сайта
CREATE TABLE IF NOT EXISTS site_pages (
    id SERIAL PRIMARY KEY,
    parent_page_id INT NOT NULL REFERENCES parent_pages(id) ON DELETE CASCADE,
    name TEXT NOT NULL
);

-- Офис банка
CREATE TABLE IF NOT EXISTS bank_offices (
    id SERIAL PRIMARY KEY,
    city TEXT NOT NULL,
    name TEXT NOT NULL,
    total_sales DECIMAL(10, 2) NOT NULL CHECK (total_sales >= 0)
);

CREATE INDEX idx_account_owners_name ON account_owners(name);
CREATE INDEX idx_accounts_id_owner ON accounts(id_owner);
CREATE INDEX idx_current_payments_source_account_id ON current_payments(source_account_id);
CREATE INDEX idx_current_payments_destination_account_id ON current_payments(destination_account_id);

