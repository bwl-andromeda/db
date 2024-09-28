-- Список платежей за последний месяц
CREATE OR REPLACE VIEW payments_last_month AS
SELECT *
FROM current_payments
WHERE payment_date >= NOW() - INTERVAL '1 month';

-- Список счетов, баланс которых больше 1000
CREATE OR REPLACE VIEW accounts_with_balance_over_1000 AS
SELECT *
FROM accounts
WHERE balance > 1000;

-- Список всех счетов с дополнительным полем, содержащим сумму всех входящих платежей
CREATE OR REPLACE VIEW accounts_with_incoming_payments AS
SELECT a.id, a.balance, a.id_owner, 
    COALESCE(SUM(p.amount), 0) AS total_incoming
FROM accounts a
LEFT JOIN current_payments p ON p.destination_account_id = a.id
GROUP BY a.id;

-- Список всех счетов с дополнительным полем, содержащим сумму исходящих платежей, где сумма больше 100
CREATE OR REPLACE VIEW accounts_with_outgoing_payments_above_100 AS
SELECT a.id, a.balance, a.id_owner, 
    COALESCE(SUM(p.amount), 0) AS total_outgoing
FROM accounts a
LEFT JOIN current_payments p ON p.source_account_id = a.id
WHERE p.amount > 100
GROUP BY a.id;

-- Список всех счетов с дополнительным полем, содержащим сумму исходящих платежей, где сумма больше 100, и фильтрация записей с суммой больше 1000
CREATE OR REPLACE VIEW accounts_with_large_outgoing_payments AS
SELECT a.id, a.balance, a.id_owner, 
    COALESCE(SUM(p.amount), 0) AS total_outgoing
FROM accounts a
LEFT JOIN current_payments p ON p.source_account_id = a.id
WHERE p.amount > 100
GROUP BY a.id
HAVING SUM(p.amount) > 1000;

-- Список всех страниц с дополнительным полем, содержащим название родительской страницы
CREATE OR REPLACE VIEW pages_with_parent_name AS
SELECT sp.id, sp.name, pp.name AS parent_name
FROM site_pages sp
LEFT JOIN parent_pages pp ON sp.parent_page_id = pp.id;

-- Список всех платежей из таблиц payments и archive_payments с дополнительным полем для обозначения источника
CREATE OR REPLACE VIEW all_payments_with_source AS
SELECT id, source_account_id, destination_account_id, payment_date, amount, 1 AS source
FROM current_payments
UNION ALL
SELECT id, source_account_id, destination_account_id, payment_date, amount, 2 AS source
FROM archived_payments;

