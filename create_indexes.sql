-- Индекс по id статуса в таблице accounts
CREATE INDEX idx_accounts_id_status ON accounts(id_owner);

-- Частичный индекс по полю name в таблице site_pages для поиска записей без родительских страниц
CREATE INDEX idx_site_pages_no_parent ON site_pages(name) WHERE parent_page_id IS NULL;

-- Индексы для ускорения запроса из п.3
CREATE INDEX idx_current_payments_payment_date ON current_payments (payment_date);
CREATE INDEX idx_current_payments_destination_account_id ON current_payments (destination_account_id);

